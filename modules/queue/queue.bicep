// // Create a Queue storage account
// resource queueAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
//   name: '${storageAccountName}queue'
//   location: rg.location
//   sku: {
//     name: 'Standard_LRS'
//   }
//   kind: 'StorageV2'
// }

// // Create a Queue for triggering summary generation
// resource summaryQueue 'Microsoft.Storage/storageAccounts/queues@2021-08-01' = {
//   name: 'summaryqueue'
//   dependsOn: [
//     queueAccount
//   ]
//   properties: {
//     queueName: 'summaryqueue'
//   }
// }
