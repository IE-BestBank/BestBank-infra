metadata name = 'Log Analytics Workspaces'
metadata description = 'This module deploys a Log Analytics Workspace.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Log Analytics workspace.')
param name string

@description('Optional. Location for the Log Analytics Workspace.')
param location string = resourceGroup().location

@description('Optional. The name of the SKU for pricing.')
@allowed([
  'CapacityReservation'
  'Free'
  'PerGB2018'
  'Standard'
])
param skuName string = 'PerGB2018'

@description('Optional. Number of days data will be retained for.')
@minValue(0)
@maxValue(730)
param dataRetention int = 365

@description('Optional. The network access type for ingestion.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccessForIngestion string = 'Enabled'

@description('Optional. The network access type for querying.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccessForQuery string = 'Enabled'

@description('Optional. Tags for the resource.')
param tags object = {}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  location: location
  name: name
  tags: tags
  properties: {
    sku: {
      name: skuName
    }
    retentionInDays: dataRetention
    publicNetworkAccessForIngestion: publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: publicNetworkAccessForQuery
  }
}

@description('The resource ID of the Log Analytics Workspace.')
output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.id

