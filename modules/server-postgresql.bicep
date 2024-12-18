param location string = resourceGroup().location
param name string
param postgreSQLAdminServicePrincipalObjectId string
param postgreSQLAdminServicePrincipalName string
@description('Required. The name of the sku, typically, tier + family + cores, e.g. Standard_D4s_v3.')
param skuName string

@allowed([
  'GeneralPurpose'
  'Burstable'
  'MemoryOptimized'
])
@description('Required. The tier of the particular SKU. Tier must align with the \'skuName\' property. Example, tier cannot be \'Burstable\' if skuName is \'Standard_D4s_v3\'.')
param tier string

resource postgresSQLServer 'Microsoft.DBforPostgreSQL/flexibleServers@2022-12-01' = {
  name: name
  location: location
  sku: {
    name: skuName
    tier: tier
  }
  // sku: {
  //   name: 'Standard_B1ms'
  //   tier: 'Burstable'
  // }
  properties: {
    // administratorLogin: 'iebankdbadmin'
    // administratorLoginPassword: 'IE.Bank.DB.Admin.Pa$$'
    createMode: 'Default'
    highAvailability: {
      mode: 'Disabled'
      standbyAvailabilityZone: ''
    }
    storage: {
      storageSizeGB: 32
    }
    backup: {
      backupRetentionDays: 7
      geoRedundantBackup: 'Disabled'
    }
    version: '15'
    authConfig: { 
      activeDirectoryAuth: 'Enabled' //Microdoft Enfra auth = on 
      passwordAuth: 'Disabled' // PostgreSQL auth = off
      tenantId: subscription().tenantId
    }
  }
}

// Firewall rule to allow Azure services
resource postgresSQLServerFirewallRules 'Microsoft.DBforPostgreSQL/flexibleServers/firewallRules@2022-12-01' = {
  name: 'AllowAllAzureServicesAndResourcesWithinAzureIps'
  parent: postgresSQLServer
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

resource postgreSQLAdministrators 'Microsoft.DBforPostgreSQL/flexibleServers/administrators@2022-12-01' = {
  parent: postgresSQLServer
  name: postgreSQLAdminServicePrincipalObjectId
  properties: {
  principalName: postgreSQLAdminServicePrincipalName
  principalType: 'ServicePrincipal'
  tenantId: subscription().tenantId
  }
  dependsOn: [ 
  postgresSQLServerFirewallRules
  ]
  }

  

// Outputs
output id string = postgresSQLServer.id
output postgreSQLServerName string = postgresSQLServer.name
// output postgreSQLServerAdmin string = administratorLogin


//adding diagnostic settings
param WorkspaceResourceId string

resource postgreSQLDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'PostgreSQLServerDiagnostic'
  scope: postgresSQLServer
  properties: {
    workspaceId: WorkspaceResourceId
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
    logs: [
      {
        category: 'PostgreSQLLogs'
        enabled: true
      }
      {
        category: 'PostgreSQLFlexSessions'
        enabled: true
      }
      {
        category: 'PostgreSQLFlexQueryStoreRuntime'
        enabled: true
      }
      {
        category: 'PostgreSQLFlexQueryStoreWaitStats'
        enabled: true
      }
      {
        category: 'PostgreSQLFlexTableStats'
        enabled: true
      }
      {
        category: 'PostgreSQLFlexDatabaseXacts'
        enabled: true
      }
    ]
  }
}
