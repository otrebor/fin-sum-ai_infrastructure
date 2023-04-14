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



@description('The language worker runtime to load in the function app.')
@allowed([
  'node'
  'dotnet'
  'java'
  'python'
])
param runtime string = 'python'

@description('Tags to apply to the Function App Instance')
param appSpecificAppSettings array = []

@description('Tags to apply to the Function App Instance')
param tags object = {}

var runtimeSpecificAppSettings =  [
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
    name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
    value: applicationInsightInstrumentationKey
  }
  {
    name: 'FUNCTIONS_WORKER_RUNTIME'
    value: runtime
  }
  {
    name: 'AzureWebJobsSecretStorageType'
    value: 'files'
  }
  {
    name: 'AzureWebJobs.TXTFinancialReportTrigger.Disabled'
    value: false
  }
  {
    name: 'AzureWebJobs.JokeTrigger.Disabled'
    value: false
  }
  {
    name: 'AzureWebJobs.HttpTrigger.Disabled'
    value: false
  }
]

resource functionApp 'Microsoft.Web/sites@2021-03-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp,linux'
  identity: {
    type: 'SystemAssigned'
  }
  tags: tags
  properties: {
    serverFarmId: functionAppHostingPlanId
    clientAffinityEnabled: false
    httpsOnly: true
    siteConfig: {
      appSettings: concat(runtimeSpecificAppSettings, appSpecificAppSettings)
      cors: {
        allowedOrigins: [
          'https://portal.azure.com'
        ]
      }
      pythonVersion: '3.10'
      linuxFxVersion: 'Python|3.10'
      ftpsState: 'FtpsOnly'
    }
  }
}
