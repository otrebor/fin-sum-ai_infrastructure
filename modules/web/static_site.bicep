param staticWebSiteName string

@allowed([ 'centralus', 'eastus2', 'eastasia', 'westeurope', 'westus2' ])
param location string = 'eastus2'

@allowed([ 'Free', 'Standard' ])
param sku string = 'Free'

param tags object = {}

resource swa_resource 'Microsoft.Web/staticSites@2021-01-15' = {
    name: staticWebSiteName
    location: location
    tags: tags
    properties: {
      repositoryUrl: 'https://dev.azure.com/hackathon-cteam-openai/fin-sum-ai/_git/fin-sum-ai_user_interface'
      repositoryToken: ''
      branch: 'main'
      buildProperties: {
        appLocation: 'fin-sum-ai-ui/'
        apiLocation: '/api'
        appArtifactLocation: 'fin-sum-ai-ui/dist/fin-sum-ai-ui'
      }
    }
    sku: {
        name: sku
        size: sku
    }
}
