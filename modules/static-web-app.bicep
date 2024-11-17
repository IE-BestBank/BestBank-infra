@description('Name of the static web app')
param name string
@allowed([
  'Free'
  'Standard'
])
@description('The service tier')
param sku string
@description('Location of the resource')
param location string = 'westeurope' 
@secure()
@description('GitHub repository personal access token')
param repositoryToken string = ''
@description('GitHub repository URL')
param repositoryUrl string
@description('Branch to deploy from')
param branch string = 'main'
@description('Static web app build properties')
param buildProperties object = {
  appLocation: 'src'
  outputLocation: 'dist'
}

resource staticSite 'Microsoft.Web/staticSites@2021-03-01' = {
  name: name
  location: location
  sku: {
    name: sku
  }
  properties: {
    repositoryUrl: repositoryUrl
    branch: branch
    repositoryToken: repositoryToken
    buildProperties: buildProperties
  }
}

output defaultHostname string = staticSite.properties.defaultHostname
