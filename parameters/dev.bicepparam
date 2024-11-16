using '../main.bicep'

//1- azure container-registry
param containerRegistryName = 'bestbankContRegistryDev'

//2- log analytics 
param logAnalyticsWorkspaceName = 'BestBank-log-dev'
param logAnalyticsSkuName = 'PerGB2018'  
param logAnalyticsDataRetention = 30  
param publicNetworkAccessForIngestion = 'Enabled'
param publicNetworkAccessForQuery = 'Enabled'

//3- Application Insights
param appInsightsName = 'bestbank-appinsights-dev'
param appInsightsApplicationType = 'web'
param appInsightsDisableIpMasking = true
param appInsightsPublicNetworkAccessForIngestion = 'Enabled'
param appInsightsPublicNetworkAccessForQuery = 'Enabled'
param appInsightsRetentionInDays = 365
param appInsightsSamplingPercentage = 100


// // App Service plan(Backend)
// param appServicePlanBEName = 'bestbank-asp-be-dev'
// param appServiceAPIAppName = 'bestbank-be-dev'
// param appServiceAPIEnvVarENV = 'dev'
// param appServiceAPIEnvVarDBHOST = 'bestbank-dbsrv-dev.postgres.database.azure.com'
// param appServiceAPIEnvVarDBNAME = 'bestbank-db-dev'
// param appServiceAPIEnvVarDBPASS = 'github-secret-replaced-in-workflow'
// param appServiceAPIDBHostDBUSER = 'github-secret-replaced-in-workflow'
// param appServiceAPIEnvVarDEFAULT_ADMIN_PASSWORD = 'BestBankPASS'
// param appServiceAPIEnvVarDEFAULT_ADMIN_USERNAME = 'BestBankUSER'

// // Static Web App (Frontend)
// param staticWebAppName = 'bestbank-fe-dev'


// //key vault 
// param keyVaultName = 'keyVault-bestbank-dev'
// param keyVaultRoleAssignments = [
//   {
//     principalId: '<AppServiceManagedIdentityPrincipalId>' // Replace with the actual managed identity's principal ID
//     roleDefinitionIdOrName: 'Key Vault Secrets User'
//   }
//   {
//     principalId: '<YourUserPrincipalId>' // Replace with your Azure AD User Principal ID
//     roleDefinitionIdOrName: 'Key Vault Administrator'
//   }
// ]
