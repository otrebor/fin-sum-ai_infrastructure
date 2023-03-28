// ========== functionapp.bicep ==========

// targetScope = 'resourceGroup'  -  default value

@description('Function App Location')
param location string = resourceGroup().location

@description('Function App Name')
param functionAppName string

@description('Function App Hosting plan Id')
param functionAppHostingPlanId string

@description('Function App Application Insights Instrumentation Key')
param applicationInsightInstrumentationKey string

@description('Function App Storage Account Connection String')
param blobStorageConnectionString string

@description('Function App Blob Container Name')
param blobContainerName string

@description('The language worker runtime to load in the function app.')
@allowed([
  'node'
  'dotnet'
  'java'
])
param runtime string = 'dotnet'

@description('Tags to apply to the Function App Instance')
param tags object = {}

resource functionApp 'Microsoft.Web/sites@2021-03-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  tags: tags
  properties: {
    serverFarmId: functionAppHostingPlanId
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: blobStorageConnectionString
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: blobStorageConnectionString
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(functionAppName)
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'WEBSITE_DOTNET_DEFAULT_VERSION'
          value: '~6'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: applicationInsightInstrumentationKey
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: runtime
        }
        {
          name: 'MyBlobContainer'
          value: blobContainerName
        }
      ]
      ftpsState: 'FtpsOnly'
      minTlsVersion: '1.2'
    }
    httpsOnly: true
  }
}
