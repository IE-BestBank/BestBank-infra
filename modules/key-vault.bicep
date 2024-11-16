param name string
param location string = resourceGroup().location

@description('Optional array of role assignments for the Key Vault')
param roleAssignments array = []

// Optional mapping of role names to role IDs (can be extended as needed)
var builtInRoleNames = {
  'Key Vault Secrets User': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6')
  'Key Vault Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '00482a5a-887f-4fb3-b363-3b7fe8e74483')
}


resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: name
  location: location
  properties: {
    enableRbacAuthorization: true // Enables RBAC instead of access policies
    enableSoftDelete: true       // It's best practice to enable soft delete
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: [] // Leave empty when using RBAC
  }
}

// Conditional role assignments loop for the Key Vault
resource keyVault_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (roleAssignments ?? []): {
    name: guid(keyVault.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
    scope: keyVault
    properties: {
      roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? roleAssignment.roleDefinitionIdOrName
      principalId: roleAssignment.principalId
      principalType: roleAssignment.principalType 
      condition: roleAssignment.condition 
      conditionVersion: !empty(roleAssignment.condition) ? (roleAssignment.conditionVersion ?? '2.0') : null
      delegatedManagedIdentityResourceId: roleAssignment.delegatedManagedIdentityResourceId 
    }
  }
]

output keyVaultId string = keyVault.id
output keyVaultUri string = keyVault.properties.vaultUri
