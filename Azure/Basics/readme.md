# Basics and Pre-requisites to run these scripts
Below modules are in the order of my personal preference. Currently the new Az modules do not work well with existing MsOnline modules.

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

## To Install the new Az module based on .Net Core. 
Only install this module after uninstalling the Rm modules.
```Install-Module -Name Az```
## To Update the module
```Install-Module -Name Az -AllowClobber -Force```