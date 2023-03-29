$ctx = New-AzStorageContext -StorageAccountName "${Env:SAName}" -StorageAccountKey "${Env:storageKey}"

Set-AzStorageBlobContent -Container "${Env:ContainerName}" -Blob "${env:csvInputFolder}/$localFileName" -Context $ctx -StandardBlobTier 'Hot' -File $localFileName