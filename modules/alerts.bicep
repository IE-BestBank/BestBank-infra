@description('Resource ID of the Application Insights instance')
param appInsightsId string

@description('Resource ID of the Action Group')
param actionGroupId string

resource uptimeAlert 'Microsoft.Insights/metricAlerts@2022-06-15' = {
  name: 'UptimeAlert'
  location: resourceGroup().location
  properties: {
    description: 'Alert when the uptime percentage drops below 99%'
    severity: 2
    enabled: true
    scopes: [appInsightsId]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      allOf: [
        {
          metricName: 'availabilityResults/availabilityPercentage'
          metricNamespace: 'microsoft.insights/components'
          operator: 'LessThan'
          threshold: 99
          timeAggregation: 'Average'
        }
      ]
    }
    actions: [
      {
        actionGroupId: actionGroupId
      }
    ]
  }
}
