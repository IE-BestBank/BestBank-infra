@description('Name of the Logic App')
param logicAppName string

@description('Location of the Logic App')
param location string

@description('Environment type (e.g., nonprod, prod)')
param environmentType string

@description('Workflow definition JSON for the Logic App')
param definition object

@description('Slack Incoming Webhook URL')
param slackWebhookUrl string

resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: logicAppName
  location: location
  properties: {
    definition: definition
    integrationAccount: null
    parameters: {
      environment: {
        value: environmentType
      }
    }
    sku: {
      name: 'Standard'
    }
  }
}

resource slackMessageAction 'Microsoft.Logic/workflows/actions@2019-05-01' = {
  name: '${logicAppName}/SendSlackMessage'
  properties: {
    type: 'Http'
    inputs: {
      method: 'POST'
      uri: slackWebhookUrl
      headers: {
        'Content-Type': 'application/json'
      }
      body: json('{
        \"text\": \"This is a message from Azure Logic App!\"
      }')
    }
  }
}
