// ========== main.bicep ==========

targetScope = 'subscription'

@minLength(2)
@maxLength(10)
@description('Prefix for all resource names.')
param appNamePrefix string = 'finsumai'

@description('Set of tags to apply to all resources.')
param tags object = {
  appPrefix: appNamePrefix
}

@description('Location for resource group.')
param resourceGrouplocation string = 'WestEurope'

@description('Location for Application Insights')
param appInsightsLocation string = 'WestEurope'

@description('Location for Web Application (HOSTING PLAN)')
param hostingPlanLocation string = 'WestEurope'

@allowed([
  'new'
  'existing'
])
param newOrExistingResourceGroup string = 'existing'

var resourceGroupName = 'Cteam8'


resource hackathon_rg_new 'Microsoft.Resources/resourceGroups@2021-04-01' = if (newOrExistingResourceGroup == 'new') {
  name: resourceGroupName
  location: resourceGrouplocation 
  tags: tags
} 

resource hackathon_rg 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  name: resourceGroupName
}

var nameSuffix = uniqueString(hackathon_rg.id)

// var kvName = 'kv${appNamePrefix}${nameSuffix}'

// module hackathon_kv './modules/key_vault/keyvault.bicep' = {
//   name: 'myKeyVaultDeployment'
//   params: {
//     location: hackathon_rg.location
//     keyVaultName: kvName
//     tags: tags
//   }
//   scope: hackathon_rg
// }

var saName = 'sa${appNamePrefix}${nameSuffix}'
var bcName = 'bc-${appNamePrefix}-${nameSuffix}'

module hackathon_stg './modules/storage/storage.bicep' = {
  name: 'myStorageDeployment'
  params: {
    location: hackathon_rg.location
    storageAccountName: saName
    blobContainerName: bcName
    tags: tags
  }
  scope: hackathon_rg
  dependsOn: [
    hackathon_rg
  ]
}


var hpName = 'hp-${appNamePrefix}-${nameSuffix}'

module hackathon_hp './modules/web/hostingplan.bicep' = {
  name: 'myHostingPlanDeployment'
  params: {
    location: hostingPlanLocation
    hostingPlanName: hpName
    tags: tags
  }
  scope: hackathon_rg
}

var appInsName = 'ai-${appNamePrefix}-${nameSuffix}'

module hackathon_ai './modules/insights/app_insights.bicep' = {
  name: 'myAppInsightsDeployment'
  params: {
    location: appInsightsLocation
    applicationInsightsName: appInsName
    tags: tags
  }
  scope: hackathon_rg
}

var formRecognizerServiceName = 'frmcs-${appNamePrefix}-${nameSuffix}'
module finsum_formRecognizer './modules/cognitive_services/form_recognizer.bicep' = {
  name: 'myFormRecognizerDeployment'
  params: {
    formRecognizerServiceName: formRecognizerServiceName
    location: hostingPlanLocation
    tags: tags
  }
  scope: hackathon_rg
}

var openAIServiceName = 'opai-${appNamePrefix}-${nameSuffix}'
// module finsum_openAI './modules/cognitive_services/open_ai.bicep' = {
//   name: 'myOpenAIDeployment'
//   params: {
//     openAIServiceName: openAIServiceName
//     location: hostingPlanLocation
//     tags: tags
//   }
//   scope: hackathon_rg
// }

module finsum_functionApps './modules/web/function_apps/functionapps.bicep' = {
  name: 'myFunctionsAppDeployment'
  params: {
    appNamePrefix: appNamePrefix
    nameSuffix: nameSuffix
    location: hostingPlanLocation
    applicationInsightInstrumentationKey: hackathon_ai.outputs.applicationInsightInstrumentationKey
    blobStorageConnectionString: hackathon_stg.outputs.blobStorageConnectionString
    hostingPlanId: hackathon_hp.outputs.hostingPlanId
    tags: tags
    blobContainerName: hackathon_stg.outputs.blobContainerName
    formRecognizerApiEndpoint: finsum_formRecognizer.outputs.formRecognizerEndpoint
    formRecognizerApiKey: finsum_formRecognizer.outputs.formRecognizerApiKey
    //azureOpenAIApiEndpoint: finsum_openAI.outputs.openAIEndpoint
    //azureOpenAIApiKey: finsum_openAI.outputs.openAIApiKey
  }
  scope: hackathon_rg
}

var automationAccountName = 'aa-${appNamePrefix}-${nameSuffix}'

module hackathon_aa './modules/automation/azureautomation.bicep' = {
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

module hackathon_law './modules/insights/log_analytics.bicep' = {
  name: 'myLogAnalyticsDeployment'
  params: {
    automationAccountId: hackathon_aa.outputs.automationAccountId
    location: hostingPlanLocation
    linkedService: automationAccountLinkedWorkspaceName
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    tags: tags
    sku: 'PerGB2018'
  }
  scope: hackathon_rg
}

var logAnalyticsWorkspaceId = hackathon_law.outputs.logAnalyticsWorkspaceId

module hackathon_dis './modules/automation/diagnosticsettings.bicep' = {
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

// var diagnosticSettingsName = 'frmcs-${appNamePrefix}-${nameSuffix}'
// module finsum_DiagnosticSettingsFunctionApp './modules/insights/diagnostic_settings.bicep' = {
//   name: 'myDiagnosticSettingsFunctionAppDeployment'
//   params: {
//     diagnosticSettingsName: diagnosticSettingsName
//     logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
//   }
//   scope: hackathon_rg
// }



