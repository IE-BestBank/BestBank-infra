using '../main.bicep'

//app-service
param environmentType = 'nonprod'
param postgreSQLServerName = 'bestbank-dbsrv-dev'
param postgreSQLDatabaseName = 'bestbank-db-dev'
param appServicePlanName = 'bestbank-asp-dev'
param appServiceAPIAppName = 'bestbank-be-dev'
param appServiceAppName = 'bestbank-fe-dev'
param location = 'North Europe'
param appServiceAPIDBHostFLASK_APP =  'iebank_api\\__init__.py'
param appServiceAPIDBHostFLASK_DEBUG =  '1'
param appServiceAPIDBHostDBUSER = 'github-secret-replaced-in-workflow'
param appServiceAPIEnvVarDBPASS =  'github-secret-replaced-in-workflow'
param appServiceAPIEnvVarDBHOST =  'bestbank-dbsrv-dev.postgres.database.azure.com'
param appServiceAPIEnvVarDBNAME =  'bestbank-db-dev'
param appServiceAPIEnvVarENV =  'dev'
param appServiceAPIEnvVarDEFAULT_ADMIN_PASSWORD = 'BestBankPASS' 
param appServiceAPIEnvVarDEFAULT_ADMIN_USERNAME = 'BestBankUSER' 



// log analytics 
param logAnalyticsWorkspaceName = 'BestBank-log-dev'
param logAnalyticsSkuName = 'PerGB2018'  
param logAnalyticsDataRetention = 30  
param publicNetworkAccessForIngestion = 'Enabled'
param publicNetworkAccessForQuery = 'Enabled'


// Application Insights
param appInsightsName = 'bestbank-appinsights-dev'
param appInsightsApplicationType = 'web'
param appInsightsDisableIpMasking = true
param appInsightsPublicNetworkAccessForIngestion = 'Enabled'
param appInsightsPublicNetworkAccessForQuery = 'Enabled'
param appInsightsRetentionInDays = 365
param appInsightsSamplingPercentage = 100

//container-registry
param containerRegistryName = 'bestbank-container-registry-dev'

