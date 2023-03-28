// ========== main.bicep ==========

targetScope = 'subscription'

@minLength(2)
@maxLength(10)
@description('Prefix for all resource names.')
param appNamePrefix string = 'hackathon'

@description('Set of tags to apply to all resources.')
param tags object = {
  appPrefix: appNamePrefix
}

@description('Location for resource group.')
param resourceGrouplocation string = 'GermanyWestCentral'

@description('Location for Application Insights')
param appInsightsLocation string = 'WestEurope'

@description('Location for Web Application (HOSTING PLAN)')
param hostingPlanLocation string = 'WestEurope'

@description('The language worker runtime to load in the function app.')
@allowed([
  'node'
  'dotnet'
  'java'
])
param runtime string = 'dotnet'

var nameSuffix = uniqueString(hackathon_rg.id)

resource hackathon_rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${appNamePrefix}'
  location: resourceGrouplocation 
}

var kvName = 'kv${appNamePrefix}${nameSuffix}'

module hackathon_kv './modules/keyvault.bicep' = {
  name: 'myKeyVaultDeployment'
  params: {
    location: hackathon_rg.location
    keyVaultName: kvName
    tags: tags
  }
  scope: hackathon_rg
}

var saName = 'sa${appNamePrefix}${nameSuffix}'
var bcName = 'bc-${appNamePrefix}-${nameSuffix}'

module hackathon_stg './modules/storage.bicep' = {
  name: 'myStorageDeployment'
  params: {
    location: hackathon_rg.location
    storageAccountName: saName
    blobContainerName: bcName
    tags: tags
  }
  scope: hackathon_rg
}


var hpName = 'hp-${appNamePrefix}-${nameSuffix}'

module hackathon_hp './modules/hostingplan.bicep' = {
  name: 'myHostingPlanDeployment'
  params: {
    location: hostingPlanLocation
    hostingPlanName: hpName
    tags: tags
  }
  scope: hackathon_rg
}

var appInsName = 'ai-${appNamePrefix}-${nameSuffix}'

module hackathon_ai './modules/appinsights.bicep' = {
  name: 'myAppInsightsDeployment'
  params: {
    location: appInsightsLocation
    applicationInsightsName: appInsName
    tags: tags
  }
  scope: hackathon_rg
}

var appFunctionName = 'af-${appNamePrefix}-${nameSuffix}'

module hackathon_af './modules/functionapp.bicep' = {
  name: 'myFunctionAppDeployment'
  params: {
    location: hostingPlanLocation
    applicationInsightInstrumentationKey: hackathon_ai.outputs.applicationInsightInstrumentationKey
    blobStorageConnectionString: hackathon_stg.outputs.blobStorageConnectionString
    functionAppHostingPlanId: hackathon_hp.outputs.hostingPlanId
    functionAppName: appFunctionName
    tags: tags
    runtime: runtime
    blobContainerName: hackathon_stg.outputs.blobContainerName
  }
  scope: hackathon_rg
}

var automationAccountName = 'aa-${appNamePrefix}-${nameSuffix}'

module hackathon_aa './modules/azureautomation.bicep' = {
  name: 'myAutomationAccountDeployment'
  params: {
    automationAccountName: automationAccountName
    location: hostingPlanLocation
    tags: tags
  }
  scope: hackathon_rg
}

var automationAccountLinkedWorkspaceName = 'Automation' //'aalws${appNamePrefix}${nameSuffix}'
var logAnalyticsWorkspaceName = 'laws-${appNamePrefix}-${nameSuffix}'

module hackathon_law './modules/loganalytics.bicep' = {
  name: 'myLogAnalyticsDeployment'
  params: {
    automationAccountId: hackathon_aa.outputs.automationAccountId
    location: hostingPlanLocation
    linkedService: automationAccountLinkedWorkspaceName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    tags: tags
  }
  scope: hackathon_rg
}

var logAnalyticsWorkspaceId = hackathon_law.outputs.logAnalyticsWorkspaceId

module hackathon_dis './modules/diagnosticsettings.bicep' = {
  name: 'myDiagnosticSettingsDeployment'
  params: {
    location: hostingPlanLocation
    automationAccountName : automationAccountName
    automationAccountLinkedWorkspaceName: automationAccountLinkedWorkspaceName
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    tags: tags
  }
  scope: hackathon_rg
}
