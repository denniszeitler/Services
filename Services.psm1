#Services.psm1
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition;
Get-ChildItem "$scriptDir\Functions\*.ps1" | ForEach-Object { . $_.FullName}
