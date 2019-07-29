#This command sets the execution policy to bypass for only the current PowerShell session.
#After the window is closed, the next PowerShell session will open running with the default execution policy. 
#“Bypass” means nothing is blocked and no warnings, prompts, or messages will be displayed.
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

##Define variables
$sourceRG = "sourceRgName"
$sourceDisk = "sourceDiskName"
$targetStorageAccount = "targetStorageAccountName"
$targetStorageAccountKey = "targetStorageAccountKey"
$targetStorageAccountContainer = "targetStorageAccountContainerName"
$targetDisk = "targetDiskName.vhd"

##Login
Login-AzureRmAccount

$sas = Grant-AzureRmDiskAccess -ResourceGroupName $sourceRG -DiskName $sourceDisk -DurationInSecond 3600 -Access Read 

$destContext = New-AzureStorageContext –StorageAccountName $targetStorageAccount -StorageAccountKey $targetStorageAccountKey 

$blob1 = Start-AzureStorageBlobCopy -AbsoluteUri $sas.AccessSAS -DestContainer $targetStorageAccountContainer -DestContext $destContext -DestBlob $targetDisk

### Retrieve the current status of the copy operation ###
$status = $blob1 | Get-AzureStorageBlobCopyState 
 
### Print out status ### 
$status 
 
### Loop until complete ###                                    
While($status.Status -eq "Pending"){
  $status = $blob1 | Get-AzureStorageBlobCopyState 
  Start-Sleep 10
  ### Print out status ###
  $status
} 
