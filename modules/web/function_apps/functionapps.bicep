param appNamePrefix string

param nameSuffix string

param location string

param tags object

param hostingPlanId string

@description('Function App Blob Container Name')
param blobContainerName string

param blobStorageConnectionString string

param applicationInsightInstrumentationKey string

param formRecognizerApiEndpoint string

@secure()
param formRecognizerApiKey string = newGuid()

param azureOpenAIApiEndpoint string = 'OPENAI_API_ENDPOINT'

@secure()
param azureOpenAIApiKey string = newGuid()

param textToSpeechApiEndpoint string = 'TEXT_TO_SPEECH_ENDPOINT'

@secure()
param textToSpeechApiKey string = newGuid()


var appSpecificAppSettings = [
  {
    name: 'FINSUM_DOCUMENT_CONTAINER'
    value: blobContainerName
  }
  {
    name: 'FINSUM_REPORTS_PATH'
    value: 'financial-reports'
  }
  {
    name: 'FINSUM_REPORTS_TXT_PATH'
    value: 'financial-reports-txt'
  }
  {
    name: 'FINSUM_UPLOAD_RELATIVE_PATH'
    value: 'upload'
  }
  {
    name: 'FINSUM_REPORTS_OCR_RELATIVE_PATH'
    value: 'ocr'
  }
  {
    name: 'FINSUM_REPORTS_SUMMARY_PATH'
    value: 'financial-report-summaries'
  }
  {
    name: 'FINSUM_REPORTS_LIST_SUMMARY_PATH'
    value: 'financial-report-list-summaries'
  }
  {
    name: 'FINSUM_REPORTS_SUMMARY_SUFFIX'
    value: '_summary'
  }
  {
    name: 'FINSUM_REPORTS_AUDIO_SUMMARY_PATH'
    value: 'financial-report-summaries-audio'
  }
  {
    name: 'AZURE_OPENAI_API_KEY'
    value: azureOpenAIApiKey
  }
  {
    name: 'AZURE_OPENAI_API_ENDPOINT'
    value: azureOpenAIApiEndpoint
  }
  {
    name: 'FORM_RECOGNIZER_API_ENDPOINT'
    value: formRecognizerApiEndpoint
  }
  {
    name: 'FORM_RECOGNIZER_API_KEY'
    value: formRecognizerApiKey
  }
  {
    name: 'TEXT_TO_SPEECH_API_ENDPOINT'
    value: textToSpeechApiEndpoint
  }
  {
    name: 'TEXT_TO_SPEECH_API_KEY'
    value: textToSpeechApiKey
  }
]

var applicationFunctionPrefix = 'app-func'
var cSharpAppFunctionName = '${applicationFunctionPrefix}-cs-${appNamePrefix}-${nameSuffix}'

module hackathon_afcs './functionapp_cs.bicep' = {
  name: 'myCSharpFunctionAppDeployment'
  params: {
    location: location
    applicationInsightInstrumentationKey: applicationInsightInstrumentationKey
    blobStorageConnectionString: blobStorageConnectionString
    functionAppHostingPlanId: hostingPlanId
    functionAppName: cSharpAppFunctionName
    tags: tags
    runtime: 'dotnet'
    appSpecificAppSettings: appSpecificAppSettings
  }
}

var pythonAppFunctionName = '${applicationFunctionPrefix}-py-${appNamePrefix}-${nameSuffix}'

module hackathon_afpy './functionapp_py.bicep' = {
  name: 'myPythonFunctionAppDeployment'
  params: {
    location: location
    applicationInsightInstrumentationKey: applicationInsightInstrumentationKey
    blobStorageConnectionString: blobStorageConnectionString
    functionAppHostingPlanId: hostingPlanId
    functionAppName: pythonAppFunctionName
    tags: tags
    runtime: 'python'
    appSpecificAppSettings: appSpecificAppSettings
  }
}
