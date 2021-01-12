##############################################################
########## Register Backup and Managed Disk ##################
##############################################################
Register-AzProviderFeature -ProviderNamespace Microsoft.RecoveryServices -FeatureName RecoveryServicesResourceMove
Register-AzResourceProvider -ProviderNamespace Microsoft.RecoveryServices
Register-AzProviderFeature -FeatureName ManagedResourcesMove -ProviderNamespace Microsoft.Compute
Register-AzResourceProvider -ProviderNamespace Microsoft.Compute
do {
    $getMdStatus = Get-AzProviderFeature -FeatureName ManagedResourcesMove -ProviderNamespace Microsoft.Compute
    $getvaultStatus = Get-AzProviderFeature -FeatureName RecoveryServicesResourceMove -ProviderNamespace Microsoft.RecoveryServices
    $getMdStatus
    $getVaultStatus
    Start-Sleep -Seconds 20
}
while ($getMdStatus.RegistrationState.Equals("Registering") -and $getVaultStatus.RegistrationState.Equals("Registering"))
Write-Host "Registration Completed."
