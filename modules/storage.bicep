// ========== storage.bicep ==========

// targetScope = 'resourceGroup'  -  default value

@description('Storage Account Location')
param location string = resourceGroup().location

@description('Storage Account Name')
param storageAccountName string

@description('Storage Account type')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
])
param storageAccountType string = 'Standard_LRS'

@description('The name of the Azure Storage blob container to create.')
param blobContainerName string

@description('Tags to apply to the Storage Account Instance')
param tags object = {}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageAccountName
  location: location
  tags: tags
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'

  properties: {
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
    accessTier: 'Hot'
    allowBlobPublicAccess: true
    minimumTlsVersion: 'TLS1_2'
    allowSharedKeyAccess: true
  }
}

resource defaultBlobService 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  name: 'default'
  parent: storageAccount
}

resource blobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-09-01' = {
  name: blobContainerName
  parent: defaultBlobService
  properties: {
    publicAccess: 'Container'
  }
}

// resource runPowerShellInlineWithOutput 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
//   name: 'copyFile'
//   location: location
//   kind: 'AzurePowerShell'
//   dependsOn: [
//     blobContainer
//   ]
//   properties: {
//     azPowerShellVersion: '8.0'
//     environmentVariables: [
//       {
//         name: 'storageKey'
//         secureValue: storageAccount.listKeys().keys[0].value
//       }
//       {
//         name: 'SAName'
//         value: storageAccountName
//       }
//       {
//         name: 'ContainerName'
//         value: blobContainerName
//       }
//       {
//         name: 'contentUri'
//         value: contentUri
//       }
//       {
//         name: 'csvFileName'
//         value: csvFilename
//       }
//       {
//         name: 'csvInputFolder'
//         value: csvInputFolder
//       }
//     ]
//     scriptContent: loadTextContent('./scripts/copy-data.ps1')
//     timeout: 'PT1H'
//     cleanupPreference: 'OnSuccess'
//     retentionInterval: 'P1D'
//   }
// }

// Determine our connection string

var blobStorageConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'

// Output our variable

output blobStorageConnectionString string = blobStorageConnectionString
output blobContainerName string = blobContainer.name

output blobEndpointHostName string = replace(replace(storageAccount.properties.primaryEndpoints.blob, 'https://', ''), '/', '')
output storageResourceId string = storageAccount.id
