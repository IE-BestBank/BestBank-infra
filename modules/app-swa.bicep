// metadata name = 'Static Web Apps'
// metadata description = 'This module deploys a Static Web App.'
// metadata owner = 'Azure/module-maintainers'

// @description('Required. The name of the static site.')
// @minLength(1)
// @maxLength(40)
// param name string

// @allowed([
//   'Free'
//   'Standard'
// ])
// @description('Optional. The service tier and name of the resource SKU.')
// param sku string = 'Free'

// @description('Optional. Location for all resources.')
// param location string = resourceGroup().location

// @secure()
// @description('Optional. The Personal Access Token for accessing the GitHub repository.')
// param repositoryToken string?

// @description('Optional. The name of the GitHub repository.')
// param repositoryUrl string?

// @description('Optional. The branch name of the GitHub repository.')
// param branch string?

// // @description('Optional. The custom domains associated with this static site. The deployment will fail as long as the validation records are not present.')
// // param customDomains array = []


// resource staticSite 'Microsoft.Web/staticSites@2021-03-01' = {
//   name: name
//   location: location
//   sku: {
//     name: sku
//     tier: sku
//   }
//   properties: {
//     branch: branch
//     repositoryToken: repositoryToken
//     repositoryUrl: repositoryUrl
//   }
// }

// // not sure if this is needed ask prof
// // module staticSite_customDomains 'custom-domain/main.bicep' = [
// //   for (customDomain, index) in customDomains: {
// //     name: '${uniqueString(deployment().name, location)}-StaticSite-customDomains-${index}'
// //     params: {
// //       name: customDomain
// //       staticSiteName: staticSite.name
// //       validationMethod: indexOf(customDomain, '.') == lastIndexOf(customDomain, '.')
// //         ? 'dns-txt-token'
// //         : 'cname-delegation'
// //     }
// //   }
// // ]
