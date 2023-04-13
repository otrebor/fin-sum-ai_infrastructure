@description('Name of the Media Services account. A Media Services account name is globally unique, all lowercase letters or numbers with no spaces.')
param mediaServicesAccountName string = 'mediasvc${uniqueString(resourceGroup().id)}'

@description('Location for all resources.')
param location string = resourceGroup().location

@description('StorageAccount ID.')
param storageAccountId string

param tags object = {}

resource mediaServicesAccount 'Microsoft.Media/mediaservices@2021-11-01' = {
  name: mediaServicesAccountName
  location: location
  tags: tags
  properties: {
    storageAccounts: [
      {
        id: storageAccountId
        type: 'Primary'
      }
    ]
  }
  identity: {
    type: 'SystemAssigned'
  }
}
