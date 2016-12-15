$domains = @(Get-Content C:\domains.txt)

Function Export-PartnerMX
{
    $results = @()
    $resolvedDomains = $domains | resolve-dnsname -Type MX -Server 8.8.8.8 | where {$_.QueryType -eq "MX"}
       
    foreach ($domain in $resolvedDomains)
    {
        $details = @{           
                DomainName          = $domain.Name
                Type                = $domain.Type
                NameExchange        = $domain.NameExchange
                Preference          = $domain.Preference
        } 
 
        $results += New-Object PSObject -Property $details
       
    }   
    $results | export-csv -Path "c:\mxtest3.csv"
    Write-Host "Very Nice, Great Success!!" -ForegroundColor Green

}
Export-PartnerMX
