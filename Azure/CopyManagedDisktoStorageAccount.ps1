$sas = Grant-AzureRmDiskAccess -ResourceGroupName $RG -DiskName $diskname -DurationInSecond 3600 -Access Read 

$destContext = New-AzureStorageContext –StorageAccountName $SAName -StorageAccountKey $SAKey 

Start-AzureStorageBlobCopy -AbsoluteUri $sas.AccessSAS -DestContainer $SAContainer -DestContext $destContext -DestBlob '$diskname.vhd'
