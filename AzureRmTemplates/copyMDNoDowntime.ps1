### SOURCE DETAILS
$SourceSubId = 'SourceID'
$SourceRGName = 'SourceRG'
$SourceDiskName = 'SourceOSDISK'

### TARGET DETAILS
$TargetSubId = 'TargetID'
$TargetRGName = 'TargetRG'

### Select Source Context
Select-AzureRmSubscription -SubscriptionId $SourceSubId
$managedDisk= Get-AzureRMDisk -ResourceGroupName $SourceRGName -DiskName $SourceDiskName

### Select Target Context
Select-AzureRmSubscription -SubscriptionId $TargetSubId
$diskConfig = New-AzureRmDiskConfig -SourceResourceId $managedDisk.Id -Location $managedDisk.Location -CreateOption Copy
New-AzureRmDisk -Disk $diskConfig -DiskName $SourceDiskName -ResourceGroupName $TargetRGName
