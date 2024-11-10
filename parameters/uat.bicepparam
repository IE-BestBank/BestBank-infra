using '../main.bicep'

param environmentType = 'nonprod'
param postgreSQLServerName = 'akhreiche-dbsrv-uat'
param postgreSQLDatabaseName = 'akhreiche-db-uat'
param appServicePlanName = 'akhreiche-asp-uat'
param appServiceAPIAppName = 'akhreiche-be-uat'
param appServiceAppName = 'akhreiche-fe-uat'
param location = 'North Europe'
param appServiceAPIDBHostFLASK_APP =  'iebank_api\\__init__.py'
param appServiceAPIDBHostFLASK_DEBUG =  '1'
param appServiceAPIDBHostDBUSER = 'github-secret-replaced-in-workflow'
param appServiceAPIEnvVarDBPASS =  'github-secret-replaced-in-workflow'
param appServiceAPIEnvVarDBHOST =  'akhreiche-dbsrv-uat.postgres.database.azure.com'
param appServiceAPIEnvVarDBNAME =  'akhreiche-db-uat'
param appServiceAPIEnvVarENV =  'uat'
