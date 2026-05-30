# Define paths for testing
$validMonitorZwiftScriptPath = 'C:\Users\Nick\Dropbox\Cycling\ZwiftScripts\MonitorZwift.ps1'
$validZwiftLauncherPath = 'C:\Program Files (x86)\Zwift\ZwiftLauncher.exe'
$invalidMonitorZwiftScriptPath = 'C:\InvalidPath\MonitorZwift.ps1'
$invalidZwiftLauncherPath = 'C:\InvalidPath\ZwiftLauncher.exe'

# Function to test the main script
function Test-MainScript {
    param (
        [string]$MonitorZwiftScriptPath,
        [string]$ZwiftLauncherPath
    )

    # Create a temporary script to test the main script
    $tempScript = @"
param (
    [string]`$MonitorZwiftScriptPath = '$MonitorZwiftScriptPath',
    [string]`$ZwiftLauncherPath = '$ZwiftLauncherPath'
)

# Resolve paths
try {
    `$MonitorZwiftScriptPath = Resolve-Path -LiteralPath `$MonitorZwiftScriptPath -ErrorAction Stop
    `$ZwiftLauncherPath = Resolve-Path -LiteralPath `$ZwiftLauncherPath -ErrorAction Stop
}
catch {
    Write-Error "Failed to resolve paths: `$(`$_.Exception.Message)"
    exit 1
}

# Start Zwift Launcher
if (Test-Path -LiteralPath `$ZwiftLauncherPath) {
    try {
        `$zwiftProcess = Start-Process -FilePath `$ZwiftLauncherPath -NoNewWindow -PassThru -ErrorAction Stop -Wait
        if (`$zwiftProcess) {
            Write-Output "Zwift Launcher started successfully from path: `$ZwiftLauncherPath"
        }
        else {
            Write-Error 'Zwift Launcher process did not start.'
        }
    }
    catch {
        Write-Error "Failed to start Zwift Launcher: `$(`$_.Exception.Message)"
    }
}
else {
    Write-Error "Zwift Launcher path not found: `$ZwiftLauncherPath"
}

# Start Zwift Monitor Script
if (Test-Path -LiteralPath `$MonitorZwiftScriptPath) {
    try {
        `$monitorProcess = Start-Process -FilePath "powershell.exe" -ArgumentList "-File `"`$MonitorZwiftScriptPath`"" -NoNewWindow -PassThru -ErrorAction Stop
        if (`$monitorProcess) {
            Write-Output "Zwift Monitor Script started successfully from path: `$MonitorZwiftScriptPath"
        }
        else {
            Write-Error 'Zwift Monitor Script process did not start.'
        }
    }
    catch {
        Write-Error "Failed to start Zwift Monitor Script: `$(`$_.Exception.Message)"
    }
}
else {
    Write-Error "Zwift Monitor Script path not found: `$MonitorZwiftScriptPath"
}
"@

    # Save the temporary script to a file
    $tempScriptPath = [System.IO.Path]::GetTempFileName() + ".ps1"
    Set-Content -Path $tempScriptPath -Value $tempScript

    # Execute the temporary script
    try {
        $output = & powershell.exe -File $tempScriptPath -ErrorAction Stop
        Write-Output $output
    }
    catch {
        Write-Error "Test failed: $($_.Exception.Message)"
    }
    finally {
        # Clean up the temporary script file
        Remove-Item -Path $tempScriptPath -Force
    }
}

# Test cases
Write-Output "Testing with valid paths..."
Test-MainScript -MonitorZwiftScriptPath $validMonitorZwiftScriptPath -ZwiftLauncherPath $validZwiftLauncherPath

Write-Output "Testing with invalid MonitorZwiftScriptPath..."
Test-MainScript -MonitorZwiftScriptPath $invalidMonitorZwiftScriptPath -ZwiftLauncherPath $validZwiftLauncherPath

Write-Output "Testing with invalid ZwiftLauncherPath..."
Test-MainScript -MonitorZwiftScriptPath $validMonitorZwiftScriptPath -ZwiftLauncherPath $invalidZwiftLauncherPath

Write-Output "Testing with both paths invalid..."
Test-MainScript -MonitorZwiftScriptPath $invalidMonitorZwiftScriptPath -ZwiftLauncherPath $invalidZwiftLauncherPath