
@description('The location of the Azure Workbook')
param location string = az.resourceGroup().location



@description('The source ID for the workbook')
param sourceId string


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
    sourceId: sourceId
  }
}

