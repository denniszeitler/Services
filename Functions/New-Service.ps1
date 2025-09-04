<#
.SYNOPSIS
Provides a function to add a New-Service to the table services

.DESCRIPTION
IT-Emergency Management / BCM requires to manage your systems and processes as "Services". This is a Powershell approach to mange a SQLite-Database.

.PARAMETER DataSource
The Savelocation of your database file.

.PARAMETER Name
The Name of the Service.

.EXAMPLE
Manage-Service -DataSource "C:\Temp\services.sqlite" -Name "E-Mail Server" 

#>


function New-Service{
    param(
        [string]$DataSource,
        [string]$Name,
        [int]$CriticalityLevel,
        [int]$LocationID
    )
If(-not $CriticalityLevel){
    $CriticalityLevel = 1;
}
If(-not $LocationID){
    $LocationID = 1;
}
$newServiceQuery = "INSERT INTO service (ServiceName,LocationID,CriticalityID) VALUES ('$Name','$LocationID','$CriticalityLevel')";
Invoke-SqliteQuery -DataSource $DataSource -Query  $newServiceQuery;
}


