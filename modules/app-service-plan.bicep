param location string = resourceGroup().location

// Backend App Service Plan (Container)
param appServicePlanBEName string
param appServiceAPIAppName string
param appServiceAPIEnvVarENV string
param appServiceAPIEnvVarDBHOST string
param appServiceAPIEnvVarDBNAME string
@secure()
param appServiceAPIEnvVarDBPASS string
param appServiceAPIDBHostDBUSER string
// param appServiceAPIDBHostFLASK_APP string
// param appServiceAPIDBHostFLASK_DEBUG string
@secure()
param appServiceAPIEnvVarDEFAULT_ADMIN_PASSWORD string
param appServiceAPIEnvVarDEFAULT_ADMIN_USERNAME string

// Frontend Static Web App
param staticWebAppName string

@allowed([
  'nonprod'
  'prod'
])
param environmentType string

// Backend App Service Plan SKU
var appServicePlanBEKind = 'linux'
var appServicePlanBESku = (environmentType == 'prod') ? 'B1' : 'B1'

// Backend App Service Plan
resource appServicePlanBE 'Microsoft.Web/serverFarms@2022-03-01' = {
  name: appServicePlanBEName
  location: location
  sku: {
    name: appServicePlanBESku
  }
  kind: appServicePlanBEKind
  properties: {
    reserved: true
  }
}

// Backend App Service (Containerized)
resource appServiceAPIApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceAPIAppName
  location: location
  properties: {
    serverFarmId: appServicePlanBE.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'PYTHON|3.11'
      alwaysOn: false
      ftpsState: 'FtpsOnly'
      appSettings: [
        {
          name: 'ENV'
          value: appServiceAPIEnvVarENV
        }
        {
          name: 'DBHOST'
          value: appServiceAPIEnvVarDBHOST
        }
        {
          name: 'DBNAME'
          value: appServiceAPIEnvVarDBNAME
        }
        {
          name: 'DBPASS'
          value: appServiceAPIEnvVarDBPASS
        }
        {
          name: 'DBUSER'
          value: appServiceAPIDBHostDBUSER
        }
        // {
        //   name: 'FLASK_APP'
        //   value: appServiceAPIDBHostFLASK_APP
        // }
        // {
        //   name: 'FLASK_DEBUG'
        //   value: appServiceAPIDBHostFLASK_DEBUG
        // }
        {
          name: 'SCM_DO_BUILD_DURING_DEPLOYMENT'
          value: 'true'
        }
        {
          name: 'DEFAULT_ADMIN_PASSWORD'
          value: appServiceAPIEnvVarDEFAULT_ADMIN_PASSWORD
        }
        {
          name: 'DEFAULT_ADMIN_USER'
          value: appServiceAPIEnvVarDEFAULT_ADMIN_USERNAME
        }
      ]
    }
  }
}

// Frontend Static Web App
resource staticWebApp 'Microsoft.Web/staticSites@2022-03-01' = {
  name: staticWebAppName
  location: location
  properties: {
    buildProperties: {
      appLocation: 'BestBank-fe' // Path to frontend app code 
      outputLocation: 'dist' // Path to build output
    }
  }
}

// Outputs
output backendAppServicePlanId string = appServicePlanBE.id
output backendAppServiceHostName string = appServiceAPIApp.properties.defaultHostName
output frontendStaticWebAppHostName string = staticWebApp.properties.defaultHostName
