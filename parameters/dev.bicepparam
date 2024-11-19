using '../main.bicep'


//1-Key Vault parameters
// Key Vault Parameters
param keyVaultName = 'keyVault-BestBank-dev' //changed key vault name bec of past softdelte = true 
param enableRbacAuthorization = true
param enableVaultForDeployment = true
param enableVaultForTemplateDeployment = true
param enableSoftDelete = false 


// //2- azure container-registry
param containerRegistryName = 'bestbankContRegistryDev'
param adminPasswordSecretName0 = 'adminPasswordSecretName0'
param adminPasswordSecretName1 = 'adminPasswordSecretName1'
param adminUsernameSecretName = 'adminUsernameSecretName'

//server 
param postgreSQLServerName = 'bestbank-dbsrv-dev'
param administratorLogin = 'iebankdbadmin'
param administratorLoginPassword = ''

//databse
param postgreSQLDatabaseName = 'bestbank-db-dev'

// //3- DB & Server 
// // PostgreSQL parameters (aligning with app service)
// param postgreSQLServerName = 'bestbank-dbsrv-dev' // DBHOST
// param postgreSQLAdminUsername = 'github-secret-replaced-in-workflow' // DBUSER
// param postgreSQLAdminPassword = 'github-secret-replaced-in-workflow' // DBPASS
// param postgreSQLDatabaseName = 'bestbank-db-dev' // DBNAME
// param postgreSQLSkuName = 'Standard_B1ms'
// param postgreSQLBackupRetentionDays = 7
// param postgreSQLGeoRedundantBackup = 'Disabled'
// param postgreSQLStorageSizeGb = 32



// //4- log analytics 
// param logAnalyticsWorkspaceName = 'BestBank-log-dev'
// param logAnalyticsSkuName = 'PerGB2018'  
// param logAnalyticsDataRetention = 30  
// param publicNetworkAccessForIngestion = 'Enabled'
// param publicNetworkAccessForQuery = 'Enabled'

// //5- Application Insights
// param appInsightsName = 'bestbank-appinsights-dev'
// param appInsightsApplicationType = 'web'
// param appInsightsDisableIpMasking = true
// param appInsightsPublicNetworkAccessForIngestion = 'Enabled'
// param appInsightsPublicNetworkAccessForQuery = 'Enabled'
// param appInsightsRetentionInDays = 365
// param appInsightsSamplingPercentage = 100

// //6- ASP 
// // App Service Plan parameters for the dev environment
// param appServicePlanName = 'bestbank-asp-be-dev' // Unique name for the App Service Plan
// param appServicePlanSku = 'B1' // Pricing tier (e.g., F1 for free, B1 for basic) --> i think we should do f1 for dev and b1 for uat and prod 

// //7- app service - containerized be 
// // App Service Backend Parameters for Dev
// param appServiceBackendName = 'bestbank-be-dev' // Name of the backend App Service
// param backendDockerImageName = 'bestbank-backend' // Docker image name
// param backendDockerImageVersion = 'latest' // Docker image version
// param backendAppSettings = [
//   { name: 'ENV', value: 'dev' }
//   { name: 'DBHOST', value: 'bestbank-dbsrv-dev.postgres.database.azure.com' } // PostgreSQL FQDN
//   { name: 'DBNAME', value: 'bestbank-db-dev' } // Database name
//   { name: 'DBUSER', value: 'iebankdbadmin' } // Database user
//   { name: 'DEFAULT_ADMIN_USERNAME', value: 'BestBankUSER' } // Admin username
// ]

// //8- Static Web App Parameters
// param staticWebAppName = 'bestbank-swa-dev'
// param staticWebAppSku = 'Free' // Free for dev, Standard for UAT/Prod
// param staticWebAppLocation = 'northeurope' // Keep consistent across environments
// param staticWebAppRepositoryUrl = 'https://github.com/AlexaKhreiche/BestBank-fe'
// param staticWebAppBranch = 'main'
// @secure()
// param staticWebAppRepositoryToken = 'your-github-personal-access-token' // Store securely in deployment pipeline //where do i find this?
