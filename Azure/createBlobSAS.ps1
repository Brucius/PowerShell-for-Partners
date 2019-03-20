#This script allows you to create an SAS policy on your existing storage account and lets you grab SAS key. 
#Useful for this tutorial https://docs.microsoft.com/en-us/sql/relational-databases/tutorial-use-azure-blob-storage-service-with-sql-server-2016?view=sql-server-2017
#SQL Server backing up to Azure Blob Storage

#Defining Variables
$storageAccountName = "<SA Name>" 
$resourceGroupName = "<RG Name>"
$containerName = "<containerName>"
$policyName = "<name>" + "policy"

# Get the access keys for the Azure Resource Manager storage account  
$accountKeys = Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -Name $storageAccountName  

# Create a new storage account context using an Azure Resource Manager storage account  
$storageContext = New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $accountKeys[0].Value

# Creates a new container in blob storage  
$container = Get-AzureStorageContainer -Context $storageContext -Name $containerName  

# Sets up a Stored Access Policy and a Shared Access Signature for the new container  
$policy = New-AzureStorageContainerStoredAccessPolicy -Container $containerName -Policy $policyName -Context $storageContext -StartTime $(Get-Date).ToUniversalTime().AddMinutes(-5) -ExpiryTime $(Get-Date).ToUniversalTime().AddYears(10) -Permission rwld

# Gets the Shared Access Signature for the policy  
$sas = New-AzureStorageContainerSASToken -name $containerName -Policy $policyName -Context $storageContext
Write-Host 'Shared Access Signature= '$($sas.Substring(1))''
