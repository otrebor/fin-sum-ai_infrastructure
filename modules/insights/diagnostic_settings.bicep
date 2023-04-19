// https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/resource-manager-diagnostic-settings?tabs=bicep#diagnostic-setting-for-a-log-analytics-workspace

@description('That name is the name of our application. It has to be unique.Type a name followed by your resource group name. (<name>-<resourceGroupName>)')
param diagnosticSettingsName string = 'diagn-${uniqueString(resourceGroup().id)}'

param logAnalyticsWorkspaceId string

param logAnalyticsWorkspaceName string

param storageAccountId string

resource finsum_logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' existing = {
  name: logAnalyticsWorkspaceName
}

resource finsum_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = {
  scope: finsum_logAnalyticsWorkspace
  name: diagnosticSettingsName
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    storageAccountId: storageAccountId
    logs: [
      {
        category: 'Audit'
        enabled: true
      }
      // {
      //   category: 'FunctionAppLogs'
      //   enabled: true
      //   retentionPolicy: {
      //     enabled: false
      //     days: 120
      //   }
      // }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 120
        }
      }
    ]
  }
}
