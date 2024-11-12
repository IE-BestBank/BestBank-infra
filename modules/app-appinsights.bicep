metadata name = 'Application Insights'
metadata description = 'This component deploys an Application Insights instance.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Application Insights.')
param name string

@description('Optional. Application type.')
@allowed([
  'web'
  'other'
])
param applicationType string = 'web'

@description('Required. Resource ID of the log analytics workspace which the data will be ingested to. This property is required to create an application with this API version. Applications from older versions will not have this property.')
param workspaceResourceId string

@description('Optional. Disable IP masking. Default value is set to true.')
param disableIpMasking bool = true //allows you to track IP address of users 

@description('Optional. The network access type for accessing Application Insights ingestion. - Enabled or Disabled.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccessForIngestion string = 'Enabled'

@description('Optional. The network access type for accessing Application Insights query. - Enabled or Disabled.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccessForQuery string = 'Enabled'

@description('Optional. Retention period in days.')
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
param retentionInDays int = 365

@description('Optional. Percentage of the data produced by the application being monitored that is being sampled for Application Insights telemetry.')
@minValue(0)
@maxValue(100)
param samplingPercentage int = 100

// @description('Optional. Array of role assignments to create.')
// param roleAssignments roleAssignmentType


@description('Optional. Tags of the resource.')
param tags object?

// @description('Optional. Enable/Disable usage telemetry for module.')
// param enableTelemetry bool = true

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

// @description('Optional. The diagnostic settings of the service.')
// param diagnosticSettings diagnosticSettingType //to configure which logs and metrics Application Insights will send to Log Analytics, storage accounts, or Event Hubs


//if i want to add the roleAssignemnts and Diagnostic settings need to add the modules in the main.becp file: https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/insights/component/main.bicep

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: name
  location: location
  tags: tags
  properties: {
    Application_Type: applicationType
    kind: applicationType 
    DisableIpMasking: disableIpMasking
    WorkspaceResourceId: workspaceResourceId
    publicNetworkAccessForIngestion: publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: publicNetworkAccessForQuery
    RetentionInDays: retentionInDays
    SamplingPercentage: samplingPercentage
  }
}

//outputs:
@description('The name of the application insights component.')
output name string = appInsights.name

@description('The resource ID of the application insights component.')
output resourceId string = appInsights.id

@description('The application ID of the application insights component.')
output applicationId string = appInsights.properties.AppId

@description('Application Insights Instrumentation key. A read-only value that applications can use to identify the destination for all telemetry sent to Azure Application Insights. This value will be supplied upon construction of each new Application Insights component.')
output instrumentationKey string = appInsights.properties.InstrumentationKey

@description('Application Insights Connection String.')
output connectionString string = appInsights.properties.ConnectionString
