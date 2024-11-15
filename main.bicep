@sys.description('The environment type (nonprod or prod)')
@allowed([
  'nonprod'
  'prod'
])
param environmentType string = 'nonprod'

@sys.description('The user alias to add to the deployment name')
param userAlias string = 'bestbank'

@sys.description('The PostgreSQL Server name')
@minLength(3)
@maxLength(24)
param postgreSQLServerName string = 'ie-bank-db-server-dev'

@sys.description('The PostgreSQL Database name')
@minLength(3)
@maxLength(24)
param postgreSQLDatabaseName string = 'ie-bank-db'

@sys.description('The Azure location where the resources will be deployed')
param location string = resourceGroup().location

// App Service (Backend) Parameters
@sys.description('The App Service Plan name for the backend')
param appServicePlanNameBE string = 'bestbank-asp-be-dev'
@sys.description('The API App name (frontend)')
param appServiceAPIAppName string = 'bestbank-be-dev'
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
@sys.description('The default admin password for the app')
@secure()
param appServiceAPIEnvVarDEFAULT_ADMIN_PASSWORD string
@sys.description('The default admin username for the app')
param appServiceAPIEnvVarDEFAULT_ADMIN_USERNAME string

// Static Web App (Frontend) Parameters
@sys.description('The Web App name (frontend)')
param staticWebAppName string = 'bestbank-fe-dev'

// Log Analytics Parameters
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

// Application Insights Parameters
@sys.description('The name of the Application Insights instance')
param appInsightsName string
@sys.description('Application type for Application Insights')
@allowed([
  'web'
  'other'
])
param appInsightsApplicationType string = 'web'
@sys.description('Disable IP masking for Application Insights')
param appInsightsDisableIpMasking bool = true
@sys.description('The network access type for ingestion in Application Insights')
@allowed([
  'Enabled'
  'Disabled'
])
param appInsightsPublicNetworkAccessForIngestion string = 'Enabled'
@sys.description('The network access type for querying in Application Insights')
@allowed([
  'Enabled'
  'Disabled'
])
param appInsightsPublicNetworkAccessForQuery string = 'Enabled'
@sys.description('Retention period in days for Application Insights data')
@allowed([
  30
  60
  90
  120
  180
  270
  365
  550
  730
])
param appInsightsRetentionInDays int = 365
@sys.description('Sampling percentage for Application Insights telemetry')
@minValue(0)
@maxValue(100)
param appInsightsSamplingPercentage int = 100

// Container Registry Parameters
@sys.description('The Container Registry name')
param containerRegistryName string

// PostgreSQL Server Resource
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

// PostgreSQL Database Resource
resource postgresSQLDatabase 'Microsoft.DBforPostgreSQL/flexibleServers/databases@2022-12-01' = {
  name: postgreSQLDatabaseName
  parent: postgresSQLServer
  properties: {
    charset: 'UTF8'
    collation: 'en_US.UTF8'
  }
}

// Container Registry Module
module containerRegistry 'modules/container-registry.bicep' = {
  name: 'containerRegistry-${userAlias}'
  params: {
    name: containerRegistryName
    location: location
  }
}

// App Service Plan Module for Backend (Containerized) and Frontend (Static Web App)
module appServicePlan 'modules/app-service-plan.bicep' = {
  name: 'appServicePlan-${userAlias}'
  params: {
    location: location
    environmentType: environmentType
    appServicePlanBEName: appServicePlanNameBE
    appServiceAPIAppName: appServiceAPIAppName
    appServiceAPIEnvVarENV: appServiceAPIEnvVarENV
    appServiceAPIEnvVarDBHOST: appServiceAPIEnvVarDBHOST
    appServiceAPIEnvVarDBNAME: appServiceAPIEnvVarDBNAME
    appServiceAPIEnvVarDBPASS: appServiceAPIEnvVarDBPASS
    appServiceAPIDBHostDBUSER: appServiceAPIDBHostDBUSER
    appServiceAPIEnvVarDEFAULT_ADMIN_PASSWORD: appServiceAPIEnvVarDEFAULT_ADMIN_PASSWORD
    appServiceAPIEnvVarDEFAULT_ADMIN_USERNAME: appServiceAPIEnvVarDEFAULT_ADMIN_USERNAME
    staticWebAppName: staticWebAppName
  }
  dependsOn: [
    postgresSQLDatabase
  ]
}

// Log Analytics Module
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

// Application Insights Module
module appInsights 'modules/app-appinsights.bicep' = {
  name: 'appInsights-${userAlias}'
  params: {
    name: appInsightsName
    applicationType: appInsightsApplicationType
    workspaceResourceId: logAnalytics.outputs.logAnalyticsWorkspaceId
    disableIpMasking: appInsightsDisableIpMasking
    publicNetworkAccessForIngestion: appInsightsPublicNetworkAccessForIngestion
    publicNetworkAccessForQuery: appInsightsPublicNetworkAccessForQuery
    retentionInDays: appInsightsRetentionInDays
    samplingPercentage: appInsightsSamplingPercentage
    location: location
    tags: {
      Environment: environmentType
    }
  }
}

// Outputs
output backendAppServicePlanId string = appServicePlan.outputs.backendAppServicePlanId
output backendAppServiceHostName string = appServicePlan.outputs.backendAppServiceHostName
output frontendStaticWebAppHostName string = appServicePlan.outputs.frontendStaticWebAppHostName
