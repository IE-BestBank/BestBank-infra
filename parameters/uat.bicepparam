using '../main.bicep'

//app-service
param environmentType = 'nonprod'
param postgreSQLServerName = 'bestbank-dbsrv-uat'
param postgreSQLDatabaseName = 'bestbank-db-uat'
param appServicePlanName = 'bestbank-asp-uat'
param appServiceAPIAppName = 'bestbank-be-uat'
param appServiceAppName = 'bestbank-fe-uat'
param location = 'North Europe'
param appServiceAPIDBHostFLASK_APP =  'iebank_api\\__init__.py'
param appServiceAPIDBHostFLASK_DEBUG =  '1'
param appServiceAPIDBHostDBUSER = 'github-secret-replaced-in-workflow'
param appServiceAPIEnvVarDBPASS =  'github-secret-replaced-in-workflow'
param appServiceAPIEnvVarDBHOST =  'bestbank-dbsrv-uat.postgres.database.azure.com'
param appServiceAPIEnvVarDBNAME =  'bestbank-db-uat'
param appServiceAPIEnvVarENV =  'uat'
param appServiceAPIEnvVarDEFAULT_ADMIN_PASSWORD = 'BestBankPASS' 
param appServiceAPIEnvVarDEFAULT_ADMIN_USER = 'BestBankUSER' 

//log analytics 
param logAnalyticsWorkspaceName = 'bestbank-log-uat'
param logAnalyticsSkuName = 'PerGB2018'  
param logAnalyticsDataRetention = 30  
param publicNetworkAccessForIngestion = 'Enabled'
param publicNetworkAccessForQuery = 'Enabled'

//application insights 
param appInsightsName = 'bestbank-appinsights-uat'
param appInsightsApplicationType = 'web'
param appInsightsDisableIpMasking = true
param appInsightsPublicNetworkAccessForIngestion = 'Enabled'
param appInsightsPublicNetworkAccessForQuery = 'Enabled'
param appInsightsRetentionInDays = 365
param appInsightsSamplingPercentage = 100
