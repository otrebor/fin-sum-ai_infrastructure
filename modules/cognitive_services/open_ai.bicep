@description('That name is the name of our application. It has to be unique.Type a name followed by your resource group name. (<name>-<resourceGroupName>)')
param openAIServiceName string = 'opai-${uniqueString(resourceGroup().id)}'

@description('Location for all resources.')
param location string = resourceGroup().location

@allowed([
  'S0'
])
param sku string = 'S0'

@description('Tags to apply to the Application Insights Instance')
param tags object = {}

@allowed([
  'new'
  'existing'
])
param newOrExistingResourceGroup string = 'existing'


resource open_ai_new 'Microsoft.CognitiveServices/accounts@2022-03-01' = if (newOrExistingResourceGroup == 'new') {
  name: openAIServiceName
  location: location
  kind: 'OpenAI'
  tags: tags
  sku: {
    name: sku
  }
  properties: {
    customSubDomainName: toLower(openAIServiceName)
  }
}

resource open_ai 'Microsoft.CognitiveServices/accounts@2022-03-01' existing = {
  name: openAIServiceName
}

output openAIName string = open_ai.name
output openAIEndpoint string = open_ai.properties.endpoint
output openAIApiKey string = open_ai.listKeys().key1
