@description('The name of the Azure Workbook')
param workbookName string

@description('The location of the Azure Workbook')
param location string = az.resourceGroup().location

@description('The subscription ID for resources')
param subscriptionId string

@description('The resource group name for resources')
param resourceGroupName string

@description('The PostgreSQL server name')
param dbServerName string

@description('The Log Analytics Workspace name')
param logAnalyticsWorkspaceName string

@description('Serialized workbook JSON content')
param workbookJson string

resource workbook 'Microsoft.Insights/workbooks@2020-10-20' = {
  name: workbookName
  location: location
  properties: {
    displayName: workbookName
    category: 'workbook'
    sourceId: subscriptionResourceId('Microsoft.OperationalInsights/workspaces', logAnalyticsWorkspaceName)
    serializedData: format(workbookJson, {
      subscriptionId: subscriptionId, resourceGroup: resourceGroupName, dbServerName: dbServerName, logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    })
  }
}
