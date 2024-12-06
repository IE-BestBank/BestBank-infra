using '../main.bicep'

// 1. Key Vault Parameters
param keyVaultName = 'BestBank-KV-uat'
param enableRbacAuthorization = true
param enableVaultForDeployment = true
param enableVaultForTemplateDeployment = true
param enableSoftDelete = false
param keyVaultRoleAssignments = [
  {
    principalId: '25d8d697-c4a2-479f-96e0-15593a830ae5' // Service Principal
    roleDefinitionIdOrName: 'Key Vault Secrets User'
    principalType: 'ServicePrincipal'
  }
  {
    principalId: 'a03130df-486f-46ea-9d5c-70522fe056de' // Group
    roleDefinitionIdOrName: 'Key Vault Administrator'
    principalType: 'Group'
  }
]

// 2. Azure Container Registry Parameters
param containerRegistryName = 'bestbankContRegistryUAT'
param adminPasswordSecretName0 = 'adminPasswordSecretName0'
param adminPasswordSecretName1 = 'adminPasswordSecretName1'
param adminUsernameSecretName = 'adminUsernameSecretName'

// 3. PostgreSQL Server Parameters
param postgreSQLServerName = 'bestbank-dbsrv-uat'

// 4. PostgreSQL Database Parameters
param postgreSQLDatabaseName = 'bestbank-db-uat'

// 5. App Service Plan Parameters
param appServicePlanName = 'bestbank-asp-be-uat'
param appServicePlanSku = 'F1'

// 6. Backend App Service Parameters (Containerized)
param appServiceWebsiteBEName = 'bestbank-be-uat'
param dockerRegistryImageName = 'bestbank-be'
param dockerRegistryImageVersion = 'latest'
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
param logAnalyticsDataRetention = 30
param logAnalyticsSkuName = 'PerGB2018'

// 9. Application Insights Parameters
param appInsightsName = 'bestbank-appinsights-uat'
param appInsightsApplicationType = 'web'
param appInsightsRetentionInDays = 90

// 10. Workbook Parameters
param workbookName = 'bestbankWorkbookUat'
param workbookJson = loadTextContent('../templates/BestBankWorkbook.workbook')

// 12. Logic App Parameters
param logicAppName = 'bestbank-logicapp-uat'

// 13. Slack Webhook URL Parameter
param slackWebhookUrl = '' // This will be passed dynamically from GitHub secrets
