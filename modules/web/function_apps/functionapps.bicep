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
param formRecognizerApiKey string

@secure()
param azureOpenAIApiKey string = newGuid()


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
    name: 'FINSUM_REPORTS_OCR_PATH'
    value: 'financial-reports-ocr'
  }
  {
    name: 'FINSUM_REPORTS_SUMMARY_PATH'
    value: 'financial-report-summaries'
  }
  {
    name: 'AZURE_OPENAI_API_KEY'
    value: azureOpenAIApiKey
  }
  {
    name: 'FORM_RECOGNIZER_API_ENDPOINT'
    value: formRecognizerApiEndpoint
  }
  {
    name: 'FORM_RECOGNIZER_API_KEY'
    value: formRecognizerApiKey
  }
]

var cSharpAppFunctionName = 'afcs-${appNamePrefix}-${nameSuffix}'

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

var pythonAppFunctionName = 'afpy-${appNamePrefix}-${nameSuffix}'

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
