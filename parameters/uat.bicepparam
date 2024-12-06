using '../main.bicep'

//1-Key Vault parameters
param keyVaultName = 'BestBank-KV-uat'
param enableRbacAuthorization = true
param enableVaultForDeployment = true
param enableVaultForTemplateDeployment = true
param enableSoftDelete = true
param keyVaultRoleAssignments= [
  {
    principalId: '25d8d697-c4a2-479f-96e0-15593a830ae5' // BCSAI2024-DEVOPS-STUDENTS-A-SP
    roleDefinitionIdOrName: 'Key Vault Secrets User' //so that the SP can access the secrets such as the swa token
    principalType: 'ServicePrincipal'
    }
]

// //2 - azure container-registry
param containerRegistryName = 'bestbankContRegistryUat'
param adminPasswordSecretName0 = 'adminPasswordSecretName0'
param adminPasswordSecretName1 = 'adminPasswordSecretName1'
param adminUsernameSecretName = 'adminUsernameSecretName'

//server
param postgreSQLServerName = 'bestbank-dbsrv-uat'
// param administratorLogin = 'iebankdbadmin'
// param administratorLoginPassword = ''

//databse
param postgreSQLDatabaseName = 'bestbank-db-uat'

//6- asp
// App Service Plan Parameters for uat
param appServicePlanName = 'bestbank-asp-be-uat' // Unique name for the App Service Plan
param appServicePlanSku = 'B1' // Pricing tier (e.g., F1 for free, B1 for basic

//7- app service - containerized be
// App Service Backend Parameters for uat
param appServiceWebsiteBEName = 'bestbank-be-uat' // Name of the backend App Service
param dockerRegistryImageName = 'bestbank-be' // Docker image name
param dockerRegistryImageVersion = 'latest' // Docker image version
param appServiceBeAppSettings = [
  { name: 'ENV', value: 'uat' }
  { name: 'DBHOST', value: 'bestbank-dbsrv-uat.postgres.database.azure.com' }
  { name: 'DBNAME', value: 'bestbank-db-uat' }
  { name: 'DBUSER', value: 'bestbank-be-uat' }
  { name: 'FLASK_DEBUG', value: '1' }
  { name: 'SCM_DO_BUILD_DURING_DEPLOYMENT', value:'true' }
]


//step 9 - deploy swa

param StaticWebAppName = 'bestbank-SWA-uat'


param SWAsku = 'Free'

// //4- log analytics 
param logAnalyticsWorkspaceName = 'BestBank-log-uat'
param logAnalyticsDataRetention = 30 
param logAnalyticsSkuName = 'PerGB2018'

// //5- Application Insights
param appInsightsName = 'bestbank-appinsights-uat'
param appInsightsApplicationType = 'web'
param appInsightsRetentionInDays = 90

// 10. Workbook Parameters
param workbookName = 'bestbankWorkbookUat'
param workbookJson = loadTextContent('../templates/BestBankWorkbook.workbook')

// 11. Slack Webhook URL for Incident Response
param slackWebhookUrl = 'https://hooks.slack.com/services/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'

