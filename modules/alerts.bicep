@description('Name of the database alert rule')
param dbAlertName string

@description('Description of the database alert')
param dbAlertDescription string

@description('Severity of the database alert (0: Critical, 1: Error, 2: Warning, 3: Informational)')
param dbAlertSeverity int

@description('Scope of the database resource to monitor')
param dbResourceScope string

@description('Name of the Key Vault alert rule')
param kvAlertName string

@description('Description of the Key Vault alert')
param kvAlertDescription string

@description('Severity of the Key Vault alert')
param kvAlertSeverity int

@description('Scope of the Key Vault resource to monitor')
param kvResourceScope string

@description('Name of the backend response alert rule')
param beResponseAlertName string

@description('Description of the backend response alert')
param beResponseAlertDescription string

@description('Severity of the backend response alert')
param beResponseAlertSeverity int

@description('Scope of the backend resource to monitor')
param beResourceScope string

@description('Action Group Resource ID')
param actionGroupId string

// Database Alert Rule
resource dbAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: dbAlertName
  location: 'global'
  properties: {
    description: dbAlertDescription
    severity: dbAlertSeverity
    enabled: true
    scopes: [
      dbResourceScope
    ]
    evaluationFrequency: 'PT1H' // Every hour
    windowSize: 'PT1H'          // Aggregate over the past hour
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
      allOf: [
        {
          name: 'FailedConnections'
          criterionType: 'StaticThresholdCriterion'
          metricNamespace: 'Microsoft.DBforPostgreSQL/flexibleServers'
          metricName: 'connections_failed'
          operator: 'GreaterThanOrEqual'
          threshold: 5 // Trigger if 5 or more failed connections in an hour
          timeAggregation: 'Total'
        }
      ]
    }
    autoMitigate: true
    actions: [
      {
        actionGroupId: actionGroupId
        webHookProperties: {
          customMessage: 'Database connection failures exceeded the threshold of 5 in the last hour. Please check immediately.'
        }
      }
    ]
  }
}

// Key Vault Alert Rule
resource kvAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: kvAlertName
  location: 'global'
  properties: {
    description: kvAlertDescription
    severity: kvAlertSeverity
    enabled: true
    scopes: [
      kvResourceScope
    ]
    evaluationFrequency: 'PT1H' // Every hour
    windowSize: 'PT1H'          // Aggregate over the past hour
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
      allOf: [
        {
          name: 'KeyVaultAvailability'
          criterionType: 'StaticThresholdCriterion'
          metricNamespace: 'Microsoft.KeyVault/vaults'
          metricName: 'Availability'
          operator: 'LessThan'
          threshold: 99 // Trigger if availability drops below 99% in the last hour
          timeAggregation: 'Average'
        }
      ]
    }
    autoMitigate: true
    actions: [
      {
        actionGroupId: actionGroupId
        webHookProperties: {
          customMessage: 'Key Vault availability dropped below 99.9% in the last hour. Please check immediately.'
        }
      }
    ]
  }
}

// Backend Response Time Alert Rule
resource beResponseAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: beResponseAlertName
  location: 'global'
  properties: {
    description: beResponseAlertDescription
    severity: beResponseAlertSeverity
    enabled: true
    scopes: [
      beResourceScope
    ]
    evaluationFrequency: 'PT1H' // Every hour
    windowSize: 'PT1H'          // Aggregate over the past hour
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          name: 'ResponseTime'
          criterionType: 'StaticThresholdCriterion'
          metricNamespace: 'Microsoft.Web/sites'
          metricName: 'HttpResponseTime'
          operator: 'GreaterThan'
          threshold: 2 // Trigger if response time exceeds 2 seconds in the last hour
          timeAggregation: 'Average'
        }
      ]
    }
    autoMitigate: true
    actions: [
      {
        actionGroupId: actionGroupId
        webHookProperties: {
          customMessage: 'Backend response time exceeded 2 seconds in the last hour. Please check immediately.'
        }
      }
    ]
  }
}
