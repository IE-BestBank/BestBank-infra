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
param dockerRegistryImageName = 'bestbank-backend' // Docker image name
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



// // 3- DB and server 
// // PostgreSQL parameters (aligning with app service)
// param postgreSQLServerName = 'bestbank-dbsrv-uat' // DBHOST
// param postgreSQLAdminUsername = 'github-secret-replaced-in-workflow' // DBUSER
// param postgreSQLAdminPassword = 'github-secret-replaced-in-workflow' // DBPASS
// param postgreSQLDatabaseName = 'bestbank-db-uat' // DBNAME
// param postgreSQLSkuName = 'Standard_B1ms'
// param postgreSQLBackupRetentionDays = 7
// param postgreSQLGeoRedundantBackup = 'Disabled'
// param postgreSQLStorageSizeGb = 32


// //4- log analytics 
// param logAnalyticsWorkspaceName = 'bestbank-log-uat'
// param logAnalyticsSkuName = 'PerGB2018'  
// param logAnalyticsDataRetention = 30  
// param publicNetworkAccessForIngestion = 'Enabled'
// param publicNetworkAccessForQuery = 'Enabled'

// //5- application insights 
// param appInsightsName = 'bestbank-appinsights-uat'
// param appInsightsApplicationType = 'web'
// param appInsightsDisableIpMasking = true
// param appInsightsPublicNetworkAccessForIngestion = 'Enabled'
// param appInsightsPublicNetworkAccessForQuery = 'Enabled'
// param appInsightsRetentionInDays = 365
// param appInsightsSamplingPercentage = 100


// //7- app service - containerized be 
// // App Service Backend Parameters for uat
// param appServiceBackendName = 'bestbank-be-uat' // Name of the backend App Service
// param backendDockerImageName = 'bestbank-backend' // Docker image name
// param backendDockerImageVersion = 'latest' // Docker image version
// param backendAppSettings = [
//   { name: 'ENV', value: 'uat' }
//   { name: 'DBHOST', value: 'bestbank-dbsrv-uat.postgres.database.azure.com' } // PostgreSQL FQDN
//   { name: 'DBNAME', value: 'bestbank-db-uat' } // Database name
//   { name: 'DBUSER', value: 'iebankdbadmin' } // Database user
//   { name: 'DEFAULT_ADMIN_USERNAME', value: 'BestBankUSER' } // Admin username
// ]

// //8- Static Web App Parameters
// param staticWebAppName = 'bestbank-swa-uat'
// param staticWebAppSku = 'Free' // Free for dev, Standard for UAT/Prod
// param staticWebAppLocation = 'northeurope' // Keep consistent across environments
// param staticWebAppRepositoryUrl = 'https://github.com/AlexaKhreiche/BestBank-fe'
// param staticWebAppBranch = 'main'
// @secure()
// param staticWebAppRepositoryToken = 'your-github-personal-access-token' // Store securely in deployment pipeline //where do i find this?
