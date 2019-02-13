<# This is for machines using marketplace Images that needs to be deployed
into availability zones. Deploy the machine first and get the error message
of failing due to marketplace terms then run this script.

Reference Marketplace Source file
"storageProfile": {
    "imageReference": {
        "publisher": "checkpoint",
        "offer": "check-point-vsec-r80",
        "sku": "sg-byol",
        "version": "latest"
    }
}
#>

$targetSubscriptionId='targetsubID'
Select-AzureRmSubscription -SubscriptionId $targetSubscriptionId
$vmName = 'vmName'
$resourceGroupName = 'rgName' 
$Zone = "1"
$nicName = "nicName"
$vmSize = "Standard_E4_v3"

$location = 'francecentral' 
$snapshotName = "$vmName-temp"
$osDiskName = "$vmName-OS-Disk"

$vm = Get-AzureRmVM -Name $vmName `
   -ResourceGroupName $resourceGroupName

$disk = Get-AzureRmDisk -ResourceGroupName $resourceGroupName `
  -DiskName $vm.StorageProfile.OsDisk.Name

$snapshotConfig =  New-AzureRmSnapshotConfig `
  -SourceUri $disk.Id `
  -OsType Linux `
  -CreateOption Copy `
  -Location $location 

$snapShot = New-AzureRmSnapshot `
   -Snapshot $snapshotConfig `
   -SnapshotName $snapshotName `
   -ResourceGroupName $resourceGroupName

$destinationResourceGroup = $resourceGroupName

$osDisk = New-AzureRmDisk -DiskName "$osDiskName" -Disk `
    (New-AzureRmDiskConfig  -Location $location -CreateOption Copy `
    -SourceResourceId $snapshot.Id `
    -Zone "$Zone") `      
    -ResourceGroupName $destinationResourceGroup

Remove-AzureRmVM -ResourceGroupName $resourceGroupName -Name $vmName


$agreementTerms = Get-AzureRmMarketplaceTerms -Publisher "publisherName" -Product "offerName" -Name "skuName" 

Set-AzureRmMarketplaceTerms -Publisher "publisherName" -Product "offerName" -Name "skuName" -Terms $agreementTerms -Accept 
$nic = Get-AzureRmNetworkInterface -Name $nicName `
   -ResourceGroupName $destinationResourceGroup 

$vmConfig = New-AzureRmVMConfig -VMName "$vmName" -VMSize $vmSize

$vm = Add-AzureRmVMNetworkInterface -VM $vmConfig -Id $nic.Id

$vm = Set-AzureRmVMOSDisk -VM $vm `
    -ManagedDiskId $osDisk.Id `
    -StorageAccountType Standard_LRS `
    -DiskSizeInGB 100 `
    -CreateOption Attach -Linux
$vm = Set-AzureRmVMPlan -VM $vm -Publisher "publisherName" -Product "offerName" -Name "skuName"

New-AzureRmVM -ResourceGroupName $destinationResourceGroup -Location $location -VM $vm
