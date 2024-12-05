@description('Name of the Action Group')
param actionGroupName string

@description('Logic App Webhook URL')
param logicAppWebhookUrl string

resource actionGroup 'Microsoft.Insights/actionGroups@2021-06-01' = {
  name: actionGroupName
  location: 'global'
  properties: {
    groupShortName: 'AG'
    webhookReceivers: [
      {
        name: 'LogicAppReceiver'
        serviceUri: logicAppWebhookUrl
      }
    ]
  }
}
