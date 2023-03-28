// ========== hostingplan.bicep ==========

// targetScope = 'resourceGroup'  -  default value

@description('Hosting Plan Location')
param location string = resourceGroup().location

@description('hosting Plan Name')
param hostingPlanName string

@description('Tags to apply to the Key Vault Instance')
param tags object = {}

resource hackathon_hp 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: hostingPlanName
  location: location
  kind: 'linux'        // required for using linux
  tags: tags
  sku: {
    name: 'Y1'
    //capacity: 2
    tier: 'Dynamic'
  }
  properties: {
    reserved: true     // required for using linux
  }
}

output hostingPlanId string = hackathon_hp.id
output hostingPlanName string = hackathon_hp.name
