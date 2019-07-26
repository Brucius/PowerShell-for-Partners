#commented lines are variables to be changed according to your needs
$managedDiskName = 'sourceDisk' #name of disk
$Zone = "1" #option of zone 1,2,3

$sourceResourceGroupName = 'sourceRG'

$newDiskName = "$managedDiskName-AZ"
$snapshotName = "$newDiskName-temp"
$resourceGroupName = $sourceResourceGroupName
$targetResourceGroupName = $resourceGroupName
$location = 'region' #option for region

$disk = Get-AzureRmDisk -ResourceGroupName $resourceGroupName `
  -DiskName $managedDiskName

$snapshotConfig =  New-AzureRmSnapshotConfig `
  -SourceUri $disk.Id `
  -CreateOption Copy `
  -Location $location `

$snapShot = New-AzureRmSnapshot `
   -Snapshot $snapshotConfig `
   -SnapshotName $snapshotName `
   -ResourceGroupName $resourceGroupName

$DataDisk = New-AzureRmDisk -DiskName $newDiskName -Disk `
    (New-AzureRmDiskConfig  -Location $location -CreateOption Copy `
    -SourceResourceId $snapshot.Id `
    -Zone $zone) `
    -ResourceGroupName $resourceGroupName

$managedDiskName
