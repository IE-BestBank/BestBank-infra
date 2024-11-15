using '../main.bicep'

// App Service (Backend)
param appServicePlanNameBE = 'bestbank-asp-be-uat'
param appServiceAPIAppName = 'bestbank-be-uat'
param appServiceAPIEnvVarENV = 'uat'
param appServiceAPIEnvVarDBHOST = 'bestbank-dbsrv-uat.postgres.database.azure.com'
param appServiceAPIEnvVarDBNAME = 'bestbank-db-uat'
param appServiceAPIEnvVarDBPASS = 'github-secret-replaced-in-workflow'
param appServiceAPIDBHostDBUSER = 'github-secret-replaced-in-workflow'
// param appServiceAPIDBHostFLASK_APP = 'iebank_api\\__init__.py'
// param appServiceAPIDBHostFLASK_DEBUG = '1'
param appServiceAPIEnvVarDEFAULT_ADMIN_PASSWORD = 'BestBankPASS'
param appServiceAPIEnvVarDEFAULT_ADMIN_USERNAME = 'BestBankUSER'

// Static Web App (Frontend)
param staticWebAppName = 'bestbank-fe-uat'


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

//container registry 
param containerRegistryName = 'bestbankContRegistryUat'

// app-service-plan-be (container)

