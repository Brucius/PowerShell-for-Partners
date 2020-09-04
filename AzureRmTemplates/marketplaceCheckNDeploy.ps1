#This command sets the execution policy to bypass for only the current PowerShell session.
#After the window is closed, the next PowerShell session will open running with the default execution policy. 
#“Bypass” means nothing is blocked and no warnings, prompts, or messages will be displayed.
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# From 4sysop
$locname=Get-AzureRmLocation | `
select displayname | `
Out-GridView -PassThru -Title "Choose a location"

$pubname=Get-AzureRmVMImagePublisher `
-Location $locname.DisplayName | `
Out-GridView -PassThru -Title "Choose a publisher"

$offername = Get-AzureRmVMImageOffer `
-Location $locname.DisplayName `
-PublisherName $pubname.PublisherName | `
Out-GridView -PassThru -Title "Choose an offer"

$title="SKUs for location: " + `
$locname.DisplayName + `
", Publisher: " + `
$pubname.PublisherName + `
", Offer: " + `
$offername.Offer

Get-AzureRmVMImageSku `
-Location $locname.DisplayName `
-PublisherName $pubname.PublisherName `
-Offer $offername.Offer | `
select SKUS | `
Out-GridView -Title $title



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
$Zone = "1-2-3" #option of zone 1,2,3
$nicName = 'nicName'
$vmSize = 'Standard_E4_v3'
$oSDiskSize = 100
$oSDiskCreateOption = 'Attach'
$location = 'francecentral'
$publisherName = ""
$productName = ""
$skuName = ""


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


$agreementTerms = Get-AzureRmMarketplaceTerms -Publisher $publisherName -Product $productName -Name $skuName

Set-AzureRmMarketplaceTerms -Publisher $publisherName -Product $productName -Name $skuName -Terms $agreementTerms -Accept 
$nic = Get-AzureRmNetworkInterface -Name $nicName `
   -ResourceGroupName $destinationResourceGroup 

$vmConfig = New-AzureRmVMConfig -VMName "$vmName" -VMSize $vmSize

$vm = Add-AzureRmVMNetworkInterface -VM $vmConfig -Id $nic.Id

$vm = Set-AzureRmVMOSDisk -VM $vm -ManagedDiskId $osDisk.Id -StorageAccountType Standard_LRS -DiskSizeInGB $OSDiskSize -CreateOption $OSDiskCreateOption -Linux
$vm = Set-AzureRmVMPlan -VM $vm -Publisher $publisherName -Product $productName -Name $skuName

New-AzureRmVM -ResourceGroupName $destinationResourceGroup -Location $location -VM $vm
