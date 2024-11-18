
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
param userAlias string = 'bestbank'
param location string = resourceGroup().location

// Deploy Key Vault
module keyVault 'modules/key-vault.bicep' = {
  name: 'keyVault-${userAlias}'
  params: {
    name: keyVaultName
    enableRbacAuthorization: enableRbacAuthorization
    enableVaultForDeployment: enableVaultForDeployment
    enableVaultForTemplateDeployment: enableVaultForTemplateDeployment
    enableSoftDelete: enableSoftDelete
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


// // // Outputs for Key Vault
// // output keyVaultResourceId string = keyVault.outputs.resourceId
// // output keyVaultUri string = keyVault.outputs.keyVaultUri

// //step 3 - deploy db and server 
// @sys.description('The name of the PostgreSQL Server (DBHOST)')
// param postgreSQLServerName string

// @sys.description('The administrator username for the PostgreSQL Server (DBUSER)')
// param postgreSQLAdminUsername string

// @sys.description('The administrator password for the PostgreSQL Server (DBPASS)')
// @secure()
// param postgreSQLAdminPassword string

// @sys.description('The name of the PostgreSQL Database (DBNAME)')
// param postgreSQLDatabaseName string

// @sys.description('Specifies the tier and SKU for the PostgreSQL Server')
// param postgreSQLSkuName string

// @sys.description('Specifies the backup retention period in days')
// param postgreSQLBackupRetentionDays int

// @sys.description('Specifies whether geo-redundant backup is enabled')
// param postgreSQLGeoRedundantBackup string

// @sys.description('Specifies the storage size in GB')
// param postgreSQLStorageSizeGb int

// module postgreSQL 'modules/postgresql.bicep' = {
//   name: 'postgreSQL-${userAlias}'
//   params: {
//     serverName: postgreSQLServerName
//     adminUsername: postgreSQLAdminUsername
//     adminPassword: postgreSQLAdminPassword
//     databaseName: postgreSQLDatabaseName
//     location: location
//     skuName: postgreSQLSkuName
//     backupRetentionDays: postgreSQLBackupRetentionDays
//     geoRedundantBackup: postgreSQLGeoRedundantBackup
//     storageSizeGb: postgreSQLStorageSizeGb
//     tags: {
//       Environment: environmentType
//       Application: 'BestBank'
//     }
//   }
// }
// // Outputs for PostgreSQL
// output postgreSQLServerId string = postgreSQL.outputs.serverId
// output postgreSQLFqdn string = postgreSQL.outputs.fullyQualifiedDomainName
// output postgreSQLDatabaseId string = postgreSQL.outputs.databaseId


// //step 4 - deploy LAW
// // Log Analytics Parameters
// @sys.description('Name of the Log Analytics workspace')
// param logAnalyticsWorkspaceName string
// @sys.description('SKU for the Log Analytics workspace')
// param logAnalyticsSkuName string
// @sys.description('Retention period for data in Log Analytics workspace')
// param logAnalyticsDataRetention int
// @sys.description('The network access type for ingestion')
// param publicNetworkAccessForIngestion string
// @sys.description('The network access type for querying')
// param publicNetworkAccessForQuery string
// // Log Analytics Module
// module logAnalytics 'modules/app-log.bicep' = {
//   name: 'logAnalyticsWorkspaceDeployment'
//   params: {
//     name: logAnalyticsWorkspaceName
//     location: location
//     skuName: logAnalyticsSkuName
//     dataRetention: logAnalyticsDataRetention
//     publicNetworkAccessForIngestion: publicNetworkAccessForIngestion
//     publicNetworkAccessForQuery: publicNetworkAccessForQuery
//     tags: {
//       Environment: environmentType
//     }
//   }
// }
// // Output LAW ID for use in other modules (e.g., App Insights)
// output logAnalyticsWorkspaceId string = logAnalytics.outputs.logAnalyticsWorkspaceId


// //Step 5 - deploy AI
// //application-insight-paramaters 
// @sys.description('The name of the Application Insights instance')
// param appInsightsName string
// @sys.description('Application type for Application Insights')
// @allowed([
//   'web'
//   'other'
// ])
// param appInsightsApplicationType string = 'web'
// @sys.description('Disable IP masking for Application Insights')
// param appInsightsDisableIpMasking bool = true
// @sys.description('The network access type for ingestion in Application Insights')
// @allowed([
//   'Enabled'
//   'Disabled'
// ])
// param appInsightsPublicNetworkAccessForIngestion string = 'Enabled'
// @sys.description('The network access type for querying in Application Insights')
// @allowed([
//   'Enabled'
//   'Disabled'
// ])
// param appInsightsPublicNetworkAccessForQuery string = 'Enabled'
// @sys.description('Retention period in days for Application Insights data')
// @allowed([
//   30
//   60
//   90
//   120
//   180
//   270
//   365
//   550
//   730
// ])
// param appInsightsRetentionInDays int = 365
// @sys.description('Sampling percentage for Application Insights telemetry')
// @minValue(0)
// @maxValue(100)
// param appInsightsSamplingPercentage int = 100
// //application-insights-module
// // Application Insights Module
// module appInsights 'modules/app-appinsights.bicep' = {
//   name: 'appInsights-${userAlias}'
//   params: {
//     name: appInsightsName
//     applicationType: appInsightsApplicationType
//     workspaceResourceId: logAnalytics.outputs.logAnalyticsWorkspaceId
//     disableIpMasking: appInsightsDisableIpMasking
//     publicNetworkAccessForIngestion: appInsightsPublicNetworkAccessForIngestion
//     publicNetworkAccessForQuery: appInsightsPublicNetworkAccessForQuery
//     retentionInDays: appInsightsRetentionInDays
//     samplingPercentage: appInsightsSamplingPercentage
//     location: location
//     tags: {
//       Environment: environmentType
//       Owner: userAlias
//       Application: 'BestBank'
//     }
//   }
// }
// // Outputs for Application Insights
// output appInsightsName string = appInsights.outputs.name
// output appInsightsResourceId string = appInsights.outputs.resourceId
// output appInsightsApplicationId string = appInsights.outputs.applicationId
// output appInsightsInstrumentationKey string = appInsights.outputs.instrumentationKey
// output appInsightsConnectionString string = appInsights.outputs.connectionString

// // Step 6: Deploy App Service Plan
// // Parameters for App Service Plan
// @sys.description('The name of the App Service Plan')
// param appServicePlanName string

// @sys.description('The SKU for the App Service Plan (e.g., F1, B1)')
// @allowed([
//   'B1'
//   'F1'
// ])
// param appServicePlanSku string 

// //App Service Plan module
// module appServicePlan 'modules/app-service-plan.bicep' = {
//   name: appServicePlanName
//   params: {
//     location: location
//     appServicePlanName: appServicePlanName
//     sku: appServicePlanSku
//   }
// }

// // Outputs for App Service Plan
// output appServicePlanID string = appServicePlan.outputs.id
// output appServicePlanName string = appServicePlan.outputs.name


// //7-  Parameters for App Service Backend
// // App Service Backend Parameters
// @sys.description('The name of the backend App Service')
// param appServiceBackendName string

// @sys.description('The name of the backend Docker image')
// param backendDockerImageName string

// @sys.description('The version of the backend Docker image')
// param backendDockerImageVersion string

// @sys.description('The app settings for the backend App Service')
// param backendAppSettings array

// // App Service Backend Module
// module appServiceBackend 'modules/app-service-be.bicep' = {
//   name: 'appServiceBackend-deployment'
//   params: {
//     location: location
//     name: appServiceBackendName
//     appServicePlanId: appServicePlan.outputs.id
//     dockerRegistryName: containerRegistryName
//     dockerRegistryServerUserName: containerRegistry.outputs.containerRegistryUserName
//     dockerRegistryServerPassword: containerRegistry.outputs.containerRegistryPassword0    
//     dockerRegistryImageName: backendDockerImageName
//     dockerRegistryImageVersion: backendDockerImageVersion
//     appSettings: backendAppSettings
//     appCommandLine: '' // No custom startup commands for now
//   }
//   dependsOn: [
//     appServicePlan
//     containerRegistry
//   ]
// }

// // Outputs for App Service Backend
// // output appServiceBackendHostName string = appServiceBackend.outputs.appServiceAppHostName
// // output appServiceBackendId string = appServiceBackend.outputs.appId

// //8- static web app deployment - parameters 
// @sys.description('The name of the Static Web App')
// param staticWebAppName string
// @sys.description('The SKU of the Static Web App (Free/Standard)')
// param staticWebAppSku string
// @sys.description('The location of the Static Web App')
// param staticWebAppLocation string
// @sys.description('The repository URL for the Static Web App')
// param staticWebAppRepositoryUrl string
// @sys.description('The branch to deploy the Static Web App from')
// param staticWebAppBranch string
// @sys.description('The GitHub personal access token for the repository')
// @secure()
// param staticWebAppRepositoryToken string

// //SWA deployment
// module staticWebApp 'modules/static-web-app.bicep' = {
//   name: 'staticWebAppDeployment'
//   params: {
//     name: staticWebAppName
//     sku: staticWebAppSku
//     location: staticWebAppLocation
//     repositoryUrl: staticWebAppRepositoryUrl
//     branch: staticWebAppBranch
//     repositoryToken: staticWebAppRepositoryToken
//     buildProperties: {
//       appLocation: 'src'
//       outputLocation: 'dist'
//     }
//   }
// }

// // output staticWebAppHostname string = staticWebApp.outputs.defaultHostname
