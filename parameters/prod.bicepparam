using '../main.bicep'
#trigger

//1-Key Vault parameters
// Key Vault Parameters
param keyVaultName = 'BestBank-KV-prod' //changed key vault name bec of past softdelte = true 
param sku = 'standard'
param enableRbacAuthorization = true
param enableVaultForDeployment = true
param enableVaultForTemplateDeployment = true
param enableSoftDelete = true //prod doesnt get deleted overnight 
param keyVaultRoleAssignments= [ 
  {
    principalId: '25d8d697-c4a2-479f-96e0-15593a830ae5' // BCSAI2024-DEVOPS-STUDENTS-A-SP
    roleDefinitionIdOrName: 'Key Vault Secrets User' //so that the SP can access the secrets such as the swa token 
    principalType: 'ServicePrincipal'
    }
]


// //2- azure container-registry
param Contsku = 'Standard'
param containerRegistryName = 'bestbankContRegistryProd'
param adminPasswordSecretName0 = 'adminPasswordSecretName0'
param adminPasswordSecretName1 = 'adminPasswordSecretName1'
param adminUsernameSecretName = 'adminUsernameSecretName'

//server 
param postgreSQLServerName = 'bestbank-dbsrv-prod'
param skuName = 'Standard_B1ms'
param skuTier = 'Burstable'

//databse
param postgreSQLDatabaseName = 'bestbank-db-prod'


//6- ASP 
// App Service Plan parameters 
param appServicePlanName = 'bestbank-asp-be-prod' // Unique name for the App Service Plan
param appServicePlanSku = 'B1' // Pricing tier (e.g., F1 for free, B1 for basic) --> i think we should do f1 for dev and b1 for uat and prod 

//7- app service - containerized be 
// App Service Backend Parameters for Dev
param appServiceWebsiteBEName = 'bestbank-be-prod' // Name of the backend App Service
param dockerRegistryImageName = 'bestbank-backend' // Docker image name
param dockerRegistryImageVersion = 'latest' // Docker image version
param appServiceBeAppSettings = [
  { name: 'ENV', value: 'prod' }
  { name: 'DBHOST', value: 'bestbank-dbsrv-prod.postgres.database.azure.com' }
  { name: 'DBNAME', value: 'bestbank-db-prod' }
  { name: 'DBUSER', value: 'bestbank-be-prod' }
  { name: 'FLASK_DEBUG', value: '1' }
  { name: 'SCM_DO_BUILD_DURING_DEPLOYMENT', value:'true' }
]

//9 swa 
param StaticWebAppName = 'bestbank-SWA-prod'
param SWAsku = 'Standard' 



// //4- log analytics 
param logAnalyticsWorkspaceName = 'BestBank-log-prod'
param logAnalyticsDataRetention = 30 
param logAnalyticsSkuName = 'PerGB2018' //standard and free dont work - not supported anymore



// //5- Application Insights
param appInsightsName = 'bestbank-appinsights-prod'
param appInsightsApplicationType = 'web'
param appInsightsRetentionInDays = 90



