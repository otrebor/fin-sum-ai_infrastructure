@description('The Azure Region to deploy the resources into')
param location string = resourceGroup().location

@description('The name of the Azure Automation Account ')
param automationAccountName string

param automationAccountLinkedWorkspaceName string

param logAnalyticsWorkspaceId string

@description('Tags to apply to the Key Vault Instance')
param tags object = {}

resource diagnosticSettings 'Microsoft.Automation/automationAccounts/providers/diagnosticSettings@2021-05-01-preview' = {
  name: '${automationAccountName}/Microsoft.Insights/${automationAccountLinkedWorkspaceName}'
  location: location
  tags: tags
  properties: {
    name: automationAccountLinkedWorkspaceName
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      // {
      //   category: 'FunctionAppLogs'
      //   enabled: true
      //   retentionPolicy: {
      //     days: 0
      //     enabled: false
      //   }
      // }
      {
        category: 'JobLogs'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 0
        }
      }
      {
        category: 'JobStreams'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 0
        }
      }
      {
        category: 'DscNodeStatus'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 0
        }
      }
      {
        category: 'AuditEvent'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 0
        }
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 0
        }
      }
    ]
  }
}
