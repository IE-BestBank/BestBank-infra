param location string = resourceGroup().location
param name string
param appServicePlanId string
param dockerRegistryName string
@secure()
param dockerRegistryServerUserName string
@secure()
param dockerRegistryServerPassword string
param dockerRegistryImageName string
param dockerRegistryImageVersion string = 'latest'
param appSettings array = []
param appCommandLine string = ''
// param keyVaultUri string // Optional for secrets
// param databasePasswordKey string // Optional for database connection

var dockerAppSettings = [
  { name: 'DOCKER_REGISTRY_SERVER_URL', value: 'https://${dockerRegistryName}.azurecr.io' }
  { name: 'DOCKER_REGISTRY_SERVER_USERNAME', value: dockerRegistryServerUserName }
  { name: 'DOCKER_REGISTRY_SERVER_PASSWORD', value: dockerRegistryServerPassword }
]

resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
  name: name
  location: location
  properties: {
    serverFarmId: appServicePlanId
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'DOCKER|${dockerRegistryName}.azurecr.io/${dockerRegistryImageName}:${dockerRegistryImageVersion}'
      alwaysOn: false
      ftpsState: 'FtpsOnly'
      appCommandLine: appCommandLine
      appSettings: union(appSettings, dockerAppSettings)
      //   [
      //   { name: 'DATABASE_PASSWORD', secureValue: list(keyVaultUri, '2016-10-01').getSecret(databasePasswordKey) }
      // ]
      // )
    }
  }
}

output appServiceAppHostName string = appServiceApp.properties.defaultHostName
output appId string = appServiceApp.id
// This module is for creating an App Service that hosts a containerized app- BACKEND
