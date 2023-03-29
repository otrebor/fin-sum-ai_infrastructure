@description('The Azure Region to deploy the resources into')
param location string = resourceGroup().location

param diagnosticSettingsName string

param logAnalyticsWorkspaceId string

@description('Tags to apply to the Key Vault Instance')
param tags object = {}

resource diagnosticSettings 'Microsoft.Automation/automationAccounts/providers/diagnosticSettings@2021-05-01-preview' = {
  name: diagnosticSettingsName
  location: location
  tags: tags
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'FunctionAppLogs'
        enabled: true
        retentionPolicy: {
          days: 0
          enabled: false
        }
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: false
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
    ]
  }
}
