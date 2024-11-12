using '../main.bicep'

param environmentType = 'nonprod'
param postgreSQLServerName = 'BestBank-dbsrv-dev'
param postgreSQLDatabaseName = 'BestBank-db-dev'
param appServicePlanName = 'BestBank-asp-dev'
param appServiceAPIAppName = 'BestBank-be-dev'
param appServiceAppName = 'BestBank-fe-dev'
param location = 'North Europe'
param appServiceAPIDBHostFLASK_APP =  'iebank_api\\__init__.py'
param appServiceAPIDBHostFLASK_DEBUG =  '1'
param appServiceAPIDBHostDBUSER = 'github-secret-replaced-in-workflow'
param appServiceAPIEnvVarDBPASS =  'github-secret-replaced-in-workflow'
param appServiceAPIEnvVarDBHOST =  'BestBank-dbsrv-dev.postgres.database.azure.com'
param appServiceAPIEnvVarDBNAME =  'BestBank-db-dev'
param appServiceAPIEnvVarENV =  'dev'



param logAnalyticsWorkspaceName = 'BestBank-log-dev'
param logAnalyticsSkuName = 'PerGB2018'  
param logAnalyticsDataRetention = 30  
param publicNetworkAccessForIngestion = 'Enabled'
param publicNetworkAccessForQuery = 'Enabled'



// param keyVaultName = 'BestBank-kv-dev'
// param keyVaultLocation = location
// param keyVaultSku = 'standard'  // Set based on your project needs; 'standard' is generally sufficient
// param enableVaultForDeployment = true
// param enableVaultForTemplateDeployment = true
// param enableVaultForDiskEncryption = false  // Set to true if using Azure Disk Encryption
// param softDeleteRetentionInDays = 90
// param keyVaultTags = {
//   Environment: environmentType
//   Project: 'IE_Best_Bank'
// }



// param staticWebAppName = 'BestBank-swa-dev'  // Name for your Static Web App
// param staticWebAppSku = 'Free'  // Change to 'Standard' if using private endpoints or custom domains
// param staticWebAppLocation = location  // Match the location to other resources
// param staticWebAppRepositoryToken = 'github-token-replaced-in-workflow'  // Placeholder for your GitHub PAT
// param staticWebAppRepositoryUrl = 'https://github.com/IE-BestBank/BestBank-fe'  // repository URL
// param staticWebAppBranch = 'modules'  // GitHub branch name for deployment 'moudles' for now - should be main later?
