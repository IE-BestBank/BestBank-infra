param name string
param location string = resourceGroup().location
resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
name: name
location: location
sku: {
name: 'Basic'
}
properties: {
adminUserEnabled: true
}
}
//requires vey vault:
#disable-next-line outputs-should-not-contain-secrets // Doesn't contain a password
output containerRegistryUserName string = containerRegistry.listCredentials().username
#disable-next-line outputs-should-not-contain-secrets // Doesn't contain a password
output containerRegistryPassword0 string = containerRegistry.listCredentials().passwords[0].value
#disable-next-line outputs-should-not-contain-secrets // Doesn't contain a password
output containerRegistryPassword1 string = containerRegistry.listCredentials().passwords[1].value
