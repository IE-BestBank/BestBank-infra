using '../main.bicep'


//1-Key Vault parameters
// Key Vault Parameters
param keyVaultName = 'BestBank-KV-dev' //changed key vault name bec of past softdelte = true 
param enableRbacAuthorization = true
param enableVaultForDeployment = true
param enableVaultForTemplateDeployment = true
param enableSoftDelete = false 
param sku = 'standard'
param keyVaultRoleAssignments= [ 
  {
    principalId: '25d8d697-c4a2-479f-96e0-15593a830ae5' // BCSAI2024-DEVOPS-STUDENTS-A-SP
    roleDefinitionIdOrName: 'Key Vault Secrets User'
    principalType: 'ServicePrincipal'
    }
    {
      principalId: 'a03130df-486f-46ea-9d5c-70522fe056de' // BCSAI2024-DEVOPS-STUDENTS-A
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

//server 
param postgreSQLServerName = 'bestbank-dbsrv-dev'
param skuName = 'Standard_B1ms'
param skuTier = 'Burstable'



//databse
param postgreSQLDatabaseName = 'bestbank-db-dev'


//6- ASP 
// App Service Plan parameters for the dev environment
param appServicePlanName = 'bestbank-asp-be-dev' // Unique name for the App Service Plan
param appServicePlanSku = 'F1' // Pricing tier (e.g., F1 for free, B1 for basic) --> i think we should do f1 for dev and b1 for uat and prod 

//7- app service - containerized be 
// App Service Backend Parameters for Dev
param appServiceWebsiteBEName = 'bestbank-be-dev' // Name of the backend App Service
param dockerRegistryImageName = 'bestbank-backend' // Docker image name
param dockerRegistryImageVersion = 'latest' // Docker image version
param appServiceBeAppSettings = [
  { name: 'ENV', value: 'dev' }
  { name: 'DBHOST', value: 'bestbank-dbsrv-dev.postgres.database.azure.com' }
  { name: 'DBNAME', value: 'bestbank-db-dev' }
  { name: 'DBUSER', value: 'bestbank-be-dev' }
  { name: 'FLASK_DEBUG', value: '1' }
  { name: 'SCM_DO_BUILD_DURING_DEPLOYMENT', value:'true' }
]

//9 swa 
param StaticWebAppName = 'bestbank-SWA-dev'
param SWAsku = 'Free'



// //4- log analytics 
param logAnalyticsWorkspaceName = 'BestBank-log-dev'
param logAnalyticsDataRetention = 30 
param logAnalyticsSkuName = 'PerGB2018'



// //5- Application Insights
param appInsightsName = 'bestbank-appinsights-dev'
param appInsightsApplicationType = 'web'
param appInsightsRetentionInDays = 90



// 10. Workbook Parameters
param workbookName = 'bestbankWorkbookDev'
param workbookJson = loadTextContent('../templates/BestBankWorkbook.workbook')
