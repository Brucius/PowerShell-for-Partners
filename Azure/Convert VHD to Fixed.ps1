Write-Host "`n`tEnter source file location e.g C:\image.vhd" -ForegroundColor Cyan -nonewline;
$choice = Read-Host
$SourceFile = $choice

Write-Host "`n`Enter destination file location C:\new\image.vhd" -ForegroundColor Cyan -nonewline;
$choice = Read-Host
$SourceFile = $choice

Convert-VHD –Path $source –DestinationPath $destination –VHDType Fixed
