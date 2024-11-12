using '../main.bicep'

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



param logAnalyticsWorkspaceName = 'bestbank-log-dev'
param logAnalyticsSkuName = 'PerGB2018'  
param logAnalyticsDataRetention = 30  
param publicNetworkAccessForIngestion = 'Enabled'
param publicNetworkAccessForQuery = 'Enabled'




