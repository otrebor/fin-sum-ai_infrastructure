// ========== azureautomation.bicep ==========

// targetScope = 'resourceGroup'  -  default value

@description('The name of the Azure Automation Account Name')
param automationAccountName string

@description('The Azure Region to deploy the resources into')
param location string = resourceGroup().location

@description('Tags to apply to the Key Vault Instance')
param tags object = {}

resource automationAccount 'Microsoft.Automation/automationAccounts@2021-06-22' = {
  name: automationAccountName
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'Free'
    }
  }
}

output automationAccountName string = automationAccount.name
output automationAccountId string = automationAccount.id
