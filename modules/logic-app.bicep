@description('Location of the resource')
param location string = resourceGroup().location

@description('Name of the Logic App')
param logicAppName string

@description('Slack Webhook URL to send alerts')
@secure()
param slackWebhookUrl string // This remains as is, we'll override it in the GitHub Actions pipeline

resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: logicAppName
  location: location
  properties: {
    state: 'Enabled'
    definition: json(loadTextContent('./logicAppWorkflow.json'))
    parameters: {
      slackWebhookUrl: {
        value: slackWebhookUrl // This value will be dynamically passed from GitHub Actions
      }
    }
  }
}


