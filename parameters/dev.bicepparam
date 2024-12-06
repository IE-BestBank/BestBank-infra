using '../main.bicep'

// 1. Key Vault Parameters
param keyVaultName = 'BestBank-KV-dev'
param enableRbacAuthorization = true
param enableVaultForDeployment = true
param enableVaultForTemplateDeployment = true
param enableSoftDelete = false
param keyVaultRoleAssignments = []

// 2. Azure Container Registry Parameters
param containerRegistryName = 'bestbankContRegistryDev'
param adminPasswordSecretName0 = 'adminPasswordSecretName0'
param adminPasswordSecretName1 = 'adminPasswordSecretName1'
param adminUsernameSecretName = 'adminUsernameSecretName'

// 3. PostgreSQL Server Parameters
param postgreSQLServerName = 'bestbank-dbsrv-dev'

// 4. PostgreSQL Database Parameters
param postgreSQLDatabaseName = 'bestbank-db-dev'

// 5. App Service Plan Parameters
param appServicePlanName = 'bestbank-asp-be-dev'
param appServicePlanSku = 'F1'

// 6. Backend App Service Parameters (Containerized)
param appServiceWebsiteBEName = 'bestbank-be-dev'
param dockerRegistryImageName = 'bestbank-be'
param dockerRegistryImageVersion = 'latest'
param appServiceBeAppSettings = [
  { name: 'ENV', value: 'dev' }
  { name: 'DBHOST', value: 'bestbank-dbsrv-dev.postgres.database.azure.com' }
  { name: 'DBNAME', value: 'bestbank-db-dev' }
  { name: 'DBUSER', value: 'bestbank-be-dev' }
]

// 7. Static Web App Parameters
param StaticWebAppName = 'bestbank-SWA-dev'
param SWAsku = 'Free'

// 8. Log Analytics Workspace Parameters
param logAnalyticsWorkspaceName = 'BestBank-log-dev'
param logAnalyticsDataRetention = 30
param logAnalyticsSkuName = 'PerGB2018'

// 9. Application Insights Parameters
param appInsightsName = 'bestbank-appinsights-dev'
param appInsightsApplicationType = 'web'
param appInsightsRetentionInDays = 90

// 10. Workbook Parameters
param workbookName = 'bestbankWorkbookDev'
param workbookJson = loadTextContent('../templates/BestBankWorkbook.workbook')

// 12. Logic App Parameters
param logicAppName = 'bestbank-logicapp-dev'

// 13. Slack Webhook URL Parameter
param slackWebhookUrl = '' // This will be passed dynamically from GitHub secrets
