//SWA token and adding the token to the KV 

@description('Name of the static web app')
param name string

@allowed([
  'Free'
  'Standard'
])
@description('The service tier')
param sku string
@description('Location of the resource')
param location string = resourceGroup().location
@description('Resource ID of the existing Key Vault')
param keyVaultResourceId string
@description('Name of the secret to store the deployment token')
param keyVaultSecretName string

resource staticSite 'Microsoft.Web/staticSites@2021-03-01' = {
  name: name
  location: location
  sku: {
    name: sku
  }
  properties: {
    allowConfigFileUpdates: false
  }
}

//refrencing the keyvault since its already created 
resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: last(split(keyVaultResourceId, '/'))
}

resource deploymentTokenSecret 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  name: keyVaultSecretName
  parent: keyVault
  properties: {
    value: staticSite.listSecrets().properties.apiKey
  }
}

output staticWebAppUrl string = staticSite.properties.defaultHostname
