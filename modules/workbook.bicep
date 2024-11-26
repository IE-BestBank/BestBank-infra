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

resource workbook 'Microsoft.Insights/workbooks@2020-10-20' = {
  name: workbookName
  location: location
  kind: 'shared'
  properties: {
    displayName: workbookName
    category: 'workbook'
    sourceId: subscriptionResourceId('Microsoft.OperationalInsights/workspaces', logAnalyticsWorkspaceName)
    serializedData: replace(replace(replace(replace(workbookJson, '{subscriptionId}', subscriptionId), '{resourceGroup}', resourceGroupName), '{dbServerName}', dbServerName), '{logAnalyticsWorkspaceName}', logAnalyticsWorkspaceName)
    }
  }
  

