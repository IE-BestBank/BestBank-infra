@description('The name of the Azure Workbook')
param workbookName string

@description('The location of the Azure Workbook')
param location string = az.resourceGroup().location

@description('The subscription ID for resources')
param subscriptionId string


@description('The name of the Log Analytics workspace')
param logAnalyticsWorkspaceName string

@description('The resource group name for resources')
param resourceGroupName string

@description('The name of the database server')
param dbServerName string


@description('Serialized workbook JSON content')
param workbookJson string


// Workbook name needs to be guid 
resource sampleWorkbook 'Microsoft.Insights/workbooks@2022-04-01' = {
  name: guid('sampleWorkbook', resourceGroup().id)
  location: location
  kind:'shared'
  properties: {
    category: 'workbook'
    displayName: 'Awesome Workbook'
    //serializedData: replace(loadTextContent(('workbooks/workbook.json')), 'APPINSIGHTSPLACEHOLDER', appInsightsResourceId)
    serializedData: loadTextContent('../templates/BestBankWorkbook.workbook')
    sourceId: resourceGroupName
  }
}

