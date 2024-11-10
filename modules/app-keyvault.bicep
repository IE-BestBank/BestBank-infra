metadata name = 'Key Vaults'
metadata description = 'This module deploys a Key Vault.'
metadata owner = 'Azure/module-maintainers'

// ================ //
// Parameters       //
// ================ //
@description('Required. Name of the Key Vault. Must be globally unique.')
@maxLength(24)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Specifies the SKU for the vault.')
@allowed([
  'premium'
  'standard'
])
param sku string = 'standard' //not sure which one were supposed to use 

//not sure if we need these (need to talk to els)
// @description('Optional. All secrets to create.')
// param secrets secretsType?

// @description('Optional. All keys to create.')
// param keys keysType?

@description('Optional. Specifies if the vault is enabled for deployment by script or compute.')
param enableVaultForDeployment bool = true

@description('Optional. Specifies if the vault is enabled for a template deployment.')
param enableVaultForTemplateDeployment bool = true

@description('Optional. Specifies if the azure platform has access to the vault for enabling disk encryption scenarios.')
param enableVaultForDiskEncryption bool = true

@description('Optional. softDelete data retention days. It accepts >=7 and <=90.')
param softDeleteRetentionInDays int = 90

@description('Optional. Resource tags.')
param tags object?

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    enabledForDeployment: enableVaultForDeployment
    enabledForTemplateDeployment: enableVaultForTemplateDeployment
    enabledForDiskEncryption: enableVaultForDiskEncryption
    softDeleteRetentionInDays: softDeleteRetentionInDays
    sku: {
      name: sku
      family: 'A'
    }
}
}
