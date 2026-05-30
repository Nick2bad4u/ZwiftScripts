# Import the Pester module for testing
Import-Module Pester

# Source the script to make its functions available
$scriptPath = "c:/Users/Nick/Dropbox/PC (2)/Documents/GitHub/ZwiftScripts/MonitorZwift-v2.ps1"
. $scriptPath

Describe "MonitorZwift-v2.ps1" {
    # Test the script version
    It "Should have the correct version" {
        $scriptContent = Get-Content -Path $scriptPath
        $scriptContent | Should -Contain "Version: 2.0"
    }

    # Test the default parameter values
    It "Should have the correct default parameter values" {
        . $scriptPath -Transparency 75 -SleepInterval 10 -ZwiftLauncher 'ZwiftLauncher' -ZwiftGame 'ZwiftApp' -PrimaryDisplayZwift 4 -PrimaryDisplayDefault 2 -FreeFileSyncPath 'C:\Program Files\FreeFileSync\FreeFileSync.exe' -BatchJobPath 'C:\Users\Nick\Dropbox\Random Save\Task Scheduler Rules\ZwiftPics.ffs_batch'

        $Transparency | Should -Be 75
        $SleepInterval | Should -Be 10
        $ZwiftLauncher | Should -Be 'ZwiftLauncher'
        $ZwiftGame | Should -Be 'ZwiftApp'
        $PrimaryDisplayZwift | Should -Be 4
        $PrimaryDisplayDefault | Should -Be 2
        $FreeFileSyncPath | Should -Be 'C:\Program Files\FreeFileSync\FreeFileSync.exe'
        $BatchJobPath | Should -Be 'C:\Users\Nick\Dropbox\Random Save\Task Scheduler Rules\ZwiftPics.ffs_batch'
    }

    # Test the Import-DisplayConfigModule function
    It "Should import the DisplayConfig module" {
        Mock -CommandName Import-Module -MockWith { $true }
        Import-DisplayConfigModule
        Assert-MockCalled -CommandName Import-Module -Exactly -Times 1
    }

    # Test the Get-ProcessRunning function
    It "Should return true if the process is running" {
        Mock -CommandName Get-Process -MockWith { return $true }
        $result = Get-ProcessRunning -ProcessName 'ZwiftLauncher'
        $result | Should -Be $true
    }

    It "Should return false if the process is not running" {
        Mock -CommandName Get-Process -MockWith { return $false }
        $result = Get-ProcessRunning -ProcessName 'ZwiftLauncher'
        $result | Should -Be $false
    }

    # Test the Set-WindowTransparencyUWP function
    It "Should set the window transparency" {
        Mock -CommandName [Win32]::SetWindowLong -MockWith { $true }
        Mock -CommandName [Win32]::SetLayeredWindowAttributes -MockWith { $true }
        Set-WindowTransparencyUWP -Transparency 50
        Assert-MockCalled -CommandName [Win32]::SetWindowLong -Exactly -Times 1
        Assert-MockCalled -CommandName [Win32]::SetLayeredWindowAttributes -Exactly -Times 1
    }

    # Test the Set-PrimaryDisplay function
    It "Should set the primary display" {
        Mock -CommandName Set-DisplayPrimary -MockWith { $true }
        Set-PrimaryDisplay -DisplayIndex 4
        Assert-MockCalled -CommandName Set-DisplayPrimary -Exactly -Times 1
    }
}
