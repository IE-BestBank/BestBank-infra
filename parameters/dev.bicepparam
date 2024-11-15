using '../main.bicep'

// App Service (Backend)
param appServicePlanBEName = 'bestbank-asp-be-dev'
param appServiceAPIAppName = 'bestbank-be-dev'
param appServiceAPIEnvVarENV = 'dev'
param appServiceAPIEnvVarDBHOST = 'bestbank-dbsrv-dev.postgres.database.azure.com'
param appServiceAPIEnvVarDBNAME = 'bestbank-db-dev'
param appServiceAPIEnvVarDBPASS = 'github-secret-replaced-in-workflow'
param appServiceAPIDBHostDBUSER = 'github-secret-replaced-in-workflow'
param appServiceAPIEnvVarDEFAULT_ADMIN_PASSWORD = 'BestBankPASS'
param appServiceAPIEnvVarDEFAULT_ADMIN_USERNAME = 'BestBankUSER'

// Static Web App (Frontend)
param staticWebAppName = 'bestbank-fe-dev'

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
param containerRegistryName = 'bestbankContRegistryDev'


