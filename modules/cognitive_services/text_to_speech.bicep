@description('That name is the name of our application. It has to be unique.Type a name followed by your resource group name. (<name>-<resourceGroupName>)')
param textToSpeechServiceName string = 'txt-to-speech-${uniqueString(resourceGroup().id)}'

@description('Location for all resources.')
param location string = resourceGroup().location

@allowed([
  'S0'
])
param sku string = 'S0'

param tags object = {}

resource textToSpeechServicesAccount 'Microsoft.CognitiveServices/accounts@2022-03-01' = {
  name: textToSpeechServiceName
  location: location
  tags: tags
  kind: 'SpeechServices'
  sku: {
    name: sku
  }
  properties: {
    apiProperties: {
      displayName: 'TextToSpeech'
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}

output textToSpeechName string = textToSpeechServicesAccount.name
output textToSpeechEndpoint string = textToSpeechServicesAccount.properties.endpoint
output textToSpeechApiKey string = textToSpeechServicesAccount.listKeys().key1
