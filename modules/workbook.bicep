@description('The name of the Azure Workbook')
param workbookName string

@description('The location of the Azure Workbook')
param location string = az.resourceGroup().location

@description('The resource group name for resources')
param resourceGroupName string

@description('Serialized workbook JSON content')
param workbookJson string

// Workbook Resource
resource sampleWorkbook 'Microsoft.Insights/workbooks@2022-04-01' = {
  name: workbookName
  location: location
  kind: 'shared'
  properties: {
    category: 'workbook'
    displayName: workbookName
    serializedData: workbookJson // Use workbookJson parameter
    sourceId: resourceId('Microsoft.Resources/resourceGroups', resourceGroup().name)

  }
}
