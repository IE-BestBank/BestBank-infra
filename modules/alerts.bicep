@description('Resource ID of the Application Insights instance')
param appInsightsId string

@description('Resource ID of the Log Analytics Workspace')
param WorkspaceResourceId string

@description('Resource ID of the Logic App to handle alerts')
param logicAppId string

// Alert for Uptime Percentage
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
    autoMitigate: true
    actions: [
      {
        actionGroupId: logicAppId
      }
    ]
  }
}

// Alert for Average HTTP Response Time
resource responseTimeAlert 'Microsoft.Insights/metricAlerts@2022-06-15' = {
  name: 'ResponseTimeAlert'
  location: resourceGroup().location
  properties: {
    description: 'Alert when HTTP response time exceeds 2 seconds'
    severity: 2
    enabled: true
    scopes: [appInsightsId]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      allOf: [
        {
          metricName: 'requestDuration'
          metricNamespace: 'microsoft.insights/components'
          operator: 'GreaterThan'
          threshold: 2000
          timeAggregation: 'Average'
        }
      ]
    }
    autoMitigate: true
    actions: [
      {
        actionGroupId: logicAppId
      }
    ]
  }
}

// Alert for Request Volume Tracking (Dynamic Threshold)
resource requestVolumeAlert 'Microsoft.Insights/metricAlerts@2022-06-15' = {
  name: 'RequestVolumeAlert'
  location: resourceGroup().location
  properties: {
    description: 'Alert on unusual request volume spikes or drops'
    severity: 3
    enabled: true
    scopes: [appInsightsId]
    evaluationFrequency: 'PT5M'
    windowSize: 'PT15M'
    criteria: {
      allOf: [
        {
          metricName: 'requests/count'
          metricNamespace: 'microsoft.insights/components'
          operator: 'Dynamic'
          dynamicCriteria: {
            sensitivity: 'Medium'
            failingPeriods: {
              minFailingPeriodsToAlert: 1
              numberOfEvaluationPeriods: 1
            }
          }
        }
      ]
    }
    autoMitigate: true
    actions: [
      {
        actionGroupId: logicAppId
      }
    ]
  }
}

/* Alert for Failed Connection Rate
resource failedConnectionRateAlert 'Microsoft.Insights/scheduledQueryRules@2020-05-01-preview' = {
  name: 'FailedConnectionRateAlert'
  location: resourceGroup().location
  properties: {
    displayName: 'Failed Connection Rate Alert'
    description: 'Alert when failed database connections exceed 10%'
    enabled: true
    severity: 3
    evaluationFrequency: 'PT5M'
    muteActionsDuration: 'PT1H'
    criteria: {
      allOf: [
        {
          query: '''
            let failedConnections = DatabaseConnections
            | summarize FailedRate = (countif(Status == "Failed") / count()) * 100;
            failedConnections | where FailedRate > 10
          '''
          dimensions: []
        }
      ]
    }
    actions: [
      {
        actionGroupId: logicAppId
      }
    ]
  }
}
*/
