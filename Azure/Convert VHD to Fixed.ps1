Write-Host "`n`tEnter source file location e.g C:/vhd/image.vhd" -ForegroundColor Cyan -nonewline;
$choice = Read-Host
$SourceFile = $choice

Write-Host "`n`Enter destination file location C:/vhd/new/image.vhd" -ForegroundColor Cyan -nonewline;
$choice = Read-Host
$SourceFile = $choice

Convert-VHD –Path $source –DestinationPath $destination –VHDType Fixed
