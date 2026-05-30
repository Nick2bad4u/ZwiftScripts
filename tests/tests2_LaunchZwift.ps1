# TestDisplayConfig.ps1

# Variables
$ZwiftProcessName = 'ZwiftLauncher'
$PrimaryDisplayZwift = 4
$PrimaryDisplayDefault = 2
$ModulePath = 'C:\Users\Nick\Dropbox\PC (2)\Documents\PowerShell\Modules\DisplayConfig\3.1.0\DisplayConfig.dll'

# Import the DisplayConfig module
try {
    Import-Module $ModulePath -ErrorAction Stop
}
catch {
    Write-Error "Failed to import DisplayConfig module: $($_.Exception.Message)"
    exit 1
}

# Function to check if Zwift is running
function Is-ZwiftRunning {
    Get-Process | Where-Object { $_.Name -eq $ZwiftProcessName } -ErrorAction SilentlyContinue
}

# Test Case 1: Zwift is Running
Write-Output 'Running Test Case 1: Zwift is Running'
Start-Process -FilePath 'C:\Program Files (x86)\Zwift\ZwiftLauncher.exe' -NoNewWindow
Start-Sleep -Seconds 5 # Wait for Zwift to start
if (Is-ZwiftRunning) {
    Write-Output 'Zwift is running. Primary display should remain unchanged.'
}
else {
    Write-Error 'Zwift is not running. Test Case 1 failed.'
}
Stop-Process -Name $ZwiftProcessName -Force
Write-Output "Test Case 1 Completed`n"

# Test Case 2: Zwift is Not Running
Write-Output 'Running Test Case 2: Zwift is Not Running'
if (-not (Is-ZwiftRunning)) {
    Write-Output "Zwift is not running. Primary display should switch to $PrimaryDisplayDefault."
    Set-DisplayPrimary $PrimaryDisplayDefault
}
else {
    Write-Error 'Zwift is running. Test Case 2 failed.'
}
Write-Output "Test Case 2 Completed`n"

# Test Case 3: DisplayConfig Module Not Found
Write-Output 'Running Test Case 3: DisplayConfig Module Not Found'
Rename-Item -Path $ModulePath -NewName 'DisplayConfig_temp.dll' -Force
try {
    Import-Module $ModulePath -ErrorAction Stop
    Write-Error 'DisplayConfig module imported successfully. Test Case 3 failed.'
}
catch {
    Write-Output "Failed to import DisplayConfig module as expected: $($_.Exception.Message)"
}
Rename-Item -Path (Split-Path $ModulePath -Parent) + '\DisplayConfig_temp.dll' -NewName 'DisplayConfig.dll' -Force
Write-Output "Test Case 3 Completed`n"

# Test Case 4: Invalid Display ID
Write-Output 'Running Test Case 4: Invalid Display ID'
$PrimaryDisplayDefault = 99 # Invalid display ID
try {
    Set-DisplayPrimary $PrimaryDisplayDefault
    Write-Error 'Invalid display ID accepted. Test Case 4 failed.'
}
catch {
    Write-Output "Invalid display ID handled as expected: $($_.Exception.Message)"
}
Write-Output "Test Case 4 Completed`n"