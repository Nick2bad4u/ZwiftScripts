# TestLaunchZwift.ps1

# Test Case 1: Valid Paths
Write-Output "Running Test Case 1: Valid Paths"
.\LaunchZwift.ps1
Write-Output "Test Case 1 Completed`n"

# Test Case 2: Invalid Zwift Launcher Path
Write-Output "Running Test Case 2: Invalid Zwift Launcher Path"
.\LaunchZwift.ps1 -ZwiftLauncherPath 'C:\InvalidPath\ZwiftLauncher.exe'
Write-Output "Test Case 2 Completed`n"

# Test Case 3: Invalid Monitor Script Path
Write-Output "Running Test Case 3: Invalid Monitor Script Path"
.\LaunchZwift.ps1 -MonitorZwiftScriptPath 'C:\InvalidPath\MonitorZwift.ps1'
Write-Output "Test Case 3 Completed`n"

# Test Case 4: Zwift Launcher Fails to Start
Write-Output "Running Test Case 4: Zwift Launcher Fails to Start"
Rename-Item -Path 'C:\Program Files (x86)\Zwift\ZwiftLauncher.exe' -NewName 'ZwiftLauncher_temp.exe' -Force
.\LaunchZwift.ps1
Rename-Item -Path 'C:\Program Files (x86)\Zwift\ZwiftLauncher_temp.exe' -NewName 'ZwiftLauncher.exe' -Force
Write-Output "Test Case 4 Completed`n"

# Test Case 5: Monitor Script Fails to Start
Write-Output "Running Test Case 5: Monitor Script Fails to Start"
Rename-Item -Path 'C:\Users\Nick\Dropbox\Cycling\ZwiftScripts\MonitorZwift.ps1' -NewName 'MonitorZwift_temp.ps1' -Force
.\LaunchZwift.ps1
Rename-Item -Path 'C:\Users\Nick\Dropbox\Cycling\ZwiftScripts\MonitorZwift_temp.ps1' -NewName 'MonitorZwift.ps1' -Force
Write-Output "Test Case 5 Completed`n"

# Test Case 6: Path Resolution Failure
Write-Output "Running Test Case 6: Path Resolution Failure"
.\LaunchZwift.ps1 -MonitorZwiftScriptPath 'C:\InvalidPath\MonitorZwift.ps1' -ZwiftLauncherPath 'C:\InvalidPath\ZwiftLauncher.exe'
Write-Output "Test Case 6 Completed`n"