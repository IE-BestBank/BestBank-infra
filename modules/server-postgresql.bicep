param location string = resourceGroup().location
param name string
param postgreSQLAdminServicePrincipalObjectId string
param postgreSQLAdminServicePrincipalName string

resource postgresSQLServer 'Microsoft.DBforPostgreSQL/flexibleServers@2022-12-01' = {
  name: name
  location: location
  sku: {
    name: 'Standard_B1ms'
    tier: 'Burstable'
  }
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
        retentionPolicy: {
          enabled: true
          days: 365
        }
      }
    ]
    logs: [
      {
        category: 'PostgreSQLLogs'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'PostgreSQLFlexSessions'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'PostgreSQLFlexQueryStoreRuntime'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'PostgreSQLFlexQueryStoreWaitStats'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'PostgreSQLFlexTableStats'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
      {
        category: 'PostgreSQLFlexDatabaseXacts'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
    ]
  }
}
