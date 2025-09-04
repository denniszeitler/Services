# Build a SQLite Database to manage IT-Services with Powershell - BCM
# Author: @denniszeitler
# Version: v.0.1
# Description: Setup a database with sqlite
#
# --- Do-Not-Change Variables --- #
#Requires -RunAsAdministrator
$repo = Get-PSRepository -Name 'PSGallery';
# --- Configuration --- #
$installPath = "C:\Temp\Services\";
$db = ($installPath + "db.sqlite");
#

if(-not (Test-Path -Path $installPath )) {
    Write-Host "Create InstallFolder...'";
    New-Item -Path $installPath -Force -ItemType Directory;
}else
{
    Write-Host "InstallFolder already exists'";
}


# --- Start Module Installation --- #
if($repo.InstallPolicy -ne 'Trusted')
{
    Write-Host "Setting PSGallery -> 'Trusted...'";
    Set-PSRepository PSGallery -InstallationPolicy Trusted;
}else
{
    Write-Host "PS Gallery already 'Trusted'";
}
#
if (-not (Get-Module -ListAvailable -Name PSSQLite)) {
    Write-Host "Starting Installation: PSSQLite Modul...";
    Install-Module -Name PSSQLite -Force;
} else {
    Write-Host "PSSQLite Modul already installed.";
}
# --- END Module Installation --- #
#
# --- Create TABLEs --- #
#
$dropQuery = "DROP TABLE IF EXISTS Service;
DROP TABLE IF EXISTS Location;
DROP TABLE IF EXISTS Criticality;
DROP TABLE IF EXISTS Host;
DROP TABLE IF EXISTS User;
DROP TABLE IF EXISTS Role;
DROP TABLE IF EXISTS ServiceDependency;"
Invoke-SqliteQuery -DataSource $db -Query $dropQuery;
# temp - todo: Default-Location / Default-Criticalities 
$cServiceQuery = "CREATE TABLE Service (
ServiceID INTEGER PRIMARY KEY NOT NULL,
ServiceName VARCHAR NOT NULL,
LocationID INTEGER NOT NULL,
CriticalityID INTEGER NOT NULL,
FOREIGN KEY(LocationID) REFERENCES Location(LocationID),
FOREIGN KEY(CriticalityID) REFERENCES Criticality(CriticalityID))"
Invoke-SqliteQuery -DataSource $db -Query $cServiceQuery;
#
$cLocationQuery = "CREATE TABLE Location (
LocationID INTEGER PRIMARY KEY NOT NULL,
LocationName VARCHAR NOT NULL);"
Invoke-SqliteQuery -DataSource $db -Query $cLocationQuery;
# temp - todo: Default Criticality 1-4
$cCriticalityQuery = "CREATE TABLE Criticality (
CriticalityID INTEGER PRIMARY KEY NOT NULL,
CriticalityLevel INTEGER NOT NULL);"
Invoke-SqliteQuery -DataSource $db -Query $cCriticalityQuery;
#
$cHostQuery = "CREATE TABLE Host (
HostID INTEGER PRIMARY KEY NOT NULL,
HostName VARCHAR NOT NULL,
isVirtual INTEGER NOT NULL,
ServiceID INTEGER NOT NULL,
OS VARCHAR NOT NULL,
LocationID INTEGER NOT NULL,
FOREIGN KEY(ServiceID) REFERENCES Service(ServiceID),
FOREIGN KEY(LocationID) REFERENCES Location(LocationID));"
Invoke-SqliteQuery -DataSource $db -Query $cHostQuery;
#
$cUserQuery = "CREATE TABLE User (
UserID INTEGER PRIMARY KEY NOT NULL,
SID VARCHAR NOT NULL,
Username VARCHAR NOT NULL,
FirstName VARCHAR NOT NULL,
SurName VARCHAR NOT NULL,
ServiceID INTEGER NOT NULL,
RoleID INTEGER NOT NULL,
FOREIGN KEY(ServiceID) REFERENCES Service(ServiceID),
FOREIGN KEY(RoleID) REFERENCES Role(RoleID));"
Invoke-SqliteQuery -DataSource $db -Query $cUserQuery;
# temp - todo: Default-Role
$cRoleQuery = "CREATE TABLE Role (
RoleID INTEGER PRIMARY KEY NOT NULL,
RoleName VARCHAR NOT NULL);"
Invoke-SqliteQuery -DataSource $db -Query $cRoleQuery;
#
$cServiceDependencyQuery = "CREATE TABLE ServiceDependency (
ServiceDependencyID INTEGER PRIMARY KEY NOT NULL,
DependsOnServiceID INTEGER NOT NULL,
ServiceID INTEGER NOT NULL,
FOREIGN KEY(ServiceID) REFERENCES Service(ServiceID));"
Invoke-SqliteQuery -DataSource $db -Query $cServiceDependencyQuery;
#
# --- END --- #

# --- INSERT INTO tables --- #
#
$iLocationQuery = "INSERT INTO Location (LocationName) VALUES ('DefaultLocation');"
Invoke-SqliteQuery -DataSource $db -Query $iLocationQuery;
#
$iCriticalityQuery = "INSERT INTO criticality (CriticalityLevel) VALUES ('1');"
Invoke-SqliteQuery -DataSource $db -Query $iCriticalityQuery;
# --- END --- #