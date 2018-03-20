##Login
Add-AzureRmAccount 

$sas = Grant-AzureRmDiskAccess -ResourceGroupName "$RG" -DiskName "$diskname" -DurationInSecond 3600 -Access Read 

$destContext = New-AzureStorageContext –StorageAccountName "$SAName" -StorageAccountKey "$SAKey" 

$blob1 = Start-AzureStorageBlobCopy -AbsoluteUri $sas.AccessSAS -DestContainer "$SAContainer" -DestContext $destContext -DestBlob '$diskname.vhd'

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
