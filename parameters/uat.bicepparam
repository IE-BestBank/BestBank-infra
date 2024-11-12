using '../main.bicep'

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


param logAnalyticsWorkspaceName = 'bestbank-log-uat'
param logAnalyticsSkuName = 'PerGB2018'  
param logAnalyticsDataRetention = 30  
param publicNetworkAccessForIngestion = 'Enabled'
param publicNetworkAccessForQuery = 'Enabled'



