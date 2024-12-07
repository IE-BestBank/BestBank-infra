param name string
param location string = resourceGroup().location
param keyVaultResourceId string
param keyVaultSecreNameAdminUsername string
#disable-next-line secure-secrets-in-params
param keyVaultSecreNameAdminPassword0 string
#disable-next-line secure-secrets-in-params
param keyVaultSecreNameAdminPassword1 string

@description('Optional. Tier of your Azure container registry.')
@allowed([
  'Basic'
  'Premium'
  'Standard'
])
param sku string 

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: name
  location: location
  sku: {
    name: sku
  }
  properties: {
    adminUserEnabled: true // Enable admin credentials
  }
}

resource adminCredentialsKeyVault 'Microsoft.KeyVault/vaults@2021-10-01' existing = if (!empty(keyVaultResourceId)) {
  name: last(split((!empty(keyVaultResourceId) ? keyVaultResourceId : 'dummyVault'), '/'))!
}

// create a secret to store the container registry admin username
resource secretAdminUserName 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = if (!empty(keyVaultSecreNameAdminUsername)) {
  name: !empty(keyVaultSecreNameAdminUsername) ? keyVaultSecreNameAdminUsername : 'dummySecret'
  parent: adminCredentialsKeyVault
  properties: {
    value: containerRegistry.listCredentials().username
}
}
// create a secret to store the container registry admin password 0
resource secretAdminUserPassword0 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = if (!empty(keyVaultSecreNameAdminPassword0)) {
  name: !empty(keyVaultSecreNameAdminPassword0) ? keyVaultSecreNameAdminPassword0 : 'dummySecret'
  parent: adminCredentialsKeyVault
  properties: {
    value: containerRegistry.listCredentials().passwords[0].value
}
}
// create a secret to store the container registry admin password 1
resource secretAdminUserPassword1 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = if (!empty(keyVaultSecreNameAdminPassword1)) {
  name: !empty(keyVaultSecreNameAdminPassword1) ? keyVaultSecreNameAdminPassword1 : 'dummySecret'
  parent: adminCredentialsKeyVault
  properties: {
    value: containerRegistry.listCredentials().passwords[1].value
}
}

output containerRegistryLoginServer string = containerRegistry.properties.loginServer // ACR login server URL



//adding diagnostic settings
param ContainerRegistryDiagnostics string ='myDiagnosticSetting'
param WorkspaceResourceId string

resource diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: ContainerRegistryDiagnostics
  scope: containerRegistry // Attach to the Container Registry
  properties: {
    workspaceId: WorkspaceResourceId // Log Analytics Workspace ID
    logs: [
      {
        category: 'ContainerRegistryLoginEvents' // Tracks login events
        enabled: true
      }
      {
        category: 'ContainerRegistryRepositoryEvents' // Tracks repository events (push, pull, delete)
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics' // Tracks metrics for ACR
        enabled: true
      }
    ]
  }
}
