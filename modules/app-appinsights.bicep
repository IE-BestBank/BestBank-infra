param location string = resourceGroup().location
param WorkspaceResourceId string
param name string
@description('Optional. Application type.')
@allowed([
  'web'
  'other'
])
param applicationType string = 'web'
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
param retentionInDays int = 90


resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: name
  location: location
  kind: 'other'
  properties: {
    Application_Type: applicationType
    Flow_Type: 'Bluefield'
    WorkspaceResourceId: WorkspaceResourceId
    RetentionInDays: retentionInDays
    IngestionMode: 'LogAnalytics'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

output id string = appInsights.id
output instrumentationKey string = appInsights.properties.InstrumentationKey
output connectionString string = appInsights.properties.ConnectionString

