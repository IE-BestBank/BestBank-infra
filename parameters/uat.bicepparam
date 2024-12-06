using '../main.bicep'

// 1. Key Vault Parameters
param keyVaultName = 'BestBank-KV-uat'
param enableRbacAuthorization = true
param enableVaultForDeployment = true
param enableVaultForTemplateDeployment = true
param enableSoftDelete = true
param keyVaultRoleAssignments = [
  {
    principalId: '25d8d697-c4a2-479f-96e0-15593a830ae5' // BCSAI2024-DEVOPS-STUDENTS-A-SP
    roleDefinitionIdOrName: 'Key Vault Secrets User' // So the SP can access the secrets such as the SWA token
    principalType: 'ServicePrincipal'
  }
]

// 2. Azure Container Registry Parameters
param containerRegistryName = 'bestbankContRegistryUat'
param adminPasswordSecretName0 = 'adminPasswordSecretName0'
param adminPasswordSecretName1 = 'adminPasswordSecretName1'
param adminUsernameSecretName = 'adminUsernameSecretName'

// 3. PostgreSQL Server Parameters
param postgreSQLServerName = 'bestbank-dbsrv-uat'

// 4. PostgreSQL Database Parameters
param postgreSQLDatabaseName = 'bestbank-db-uat'

// 5. App Service Plan Parameters
param appServicePlanName = 'bestbank-asp-be-uat' // Unique name for the App Service Plan
param appServicePlanSku = 'B1' // Pricing tier (e.g., F1 for free, B1 for basic)

// 6. Backend App Service Parameters (Containerized)
param appServiceWebsiteBEName = 'bestbank-be-uat' // Name of the backend App Service
param dockerRegistryImageName = 'bestbank-be' // Docker image name
param dockerRegistryImageVersion = 'latest' // Docker image version
param appServiceBeAppSettings = [
  { name: 'ENV', value: 'uat' }
  { name: 'DBHOST', value: 'bestbank-dbsrv-uat.postgres.database.azure.com' }
  { name: 'DBNAME', value: 'bestbank-db-uat' }
  { name: 'DBUSER', value: 'bestbank-be-uat' }
  { name: 'FLASK_DEBUG', value: '1' }
  { name: 'SCM_DO_BUILD_DURING_DEPLOYMENT', value: 'true' }
]

// 7. Static Web App Parameters
param StaticWebAppName = 'bestbank-SWA-uat'
param SWAsku = 'Free'

// 8. Log Analytics Workspace Parameters
param logAnalyticsWorkspaceName = 'BestBank-log-uat'
param logAnalyticsDataRetention = 30 // Retention period in days
param logAnalyticsSkuName = 'PerGB2018'

// 9. Application Insights Parameters
param appInsightsName = 'bestbank-appinsights-uat'
param appInsightsApplicationType = 'web'
param appInsightsRetentionInDays = 90 // Retention period in days

// 10. Workbook Parameters
param workbookName = 'bestbankWorkbookUat'
param workbookJson = loadTextContent('../templates/BestBankWorkbook.workbook')

// 12. Logic App Parameters
param logicAppName = 'bestbank-logicapp-uat'
