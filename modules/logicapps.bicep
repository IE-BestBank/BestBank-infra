@description('Name of the Logic App')
param logicAppName string

@description('Location of the Logic App')
param location string

@description('Environment type (e.g., nonprod, prod)')
param environmentType string

@description('Slack Incoming Webhook URL')
param slackWebhookUrl string

var message = '{"text": "An alert has been triggered in your Azure environment!"}'

resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: logicAppName
  location: location
  properties: {
    definition: {
      triggers: {
        HttpTrigger: {
          type: 'Request'
          inputs: {
            schema: {
              type: 'object'
              properties: {
                alertName: {
                  type: 'string'
                }
                alertDescription: {
                  type: 'string'
                }
              }
            }
          }
        }
      }
      actions: {
        SendSlackMessage: {
          type: 'Http'
          inputs: {
            method: 'POST'
            uri: slackWebhookUrl
            headers: {
              'Content-Type': 'application/json'
            }
            body: {
              text: '[Alert]: ${triggerBody().alertName} - ${triggerBody().alertDescription}'
            }
          }
        }
      }
    }
    parameters: {}
  }
}
