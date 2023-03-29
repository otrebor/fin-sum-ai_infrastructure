// ========== add-secret-to-existing-kv-1.bicep ==========
@description('Specifies the name of the vault where we want to add a secret.')
param vaultName string = 'kv-contoso'

@description('Specifies the name of the secret that you want to create.')
param secretName string

@description('Specifies the value of the secret that you want to create.')
@secure()
param secretValue string

resource secret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${vaultName}/${secretName}'  // The first part is KV's name
  properties: {
    value: secretValue
  }
}
