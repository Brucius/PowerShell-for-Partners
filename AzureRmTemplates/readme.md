# Basics and Pre-requisites to run these scripts
The below cmdlets helps you install necessary moduesl the run the scripts on your local machine.

## To Install AzureRM module
```
Install-Module -Name AzureRM
Import-Module -Name AzureRM
```
## To Update AzureRm module to latest
```Update-Module -Name AzureRM```

## Install MSOnline PowerShell for Azure Active Directory (V1)
```Install-Module -Name MSOnline```

Import Office 365 and Azure AD module
```Import-Module -Name MSOnline```

## To Uninstall all AzureRM module
```
$versions = (Get-InstalledModule AzureRM -AllVersions | Select-Object Version)
$versions | foreach { Uninstall-AllModules -TargetModule AzureRM -Version ($_.Version) -Force }
Get-Module -ListAvailable | Where-Object { $_.Name -like 'AzureRM*' } | Uninstall-Module
```
## To Uninstall all Azure
```Get-Module -ListAvailable | Where-Object { $_.Name -like 'Azure*' } | Uninstall-Module```