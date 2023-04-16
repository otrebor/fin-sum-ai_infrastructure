// ========== main.bicep ==========

@minLength(2)
@maxLength(10)
@description('Prefix for all resource names.')
param appNamePrefix string = 'finsumai'

@description('Set of tags to apply to all resources.')
param tags object = {
  appPrefix: appNamePrefix
}

@description('Location for Application Insights')
param appInsightsLocation string = resourceGroup().location

@description('Location for Web Application (HOSTING PLAN)')
param hostingPlanLocation string = resourceGroup().location

param resourceGrouplocation string = resourceGroup().location


var nameSuffix = substring(uniqueString(resourceGroup().id), 0, 5)


// var kvName = 'kv${appNamePrefix}${nameSuffix}'

// module hackathon_kv './modules/key_vault/keyvault.bicep' = {
//   name: 'myKeyVaultDeployment'
//   params: {
//     location: resourceGrouplocation
//     keyVaultName: kvName
//     tags: tags
//   }
//   scope: resourceGroup()
// }

// #################################################################################################
// STORAGE SECTION
// #################################################################################################

var saName = 'storageacc${appNamePrefix}${nameSuffix}'
var bcName = 'blob-cont-${appNamePrefix}-${nameSuffix}'

module finsum_storageAccount './modules/storage/storage.bicep' = {
  name: 'myStorageDeployment'
  params: {
    location: resourceGrouplocation
    storageAccountName: saName
    blobContainerName: bcName
    tags: tags
  }
  scope:  resourceGroup()
}

// #################################################################################################
// COGNITIVE SERVICES SECTION
// #################################################################################################

var formRecognizerServiceName = 'form-rec-${appNamePrefix}-${nameSuffix}'

module finsum_formRecognizer './modules/cognitive_services/form_recognizer.bicep' = {
  name: 'myFormRecognizerDeployment'
  params: {
    formRecognizerServiceName: formRecognizerServiceName
    location: hostingPlanLocation
    tags: tags
  }
  scope: resourceGroup()
}

var openAIServiceName = 'OpenAI-A02-EU'

module finsum_openAI './modules/cognitive_services/open_ai.bicep' = {
  name: 'myOpenAIDeployment'
  params: {
    openAIServiceName: openAIServiceName
    location: hostingPlanLocation
    tags: tags
  }
  scope: resourceGroup()
}

var textToSpeechServiceName = 'text-to-speech-${appNamePrefix}-${nameSuffix}'

module finsum_textToSpeech './modules/cognitive_services/text_to_speech.bicep' = {
  name: 'myTextToSpeechDeployment'
  params: {
    textToSpeechServiceName: textToSpeechServiceName
    location: hostingPlanLocation
    tags: tags
  }
  scope: resourceGroup()
}

// #################################################################################################
// MEDIA SERVICES SECTION
// #################################################################################################

// !!!!!!!!!!! Disallowed by policy !!!!!!!!!!!!!!!

// var mediaServicesAccountName = 'mediasvc${appNamePrefix}${nameSuffix}'

// module finsum_mediaService './modules/media_services/media_services.bicep' = {
//   name: 'myMediaServicesDeployment'
//   params: {
//     mediaServicesAccountName: mediaServicesAccountName
//     storageAccountId: finsum_storageAccount.outputs.storageAccountId
//     location: hostingPlanLocation
//     tags: tags
//   }
//   scope: resourceGroup()
// }

// #################################################################################################
// WEB APPLICATION SECTION
// #################################################################################################

var hpName = 'host-plan-${appNamePrefix}-${nameSuffix}'

module finsum_hostingPlan './modules/web/hostingplan.bicep' = {
  name: 'myHostingPlanDeployment'
  params: {
    location: hostingPlanLocation
    hostingPlanName: hpName
    tags: tags
  }
  scope: resourceGroup()
}
// ------------------------------
// MONITORING 
// ------------------------------

var logAnalyticsWorkspaceName = 'log-an-${appNamePrefix}-${nameSuffix}'

module hackathon_law './modules/insights/log_analytics.bicep' = {
  name: 'myLogAnalyticsDeployment'
  params: {
    location: hostingPlanLocation
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    tags: tags
    sku: 'PerGB2018'
  }
  scope: resourceGroup()
}


var appInsName = 'app-insights-${appNamePrefix}-${nameSuffix}'

module finsum_appInsights './modules/insights/app_insights.bicep' = {
  name: 'myAppInsightsDeployment'
  params: {
    location: appInsightsLocation
    applicationInsightsName: appInsName
    tags: tags
    logAnalyticsWorkspaceId: hackathon_law.outputs.logAnalyticsWorkspaceId
  }
  scope: resourceGroup()
}

var diagnosticSettingsName = 'diagnostic-${appNamePrefix}-${nameSuffix}'

module finsumai_diagnosticSettings './modules/insights/diagnostic_settings.bicep' = {
  name: 'myDiagnosticSettingsDeployment'
  params: {
    diagnosticSettingsName: diagnosticSettingsName
    logAnalyticsWorkspaceId: hackathon_law.outputs.logAnalyticsWorkspaceId
    logAnalyticsWorkspaceName: hackathon_law.outputs.logAnalyticsWorkspaceName
    storageAccountId: finsum_storageAccount.outputs.storageAccountId
  }
  scope: resourceGroup()
}


// ------------------------------
// APPS
// ------------------------------
module finsum_functionApps './modules/web/function_apps/functionapps.bicep' = {
  name: 'myFunctionsAppDeployment'
  params: {
    appNamePrefix: appNamePrefix
    nameSuffix: nameSuffix
    location: hostingPlanLocation
    applicationInsightInstrumentationKey: finsum_appInsights.outputs.applicationInsightInstrumentationKey
    blobStorageConnectionString: finsum_storageAccount.outputs.blobStorageConnectionString
    hostingPlanId: finsum_hostingPlan.outputs.hostingPlanId
    tags: tags
    blobContainerName: finsum_storageAccount.outputs.blobContainerName
    formRecognizerApiEndpoint: finsum_formRecognizer.outputs.formRecognizerEndpoint
    formRecognizerApiKey: finsum_formRecognizer.outputs.formRecognizerApiKey
    azureOpenAIApiEndpoint: finsum_openAI.outputs.openAIEndpoint
    azureOpenAIApiKey: finsum_openAI.outputs.openAIApiKey
    textToSpeechApiEndpoint: finsum_textToSpeech.outputs.textToSpeechEndpoint
    textToSpeechApiKey: finsum_textToSpeech.outputs.textToSpeechApiKey
  }
  scope: resourceGroup()
}


