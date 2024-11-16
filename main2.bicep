// Parameters
param environmentType string = 'nonprod'
@sys.description('The user alias to add to the deployment name')
param userAlias string = 'bestbank'
param location string = resourceGroup().location
param containerRegistryName string

// Step 1: Deploy Azure Container Registry
module containerRegistry 'modules/container-registry.bicep' = {
  name: 'containerRegistry-${userAlias}'
  params: {
    name: containerRegistryName
    location: location
  }
}
// Outputs (temporarily exposing sensitive info until Key Vault is deployed)
#disable-next-line outputs-should-not-contain-secrets
output acrLoginServer string = containerRegistry.outputs.containerRegistryLoginServer
#disable-next-line outputs-should-not-contain-secrets
output acrAdminUsername string = containerRegistry.outputs.containerRegistryUserName
#disable-next-line outputs-should-not-contain-secrets
output acrAdminPassword0 string = containerRegistry.outputs.containerRegistryPassword0
#disable-next-line outputs-should-not-contain-secrets
output acrAdminPassword1 string = containerRegistry.outputs.containerRegistryPassword1


//step 2 - deploy LAW
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

//Step 3 - deploy AI
//application-insight-paramaters 
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
//application-insights-module
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


