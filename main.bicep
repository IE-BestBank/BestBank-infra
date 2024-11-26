//step 3 - deploy Log analytics
@sys.description('Name of the Log Analytics workspace')
param logAnalyticsWorkspaceName string
@sys.description('SKU for the Log Analytics workspace')
param logAnalyticsSkuName string
@sys.description('Retention period for data in Log Analytics workspace')
param logAnalyticsDataRetention int

// Log Analytics Module
module logAnalytics 'modules/app-log.bicep' = {
  name: 'logAnalyticsWorkspaceDeployment'
  params: {
    name: logAnalyticsWorkspaceName
    location: location
    skuName: logAnalyticsSkuName
    dataRetention: logAnalyticsDataRetention
  }
}

//steo 4 - deploy app insights 
//application-insight-paramaters 
@sys.description('The name of the Application Insights instance')
param appInsightsName string
@sys.description('Application type for Application Insights')
param appInsightsApplicationType string 
param appInsightsRetentionInDays int

module appInsights 'modules/app-appinsights.bicep' = {
  name: appInsightsName
  params: {
    name: appInsightsName
    applicationType: appInsightsApplicationType
    WorkspaceResourceId: logAnalytics.outputs.logAnalyticsWorkspaceId
    retentionInDays: appInsightsRetentionInDays
    location: location
  }
}

@description('The name of the Workbook')
param workbookName string

@description('The JSON template for the Workbook')
@secure()
param workbookJson string

module workbook 'modules/workbook.bicep' = {
  name: 'workbookDeployment'
  params: {
    workbookName: workbookName
    location: resourceGroup().location
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    dbServerName: postgreSQLServerName
    workbookJson: workbookJson
    subscriptionId: subscription().subscriptionId
    resourceGroupName: resourceGroup().name
  }
  dependsOn: [logAnalytics]
}



// step 1- deploy KeyVault with RBAC 
@sys.description('The name of the Key Vault')
param keyVaultName string
@sys.description('Enable RBAC authorization for Key Vault')
param enableRbacAuthorization bool
@sys.description('Specifies if the vault is enabled for deployment by script or compute')
param enableVaultForDeployment bool
@sys.description('Specifies if the vault is enabled for a template deployment')
param enableVaultForTemplateDeployment bool
@sys.description('Enable Key Vault\'s soft delete feature')
param enableSoftDelete bool
@sys.description('The user alias to add to the deployment name')
param location string = resourceGroup().location
param keyVaultRoleAssignments array = [ ]


// Deploy Key Vault
module keyVault 'modules/key-vault.bicep' = {
  name: keyVaultName
  params: {
    name: keyVaultName
    WorkspaceResourceId: logAnalytics.outputs.logAnalyticsWorkspaceId //added for diagnostic settings 
    enableRbacAuthorization: enableRbacAuthorization
    enableVaultForDeployment: enableVaultForDeployment
    enableVaultForTemplateDeployment: enableVaultForTemplateDeployment
    enableSoftDelete: enableSoftDelete
    roleAssignments: keyVaultRoleAssignments
    location: location
  }
}

// Step 2: Deploy Azure Container Registry
@sys.description('The user alias to add to the deployment name')
param containerRegistryName string
@sys.description('Name of the Key Vault secret for the ACR admin username')
param adminUsernameSecretName string 
param adminPasswordSecretName0 string
param adminPasswordSecretName1 string

module containerRegistry 'modules/container-registry.bicep' = {
  name: containerRegistryName 
  params: {
    WorkspaceResourceId: logAnalytics.outputs.logAnalyticsWorkspaceId //added for diagnostic settings 
    keyVaultResourceId: keyVault.outputs.resourceId
    keyVaultSecreNameAdminUsername: adminUsernameSecretName
    keyVaultSecreNameAdminPassword0: adminPasswordSecretName0
    keyVaultSecreNameAdminPassword1: adminPasswordSecretName1
    location: location
    name: containerRegistryName 
  }
  dependsOn: [
    keyVault 
  ]  
}

//step 5- Deploy App Service Plan
@description('The PostgreSQL Server name')
param postgreSQLServerName string
@sys.description('The name of the App Service Plan')
param appServicePlanName string
@sys.description('The SKU for the App Service Plan (e.g., F1, B1)')
@allowed([
  'B1'
  'F1'
])
param appServicePlanSku string 

module appServicePlan 'modules/app-service-plan.bicep' = {
  name: appServicePlanName
  params: {
    location: location
    appServicePlanName: appServicePlanName
    sku: appServicePlanSku
  }
}

//step 6- deploy app service (be - cont)
@sys.description('The name of the backend App Service')
param appServiceWebsiteBEName string
@sys.description('The name of the backend Docker image')
param dockerRegistryImageName string
@sys.description('The version of the backend Docker image')
param dockerRegistryImageVersion string
@sys.description('The app settings for the backend App Service')
param appServiceBeAppSettings array
@secure()
param adminUsername string = '' //will be overridden when the secrets are passed dynamically from the workflow

@secure()
param adminPassword string = '' //will be overridden when the secrets are passed dynamically from the workflow


//refrence to keyvault used to retireve secrets from KV
resource keyVaultReference 'Microsoft.KeyVault/vaults@2023-07-01'existing = {
  name: keyVaultName
}
module appServiceWebsiteBE 'modules/app-service-be.bicep' = {
  name: appServiceWebsiteBEName
  params: {
  name: appServiceWebsiteBEName
  location: location
  WorkspaceResourceId: logAnalytics.outputs.logAnalyticsWorkspaceId //added for diagnostic settings 
  appServicePlanId: appServicePlan.outputs.id
  appCommandLine: ''
  appSettings: appServiceBeAppSettings
  dockerRegistryName: containerRegistryName
  dockerRegistryServerUserName: keyVaultReference.getSecret(adminUsernameSecretName)
  dockerRegistryServerPassword: keyVaultReference.getSecret(adminPasswordSecretName0)
  dockerRegistryImageName: dockerRegistryImageName
  dockerRegistryImageVersion: dockerRegistryImageVersion
  connectionString: appInsights.outputs.connectionString
  instrumentationKey: appInsights.outputs.instrumentationKey
  adminUsername: adminUsername // Pass to backend module
  adminPassword: adminPassword // Pass to backend module
  }
  dependsOn: [
  appServicePlan
  containerRegistry
  keyVault
  ]
  }

//step 7- deploy server 
param userAlias string = 'bestbank'
module postgresSQLServer 'modules/server-postgresql.bicep' = {
  name: 'psqlsrv-${userAlias}'
  params: {
  name: postgreSQLServerName
  WorkspaceResourceId: logAnalytics.outputs.logAnalyticsWorkspaceId //added for diagnostic settings 
  postgreSQLAdminServicePrincipalObjectId: appServiceWebsiteBE.outputs.systemAssignedIdentityPrincipalId
  postgreSQLAdminServicePrincipalName: appServiceWebsiteBEName
  }
  dependsOn: [
    appServiceWebsiteBE
  ]
  }

//step 8- deploy databse  
@description('The PostgreSQL Database name')
param postgreSQLDatabaseName string 

module postgresSQLDatabase 'modules/db-postgresql.bicep' = {
  name: postgreSQLDatabaseName 
  params: {
    postgreSQLDatabaseName: postgreSQLDatabaseName
    serverName: postgreSQLServerName
  }
  dependsOn: [
    postgresSQLServer
  ]
}

//step 9 - deploy swa 
@sys.description('static web app name')
param StaticWebAppName string

param SWAsku string

module staticWebApp 'modules/static-web-app.bicep' = {
  name: StaticWebAppName
  params: {
    name: StaticWebAppName
    sku: SWAsku
    keyVaultResourceId: keyVault.outputs.resourceId
    keyVaultSecretName: 'SWAtoken'
  }
}






//app insigths creates instrumetation key used as an env var in be 
//be and fe --> app insights so they depend on app insights 
//log analytics --> diagnositc settings 
