using '../main.bicep'

param environmentType = 'nonprod'
param postgreSQLServerName = 'akhreiche-dbsrv-dev'
param postgreSQLDatabaseName = 'akhreiche-db-dev'
param appServicePlanName = 'akhreiche-asp-dev'
param appServiceAPIAppName = 'akhreiche-be-dev'
param appServiceAppName = 'akhreiche-fe-dev'
param location = 'North Europe'
param appServiceAPIDBHostFLASK_APP =  'iebank_api\\__init__.py'
param appServiceAPIDBHostFLASK_DEBUG =  '1'
param appServiceAPIDBHostDBUSER = 'github-secret-replaced-in-workflow'
param appServiceAPIEnvVarDBPASS =  'github-secret-replaced-in-workflow'
param appServiceAPIEnvVarDBHOST =  'akhreiche-dbsrv-dev.postgres.database.azure.com'
param appServiceAPIEnvVarDBNAME =  'akhreiche-db-dev'
param appServiceAPIEnvVarENV =  'dev'



param logAnalyticsWorkspaceName = 'akhreiche-log-dev'
param logAnalyticsSkuName = 'PerGB2018'  
param logAnalyticsDataRetention = 30  
param publicNetworkAccessForIngestion = 'Enabled'
param publicNetworkAccessForQuery = 'Enabled'



param keyVaultName = 'akhreiche-kv-dev'
param keyVaultLocation = location
param keyVaultSku = 'standard'  // Set based on your project needs; 'standard' is generally sufficient
param enableVaultForDeployment = true
param enableVaultForTemplateDeployment = true
param enableVaultForDiskEncryption = false  // Set to true if using Azure Disk Encryption
param softDeleteRetentionInDays = 90
param keyVaultTags = {
  Environment: environmentType
  Project: 'IE_Best_Bank'
}
