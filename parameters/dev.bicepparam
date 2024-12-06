using '../main.bicep'

// 1. Key Vault Parameters
param keyVaultName = 'BestBank-KV-dev' // Changed Key Vault name due to past soft delete = true
param enableRbacAuthorization = true
param enableVaultForDeployment = true
param enableVaultForTemplateDeployment = true

param enableSoftDelete = false 
param sku = 'standard'
param keyVaultRoleAssignments= [ 
  {
    principalId: '25d8d697-c4a2-479f-96e0-15593a830ae5' // Service Principal
    roleDefinitionIdOrName: 'Key Vault Secrets User'
    principalType: 'ServicePrincipal'
  }
  {
    principalId: 'a03130df-486f-46ea-9d5c-70522fe056de' // Group.
    roleDefinitionIdOrName: 'Key Vault Administrator'
    principalType: 'Group'
  }
]



// //2- azure container-registry
param Contsku = 'Basic'

param containerRegistryName = 'bestbankContRegistryDev'
param adminPasswordSecretName0 = 'adminPasswordSecretName0'
param adminPasswordSecretName1 = 'adminPasswordSecretName1'
param adminUsernameSecretName = 'adminUsernameSecretName'

// 3. PostgreSQL Server Parameters
param postgreSQLServerName = 'bestbank-dbsrv-dev'

param skuName = 'Standard_B1ms'
param skuTier = 'Burstable'



// 4. PostgreSQL Database Parameters
param postgreSQLDatabaseName = 'bestbank-db-dev'

// 5. App Service Plan Parameters
param appServicePlanName = 'bestbank-asp-be-dev' // Unique name for the App Service Plan
param appServicePlanSku = 'F1' // Free SKU for dev; can upgrade for uat/prod

// 6. Backend App Service Parameters (Containerized)
param appServiceWebsiteBEName = 'bestbank-be-dev' // Backend App Service name
param dockerRegistryImageName = 'bestbank-be' // Docker image name
param dockerRegistryImageVersion = 'latest' // Docker image version
param appServiceBeAppSettings = [
  { name: 'ENV', value: 'dev' }
  { name: 'DBHOST', value: 'bestbank-dbsrv-dev.postgres.database.azure.com' }
  { name: 'DBNAME', value: 'bestbank-db-dev' }
  { name: 'DBUSER', value: 'bestbank-be-dev' }
  { name: 'FLASK_DEBUG', value: '1' }
  { name: 'SCM_DO_BUILD_DURING_DEPLOYMENT', value: 'true' }
]

// 7. Static Web App Parameters
param StaticWebAppName = 'bestbank-SWA-dev'
param SWAsku = 'Free'

// 8. Log Analytics Workspace Parameters
param logAnalyticsWorkspaceName = 'BestBank-log-dev'
param logAnalyticsDataRetention = 30 // Retention period in days
param logAnalyticsSkuName = 'PerGB2018' // Pricing tier for Log Analytics Workspace

// 9. Application Insights Parameters
param appInsightsName = 'bestbank-appinsights-dev'
param appInsightsApplicationType = 'web'
param appInsightsRetentionInDays = 90 // Retention period in days


