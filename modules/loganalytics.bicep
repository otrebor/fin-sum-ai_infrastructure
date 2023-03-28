// ========== loganalytics.bicep ==========

// targetScope = 'resourceGroup'  -  default value

@description('The name of the Log Analytics Workspace')
param logAnalyticsWorkspaceName string

@description('The name of the Linked Workspace')
param linkedService string = 'Automation'

@description('The Azure Region to deploy the resources into')
param location string = resourceGroup().location

@description('Tags to apply to the Key Vault Instance')
param tags object = {}

@description('Automation Account id')
param automationAccountId string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'pergb2018'
    }
  }
}

resource automationAccountLinkedWorkspace 'Microsoft.OperationalInsights/workspaces/linkedServices@2020-08-01' = {
  name: linkedService
  parent: logAnalyticsWorkspace
  //location: location
  properties: {
    resourceId: automationAccountId
  }
}

output automationAccountLinkedWorkspaceName string = automationAccountLinkedWorkspace.name
output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.id
