## To Install the new Az module based on .Net Core. 
Currently in progress of converting existing RM scripts into Az. Contributions welcome! Only install this module after uninstalling the RM modules.
To Uninstall all AzureRM module
```
$versions = (Get-InstalledModule AzureRM -AllVersions | Select-Object Version)
$versions | foreach { Uninstall-AllModules -TargetModule AzureRM -Version ($_.Version) -Force }
Get-Module -ListAvailable | Where-Object { $_.Name -like 'AzureRM*' } | Uninstall-Module
```
To Uninstall all Azure

```Get-Module -ListAvailable | Where-Object { $_.Name -like 'Azure*' } | Uninstall-Module```

## To Install and Update the module
```
Install-Module -Name Az
Install-Module -Name Az -AllowClobber -Force
```