using '../main.bicep'

//1 - azure container-registry
param containerRegistryName = 'bestbankContRegistryUat'

//2- log analytics 
param logAnalyticsWorkspaceName = 'bestbank-log-uat'
param logAnalyticsSkuName = 'PerGB2018'  
param logAnalyticsDataRetention = 30  
param publicNetworkAccessForIngestion = 'Enabled'
param publicNetworkAccessForQuery = 'Enabled'

//3- application insights 
param appInsightsName = 'bestbank-appinsights-uat'
param appInsightsApplicationType = 'web'
param appInsightsDisableIpMasking = true
param appInsightsPublicNetworkAccessForIngestion = 'Enabled'
param appInsightsPublicNetworkAccessForQuery = 'Enabled'
param appInsightsRetentionInDays = 365
param appInsightsSamplingPercentage = 100

// // App Service (Backend)
// param appServicePlanBEName = 'bestbank-asp-be-uat'
// param appServiceAPIAppName = 'bestbank-be-uat'
// param appServiceAPIEnvVarENV = 'uat'
// param appServiceAPIEnvVarDBHOST = 'bestbank-dbsrv-uat.postgres.database.azure.com'
// param appServiceAPIEnvVarDBNAME = 'bestbank-db-uat'
// param appServiceAPIEnvVarDBPASS = 'github-secret-replaced-in-workflow'
// param appServiceAPIDBHostDBUSER = 'github-secret-replaced-in-workflow'
// param appServiceAPIEnvVarDEFAULT_ADMIN_PASSWORD = 'BestBankPASS'
// param appServiceAPIEnvVarDEFAULT_ADMIN_USERNAME = 'BestBankUSER'

// // Static Web App (Frontend)
// param staticWebAppName = 'bestbank-fe-uat'








