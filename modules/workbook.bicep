@description('The name of the Azure Workbook')
param workbookName string

@description('The location of the Azure Workbook')
param location string = az.resourceGroup().location

@description('Serialized workbook JSON content')
param workbookJson string

// Workbook Resource
resource sampleWorkbook 'Microsoft.Insights/workbooks@2022-04-01' = {
  name: guid(resourceGroup().id, workbookName) // Generate a GUID for the name
  location: location
  kind: 'shared'
  properties: {
    category: 'workbook'
    displayName: workbookName
    serializedData: workbookJson // Use workbookJson parameter
    sourceId: resourceId('Microsoft.Resources/resourceGroups', resourceGroup().name) // Dynamically retrieve resource group name
  }
}
