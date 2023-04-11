@description('That name is the name of our application. It has to be unique.Type a name followed by your resource group name. (<name>-<resourceGroupName>)')
param formRecognizerServiceName string = 'frmcs-${uniqueString(resourceGroup().id)}'

@description('Location for all resources.')
param location string = resourceGroup().location

@allowed([
  'S0'
])
param sku string = 'S0'

@description('Tags to apply to the Application Insights Instance')
param tags object = {}

resource frmRecognizer 'Microsoft.CognitiveServices/accounts@2021-04-30' = {
  name: formRecognizerServiceName
  location: location
  sku: {
    name: sku
  }
  tags: tags
  kind: 'FormRecognizer'
  properties: {
    restore: true
    customSubDomainName: formRecognizerServiceName
    publicNetworkAccess: 'Enabled'
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: [
        
      ]
    }
  }
}

output formRecognizerName string = frmRecognizer.name
output formRecognizerEndpoint string = frmRecognizer.properties.endpoint
output formRecognizerApiKey string = frmRecognizer.listKeys().key1
