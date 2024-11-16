@description('The name of the PostgreSQL Server')
param serverName string

@description('The administrator username for the PostgreSQL Server (DBUSER)')
param adminUsername string

@description('The administrator password for the PostgreSQL Server (DBPASS)')
@secure()
param adminPassword string

@description('The name of the PostgreSQL Database (DBNAME)')
param databaseName string

@description('The location of the resources')
param location string = resourceGroup().location

@description('Specifies the tier and SKU for the PostgreSQL Server')
param skuName string = 'Standard_B1ms'

@description('Specifies the backup retention period in days')
param backupRetentionDays int = 7

@description('Specifies whether geo-redundant backup is enabled')
param geoRedundantBackup string = 'Disabled'

@description('Specifies the storage size in GB')
param storageSizeGb int = 32

@description('Tags to apply to the resources')
param tags object = {}

resource postgresSQLServer 'Microsoft.DBforPostgreSQL/flexibleServers@2022-12-01' = {
  name: serverName
  location: location
  sku: {
    name: skuName
    tier: 'Burstable'
  }
  properties: {
    administratorLogin: adminUsername
    administratorLoginPassword: adminPassword
    createMode: 'Default'
    storage: {
      storageSizeGB: storageSizeGb
    }
    backup: {
      backupRetentionDays: backupRetentionDays
      geoRedundantBackup: geoRedundantBackup
    }
    highAvailability: {
      mode: 'Disabled'
      standbyAvailabilityZone: ''
    }
  }
  tags: tags
}

resource postgresSQLDatabase 'Microsoft.DBforPostgreSQL/flexibleServers/databases@2022-12-01' = {
  name: databaseName
  parent: postgresSQLServer
  properties: {
    charset: 'UTF8'
    collation: 'en_US.UTF8'
  }
}

@description('The resource ID of the PostgreSQL Server')
output serverId string = postgresSQLServer.id

@description('The fully qualified domain name of the PostgreSQL Server (DBHOST)')
output fullyQualifiedDomainName string = postgresSQLServer.properties.fullyQualifiedDomainName

@description('The resource ID of the PostgreSQL Database')
output databaseId string = postgresSQLDatabase.id
