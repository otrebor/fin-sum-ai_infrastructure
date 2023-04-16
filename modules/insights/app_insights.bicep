// ========== appinsights.bicep ==========

// targetScope = 'resourceGroup'  -  default value

@description('Application Insights Location')
param location string = resourceGroup().location

@description('Application Insights Name')
param applicationInsightsName string

@description('Log analytics workspace ID')
param logAnalyticsWorkspaceId string

@description('Tags to apply to the Application Insights Instance')
param tags object = {}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Request_Source: 'rest'
    Flow_Type: 'Bluefield'
    WorkspaceResourceId: logAnalyticsWorkspaceId
  }
  tags: tags
}

output applicationInsightInstrumentationKey string = applicationInsights.properties.InstrumentationKey
output applicationInsightConnectionString string = applicationInsights.properties.ConnectionString
