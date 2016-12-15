$domains = @(Get-Content C:\domains.txt)

Function Export-PartnerMX
{
    $results = @()
    $domains | resolve-dnsname -Type MX -Server 8.8.8.8 | where {$_.QueryType -eq "MX"}
        
    foreach ($domains in $domains)
    {
        $details = @{            
                DomainName          = $domains.Name
                Tye                 = $domains.Type
                NameExchange        = $domains.NameExchange
                Preference          = $domains.Preference
        }  

        $results += New-Object PSObject -Property $details
        
    }    
    $results | export-csv -Path "c:\mxtest.csv"
    Write-Host "Very Nice, Great Success!!" -ForegroundColor Green

}
Export-PartnerMX
