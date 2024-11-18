param name string
param location string = resourceGroup().location

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: name
  location: location
  sku: {
    name: 'Basic' // Basic SKU for dev
  }
  properties: {
    adminUserEnabled: true // Enable admin credentials
  }
}

//need to add resource KeyVaultSecret


// Outputs (temporary, will use Key Vault later)
#disable-next-line outputs-should-not-contain-secrets
output containerRegistryLoginServer string = containerRegistry.properties.loginServer // ACR login server URL
#disable-next-line outputs-should-not-contain-secrets
output containerRegistryUserName string = containerRegistry.listCredentials().username // ACR admin username
#disable-next-line outputs-should-not-contain-secrets
output containerRegistryPassword0 string = containerRegistry.listCredentials().passwords[0].value // First admin password
#disable-next-line outputs-should-not-contain-secrets
output containerRegistryPassword1 string = containerRegistry.listCredentials().passwords[1].value // Second admin password
