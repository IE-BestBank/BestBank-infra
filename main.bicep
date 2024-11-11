@sys.description('The environment type (nonprod or prod)')
@allowed([
  'nonprod'
  'prod'
])
param environmentType string = 'nonprod'
@sys.description('The user alias to add to the deployment name')
param userAlias string = 'akhreiche'
@sys.description('The PostgreSQL Server name')
@minLength(3)
@maxLength(24)
param postgreSQLServerName string = 'ie-bank-db-server-dev'
@sys.description('The PostgreSQL Database name')
@minLength(3)
@maxLength(24)
param postgreSQLDatabaseName string = 'ie-bank-db'
@sys.description('The App Service Plan name')
@minLength(3)
@maxLength(24)
param appServicePlanName string = 'ie-bank-app-sp-dev'
@sys.description('The Web App name (frontend)')
@minLength(3)
@maxLength(24)
param appServiceAppName string = 'ie-bank-dev'
@sys.description('The API App name (backend)')
@minLength(3)
@maxLength(24)
param appServiceAPIAppName string = 'ie-bank-api-dev'
@sys.description('The Azure location where the resources will be deployed')
param location string = resourceGroup().location
@sys.description('The value for the environment variable ENV')
param appServiceAPIEnvVarENV string
@sys.description('The value for the environment variable DBHOST')
param appServiceAPIEnvVarDBHOST string
@sys.description('The value for the environment variable DBNAME')
param appServiceAPIEnvVarDBNAME string
@sys.description('The value for the environment variable DBPASS')
@secure()
param appServiceAPIEnvVarDBPASS string
@sys.description('The value for the environment variable DBUSER')
param appServiceAPIDBHostDBUSER string
@sys.description('The value for the environment variable FLASK_APP')
param appServiceAPIDBHostFLASK_APP string
@sys.description('The value for the environment variable FLASK_DEBUG')
param appServiceAPIDBHostFLASK_DEBUG string

@sys.description('Name of the Log Analytics workspace')
param logAnalyticsWorkspaceName string
@sys.description('SKU for the Log Analytics workspace')
param logAnalyticsSkuName string
@sys.description('Retention period for data in Log Analytics workspace')
param logAnalyticsDataRetention int
@sys.description('The network access type for ingestion')
param publicNetworkAccessForIngestion string
@sys.description('The network access type for querying')
param publicNetworkAccessForQuery string


// @sys.description('The Key Vault name')
// param keyVaultName string
// @sys.description('The location for the Key Vault')
// param keyVaultLocation string
// @sys.description('SKU for the Key Vault')
// @allowed(['standard', 'premium'])
// param keyVaultSku string = 'standard'
// @sys.description('Enable Key Vault for deployment')
// param enableVaultForDeployment bool = true
// @sys.description('Enable Key Vault for template deployments')
// param enableVaultForTemplateDeployment bool = true
// @sys.description('Enable Key Vault for disk encryption')
// param enableVaultForDiskEncryption bool = false
// @sys.description('Soft delete retention period in days for Key Vault')
// @minValue(7)
// @maxValue(90)
// param softDeleteRetentionInDays int = 90
// @sys.description('Resource tags for the Key Vault')
// param keyVaultTags object


// @sys.description('The name of the Static Web App')
// param staticWebAppName string
// @sys.description('SKU for the Static Web App')
// @allowed([ 'Free', 'Standard' ])
// param staticWebAppSku string = 'Free'
// @sys.description('Location of the Static Web App')
// param staticWebAppLocation string
// @sys.description('Personal Access Token for accessing the GitHub repository')
// @secure()
// param staticWebAppRepositoryToken string?
// @sys.description('GitHub repository URL for Static Web App deployment')
// param staticWebAppRepositoryUrl string?
// @sys.description('GitHub branch name for Static Web App deployment')
// param staticWebAppBranch string?


resource postgresSQLServer 'Microsoft.DBforPostgreSQL/flexibleServers@2022-12-01' = {
  name: postgreSQLServerName
  location: location
  sku: {
    name: 'Standard_B1ms'
    tier: 'Burstable'
  }
  properties: {
    administratorLogin: 'iebankdbadmin'
    administratorLoginPassword: 'IE.Bank.DB.Admin.Pa$$'
    createMode: 'Default'
    highAvailability: {
      mode: 'Disabled'
      standbyAvailabilityZone: ''
    }
    storage: {
      storageSizeGB: 32
    }
    backup: {
      backupRetentionDays: 7
      geoRedundantBackup: 'Disabled'
    }
    version: '15'
  }

  resource postgresSQLServerFirewallRules 'firewallRules@2022-12-01' = {
    name: 'AllowAllAzureServicesAndResourcesWithinAzureIps'
    properties: {
      endIpAddress: '0.0.0.0'
      startIpAddress: '0.0.0.0'
    }
  }
}

resource postgresSQLDatabase 'Microsoft.DBforPostgreSQL/flexibleServers/databases@2022-12-01' = {
  name: postgreSQLDatabaseName
  parent: postgresSQLServer
  properties: {
    charset: 'UTF8'
    collation: 'en_US.UTF8'
  }
}

module appService 'modules/app-service.bicep' = {
  name: 'appService-${userAlias}'
  params: {
    location: location
    environmentType: environmentType
    appServiceAppName: appServiceAppName
    appServiceAPIAppName: appServiceAPIAppName
    appServicePlanName: appServicePlanName
    appServiceAPIDBHostDBUSER: appServiceAPIDBHostDBUSER
    appServiceAPIDBHostFLASK_APP: appServiceAPIDBHostFLASK_APP
    appServiceAPIDBHostFLASK_DEBUG: appServiceAPIDBHostFLASK_DEBUG
    appServiceAPIEnvVarDBHOST: appServiceAPIEnvVarDBHOST
    appServiceAPIEnvVarDBNAME: appServiceAPIEnvVarDBNAME
    appServiceAPIEnvVarDBPASS: appServiceAPIEnvVarDBPASS
    appServiceAPIEnvVarENV: appServiceAPIEnvVarENV
  }
  dependsOn: [
    postgresSQLDatabase
  ]
}

output appServiceAppHostName string = appService.outputs.appServiceAppHostName


module logAnalytics 'modules/app-log.bicep' = {
  name: 'logAnalyticsWorkspaceDeployment'
  params: {
    name: logAnalyticsWorkspaceName
    location: location
    skuName: logAnalyticsSkuName
    dataRetention: logAnalyticsDataRetention
    publicNetworkAccessForIngestion: publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: publicNetworkAccessForQuery
    tags: {
      Environment: environmentType
    }
  }
}


// module keyVault 'modules/app-keyvault.bicep' = {
//   name: 'keyVaultDeployment'
//   params: {
//     name: keyVaultName
//     location: keyVaultLocation
//     sku: keyVaultSku
//     enableVaultForDeployment: enableVaultForDeployment
//     enableVaultForTemplateDeployment: enableVaultForTemplateDeployment
//     enableVaultForDiskEncryption: enableVaultForDiskEncryption
//     softDeleteRetentionInDays: softDeleteRetentionInDays
//     tags: keyVaultTags
//   }
// }


// module staticWebApp 'modules/app-swa.bicep' = {
//   name: 'staticWebAppDeployment'
//   params: {
//     name: staticWebAppName
//     sku: staticWebAppSku
//     location: staticWebAppLocation
//     repositoryToken: staticWebAppRepositoryToken
//     repositoryUrl: staticWebAppRepositoryUrl
//     branch: staticWebAppBranch
//   }
// }
