<#
    .SCRIPT SYNOPSIS 
        ARM environment 
        Copy a Managed Disk to a vhd blob on a specified storage account \ container
	  
	.Description
	  	This script copy a Managed Disk to a vhd on a Storage Account \ container.
        Account login should be Administrator of each subscription ID.
        
1-	From the disk please create the snapshot:
2-	After creating the snapshot, please make the download of the attached zip file and extract the files on desktop.
3-	Open powershell and run the command after making the right modifications:
<<location>>\AzureRMCopyVhdManagedDisks.ps1 -S "<<subsID>>" -RG "<<resourcegroupname>>" -Name "<<snapshotname>>" -ToSA "<<storageaccount>>" -ToSAContainer "vhds" -Snapshot 
4-	After this the vhd will be created.
5-	From Azure Storage Explorer check if the size of the vhd is right.
6-	Make a copy of it and try to attach the data disk to the vm.

	.Parameter InHelp
		Optional: This item will display syntax help
		Alias: H

	.Parameter SubID
		Mandatory: This item is the Subscription ID that will be used
		Alias: S

	.Parameter rgName
		Mandatory: This item is the Resource Group Name that will be used
		Alias: RG

	.Parameter DiskName
		Mandatory: This item is the VM image Name that will be used
		Alias: Name

	.Parameter InSnapshot
		Mandatory: This switch will managed this disk as a source snapshot
		Alias: Snapshot

	.Parameter ToSaName
		Mandatory: This item is the Destination Storage Account Name that will be used
		Alias: ToSA

	.Parameter ToSaContainer
		Mandatory: This item is the Destination container on Storage account Name that will be used
		Alias: ToSAContainer

	.Example
		.\AzureRMCopyVhdManagedDisks.ps1 -S "aaaaaaaa-0000-1111-3333-bbbbbbbbbbbb" -RG "<ResourceGroup" -DSK "<ManageDiskName>" -ToSA "<storageaccount>" -ToSAContainer "<container>" -Snapshot

    .Author  
        Rafael Duarte
		Created By Rafael Duarte
		Email v-raduar@microsoft.com		

    .Credits

    .Notes / Versions / Output
    	* Version: 1.0
		  Date: June 22th 2017
		  Purpose/Change:	Initial function development
          # Constrains / Pre-requisites:
            > none
          # Output
            > Creates a Transcript File (<ScriptName>_<TrackTimeStamp>.txt)
            > Creates a vhd blob on destination Storage Account \ container
#>
	Param(
	[Parameter(Mandatory=$false)][Alias('H')][Switch]$InHelp,
	[Parameter(Mandatory=$false)][Alias('Snapshot')][Switch]$InSnapshot,
	[Parameter(Mandatory=$false)][Alias('S')][String]$InSubId = "",
	[Parameter(Mandatory=$false)][Alias('RG')][String]$InrgName = "",
	[Parameter(Mandatory=$false)][Alias('Name')][String]$InDiskName = "",
	[Parameter(Mandatory=$false)][Alias('ToSA')][String]$InToSaName = "",
	[Parameter(Mandatory=$false)][Alias('ToSAContainer')][String]$InToSaContainer = "")
<#
    .Function SYNOPSIS - ErrorMsgCentral
      Displays a custom message to console output depending on MsgID
	  
	.Description
	  	This function helps to centralize all custom messages to console output
	  	depending on MsgID selected. q

	.Parameter MsgID
		Mandatory: This item idenfify message to be displayed on console output
		Alias: ID

	.Parameter MsgData
		Optional: Additional data that can be used when displaying message to console output
		Alias: Data

	.Example
		ErrorMsgCentral -ID 10 -Data "Demo"
		
		This example will output error message assign to ID 10 and may use "Demo" string
        to be added on Message ID selected.

	.Notes
		Created By Rafael Duarte
		Email v-raduar@microsoft.com		

		Version: 1.0
		Date: May 14th 2017
		Purpose/Change:	Initial function development

    .Link

#>
function ErrorMsgCentral{
	Param(
	[Parameter(Mandatory=$True)][Alias('ID')][Int32]$MsgID,
	[Parameter(Mandatory=$False)][Alias('Data')][String]$MsgData)

    switch ($MsgID) 
    { 
        0   {$MsgTxt = ""}
        5   {$MsgTxt = "Syntax: $MsgData" + `
		     "`n`n .\$($ScriptName).ps1 -H | (-S `"<SubscriptionID>`" -RG `"<RGName>`" -DSK `"<DiskName>`" -ToSA `"<ToStorageAccountName>`" -ToSAContainer `"<ToStorageAccountContainerName>`")"
            }
        10  {$MsgTxt = "Error: Invalid Authentication ! $MsgData`n"}
        30  {$MsgTxt = "Error: Invalid Resource Name <$($MsgData)>!"}
        31  {$MsgTxt = "Error: Error creating Storage Account <$($MsgData)>!"}
        32  {$MsgTxt = "Error: Error creating Container! $($MsgData)>!"}
        33  {$MsgTxt = "Error: Error creating SAS! $($MsgData)>!"}
        default {$MsgTxt = "Error unknown !!!"}

    }
    If ($MsgID -gt 0)
    {
        Write-Host "`n<$MsgID>" -ForegroundColor Yellow 
        Write-Host $MsgTxt -ForegroundColor Red 
    }
    Write-Host "`n####### End - PoSH script $ScriptName.ps1 #######" -ForegroundColor Green

    Stop-Transcript
}

### Parameters / Constants ###
## Get Script Name
    # invocation from POSH Command Line
    $ScriptName = $MyInvocation.MyCommand.Name
    if (($ScriptName -eq $null) -or ($ScriptName -eq ""))
    {
        # invocation from POSH ISE Environment
        $ScriptName = ($psISE.CurrentFile.DisplayName).Replace("*","")
    }
    $ScriptName = $ScriptName.Replace(".ps1","")

## Files / logs / Paths
    $TrackTimeStamp = "$('{0:yyyyMMddHHmmss}_{1,-1}' -f $(Date), $(Get-Random))" 
    $TranscriptPath = "$env:USERPROFILE\Documents\PoSH_Transcript\"
    if (!(Test-Path -LiteralPath $TranscriptPath -PathType Container)) 
        {Invoke-Command -ScriptBlock {md $TranscriptPath}}
    $LogPath        = "$env:USERPROFILE\Documents\PoSH_Logs\"
    if (!(Test-Path -LiteralPath $LogPath -PathType Container)) 
        {Invoke-Command -ScriptBlock {md $LogPath}}
    $TranscriptFile = $TranscriptPath + $ScriptName + "_" + $TrackTimeStamp + ".txt"

## Setting PoSH Execution Policy to Lowest
    #Set-ExecutionPolicy -ExecutionPolicy Bypass -Force

### Main Script ###
    Clear

## Track Log
    Start-Transcript $TranscriptFile

## Begin Script
    Write-Host "`n####### Begin - PoSH script $ScriptName.ps1 #######`n" -ForegroundColor Green

## Parameters Validation
    If ($InHelp)
    {
        ErrorMsgCentral -ID 5
        Throw
    }
    
    $SubId = $InSubId
    $rgName = $InrgName
    $DiskName = $InDiskName
    $ToSaName = $InToSaName
    $ToSaContainer = $InToSaContainer
    $IsSnapshot = $InSnapshot
    # Test Purposes
    <#
    $SubId = "9ccbaf3b-d079-4d08-b717-49509799519a"
    $rgName = "rdrgteste"
    $DiskName = "rdvmteste_OsDisk_1_3b97bbbb67cc41a0ac60aae8956966fd"
    $ToSaName = "rdtestemngstd"
    $ToSaContainer = "disks"
    $IsSnapshot = $false
    #>

    If (($SubId -eq "") -or `
        ($rgName -eq "") -or `
        ($DiskName -eq "") -or `
        ($ToSaName -eq "") -or `
        ($ToSaContainer -eq ""))
    {
        ErrorMsgCentral -ID 5 -MsgData "Missing Parameters !"
        Throw
    }

## Authenticate Azure ARM
    Write-Host " Authenticating Azure ARM ....." -ForegroundColor Yellow
    Add-AzureRMAccount -ErrorAction SilentlyContinue -ErrorVariable RC_Err > $null
    if ($RC_Err.Count -gt 0)
    {
        ErrorMsgCentral -ID 10 -Data "Login to Azure ARM"
        Throw
    }

# Select Subscription
    Select-AzureRmSubscription -SubscriptionID $subID -ErrorAction SilentlyContinue -ErrorVariable ErrSub
    if ($ErrSub.Count -gt 0)
    {
        ErrorMsgCentral -ID 10 -Data "Selecting Subscription ID: $($subID)."
        Throw
    }
    Set-AzureRmContext -SubscriptionID $subID -ErrorAction SilentlyContinue -ErrorVariable ErrSub
    if ($ErrSub.Count -gt 0)
    {
        ErrorMsgCentral -ID 10 -Data "Setting Azure ARM Context with Subscription ID: $($subID)."
        Throw
    }

## Resource Group
    Write-Host "`n ==== Input parameters ====" -ForegroundColor Yellow
    Write-Host   "   Subscription ID: $SubId" -ForegroundColor Green
    Write-Host   "    Resource Group: $rgName" -ForegroundColor Green
    if ($IsSnapshot)
    {
        Write-Host   "     Snapshot Name: $DiskName" -ForegroundColor Green
    } else
        {
            Write-Host   " Managed Disk Name: $DiskName" -ForegroundColor Green
        }
    Write-Host   "     Dest. Storage: $ToSaName" -ForegroundColor Green
    Write-Host   "   Dest. Container: $ToSaContainer" -ForegroundColor Green

## Parameters Validation
## Resource Group
    $rg = Get-AzureRmResourceGroup -Name $rgName -ErrorAction SilentlyContinue -ErrorVariable ErrRes
    if ($ErrRes.Count -gt 0)
    {
        ErrorMsgCentral -ID 30 -Data "Resource Group $($rgName)"
        Throw
    }

## Assuming Parameters
    $ToSALocation = $rg.Location
    $ToSAType = "Standard_LRS"

    if ($IsSnapshot)
    {
    ## Snapshot Managed Disk Name
        $Disk = Get-AzureRmSnapshot -ResourceGroupName $rgName -SnapshotName $DiskName  -ErrorAction SilentlyContinue -ErrorVariable ErrRes
        if ($ErrRes.Count -gt 0 -or $DiskName -eq $null)
        {
            ErrorMsgCentral -ID 30 -Data "Snapshot Managed Disk Name $($DiskName)"
            Throw
        }
    } else
        {
        ## Managed Disk Name
            $Disk = Get-AzureRmDisk -ResourceGroupName $rgName -DiskName $DiskName  -ErrorAction SilentlyContinue -ErrorVariable ErrRes
            if ($ErrRes.Count -gt 0 -or $DiskName -eq $null)
            {
                ErrorMsgCentral -ID 30 -Data "Managed Disk Name $($DiskName)"
                Throw
            }
        }
## Destination SA
    Write-Host "`n         SA Dest. : $ToSaName" -ForegroundColor Green
    Write-Host   "  Container Dest. : $ToSaContainer" -ForegroundColor Green
    # Check SA account 
    $ToSA = Get-AzureRmStorageAccount -ResourceGroupName $rgName -Name $ToSAName -ErrorAction SilentlyContinue -ErrorVariable ErrSA
    if ($ErrSA.Count -gt 0)
    {
        Write-Host "`n NEW Storage account! Creating ($ToSAName)......" -ForegroundColor Yellow
        $ToSA = New-AzureRmStorageAccount -ResourceGroupName $rgName -Name $ToSAName -Location $ToSALocation -SkuName $ToSAType 
        $ToSA = Get-AzureRmStorageAccount -ResourceGroupName $rgName -Name $ToSAName -ErrorAction SilentlyContinue -ErrorVariable ErrSA
        if ($ErrSA.Count -gt 0)
        {
            ErrorMsgCentral -ID 31 -Data "$ToSaName"
            Throw
        }
        Write-Host "`n NEW Storage account Created !" -ForegroundColor Green
    } else
        {
            Write-Host "`n Using existing Storage account ($ToSAName)!" -ForegroundColor Green
        }

# Create Storage Account Contexts
# Context to Destination Storage Account
    $ToSAKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $rgName -StorageAccountName $ToSAName).Value[0]
    $ToSAContext = New-AzureStorageContext –StorageAccountName $ToSAName -StorageAccountKey $ToSAKey

# Check Container on that Destination SA account 
    if ((Get-AzureStorageContainer -Context $ToSAContext -Name $ToSAContainer -ErrorAction SilentlyContinue) -eq $null) 
    {
        Write-Host "`n Creating container ($ToSAContainer) on Storage Account ($ToSAName)......" -ForegroundColor Yellow
        $ToSAContainerID = New-AzureStorageContainer -Context $ToSAContext -Name $ToSAContainer -ErrorAction SilentlyContinue -ErrorVariable ErrSA
        if ($ErrSA.Count -gt 0)
        {
            ErrorMsgCentral -ID 32 -Data "Container ($ToSAContainer) on Storage Account ($ToSAName)"
            Throw
        }
        Write-Host "`n NEW container created !" -ForegroundColor Green
    } else
        {
            Write-Host "`n Using existing Container ($ToSAContainer) on Storage Account ($ToSAName)!" -ForegroundColor Green
        }

    # Managed Disk
    $DiskVHDName =  $DiskName + ".vhd" 
    $DiskVHDURI = $ToSAContext.BlobEndPoint + $ToSaContainer + "/" + $DiskVHDName
    Write-Host "`n          VHD Blob: $DiskVHDName" -ForegroundColor Green
    Write-Host   "           VHD URI: $DiskVHDURI" -ForegroundColor Green

## SAS for Managed Disk \snapshot
    if ($IsSnapshot)
    {
        $DiskSAS = Grant-AzureRmSnapshotAccess -ResourceGroupName $rgName -SnapshotName $DiskName -Access Read -DurationInSecond 3660 -ErrorAction SilentlyContinue -ErrorVariable ErrMDisk
    } else
        {
            $DiskSAS = Grant-AzureRmDiskAccess -ResourceGroupName $rgName -DiskName $DiskName -Access Read -DurationInSecond 3660 -ErrorAction SilentlyContinue -ErrorVariable ErrMDisk
        }
    if ($ErrMDisk.Count -gt 0)
    {
        ErrorMsgCentral -ID 33 -Data "Managed Disk Name $($DiskName)"
        Throw
    }

## Starting copying vhd
    # Managed Disk
    Start-AzureStorageBlobCopy -AbsoluteUri $DiskSAS.AccessSAS -DestContainer $ToSaContainer -DestContext $ToSAContext -DestBlob $DiskVHDName

# Wait until vhds files are copy.
    Write-Host "`n Waiting for disk copy to complete. Checking status every 30 seconds." -ForegroundColor Yellow
    do {
         Sleep -Seconds 30
            $CopyStateDisk = Get-AzureStorageBlobCopyState -Container $ToSaContainer -Context $ToSAContext -Blob $DiskVHDName 
            if ($CopyStateDisk.Status -eq "Success") {
                Write-Host "`n Copy complete for $DiskVHDName at $($CopyStateDisk.CompletionTime)" -ForegroundColor Green
            }
            else {
                if ($CopyStateDisk.TotalBytes -gt 0) {
                    $percent = ($CopyStateDisk.BytesCopied / $CopyStateDisk.TotalBytes) * 100
                    Write-Host "`n $('{0:N2}' -f $percent)% of disk $DiskVHDName copied." -ForegroundColor Yellow
                }
            }

    } while($CopyStateDisk.Status -ne "Success")
 

## Cancel pending copy of vhds (if needed)
    # Managed Disk
    #Stop-AzureStorageBlobCopy -Container $ToSaContainer -Context $ToSAContext -DestBlob $DiskVHDName

# End Script
    ErrorMsgCentral -ID 0 
