$agreementTerms = Get-AzureRmMarketplaceTerms -Publisher "paloaltonetworks" -Product "vmseries1" -Name "byol" 

Set-AzureRmMarketplaceTerms -Publisher "paloaltonetworks" -Product "vmseries1" -Name "byol" -Terms $agreementTerms -Accept 
$nic = Get-AzureRmNetworkInterface -Name $nicName `
   -ResourceGroupName $destinationResourceGroup 


$vmConfig = New-AzureRmVMConfig -VMName "AZUDMZSVNETPA02" -VMSize $vmSize -Zone "2"

$vm = Add-AzureRmVMNetworkInterface -VM $vmConfig -Id $nic.Id

$vm = Set-AzureRmVMOSDisk -VM $vm -ManagedDiskId $osDisk.Id -StorageAccountType Standard_LRS `
    -DiskSizeInGB 128 -CreateOption Attach -Linux
$vm = Set-AzureRmVMPlan -VM $vm -Publisher "paloaltonetworks" -Product "vmseries1" -Name "byol" 

New-AzureRmVM -ResourceGroupName $destinationResourceGroup -Location $location -VM $vm
