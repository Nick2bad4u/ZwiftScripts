<#PSScriptInfo

.VERSION 2.1.3
.GUID 4296fcf1-a13d-4d31-afdc-bcbd4e05506d

.AUTHOR Nick2bad4u

.COMPANYNAME Personal Project

.COPYRIGHT © 2025 Nick. All rights reserved.

.TAGS Zwift, Automation, PowerShell, OBS, FileSync, Display Management, Edge, Spotify, Sauce for Zwift

.LICENSEURI https://opensource.org/licenses/MIT

.PROJECTURI https://github.com/Nick2bad4u/ZwiftScripts

.ICONURI https://www.google.com/s2/favicons?sz=256&domain=zwift.com

.EXTERNALMODULEDEPENDENCIES DisplayConfig

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES
- PowerToys (Recommended): https://github.com/microsoft/PowerToys
  Required for managing workspaces during Zwift sessions. If not installed, workspace management features will be unavailable.
- FreeFileSync (Mandatory): https://freefilesync.org/
  Required for synchronizing Zwift-related files.
- OBS Studio (Optional): https://obsproject.com/
  Used for recording and streaming Zwift sessions.
- Sauce for Zwift (Optional): https://sauce.llc/
  Provides additional metrics and overlays for Zwift.
- Spotify (Optional): https://www.spotify.com/
  Used for managing music playback during Zwift sessions.
- Microsoft Edge (Mandatory): https://www.microsoft.com/edge
  Ensure Microsoft Edge is installed and accessible before running the script.
  Required for launching Zwift-related web pages in app mode.

.RELEASENOTES
- Initial release of MonitorZwift-v2.
- Automates Zwift session setup, monitoring, and teardown.
- Includes display management, OBS integration, file synchronization, and application handling.
- Added support for Microsoft Edge in app mode and Sauce for Zwift.

.PRIVATEDATA
# No private data included in this script.

#>

<#
.DESCRIPTION
### Main Script Function

This script performs the following tasks:

- **Window Management**:
	- Resizes and positions the PowerShell window.
	- Sets window transparency for the PowerShell window.
- **Path Resolution**:
	- Resolves paths for Zwift Launcher and Monitor Script.
- **Application Automation**:
	- Starts Zwift Launcher and monitors Zwift game processes.
	- Sets the primary display for Zwift and restores it after the session.
	- Launches PowerToys Workspaces for Zwift if required.
- **Zwift Game Monitoring**:
	- Waits for Zwift game to start, maximizes its window, and monitors until it closes.
- **Application Cleanup**:
	- Closes additional applications like Sauce for Zwift, OBS, and Spotify.
- **File Synchronization**:
	- Synchronizes Zwift-related files using FreeFileSync.
- **Browser Automation**:
	- Launches Microsoft Edge in app mode with specified URLs.
- **File Explorer Integration**:
	- Opens File Explorer for Zwift media and pictures directories.
- **Task Validation**:
	- Validates task completion and provides a review window before closing.

---

### Features

- **Display Management**:
	- Automatically sets the primary display for Zwift and restores it after the session.
- **Application Automation**:
	- Launches Zwift Launcher and monitors Zwift game processes.
	- Closes additional applications like Sauce for Zwift, OBS, and Spotify.
	- Launches PowerToys Workspaces for Zwift if required.
- **OBS Integration**:
	- Stops OBS recording using a configurable hotkey.
	- Closes OBS gracefully or forcefully if needed.
- **File Synchronization**:
	- Runs a FreeFileSync batch job to synchronize Zwift-related files after the session.
- **Browser Automation**:
	- Launches Microsoft Edge in app mode with specified URLs (e.g., YouTube Studio, Strava, Garmin Connect).
- **File Explorer Integration**:
	- Opens File Explorer for Zwift media and pictures directories.
- **Customizable Settings**:
	- Configurable display indices, window positions, and dimensions.
	- Adjustable transparency for the PowerShell window.
	- Customizable hotkeys for OBS recording and closing.
- **Task Validation**:
	- Tracks and validates the completion of all tasks, providing a summary at the end.
- **User-Friendly Animations**:
	- Includes waiting animations and countdown timers for a better user experience.

---

### Requirements

- **PowerShell**: Version 5.1 or later.
- **External Dependencies**:
	- DisplayConfig module (automatically installed if missing).
	- Applications like PowerToys, FreeFileSync, and OBS (optional but recommended).
- **Configuration**:
	- Ensure all paths and parameters are correctly configured before running the script.

---

### Examples

1. **Run with default settings**:
````powershell
	.\MonitorZwift-v2.ps1

2. **Run with custom Zwift Launcher path and display settings**:
	.\MonitorZwift-v2.ps1 -ZwiftLauncherPath "C:\Zwift\ZwiftLauncher.exe" -PrimaryDisplayZwift 2

3. **Run with custom window transparency and dimensions**:
	.\MonitorZwift-v2.ps1 -Transparency 50 -WindowWidth 400 -WindowHeight 800
	```
#>

<#
.SYNOPSIS
	A PowerShell script to automate the setup, monitoring, and teardown of a Zwift session, including managing displays, applications, and file synchronization.

.DESCRIPTION
	This script performs the following tasks:
	- Resizes and positions the PowerShell window.
	- Sets window transparency for the PowerShell window.
	- Resolves paths for Zwift Launcher and Monitor Script.
	- Starts Zwift Launcher and monitors Zwift game processes.
	- Sets the primary display for Zwift and restores it after the session.
	- Launches PowerToys Workspaces for Zwift if required.
	- Waits for Zwift game to start, maximizes its window, and monitors until it closes.
	- Closes additional applications like Sauce for Zwift, OBS, and Spotify.
	- Synchronizes Zwift-related files using FreeFileSync.
	- Launches Microsoft Edge in app mode with specified URLs.
	- Opens File Explorer for Zwift media and pictures directories.
	- Validates task completion and provides a review window before closing.

.PARAMETER ZwiftLauncherPath
	Path to the Zwift Launcher executable. Default: 'C:\Program Files (x86)\Zwift\ZwiftLauncher.exe'.

.PARAMETER MonitorZwiftScriptPath
	Path to the MonitorZwift script. Default: 'C:\Users\Nick\Dropbox\Cycling\ZwiftScripts\MonitorZwift-v2.ps1'.

.PARAMETER ZwiftLauncher
	Process name of the Zwift Launcher. Default: 'ZwiftLauncher'.

.PARAMETER ZwiftGame
	Process name of the Zwift game. Default: 'ZwiftApp'.

.PARAMETER ZwiftGameMaximizeDelay
	Delay in seconds before maximizing the Zwift game window. Default: 180.

.PARAMETER PrimaryDisplayZwift
	Zero-based index of the display to be used for Zwift. Default: 3.

.PARAMETER PrimaryDisplayDefault
	Zero-based index of the default primary display. Default: 1.

.PARAMETER TargetDisplayIndex
	Zero-based index of the target display for positioning the PowerShell window. Default: 1.

.PARAMETER WindowPositionX
	X-coordinate offset for the PowerShell window position. Default: 0.

.PARAMETER WindowPositionY
	Y-coordinate offset for the PowerShell window position. Default: 50.

.PARAMETER WindowWidth
	Width of the PowerShell window in pixels. Default: 300.

.PARAMETER WindowHeight
	Height of the PowerShell window in pixels. Default: 600.

.PARAMETER PowerToysPath
	Path to the PowerToys executable. Default: 'C:\Program Files\PowerToys\PowerToys.exe'.

.PARAMETER PowerToysAwakePath
	Path to the PowerToys Awake executable. Default: 'C:\Program Files\PowerToys\PowerToys.Awake.exe'.

.PARAMETER PowerToysWorkspacesPath
	Path to the PowerToys Workspaces executable. Default: 'C:\Program Files\PowerToys\PowerToys.WorkspacesLauncher.exe'.

.PARAMETER WorkspaceGuid
	GUID for the PowerToys Workspace for Zwift. Default: '{E2CDEA2A-6E33-4CFD-A26B-0C5CC2E55F40}'.

.PARAMETER FreeFileSyncPath
	Path to the FreeFileSync executable. Default: 'C:\Program Files\FreeFileSync\FreeFileSync.exe'.

.PARAMETER BatchJobPath
	Path to the FreeFileSync batch job file for synchronizing files. Default: 'C:\Users\Nick\Dropbox\Random Save\Task Scheduler Rules\ZwiftPics.ffs_batch'.

.PARAMETER BatchJobPath2
	Path to the second FreeFileSync batch job file for synchronizing recordings to NAS. Default: 'C:\Users\Nick\Dropbox\Random Save\Task Scheduler Rules\RecordingsToNas.ffs_batch'.

.PARAMETER ZwiftMediaPath
	Path to the Zwift media directory. Default: 'C:\Users\Nick\Dropbox\Cycling\ZwiftMedia'.

.PARAMETER ZwiftPicturesPath
	Path to the Zwift pictures directory. Default: 'C:\Users\Nick\Dropbox\PC (2)\Pictures\Zwift'.

.PARAMETER EdgePath
	Path to the Microsoft Edge executable. Default: 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe'.

.PARAMETER EdgeUrl1
	URL to open in Microsoft Edge (YouTube Studio). Default: YouTube Studio upload page.

.PARAMETER EdgeUrl2
	URL to open in Microsoft Edge (Strava). Default: Strava training page.

.PARAMETER EdgeUrl3
	URL to open in Microsoft Edge (Garmin Connect). Default: Garmin Connect home page.

.PARAMETER AppsToCheck
	List of additional applications to check and close when Zwift is detected. Default: @('Spotify', 'obs64', 'Sauce for Zwift').

.PARAMETER AnimationChars
	Characters used for the waiting animation. Default: @('|', '/', '-', '\', '|', '/', '-', '\').

.PARAMETER Transparency
	Transparency percentage for the PowerShell window (0-100). Default: 75.

.PARAMETER SleepInterval
	Interval in seconds for detecting Zwift processes. Default: 10.

.PARAMETER Colors
	List of colors for the waiting animation. Default: Various console colors.

.PARAMETER randomColor
	Random color selected for the waiting animation.

.PARAMETER AnimIndex
	Index for the waiting animation.

.PARAMETER ObsProcessName
	Process name of OBS. Default: 'obs64'.

.PARAMETER ObsRecordingHotkey
	Hotkey to stop recording in OBS. Default: '^{F11}' (Ctrl+F11).

.PARAMETER CloseObsHotkey
	Hotkey to close OBS gracefully. Default: '%{F4}' (Alt+F4).

.PARAMETER ZwiftLogPath
	Path to the Zwift log file. Default: 'C:\Users\Nick\AppData\Local\Zwift\logs\Log.txt'.

.PARAMETER ObsLogDir
	Path to the OBS log directory. Default: "$env:APPDATA\obs-studio\logs".

.PARAMETER obsPath
	Path to the OBS executable. Default: 'C:\Program Files\obs-studio\bin\64bit\obs64.exe'.

.PARAMETER ObsRecordingStartLogMessage
	Log message indicating OBS recording start. Default: '==== Recording Start'.

.PARAMETER tasksCompleted
	List of tasks to track completion status.

.PARAMETER remainingTimeinHours
	Remaining time in hours for the script to remain open for review. Default: 3.

.PARAMETER remainingTimeinMinutes
	Remaining time in minutes for the script to remain open for review. Default: 180.
	Must be manually uncommented if used.

.PARAMETER remainingTimeinSeconds
	Remaining time in seconds for the script to remain open for review. Default: 10800.
	Must be manually uncommented if used.

.PARAMETER remainingTime
	Remaining time in seconds for the script to remain open for review. Default: 10800.
	Must be manually uncommented if used.

.PARAMETER PowerToysAwakeTime
	Time in seconds for PowerToys Awake to keep the display awake. Default: 3600 seconds (1 hour).

.PARAMETER ExplorerPath
	Path to the File Explorer executable. Default: 'explorer.exe'.

.PARAMETER SpotifyProcessName
	Process name of Spotify. Default: 'Spotify'.

.PARAMETER SauceProcessName
	Process name of Sauce for Zwift. Default: 'Sauce for Zwift'.

.NOTES
	- Requires PowerShell 5.1 or later.
	- Some features depend on external modules like DisplayConfig and applications like PowerToys, FreeFileSync, and OBS.
	- Ensure all paths and parameters are correctly configured before running the script.

.EXAMPLE
	.\MonitorZwift-v2.ps1 -ZwiftLauncherPath "C:\Zwift\ZwiftLauncher.exe" -PrimaryDisplayZwift 2

	Runs the script with a custom Zwift Launcher path and sets display 2 as the primary display for Zwift.

.EXAMPLE
	.\MonitorZwift-v2.ps1 -Transparency 50 -WindowWidth 400 -WindowHeight 800

	Runs the script with 50% window transparency and custom window dimensions.

#>
[CmdletBinding()]
param (
	# Used in Step 1: Define helper functions and Win32 API for window management
	[string[]]$Colors = @('Black', 'DarkBlue', 'DarkGreen', 'DarkCyan', 'DarkRed', 'DarkMagenta', 'DarkYellow', 'Gray', 'DarkGray', 'Blue', 'Green', 'Cyan', 'Red', 'Magenta', 'Yellow', 'White'),
	[string]$randomColor = ($Colors | Get-Random),
	[int]$AnimIndex = 0,
	[string[]]$AnimationChars = @('|', '/', '-', '\', '|', '/', '-', '\'),

	# Used in Step 2: Resize and position the PowerShell window on the target display
	[ValidateRange(1, 10000)]
	[int]$TargetDisplayIndex = 1,
	[int]$WindowPositionX = 0,
	[int]$WindowPositionY = 50,
	[int]$WindowWidth = 300,
	[int]$WindowHeight = 600,

	# Used in Step 3: Import the DisplayConfig module for display management
	# (No params used directly here)

	# Used in Step 4: Set PowerShell window transparency
	[ValidateRange(0, 100)]
	[int]$Transparency = 75,

	# Used in Step 5: Resolve paths for Zwift Launcher and Monitor Script
	[string]$MonitorZwiftScriptPath = 'C:\Users\Nick\Dropbox\Cycling\ZwiftScripts\MonitorZwift-v2.ps1',
	[string]$ZwiftLauncherPath = 'C:\Program Files (x86)\Zwift\ZwiftLauncher.exe',

	# Used in Step 6: Start Zwift Launcher if Zwift is not already running
	[string]$ZwiftGame = 'ZwiftApp',
	[string]$ZwiftLauncher = 'ZwiftLauncher',

	# Used in Step 7: Wait for Zwift Launcher to start, then set Zwift display as primary
	[ValidateRange(0, 100)]
	[int]$PrimaryDisplayZwift = 3,

	# Used in Step 8: Optionally launch PowerToys Workspaces for Zwift
	[string[]]$AppsToCheck = @('Spotify', 'obs64', 'Sauce for Zwift'),
	[string]$PowerToysPath = 'C:\Program Files\PowerToys\PowerToys.exe',
	[string]$PowerToysWorkspacesPath = 'C:\Program Files\PowerToys\PowerToys.WorkspacesLauncher.exe',
	[string]$WorkspaceGuid = '{E2CDEA2A-6E33-4CFD-A26B-0C5CC2E55F40}',

	# Used in Step 9: Wait for Zwift game to start, then maximize its window
	[int]$ZwiftGameMaximizeDelay = 60,

	# Used in Step 10: Move OBS to Zwift monitor if running
	[string]$ObsProcessName = 'obs64',

	# Used in Step 10.5: Monitor Zwift log for 'GameFlowState Riding' and check OBS
	[string]$ZwiftLogPath = 'C:\Users\Nick\AppData\Local\Zwift\logs\Log.txt',
	[string]$ObsLogDir = "$env:APPDATA\obs-studio\logs",
	[string]$obsPath = 'C:\Program Files\obs-studio\bin\64bit\obs64.exe',
	[string]$ObsRecordingStartLogMessage = '==== Recording Start',
	[string]$ObsRecordingHotkey = '^{F11}',

	# Used in Step 11: Wait for Zwift game to close.

	# Used in Step 12: Ensure Sauce for Zwift is closed.
	[string]$SauceProcessName = 'Sauce for Zwift',

	# Used in Step 13: Restore primary display to default.
	[int]$PrimaryDisplayDefault = 1,

	# Used in Step 14: Stop and close OBS if running.
	[string]$CloseObsHotkey = '%{F4}',

	# Used in Step 15: Run FreeFileSync batch job to sync Zwift media and pictures
	[string]$FreeFileSyncPath = 'C:\Program Files\FreeFileSync\FreeFileSync.exe',
	[string]$BatchJobPath = 'C:\Users\Nick\Dropbox\Random Save\Task Scheduler Rules\ZwiftPics.ffs_batch',
	[string]$BatchJobPath2 = 'C:\Users\Nick\Dropbox\Random Save\Task Scheduler Rules\RecordingsToNas.ffs_batch',

	# Used in Step 16: Close Spotify if running
	[string]$SpotifyProcessName = 'Spotify',

	# Used in Step 17: Launch Microsoft Edge with specified URLs in app mode
	[string]$EdgePath = 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe',
	[string]$EdgeUrl1 = 'https://studio.youtube.com/channel/UCyYwMWui3Opy2yZyom2QM0g/videos/upload?filter=%5B%5D&sort=%7B%22columnType%22%3A%22date%22%2C%22sortOrder%22%3A%22DESCENDING%22%7D',
	[string]$EdgeUrl2 = 'https://www.strava.com/athlete/training',
	[string]$EdgeUrl3 = 'https://connect.garmin.com/modern/home',

	# Used in Step 18: Open File Explorer for Zwift media and pictures directories
	[string]$ZwiftMediaPath = 'C:\Users\Nick\Dropbox\Cycling\ZwiftMedia',
	[string]$ZwiftPicturesPath = 'C:\Users\Nick\Dropbox\PC (2)\Pictures\Zwift',
	[string]$ExplorerPath = 'explorer.exe',

	# Used in Step 19: Show task completion summary
	# (No params used directly here)

	# Used in Step 20: Set PowerToys Awake if available
	[string]$PowerToysAwakePath = 'C:\Program Files\PowerToys\PowerToys.Awake.exe',
	[int]$remainingTimeinHours = 3,
	[int]$PowerToysAwakeTime = $remainingTimeinHours * 3600,
	# [int]$remainingTimeinMinutes = 180, # Uncomment if needed
	# [int]$remainingTimeinSeconds = 10800, # Uncomment if needed
	# [int]$remainingTime = 10800, # Uncomment if needed

	# Used in Step 21: Show task completion summary and allow review/countdown before exit
	# (No params used directly here)

	# Used throughout
	# Poll interval (seconds) used by process-wait loops.
	# Default set to 1 to preserve current effective behavior (previously hard-coded 1s waits).
	[int]$SleepInterval = 1
)

# =============================
# Script initialization (derived from parameters)
# =============================

# ScriptAnalyzer: these parameters were previously only "implicitly" relied on via $script: vars.
# Make the relationship explicit and ensure script-scoped state is initialized.
$script:randomColor = $randomColor
$script:animIndex = $AnimIndex
$script:AnimationChars = $AnimationChars

# =============================
# Step 1: Define helper functions and Win32 API for window management.
# =============================

# Check if the 'Win32' type is already defined
if (-not ([System.Management.Automation.PSTypeName]'Win32').Type) {
	$win32Code = @'
	using System;
	using System.Runtime.InteropServices;
	public class Win32 {
		[DllImport("user32.dll", SetLastError = true)]
		public static extern IntPtr GetForegroundWindow();

		[DllImport("user32.dll", SetLastError = true)]
		public static extern int GetWindowLong(IntPtr hWnd, int nIndex);

		[DllImport("user32.dll")]
		public static extern int SetWindowLong(IntPtr hWnd, int nIndex, int dwNewLong);

		[DllImport("user32.dll", SetLastError = true)]
		[return: MarshalAs(UnmanagedType.Bool)]
		public static extern bool SetLayeredWindowAttributes(IntPtr hwnd, uint crKey, byte bAlpha, uint dwFlags);

		[DllImport("user32.dll", SetLastError = true)]
		public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);

		[DllImport("user32.dll", SetLastError = true)]
		public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

		public const int GWL_EXSTYLE = -20;
		public const int WS_EX_LAYERED = 0x80000;
		public const int LWA_ALPHA = 0x2;
		public const uint SWP_NOSIZE = 0x0001;
		public const uint SWP_NOMOVE = 0x0002;
		public const uint SWP_NOZORDER = 0x0004;
		public const uint SWP_SHOWWINDOW = 0x0040;
		public const int SW_MAXIMIZE = 3;
	}
'@
	Add-Type -TypeDefinition $win32Code
}

# Host-safe console output helper (color + NoNewline) to replace Write-Host.
# Keeps interactive behavior but avoids PSAvoidUsingWriteHost.
function Write-Console {
	[CmdletBinding()]
	param(
		[Parameter(Position = 0, ValueFromRemainingArguments = $true)]
		[object[]]$Object,
		[ConsoleColor]$ForegroundColor,
		[ConsoleColor]$BackgroundColor,
		[switch]$NoNewline,
		[string]$Separator = ' '
	)

	# Match Write-Host behavior: join all objects with separator, write to host (not pipeline)
	$text = ($Object | ForEach-Object { if ($null -eq $_) { '' } else { $_.ToString() } }) -join $Separator

	try {
		if ($Host -and $Host.UI) {
			$fgSpecified = $PSBoundParameters.ContainsKey('ForegroundColor')
			$bgSpecified = $PSBoundParameters.ContainsKey('BackgroundColor')

			if ($fgSpecified -or $bgSpecified) {
				$fg = if ($fgSpecified) { $ForegroundColor } else { $Host.UI.RawUI.ForegroundColor }
				$bg = if ($bgSpecified) { $BackgroundColor } else { $Host.UI.RawUI.BackgroundColor }

				if ($NoNewline) { $Host.UI.Write($fg, $bg, $text) }
				else { $Host.UI.WriteLine($fg, $bg, $text) }
			}
			else {
				if ($NoNewline) { $Host.UI.Write($text) }
				else { $Host.UI.WriteLine($text) }
			}
			return
		}
	}
	catch {
		# Fall through to non-host fallback
		Write-Verbose "Write-Console host write failed: $($_.Exception.Message)"
	}

	# Fallback: write to the success output stream (may be captured/redirected; no color).
	# NOTE: Write-Output does not support -NoNewline; in non-host scenarios we accept the newline.
	Write-Output $text
}

function Test-LogPatternMatch {
	[CmdletBinding()]
	param(
		[AllowNull()] [string[]]$Lines,
		[Parameter(Mandatory)] [string[]]$Patterns
	)

	if (-not $Lines) { return $false }

	foreach ($pattern in $Patterns) {
		if ($Lines -match $pattern) {
			return $true
		}
	}

	return $false
}

function Test-ManualOverrideKeyPressed {
	[CmdletBinding()]
	param(
		[System.ConsoleKey]$OverrideKey = [System.ConsoleKey]::F8,
		[string]$Description = 'the current wait'
	)

	try {
		while ([Console]::KeyAvailable) {
			$keyInfo = [Console]::ReadKey($true)
			if ($keyInfo.Key -eq $OverrideKey) {
				Write-Console "$(Get-Date): Manual override key '$OverrideKey' pressed while waiting for $Description. Continuing." -ForegroundColor Yellow
				return $true
			}
		}
	}
	catch {
		Write-Verbose "Manual override key check failed: $($_.Exception.Message)"
	}

	return $false
}

function Wait-ForLogPatterns {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)] [string]$LiteralPath,
		[Parameter(Mandatory)] [string[]]$Patterns,
		[int]$PollSeconds = 1,
		[int]$InitialTailLines = 2000,
		[string]$MatchDescription = 'log pattern',
		[System.ConsoleKey]$ManualOverrideKey = [System.ConsoleKey]::F8
	)

	if (-not (Test-Path -LiteralPath $LiteralPath)) {
		return $false
	}

	if ($InitialTailLines -gt 0) {
		try {
			$recentLines = Get-Content -LiteralPath $LiteralPath -Tail $InitialTailLines -ErrorAction Stop
			if (Test-LogPatternMatch -Lines $recentLines -Patterns $Patterns) {
				Write-Console "$(Get-Date): Detected $MatchDescription in recent Zwift log lines." -ForegroundColor Green
				return $true
			}
		}
		catch {
			Write-Verbose "Initial log scan failed: $($_.Exception.Message)"
		}
	}

	$logStream = $null
	$reader = $null

	try {
		$logStream = [System.IO.File]::Open($LiteralPath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite)
		$reader = New-Object System.IO.StreamReader($logStream)
		$null = $reader.BaseStream.Seek(0, [System.IO.SeekOrigin]::End)

		while ($true) {
			if (Test-ManualOverrideKeyPressed -OverrideKey $ManualOverrideKey -Description $MatchDescription) {
				return $true
			}

			Start-Sleep -Seconds ([Math]::Max(1, $PollSeconds))
			while ($null -ne ($line = $reader.ReadLine())) {
				foreach ($pattern in $Patterns) {
					if ($line -match $pattern) {
						Write-Console "$(Get-Date): Detected $MatchDescription in Zwift log!" -ForegroundColor Green
						return $true
					}
				}
			}
		}
	}
	finally {
		if ($null -ne $reader) { $reader.Close() }
		elseif ($null -ne $logStream) { $logStream.Close() }
	}
}

function Get-LatestObsLogFile {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)] [string]$ObsLogDirectory
	)

	if (-not (Test-Path -LiteralPath $ObsLogDirectory)) {
		return $null
	}

	return Get-ChildItem -Path $ObsLogDirectory -Filter '*.txt' -ErrorAction SilentlyContinue |
		Sort-Object LastWriteTime -Descending |
		Select-Object -First 1
}

function Test-ObsRecordingStartedInLog {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)] [string]$ObsLogDirectory,
		[Parameter(Mandatory)] [string]$RecordingStartMessage
	)

	$latestLog = Get-LatestObsLogFile -ObsLogDirectory $ObsLogDirectory
	if (-not $latestLog) {
		return $false
	}

	try {
		$logContent = Get-Content -LiteralPath $latestLog.FullName -Raw -ErrorAction Stop
		return ($logContent -match [regex]::Escape($RecordingStartMessage) -or $logContent -match 'Recording started' -or $logContent -match 'Start recording')
	}
	catch {
		Write-Verbose "Failed reading OBS log '$($latestLog.FullName)': $($_.Exception.Message)"
		return $false
	}
}

function Start-ObsRecordingWithHotkeyRetry {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)] [string]$ObsProcessName,
		[Parameter(Mandatory)] [string]$ObsRecordingHotkey,
		[Parameter(Mandatory)] [string]$ObsLogDirectory,
		[Parameter(Mandatory)] [string]$RecordingStartMessage,
		[int]$MaxAttempts = 3,
		[int]$ActivationRetries = 5,
		[int]$FocusSettleMilliseconds = 1500,
		[int]$ConfirmTimeoutSeconds = 10
	)

	$wshell = New-Object -ComObject WScript.Shell

	for ($attempt = 1; $attempt -le $MaxAttempts; $attempt++) {
		if (Test-ObsRecordingStartedInLog -ObsLogDirectory $ObsLogDirectory -RecordingStartMessage $RecordingStartMessage) {
			Write-Console "$(Get-Date): OBS recording already active before retry attempt $attempt." -ForegroundColor Green
			return $true
		}

		$obsProc = Get-Process -Name $ObsProcessName -ErrorAction SilentlyContinue | Select-Object -First 1
		if (-not $obsProc) {
			Write-Console "$(Get-Date): OBS process not found for recording attempt $attempt of $MaxAttempts." -ForegroundColor Red
			return $false
		}

		$activated = $false
		for ($retry = 1; $retry -le $ActivationRetries -and -not $activated; $retry++) {
			$obsProc = Get-Process -Id $obsProc.Id -ErrorAction SilentlyContinue
			if ($obsProc -and $obsProc.MainWindowHandle -ne 0) {
				$activated = Set-WindowFocus $obsProc
				if ($activated) {
					try { [void]$wshell.AppActivate($obsProc.Id) } catch { Write-Verbose "OBS AppActivate failed: $($_.Exception.Message)" }
					Start-Sleep -Milliseconds $FocusSettleMilliseconds
				}
				else {
					Write-Console "[$(Get-Date -Format o)] OBS activation retry $retry of $ActivationRetries failed for attempt $attempt." -ForegroundColor Yellow
					Start-Sleep -Seconds 1
				}
			}
			else {
				Write-Console "[$(Get-Date -Format o)] OBS MainWindowHandle not ready for attempt $attempt. Waiting..." -ForegroundColor Yellow
				Start-Sleep -Seconds 1
			}
		}

		if (-not $activated) {
			Write-Console "[$(Get-Date -Format o)] Could not activate OBS window for attempt $attempt of $MaxAttempts." -ForegroundColor Yellow
		}

		Write-Console "$(Get-Date): Sending OBS recording hotkey (attempt $attempt of $MaxAttempts)..." -ForegroundColor Cyan
		$wshell.SendKeys($ObsRecordingHotkey)

		$deadline = (Get-Date).AddSeconds($ConfirmTimeoutSeconds)
		while ((Get-Date) -lt $deadline) {
			if (Test-ObsRecordingStartedInLog -ObsLogDirectory $ObsLogDirectory -RecordingStartMessage $RecordingStartMessage) {
				Write-Console "$(Get-Date): OBS recording confirmed in log after attempt $attempt." -ForegroundColor Green
				$obsProc = Get-Process -Name $ObsProcessName -ErrorAction SilentlyContinue | Select-Object -First 1
				if ($obsProc -and $obsProc.MainWindowHandle -ne 0) {
					if (-not ([System.Management.Automation.PSTypeName]'Win32Activate').Type) {
						$win32 = @'
using System;
using System.Runtime.InteropServices;
public class Win32Activate {
	[DllImport("user32.dll")]
	public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
}
'@
						Add-Type -TypeDefinition $win32 -ErrorAction SilentlyContinue
					}
					[Win32Activate]::ShowWindowAsync($obsProc.MainWindowHandle, 6) | Out-Null
				}
				return $true
			}

			Start-Sleep -Seconds 1
		}

		Write-Console "$(Get-Date): OBS recording was not confirmed after attempt $attempt. Retrying..." -ForegroundColor Yellow
	}

	return $false
}

# Win32 API helper for robust window activation (works for OBS and others)
function Set-WindowFocus {
	[CmdletBinding(SupportsShouldProcess = $true)]
	param([System.Diagnostics.Process]$proc)
	if (-not $proc) { return $false }
	$hWnd = $proc.MainWindowHandle
	if ($hWnd -eq 0) {
		Write-Console "[$(Get-Date -Format o)] Process has no MainWindowHandle." -ForegroundColor Yellow
		return $false
	}
	if (-not $PSCmdlet.ShouldProcess($proc.ProcessName, 'Set window focus (foreground)')) {
		return $false
	}
	# If minimized, restore window (SW_RESTORE = 9)
	$win32 = @'
using System;
using System.Runtime.InteropServices;
public class Win32Activate {
    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);
    [DllImport("user32.dll")]
    public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
    [DllImport("user32.dll")]
    public static extern bool IsIconic(IntPtr hWnd);
}
'@
	if (-not ([System.Management.Automation.PSTypeName]'Win32Activate').Type) {
		Add-Type -TypeDefinition $win32 -ErrorAction SilentlyContinue
	}
	if ([Win32Activate]::IsIconic($hWnd)) {
		[Win32Activate]::ShowWindowAsync($hWnd, 9) | Out-Null
		Start-Sleep -Milliseconds 500
	}
	$result = [Win32Activate]::SetForegroundWindow($hWnd)
	if ($result) {
		Write-Console "[$(Get-Date -Format o)] Window activated using Win32 API."
	}
	else {
		Write-Console "[$(Get-Date -Format o)] Failed to activate window using Win32 API." -ForegroundColor Yellow
	}
	return $result
}

# Variables for the current PowerShell window and process
$hwnd = [Win32]::GetForegroundWindow()
$process = Get-Process -Id ([System.Diagnostics.Process]::GetCurrentProcess().Id)
$processName = $process.ProcessName.ToLower()
$allowedProcesses = @('powershell', 'pwsh', 'windowsterminal', 'wt')
$style = [Win32]::GetWindowLong($hwnd, [Win32]::GWL_EXSTYLE)

# Ensure the transparency is applied only to the current PowerShell window or Windows Terminal

# Initialize a hashtable to track completed tasks
$taskTracker = @{
	CompletedTasks = @()
}

# Function to add a completed task
<#+
.SYNOPSIS
		Adds a completed task to the tracker.
.DESCRIPTION
		This function adds a task name to the list of completed tasks in the tracker.
.PARAMETER Tracker
		The hashtable tracking completed tasks.
.PARAMETER TaskName
		The name of the task to add to the completed tasks list.
.EXAMPLE
		Add-CompletedTask -Tracker $taskTracker -TaskName "Task 1"
		Adds "Task 1" to the completed tasks list in the task tracker.
#>
function Add-CompletedTask {
	param (
		[hashtable]$Tracker,
		[string]$TaskName
	)
	$Tracker.CompletedTasks += $TaskName
}

# Function to check if a task is completed
<#+
.SYNOPSIS
	Checks if a task is completed.
.DESCRIPTION
	This function checks if a task name is present in the list of completed tasks in the tracker.
.PARAMETER Tracker
		The hashtable tracking completed tasks.
.PARAMETER TaskName
		The name of the task to check for completion.
.EXAMPLE
		Test-TaskCompletion -Tracker $taskTracker -TaskName "Task 1"
		Returns $true if "Task 1" is in the completed tasks list, otherwise $false.
#>
function Test-TaskCompletion {
	param (
		[hashtable]$Tracker,
		[string]$TaskName
	)
	return $TaskName -in $Tracker.CompletedTasks
}

# Function to get the list of completed tasks
<#+
.SYNOPSIS
	Returns the list of completed tasks.
.DESCRIPTION
	This function retrieves the list of completed tasks from the tracker.
.PARAMETER Tracker
		The hashtable tracking completed tasks.
.EXAMPLE
		Get-CompletedTasks -Tracker $taskTracker
		Returns the list of completed tasks from the task tracker.
#>
function Get-CompletedTask {
	param (
		[hashtable]$Tracker
	)
	return $Tracker.CompletedTasks
}

# Function: Show-WaitingAnimation
<#+
.SYNOPSIS
    Displays a waiting animation with a message.
.DESCRIPTION
    This function shows a rotating animation (e.g., '|', '/', '-', '\') alongside a custom message.
.PARAMETER Message
    The message to display alongside the animation.
.PARAMETER Continue
    A boolean indicating whether to continue the animation.
.EXAMPLE
    Show-WaitingAnimation -Message "Loading..." -Continue $true
#>
# Function to display a waiting animation with a message
function Show-WaitingAnimation {
	param (
		[string]$Message,
		[bool]$Continue = $true,
		[string[]]$AnimationChars = $script:AnimationChars
	)
	if (-not $Continue) { return }
	$script:animIndex = ($script:animIndex + 1) % $AnimationChars.Length
	Write-Console "`r$Message $($AnimationChars[$script:animIndex])" -NoNewline -ForegroundColor $script:randomColor
}

# Function: Wait-WithAnimation
<#+
.SYNOPSIS
    Waits for a specified duration while displaying an animation.
.DESCRIPTION
    This function waits for a given number of seconds and displays a rotating animation with a custom message.
.PARAMETER Seconds
    The number of seconds to wait.
.PARAMETER Message
    The message to display alongside the animation.
.EXAMPLE
    Wait-WithAnimation -Seconds 5 -Message "Processing..."
#>
# Function to wait with an animation and a message
function Wait-WithAnimation {
	param (
		[int]$Seconds,
		[string]$Message
	)
	$endTime = (Get-Date).AddSeconds($Seconds)
	while ((Get-Date) -lt $endTime) {
		Show-WaitingAnimation -Message $Message -Continue $true -AnimationChars $AnimationChars
		Start-Sleep -Milliseconds 200
	}
}

# Function: Import-DisplayConfigModule
<#+
.SYNOPSIS
    Imports the DisplayConfig module or installs it if not available.
.DESCRIPTION
    This function checks for the availability of the DisplayConfig module, installs it if missing, and imports it.
.EXAMPLE
    Import-DisplayConfigModule
#>
# Function to Import the DisplayConfig module or install it if not available (requires PowerShellGet) and handle exceptions
function Import-DisplayConfigModule {
	try {
		if (-not (Get-Module -ListAvailable -Name DisplayConfig)) {
			Write-Console "$(Get-Date): DisplayConfig module not found. Downloading..." -ForegroundColor Yellow
			Install-Module -Name DisplayConfig -Force -AllowClobber -Scope CurrentUser -ErrorAction Stop
			Write-Console "$(Get-Date): Module downloaded and installed successfully." -ForegroundColor Green
		}
	}
	catch {
		Write-Error "$(Get-Date): Failed to download and install module: $($_.Exception.Message). Continuing without it."
	}

	try {
		Import-Module DisplayConfig -ErrorAction Stop
		Write-Console "$(Get-Date): Successfully imported DisplayConfig module." -ForegroundColor Green
	}
	catch {
		Write-Error "$(Get-Date): Failed to import DisplayConfig module: $($_.Exception.Message). Continuing without it."
	}
}

# Function: Get-ProcessRunning
<#+
.SYNOPSIS
    Checks if a process is running by name.
.DESCRIPTION
    This function checks if a process with the specified name is currently running.
.PARAMETER ProcessName
    The name of the process to check.
.EXAMPLE
    Get-ProcessRunning -ProcessName "notepad"
#>
# Function to check if a process is running by name (case-insensitive) and handle exceptions
function Get-ProcessRunning {
	param ([string]$ProcessName)
	try {
		return $null -ne (Get-Process -Name $ProcessName -ErrorAction SilentlyContinue)
	}
	catch {
		Write-Error "$(Get-Date): Error checking process ${ProcessName}: $($_.Exception.Message)"
		return $false
	}
}

# Function: Set-WindowTransparencyUWP
<#+
.SYNOPSIS
    Sets the transparency of the current PowerShell or Windows Terminal window.
.DESCRIPTION
    This function adjusts the transparency of the current window using the Win32 API.
.PARAMETER Transparency
    The transparency percentage (0-100) to apply to the window.
.EXAMPLE
    Set-WindowTransparencyUWP -Transparency 50
#>
# Function to set window transparency using UWP API
function Set-WindowTransparencyUWP {
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[int]$Transparency # Set at the beginning of the script
	)
	try {
		if (-not $PSCmdlet.ShouldProcess('Current window', "Set transparency to $Transparency%")) {
			return
		}
		if ($allowedProcesses -contains $processName) {
			Write-Console "$(Get-Date): Trying to set window transparency to $Transparency%..." -ForegroundColor Cyan
			$null = [Win32]::SetWindowLong($hwnd, [Win32]::GWL_EXSTYLE, $style -bor [Win32]::WS_EX_LAYERED)
			# Ensure transparency value of 0 sets the window to fully opaque
			$opacity = if ($Transparency -eq 0) { 255 } else { [byte]((100 - $Transparency) * 255 / 100) }
			$null = [Win32]::SetLayeredWindowAttributes($hwnd, 0, $opacity, [Win32]::LWA_ALPHA)
			Write-Console "$(Get-Date): Successfully set window transparency to $Transparency%" -ForegroundColor Green
		}
		else {
			Write-Console "$(Get-Date): The foreground window is not a PowerShell or Windows Terminal window. Transparency not applied." -ForegroundColor Yellow
		}
	}
	catch {
		Write-Error "$(Get-Date): Failed to set window transparency: $($_.Exception.Message)"
	}
}

# Function: Set-PrimaryDisplay
<#+
.SYNOPSIS
    Sets the primary display to the specified index.
.DESCRIPTION
    This function uses the DisplayConfig module to set the primary display to the given index.
.PARAMETER DisplayIndex
    The zero-based index of the display to set as primary.
.EXAMPLE
    Set-PrimaryDisplay -DisplayIndex 2
#>
# Function to set the primary display using the DisplayConfig module and handle exceptions
function Set-PrimaryDisplay {
	[CmdletBinding(SupportsShouldProcess = $true)]
	param ([int]$DisplayIndex)
	try {
		if (-not $PSCmdlet.ShouldProcess("DisplayIndex=$DisplayIndex", 'Set primary display')) {
			return
		}
		Set-DisplayPrimary $DisplayIndex
		Write-Console "$(Get-Date): Primary display set to $DisplayIndex" -ForegroundColor Green
	}
	catch {
		Write-Error "$(Get-Date): Failed to set primary display to ${DisplayIndex}: $($_.Exception.Message)"
	}
}

# Function: Show-TaskCompletionSummary
<#+
.SYNOPSIS
Displays a summary of task completion status.

.DESCRIPTION
The Show-TaskCompletionSummary function outputs a summary of completed tasks in the order they were completed. It also highlights any tasks in the provided tasksCompleted list that were not completed.

.PARAMETER Tracker
A hashtable containing task tracking information, including a list of completed tasks.

.PARAMETER tasksCompleted
An additional collection of tasks to check for completion.

.EXAMPLE
Show-TaskCompletionSummary -Tracker $myTracker -tasksCompleted $recentlyCompleted

.NOTES
This function assumes the existence of a Get-CompletedTasks function that retrieves completed tasks from the provided tracker.
#>
function Show-TaskCompletionSummary {
	param (
		[hashtable]$Tracker,
		$tasksCompleted
	)
	try {
		# Only use the order in which tasks were completed
		$completedOrdered = $Tracker.CompletedTasks
		Write-Console "$(Get-Date): Task Completion Summary (in order completed):" -ForegroundColor Cyan
		foreach ($task in $completedOrdered) {
			Write-Console "- ${task}: Completed" -ForegroundColor Green
		}
		# Optionally, show any tasks in $tasksCompleted that were not completed (if needed)
		if ($tasksCompleted) {
			foreach ($task in $tasksCompleted) {
				if ($task -notin $completedOrdered) {
					Write-Console "- ${task}: Not Completed" -ForegroundColor Red
				}
			}
		}
	}
	catch {
		Write-Error "$(Get-Date): Error during task validation: $($_.Exception.Message)"
	}
}

# Function: Get-RemainingTime
<#
.SYNOPSIS
Calculates the remaining time in seconds based on provided hours, minutes, or seconds.

.DESCRIPTION
The Get-RemainingTime function returns the remaining time in seconds. It accepts one of three parameters: hours, minutes, or seconds. The function prioritizes hours over minutes, and minutes over seconds. If none of the parameters are provided, it writes an error message and exits the script.

.PARAMETER remainingTimeinHours
The number of remaining hours to be converted to seconds.

.PARAMETER remainingTimeinMinutes
The number of remaining minutes to be converted to seconds.

.PARAMETER remainingTimeinSeconds
The number of remaining seconds.

.EXAMPLE
Get-RemainingTime -remainingTimeinMinutes 15
# Returns 900

.EXAMPLE
Get-RemainingTime -remainingTimeinHours 1
# Returns 3600

.NOTES
Only one parameter should be provided at a time. If multiple parameters are provided, hours take precedence over minutes, and minutes over seconds.
#>
function Get-RemainingTime {
	param (
		$remainingTimeinHours,
		$remainingTimeinMinutes,
		$remainingTimeinSeconds
	)
	try {
		if ($null -ne $remainingTimeinHours) {
			return $remainingTimeinHours * 3600
		}
		elseif ($null -ne $remainingTimeinMinutes) {
			return $remainingTimeinMinutes * 60
		}
		elseif ($null -ne $remainingTimeinSeconds) {
			return $remainingTimeinSeconds
		}
		else {
			Write-Console "$(Get-Date): No valid remaining time parameter provided. Exiting script." -ForegroundColor Red
			exit
		}
	}
	catch {
		Write-Error "$(Get-Date): Error calculating remaining time: $($_.Exception.Message)"
		exit
	}
}

# Function: Invoke-ReviewCountdownAndCleanup
<#
.SYNOPSIS
Displays a countdown timer for script review and performs cleanup actions after script execution.

.DESCRIPTION
The Invoke-ReviewCountdownAndCleanup function provides a post-execution review period by displaying a countdown timer in the console. The user can exit the review early by pressing any key. Once the countdown completes or a key is pressed, the function attempts to stop the PowerToys Awake process if it is running, ensuring proper cleanup. Informative messages are displayed throughout the process, and errors are handled gracefully.

.PARAMETER remainingTime
The number of seconds to keep the script window open for review after execution completes.

.EXAMPLE
Invoke-ReviewCountdownAndCleanup -remainingTime 60
# Keeps the script window open for 60 seconds, allowing the user to review output or exit early by pressing a key.

.NOTES
This function is intended to be called at the end of a script to allow users time to review output and ensure that PowerToys Awake is stopped if it was started during script execution.
#>
function Invoke-ReviewCountdownAndCleanup {
	param (
		[int]$remainingTime
	)
	try {
		Write-Console "$(Get-Date): Script execution completed. The window will remain open for review for $([TimeSpan]::FromSeconds($remainingTime).ToString('hh\:mm\:ss'))." -ForegroundColor Yellow
		$originalRemainingTime = $remainingTime
		$exitEarly = $false
		while ($remainingTime -gt 0) {
			try {
				if ([Console]::KeyAvailable) {
					Write-Console "`n$(Get-Date): Key press detected. Exiting script, window will remain open." -ForegroundColor Yellow
					$exitEarly = $true
					break
				}
				$formattedTime = [TimeSpan]::FromSeconds($remainingTime).ToString('hh\:mm\:ss')
				Wait-WithAnimation -Seconds 1 -Message "Time remaining: $formattedTime"
				$remainingTime--
			}
			catch {
				Write-Error "$(Get-Date): Error during countdown timer: $($_.Exception.Message)"
				break
			}
		}

		# --- Always attempt to stop PowerToys Awake, regardless of exitEarly ---
		try {
			if (Get-Process -Name 'PowerToys.Awake' -ErrorAction SilentlyContinue) {
				Write-Console "$(Get-Date): PowerToys Awake is running. Stopping it now..." -ForegroundColor Cyan
				Get-Process -Name 'PowerToys.Awake' -ErrorAction SilentlyContinue | Stop-Process -Force
				Write-Console "$(Get-Date): PowerToys Awake stopped successfully." -ForegroundColor Green
			}
			else {
				Write-Console "$(Get-Date): PowerToys Awake is not running. No action needed." -ForegroundColor Yellow
			}
		}
		catch {
			Write-Error "$(Get-Date): Error stopping PowerToys Awake: $($_.Exception.Message)"
		}

		if ($exitEarly) {
			Write-Console "$(Get-Date): Exiting review early due to key press. Window will remain open." -ForegroundColor Yellow
			return
		}
		else {
			Write-Console "`n$(Get-Date): Script review time over. $([TimeSpan]::FromSeconds($originalRemainingTime).ToString('hh\:mm\:ss')) has passed since the script ended." -ForegroundColor Yellow
			Write-Console "$(Get-Date): Closing the script now." -ForegroundColor Yellow
		}
	}
	catch {
		Write-Error "$(Get-Date): Error during script review countdown: $($_.Exception.Message)"
	}
}

# =============================
# Step 2: Resize and position the PowerShell window on the target display.
# =============================

# Resize the PowerShell window using Win32 API functions
# This code snippet uses the Win32 class defined earlier to resize the
# current PowerShell window. It retrieves the handle of the current
# foreground window using the GetForegroundWindow function, and then
# uses the SetWindowPos function to set the window position and size.
# The window position (X, Y) and size (width, height) are specified in
# pixels. The script also uses the SWP_NOZORDER and SWP_SHOWWINDOW flags
# to ensure that the window is resized without changing its z-order and
# is shown after resizing.
try {
	# Load the System.Windows.Forms assembly
	Add-Type -AssemblyName System.Windows.Forms

	# Resize the PowerShell window
	$hwnd = [Win32]::GetForegroundWindow()

	# Validate display index
	if ($TargetDisplayIndex -lt 1 -or $TargetDisplayIndex -gt [System.Windows.Forms.Screen]::AllScreens.Count) {
		Write-Console "Invalid TargetDisplayIndex: $TargetDisplayIndex. Defaulting to 1." -ForegroundColor Yellow
		$TargetDisplayIndex = 1
	}

	# Get the screen coordinates of the target display
	$displayIndex = $TargetDisplayIndex - 1 # Subtract 1 to make it zero-based
	$displays = [System.Windows.Forms.Screen]::AllScreens
	if ($displayIndex -lt $displays.Count) {
		$targetDisplay = $displays[$displayIndex]
		$x = $targetDisplay.WorkingArea.X
		$y = $targetDisplay.WorkingArea.Y

		# Set the window position to the target display
		[Win32]::SetWindowPos($hwnd, [IntPtr]::Zero, $x + $WindowPositionX, $y + $WindowPositionY, $WindowWidth, $WindowHeight, [Win32]::SWP_NOZORDER -bor [Win32]::SWP_SHOWWINDOW)
		Write-Console "$(Get-Date): Successfully resized and positioned the PowerShell window on display $TargetDisplayIndex." -ForegroundColor Green
		Add-CompletedTask -Tracker $taskTracker -TaskName 'Resized and positioned PowerShell window'
	}
	else {
		Write-Console "$(Get-Date): Target display not found. Resizing in current display." -ForegroundColor Yellow
		[Win32]::SetWindowPos($hwnd, [IntPtr]::Zero, $WindowPositionX, $WindowPositionY, $WindowWidth, $WindowHeight, [Win32]::SWP_NOZORDER -bor [Win32]::SWP_SHOWWINDOW)
	}
}
catch {
	Write-Error "$(Get-Date): Error resizing or positioning the PowerShell window: $($_.Exception.Message)"
}

# =============================
# Step 3: Import the DisplayConfig module for display management.
# =============================

try {
	Write-Console "$(Get-Date): Attempting to import DisplayConfig module..." -ForegroundColor Cyan
	Import-DisplayConfigModule
	Add-CompletedTask -Tracker $taskTracker -TaskName 'Imported DisplayConfig module'
}
catch {
	Write-Error "$(Get-Date): Error importing DisplayConfig module: $($_.Exception.Message)"
}

# =============================
# Step 4: Set PowerShell window transparency.
# =============================

# Set PowerShell window transparency to the specified value (default: 25)
try {
	Set-WindowTransparencyUWP -Transparency $Transparency
	Add-CompletedTask -Tracker $taskTracker -TaskName 'Set Window Transparency'
}
catch {
	Write-Error "$(Get-Date): Error setting window transparency: $($_.Exception.Message)"
}

# =============================
# Step 5: Resolve paths for Zwift Launcher and Monitor Script.
# =============================

try {
	$MonitorZwiftScriptPath = Resolve-Path -LiteralPath $MonitorZwiftScriptPath -ErrorAction Stop
	$ZwiftLauncherPath = Resolve-Path -LiteralPath $ZwiftLauncherPath -ErrorAction Stop
	Add-CompletedTask -Tracker $taskTracker -TaskName 'Zwift Launcher path resolved'
}
catch {
	Write-Error "Failed to resolve paths: $($_.Exception.Message)"
	exit 1
}

# =============================
# Step 6: Start Zwift Launcher if Zwift is not already running.
# =============================

# Check if Zwift is already running
$ZwiftAppRunning = $null -ne (Get-Process -Name $ZwiftGame -ErrorAction SilentlyContinue)

if ($ZwiftAppRunning) {
	Write-Output 'ZwiftApp.exe is already running. Skipping ZwiftLauncher.exe start.'
	Add-CompletedTask -Tracker $taskTracker -TaskName 'ZwiftApp already running or Zwift Launcher started'
}
else {
	# Start Zwift Launcher
	if (Test-Path -LiteralPath $ZwiftLauncherPath) {
		try {
			$ZwiftProcess = Start-Process -FilePath $ZwiftLauncherPath -NoNewWindow -PassThru -ErrorAction Stop
			if ($ZwiftProcess) {
				Write-Output "Zwift Launcher started successfully from path: $ZwiftLauncherPath"
				Add-CompletedTask -Tracker $taskTracker -TaskName 'ZwiftApp already running or Zwift Launcher started'
			}
			else {
				Write-Error 'Zwift Launcher process did not start.'
			}
		}
		catch {
			Write-Error "Failed to start Zwift Launcher: $($_.Exception.Message)"
		}
	}
	else {
		Write-Error "Zwift Launcher path not found: $ZwiftLauncherPath"
	}
}

# =============================
# Step 7: Wait for Zwift Launcher to start, then set Zwift display as primary.
# =============================

try {
	Write-Console "$(Get-Date): Waiting for Zwift launcher to start..." -ForegroundColor Cyan
	while (-not (Get-ProcessRunning -ProcessName $ZwiftLauncher)) {
		Wait-WithAnimation -Seconds $SleepInterval -Message "Waiting for $ZwiftLauncher"
	}

	# Validate display index
	if ($PrimaryDisplayZwift -lt 0 -or $PrimaryDisplayZwift -ge [System.Windows.Forms.Screen]::AllScreens.Count) {
		Write-Console "Invalid PrimaryDisplayZwift index: $PrimaryDisplayZwift. Defaulting to 1." -ForegroundColor Yellow
		$PrimaryDisplayZwift = 1
	}
	Write-Console "$(Get-Date): Zwift launcher detected. Switching primary display to $($PrimaryDisplayZwift + 1)" -ForegroundColor Green
	Set-PrimaryDisplay ($PrimaryDisplayZwift + 1) # + 1 to make it one-based index for the DisplayConfig module (index: 4)
	Add-CompletedTask -Tracker $taskTracker -TaskName 'Zwift launcher running'
	Add-CompletedTask -Tracker $taskTracker -TaskName 'Primary display set for Zwift'
}
catch {
	Write-Error "$(Get-Date): Error while waiting for Zwift launcher to start or switching primary display: $($_.Exception.Message)"
}

# =============================
# Step 8: Optionally launch PowerToys Workspaces for Zwift.
# =============================

# Launch the PowerToys Workspaces for Zwift (if installed) after the Zwift launcher starts
try {
	# Check if all of the specified applications are running
	Write-Console "$(Get-Date): Checking if all specified applications are running..." -ForegroundColor Cyan
	$allAppsRunning = $true
	foreach ($app in $AppsToCheck) {
		try {
			if (-not (Get-Process -Name $app -ErrorAction SilentlyContinue)) {
				$allAppsRunning = $false
				break
			}
		}
		catch {
			Write-Error "$(Get-Date): Error checking process ${app}: $($_.Exception.Message)"
			$allAppsRunning = $false
			break
		}
	}

	if (-not $allAppsRunning) {
		try {
			# If the Workspaces launcher path is wrong/missing, try to derive it from PowerToys.exe
			if (-not (Test-Path -LiteralPath $PowerToysWorkspacesPath) -and (Test-Path -LiteralPath $PowerToysPath)) {
				$ptDir = Split-Path -Parent $PowerToysPath
				$candidate = Join-Path $ptDir 'PowerToys.WorkspacesLauncher.exe'
				if (Test-Path -LiteralPath $candidate) {
					$PowerToysWorkspacesPath = $candidate
				}
			}
			Write-Console "$(Get-Date): Launching Zwift PowerToys Workspaces..." -ForegroundColor Cyan
			Start-Process -FilePath $PowerToysWorkspacesPath -ArgumentList "$WorkspaceGuid 1"
			Write-Console "$(Get-Date): Zwift PowerToys Workspaces launched successfully." -ForegroundColor Green
			Add-CompletedTask -Tracker $taskTracker -TaskName 'PowerToys Workspaces launched or skipped'
		}
		catch {
			Write-Error "$(Get-Date): Error launching PowerToys Workspaces: $($_.Exception.Message)"
		}
	}
	else {
		Write-Console "$(Get-Date): All specified applications are running. Skipping PowerToys Workspaces launch." -ForegroundColor Yellow
	}
}
catch {
	Write-Error "$(Get-Date): Error in checking or launching applications: $($_.Exception.Message)"
}

# =============================
# Step 9: Wait for Zwift game to start, then maximize its window.
# =============================

try {
	Write-Console "$(Get-Date): Waiting for Zwift game to start..." -ForegroundColor Cyan
	while (-not (Get-ProcessRunning -ProcessName $ZwiftGame)) {
		Wait-WithAnimation -Seconds $SleepInterval -Message "Waiting for $ZwiftGame"
	}
	Write-Console "$(Get-Date): Zwift game detected." -ForegroundColor Green
	Add-CompletedTask -Tracker $taskTracker -TaskName 'Zwift game started'
}
catch {
	Write-Error "$(Get-Date): Error while waiting for or detecting Zwift game: $($_.Exception.Message)"
}

# Wait for a specified amount of time before maximizing the Zwift game window
try {
	Write-Console "$(Get-Date): Waiting for $ZwiftGameMaximizeDelay seconds before maximizing the Zwift game window..." -ForegroundColor Cyan

	# Countdown animation
	for ($i = $ZwiftGameMaximizeDelay; $i -gt 0; $i--) {
		Write-Console "`rWaiting: $i seconds remaining..." -NoNewline -ForegroundColor Yellow
		Start-Sleep -Seconds 1
	}
	Write-Console "`rCountdown complete. Proceeding..." -ForegroundColor Green

	$ZwiftProcess = Get-Process -Name $ZwiftGame -ErrorAction SilentlyContinue
	if ($ZwiftProcess) {
		# Get the main window handle of the Zwift game process
		$ZwiftHwnd = $ZwiftProcess.MainWindowHandle
		Write-Console "Zwift MainWindowHandle: $ZwiftHwnd"
		# If the handle is valid, maximize the window
		if ($ZwiftHwnd -ne [IntPtr]::Zero) {
			[Win32]::ShowWindow($ZwiftHwnd, [Win32]::SW_MAXIMIZE)
			Write-Console "$(Get-Date): Zwift game window maximized successfully." -ForegroundColor Green
			Add-CompletedTask -Tracker $taskTracker -TaskName 'Zwift game window maximized'
		}
		else {
			Write-Console "$(Get-Date): Zwift game window handle not found. Unable to maximize." -ForegroundColor Yellow
		}
	}
	else {
		Write-Console "$(Get-Date): Zwift game process not found. Unable to maximize window." -ForegroundColor Yellow
	}
}
catch {
	Write-Error "$(Get-Date): Error maximizing Zwift game window: $($_.Exception.Message)"
}

# =============================
# Step 10: Move OBS to Zwift monitor if running.
# =============================

# Move OBS to the Zwift monitor, center it, and resize to 80% of the monitor's width and height
try {
	Write-Console "$(Get-Date): Attempting to move OBS to the Zwift monitor, center it, and resize to 80% of the monitor's dimensions..." -ForegroundColor Cyan
	$ObsProcess = Get-Process -Name $ObsProcessName -ErrorAction SilentlyContinue
	if ($ObsProcess) {
		$ObsHwnd = $ObsProcess.MainWindowHandle
		if ($ObsHwnd -ne [IntPtr]::Zero) {
			# Get the screen coordinates of the Zwift display
			Add-Type -AssemblyName System.Windows.Forms
			# Validate display index
			if ($PrimaryDisplayZwift -lt 0 -or $PrimaryDisplayZwift -ge [System.Windows.Forms.Screen]::AllScreens.Count) {
				Write-Console "Invalid PrimaryDisplayZwift index: $PrimaryDisplayZwift. Defaulting to 1." -ForegroundColor Yellow
				$PrimaryDisplayZwift = 1
			}
			# Get the display index for Zwift (1-based index)
			$ZwiftDisplayIndex = $PrimaryDisplayZwift - 1
			$Displays = [System.Windows.Forms.Screen]::AllScreens
			if ($ZwiftDisplayIndex -lt $Displays.Count) {
				$ZwiftDisplay = $Displays[$ZwiftDisplayIndex]
				$X = $ZwiftDisplay.WorkingArea.X
				$Y = $ZwiftDisplay.WorkingArea.Y
				$Width = $ZwiftDisplay.WorkingArea.Width
				$Height = $ZwiftDisplay.WorkingArea.Height

				# Calculate 80% of the display size for OBS window
				$ObsWidth = [int]($Width * 0.8)
				$ObsHeight = [int]($Height * 0.8)
				# Center the OBS window on the display
				$ObsX = $X + [int](($Width - $ObsWidth) / 2)
				$ObsY = $Y + [int](($Height - $ObsHeight) / 2)

				# Move and resize OBS to be centered and 80% of the Zwift display
				[Win32]::SetWindowPos($ObsHwnd, [IntPtr]::Zero, $ObsX, $ObsY, $ObsWidth, $ObsHeight, [Win32]::SWP_SHOWWINDOW)
				[Win32]::ShowWindow($ObsHwnd, 5) # SW_SHOW
				Write-Console "$(Get-Date): OBS moved to Zwift monitor, centered, and resized to 80% of the display." -ForegroundColor Green
				Add-CompletedTask -Tracker $taskTracker -TaskName 'OBS moved to Zwift monitor and centered/resized'
			}
			else {
				Write-Console "$(Get-Date): Zwift display index $ZwiftDisplayIndex not found. Skipping OBS move." -ForegroundColor Yellow
			}
		}
		else {
			Write-Console "$(Get-Date): OBS window handle not found. Skipping OBS move." -ForegroundColor Yellow
		}
	}
	else {
		Write-Console "$(Get-Date): OBS is not running. Skipping OBS move." -ForegroundColor Yellow
	}
}
catch {
	Write-Error "$(Get-Date): Error moving OBS to Zwift monitor: $($_.Exception.Message)"
}

# =============================
# Step 10.4: Focus Spotify and start playing music if running.
# =============================

try {
	Write-Console "$(Get-Date): Checking for Spotify before starting OBS recording..." -ForegroundColor Cyan
	$SpotifyProcess = Get-Process -Name $SpotifyProcessName -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowHandle -ne 0 } | Select-Object -First 1
	if ($SpotifyProcess) {
		Write-Console "$(Get-Date): Spotify is running. Focusing window and sending Play hotkey (Spacebar)..." -ForegroundColor Green
		try {
			Set-WindowFocus $SpotifyProcess | Out-Null
			Start-Sleep -Milliseconds 500
			$wshell = New-Object -ComObject WScript.Shell
			$wshell.SendKeys(' ')
			Write-Console "$(Get-Date): Sent Play hotkey (Spacebar) to Spotify." -ForegroundColor Green
			Add-CompletedTask -Tracker $taskTracker -TaskName 'Spotify play hotkey sent'
		}
		catch {
			Write-Error "$(Get-Date): Error activating Spotify window or sending play hotkey: $($_.Exception.Message)"
		}
	}
	else {
		Write-Console "$(Get-Date): Spotify is not running. Skipping play hotkey." -ForegroundColor Yellow
	}
}
catch {
	Write-Error "$(Get-Date): Error checking for Spotify or sending play hotkey: $($_.Exception.Message)"
}

# =============================
# Step 10.5: Monitor Zwift log for 'GameFlowState Riding' and check OBS
# =============================

$GameFlowRidingDetected = $false

if (Test-Path -Path $ZwiftLogPath) {
	Write-Console "$(Get-Date): Monitoring Zwift log for ride-start markers... Press F8 to continue manually." -ForegroundColor Cyan
	$rideStartPatterns = @(
		'\[ZWATCHDOG\]: GameFlowState Riding',
		'INFO LEVEL: \[GameState\] Starting Ride\.',
		'INFO LEVEL: \[GameState\] ZSF_INITIAL_CHALLENGE_SELECT -> ZSF_RIDE'
	)
	$GameFlowRidingDetected = Wait-ForLogPatterns -LiteralPath $ZwiftLogPath -Patterns $rideStartPatterns -PollSeconds 1 -InitialTailLines 2000 -MatchDescription 'a ride-start marker'

	# Check if OBS is running
	$obsProcess = Get-Process -Name $ObsProcessName -ErrorAction SilentlyContinue
	if (-not $obsProcess) {
		Write-Console "$(Get-Date): OBS is NOT running!" -ForegroundColor Red
		$obsPromptTimeout = 15 # seconds
		$obsPromptStart = Get-Date
		$userInput = $null
		while ($null -eq $userInput -and ((Get-Date) - $obsPromptStart).TotalSeconds -lt $obsPromptTimeout) {
			if ([Console]::KeyAvailable) {
				$userInput = Read-Host 'Would you like to start OBS now? (Y/N)'
			}
			else {
				Start-Sleep -Milliseconds 500
			}
		}
		if ($null -eq $userInput) {
			Write-Console "No input received after $obsPromptTimeout seconds. Defaulting to 'N'." -ForegroundColor Yellow
			$userInput = 'N'
		}
		if ($userInput -match '^(Y|y)') {
			if (Test-Path -Path $obsPath) {
				Start-Process -FilePath $obsPath
				Write-Console "$(Get-Date): OBS started." -ForegroundColor Green
				# Wait for OBS to start
				Start-Sleep -Seconds 3
				$obsProcess = Get-Process -Name $ObsProcessName -ErrorAction SilentlyContinue
				Add-CompletedTask -Tracker $taskTracker -TaskName 'OBS started after user prompt'
			}
			else {
				Write-Console "$(Get-Date): OBS executable not found at $obsPath. Please start OBS manually." -ForegroundColor Yellow
			}
		}
		else {
			Write-Console "$(Get-Date): OBS will not be started automatically. Remember to start it if you want to record!" -ForegroundColor Yellow
		}
	}
	else {
		Write-Console "$(Get-Date): OBS is already running." -ForegroundColor Green
	}

	# After checking/starting OBS, check if recording has started in the latest OBS log
	if ((Test-Path $ObsLogDir) -and (Get-ChildItem -Path $ObsLogDir -Filter '*.txt' -ErrorAction SilentlyContinue)) {
		$latestLog = Get-LatestObsLogFile -ObsLogDirectory $ObsLogDir
		if ($latestLog) {
			if (Test-ObsRecordingStartedInLog -ObsLogDirectory $ObsLogDir -RecordingStartMessage $ObsRecordingStartLogMessage) {
				# Ensure OBS window is active before sending the hotkey
				if ($obsProc -and $obsProc.MainWindowTitle) {
					$retryCount = 0
					$maxRetries = 3
					while (-not $obsProc -and $retryCount -lt $maxRetries) {
						Write-Console "$(Get-Date): OBS process not found. Retrying in 5 seconds... (Attempt $($retryCount + 1) of $maxRetries)" -ForegroundColor Yellow
						Start-Sleep -Seconds 5
						$obsProc = Get-Process -Name $ObsProcessName -ErrorAction SilentlyContinue
						$retryCount++
					}

					if ($obsProc) {
						Set-WindowFocus $obsProc | Out-Null
					}
					else {
						Write-Console "$(Get-Date): OBS process could not be found after $maxRetries attempts. Please start OBS manually." -ForegroundColor Red
					}
					Start-Sleep -Milliseconds 500
				}
				Write-Console "$(Get-Date): OBS recording already started (detected in log)." -ForegroundColor Green
				Add-CompletedTask -Tracker $taskTracker -TaskName 'OBS recording already started, detected in log'
			}
			else {
				Write-Console "$(Get-Date): OBS recording not detected in log. Attempting to start recording with retries..." -ForegroundColor Yellow
				$recordingStarted = Start-ObsRecordingWithHotkeyRetry -ObsProcessName $ObsProcessName -ObsRecordingHotkey $ObsRecordingHotkey -ObsLogDirectory $ObsLogDir -RecordingStartMessage $ObsRecordingStartLogMessage -MaxAttempts 3 -ActivationRetries 5 -FocusSettleMilliseconds 1500 -ConfirmTimeoutSeconds 10
				if ($recordingStarted) {
					Add-CompletedTask -Tracker $taskTracker -TaskName 'OBS recording started'
					Start-Sleep -Seconds 2
				}
				else {
					Write-Console "$(Get-Date): OBS recording could not be confirmed after multiple attempts. Please focus OBS and start recording manually if needed." -ForegroundColor Red
				}
			}
		}
		else {
			Write-Console "$(Get-Date): No OBS log files found to check recording status." -ForegroundColor Yellow
		}
	}
	else {
		Write-Console "$(Get-Date): OBS log directory not found: $ObsLogDir" -ForegroundColor Yellow
	}
}
else {
	Write-Console "$(Get-Date): Zwift log file not found at $ZwiftLogPath. Skipping log monitoring for ride start." -ForegroundColor Yellow
}

# =============================
# Step 11: Wait for Zwift game to close.
# =============================

try {
	Write-Console "$(Get-Date): Zwift game is running. Waiting for it to close..." -ForegroundColor Cyan
	while (Get-ProcessRunning -ProcessName $ZwiftGame) {
		Wait-WithAnimation -Seconds $SleepInterval -Message "Waiting for $ZwiftGame"
	}
	Write-Console "$(Get-Date): Zwift game closed." -ForegroundColor Green
	Add-CompletedTask -Tracker $taskTracker -TaskName 'Zwift game closed'
}
catch {
	Write-Error "$(Get-Date): Error monitoring Zwift game: $($_.Exception.Message)"
}

# =============================
# Step 12: Ensure Sauce for Zwift is closed.
# =============================

try {
	Write-Console "$(Get-Date): Checking for Sauce for Zwift process..." -ForegroundColor Cyan
	$SauceProcess = Get-Process -Name $SauceProcessName -ErrorAction SilentlyContinue

	if ($SauceProcess) {
		Write-Console "$(Get-Date): Sauce for Zwift is running. Closing it..." -ForegroundColor Yellow
		$SauceProcess | Stop-Process -Force
		Write-Console "$(Get-Date): Sauce for Zwift closed successfully." -ForegroundColor Green
		Add-CompletedTask -Tracker $taskTracker -TaskName 'Sauce for Zwift closed or skipped'
	}
	else {
		Write-Console "$(Get-Date): Sauce for Zwift is not running. Skipping..." -ForegroundColor Yellow
		Add-CompletedTask -Tracker $taskTracker -TaskName 'Sauce for Zwift closed or skipped'
	}
}
catch {
	Write-Error "$(Get-Date): Error closing Sauce for Zwift: $($_.Exception.Message)"
}

# =============================
# Step 13: Restore primary display to default.
# =============================

try {
	# Validate display index
	if ($PrimaryDisplayDefault -lt 0 -or $PrimaryDisplayDefault -ge [System.Windows.Forms.Screen]::AllScreens.Count) {
		Write-Console "Invalid PrimaryDisplayDefault index: $PrimaryDisplayDefault. Defaulting to 1." -ForegroundColor Yellow
		$PrimaryDisplayDefault = 1
	}
	Write-Console "$(Get-Date): Restoring primary display to $($PrimaryDisplayDefault + 1)..." -ForegroundColor Cyan
	Set-PrimaryDisplay ($PrimaryDisplayDefault + 1) # + 1 to make it one-based index for the DisplayConfig module (index: 2)
	Write-Console "$(Get-Date): Primary display restored to $($PrimaryDisplayDefault + 1)." -ForegroundColor Green
	Add-CompletedTask -Tracker $taskTracker -TaskName 'Primary display restored'
}
catch {
	Write-Error "$(Get-Date): Error restoring primary display: $($_.Exception.Message)"
}

# =============================
# Step 14: Stop and close OBS if running.
# =============================

try {
	Write-Console "$(Get-Date): Checking for OBS..." -ForegroundColor Cyan
	$ObsProcess = Get-Process -Name $ObsProcessName -ErrorAction SilentlyContinue

	if ($ObsProcess) {
		Write-Console "$(Get-Date): OBS is running. Stopping recording and closing OBS..." -ForegroundColor Yellow

		try {
			# Send hotkey to stop recording
			$wshell = New-Object -ComObject WScript.Shell
			$ObsProcess | ForEach-Object {
				try {
					Set-WindowFocus $_ | Out-Null
					Start-Sleep -Milliseconds 500
					$wshell.SendKeys($ObsRecordingHotkey) # Send hotkey to stop recording
				}
				catch {
					Write-Error "$(Get-Date): Error activating OBS window or sending stop recording hotkey: $($_.Exception.Message)"
				}
			}
			Write-Console "$(Get-Date): Sent stop recording command to OBS" -ForegroundColor Green

			# Wait for '==== Recording Stop' in the latest OBS log (mirror start check)
			$ObsRecordingStopLogMessage = '==== Recording Stop'
			$stopTimeout = 15 # seconds
			$stopDetected = $false
			$stopStartTime = Get-Date
			if ((Test-Path $ObsLogDir) -and (Get-ChildItem -Path $ObsLogDir -Filter '*.txt' -ErrorAction SilentlyContinue)) {
				$latestLog = Get-ChildItem -Path $ObsLogDir -Filter '*.txt' | Sort-Object LastWriteTime -Descending | Select-Object -First 1
				if ($latestLog) {
					while (-not $stopDetected -and ((Get-Date) - $stopStartTime).TotalSeconds -lt $stopTimeout) {
						$logContent = Get-Content $latestLog.FullName -Raw
						if ($logContent -match [regex]::Escape($ObsRecordingStopLogMessage) -or $logContent -match 'Recording stopped' -or $logContent -match 'Stop recording') {
							$stopDetected = $true
							Write-Console "$(Get-Date): OBS recording stop detected in log." -ForegroundColor Green
							Add-CompletedTask -Tracker $taskTracker -TaskName 'OBS recording stopped, detected in log'
							break
						}
						Start-Sleep -Seconds 1
					}
					if (-not $stopDetected) {
						Write-Console "$(Get-Date): OBS recording stop NOT detected in log after $stopTimeout seconds. Proceeding anyway." -ForegroundColor Yellow
					}
				}
				else {
					Write-Console "$(Get-Date): No OBS log files found to check recording stop status." -ForegroundColor Yellow
				}
			}
			else {
				Write-Console "$(Get-Date): OBS log directory not found: $ObsLogDir" -ForegroundColor Yellow
			}
		}
		catch {
			Write-Error "$(Get-Date): Error initializing WScript.Shell or sending stop recording command: $($_.Exception.Message)"
		}

		try {
			# Give OBS time to save the recording
			Write-Console "$(Get-Date): Waiting for recording to save..." -ForegroundColor Cyan
			Wait-WithAnimation -Seconds 5 -Message 'Saving recording...'
		}
		catch {
			Write-Error "$(Get-Date): Error while waiting for recording to save: $($_.Exception.Message)"
		}

		try {
			# Close OBS gracefully with hotkey instead of force-killing it
			$ObsProcess | ForEach-Object {
				try {
					Set-WindowFocus $_ | Out-Null
					Start-Sleep -Milliseconds 500
					# Send the hotkey to close OBS
					$wshell.SendKeys($CloseObsHotkey)
					Write-Console "$(Get-Date): Sent close hotkey to OBS window: $($_.MainWindowTitle)" -ForegroundColor Green
					Add-CompletedTask -Tracker $taskTracker -TaskName 'OBS recording stopped'

				}
				catch {
					Write-Error "$(Get-Date): Error focusing OBS window or sending close hotkey: $($_.Exception.Message)"
				}
			}
		}
		catch {
			Write-Error "$(Get-Date): Error initializing WScript.Shell or sending close command to OBS: $($_.Exception.Message)"
		}

		try {
			# Wait for OBS to close naturally (up to 10 seconds)
			$timeout = 10
			Write-Console "$(Get-Date): Waiting for OBS to close..." -ForegroundColor Cyan
			Wait-WithAnimation -Seconds $timeout -Message 'Waiting for OBS to close'

			if (Get-Process -Name $ObsProcessName -ErrorAction SilentlyContinue) {
				Write-Console "$(Get-Date): OBS didn't close after $timeout seconds, closing forcefully" -ForegroundColor Yellow
				try {
					Get-Process -Name $ObsProcessName -ErrorAction SilentlyContinue | Stop-Process
				}
				catch {
					Write-Error "$(Get-Date): Error forcefully closing OBS: $($_.Exception.Message)"
				}
			}
			else {
				Write-Console "$(Get-Date): OBS closed successfully" -ForegroundColor Green
				Add-CompletedTask -Tracker $taskTracker -TaskName 'OBS closed'
			}
		}
		catch {
			Write-Error "$(Get-Date): Error while waiting for OBS to close: $($_.Exception.Message)"
		}
	}
	else {
		Write-Console "$(Get-Date): OBS is not running" -ForegroundColor Yellow
	}
}
catch {
	Write-Error "$(Get-Date): Error stopping OBS recording or closing OBS: $($_.Exception.Message)"
}

# =============================
# Step 14.5: Stop Spotify music and close Spotify after recording ends.
# =============================

try {
	Write-Console "$(Get-Date): Attempting to stop Spotify music and close Spotify after recording..." -ForegroundColor Cyan
	$SpotifyProcess = Get-Process -Name $SpotifyProcessName -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowHandle -ne 0 } | Select-Object -First 1
	if ($SpotifyProcess) {
		try {
			Set-WindowFocus $SpotifyProcess | Out-Null
			Start-Sleep -Milliseconds 500
			$wshell = New-Object -ComObject WScript.Shell
			$wshell.SendKeys(' ')
			Write-Console "$(Get-Date): Sent Pause hotkey (Spacebar) to Spotify." -ForegroundColor Green
		}
		catch {
			Write-Error "$(Get-Date): Error activating Spotify window or sending pause hotkey: $($_.Exception.Message)"
		}
		try {
			$SpotifyProcess | Stop-Process -Force
			Write-Console "$(Get-Date): Spotify closed successfully after recording." -ForegroundColor Green
			Add-CompletedTask -Tracker $taskTracker -TaskName 'Spotify stopped and closed after recording'
		}
		catch {
			Write-Error "$(Get-Date): Error closing Spotify after recording: $($_.Exception.Message)"
		}
	}
	else {
		Write-Console "$(Get-Date): Spotify is not running after recording. No action needed." -ForegroundColor Yellow
	}
}
catch {
	Write-Error "$(Get-Date): Error in stopping or closing Spotify after recording: $($_.Exception.Message)"
}

# =============================
# Step 15: Run FreeFileSync batch job to sync files.
# =============================

# Run FreeFileSync batch job after Zwift game closes and display is restored to default display (index: 2)
# This ensures that any files (screenshots) modified during the Zwift session are synchronized with the backup location.
try {
	Write-Console "$(Get-Date): Running FreeFileSync batch job..." -ForegroundColor Cyan
	Start-Process -FilePath $FreeFileSyncPath -ArgumentList "`"$BatchJobPath`""
	Write-Console "$(Get-Date): FreeFileSync batch job started (not waiting for completion)." -ForegroundColor Green
	Add-CompletedTask -Tracker $taskTracker -TaskName 'FreeFileSync batch job started'

	# Run the second batch job for recordings to NAS
	Write-Console "$(Get-Date): Running second FreeFileSync batch job (RecordingsToNas)..." -ForegroundColor Cyan
	Start-Process -FilePath $FreeFileSyncPath -ArgumentList "`"$BatchJobPath2`""
	Write-Console "$(Get-Date): Second FreeFileSync batch job started (not waiting for completion)." -ForegroundColor Green
	Add-CompletedTask -Tracker $taskTracker -TaskName 'FreeFileSync batch job 2 started'
}
catch {
	Write-Error "$(Get-Date): Error running FreeFileSync batch job(s): $($_.Exception.Message)"
}



# =============================
# Step 16: Close Spotify if running.
# =============================

try {
	Write-Console "$(Get-Date): Checking for Spotify..." -ForegroundColor Cyan
	$SpotifyProcess = Get-Process -Name $SpotifyProcessName -ErrorAction SilentlyContinue

	if ($SpotifyProcess) {
		Write-Console "$(Get-Date): Spotify is running. Closing Spotify..." -ForegroundColor Yellow
		$SpotifyProcess | Stop-Process -Force
		Write-Console "$(Get-Date): Spotify closed successfully." -ForegroundColor Green
		Add-CompletedTask -Tracker $taskTracker -TaskName 'Spotify closed'
	}
	else {
		Write-Console "$(Get-Date): Spotify is not running." -ForegroundColor Yellow
	}
}
catch {
	Write-Error "$(Get-Date): Error closing Spotify: $($_.Exception.Message)"
}

# =============================
# Step 17: Launch Microsoft Edge with specified URLs in app mode.
# =============================

# Check if Microsoft Edge is installed
if (Test-Path -Path $EdgePath) {
	try {
		Write-Console "$(Get-Date): Microsoft Edge found. Launching in app mode with the specified URLs..." -ForegroundColor Cyan
		Start-Process -FilePath "$EdgePath" -ArgumentList @("$EdgeUrl1", "$EdgeUrl2", "$EdgeUrl3")
		Write-Console "$(Get-Date): Microsoft Edge launched successfully with the specified URLs." -ForegroundColor Green
		Add-CompletedTask -Tracker $taskTracker -TaskName 'Microsoft Edge launched'
	}
	catch {
		Write-Error "$(Get-Date): Error launching Microsoft Edge: $($_.Exception.Message)"
	}
}
else {
	Write-Console "$(Get-Date): Microsoft Edge not found at $EdgePath. Skipping launch." -ForegroundColor Yellow
	Add-CompletedTask -Tracker $taskTracker -TaskName 'Microsoft Edge skipped'
}

# =============================
# Step 18: Open File Explorer for Zwift media and pictures directories.
# =============================

try {
	Write-Console "$(Get-Date): Opening File Explorer with specified directories..." -ForegroundColor Cyan
	if (Test-Path -Path $ZwiftMediaPath) {
		Start-Process -FilePath $ExplorerPath -ArgumentList "`"$ZwiftMediaPath`""
		Add-CompletedTask -Tracker $taskTracker -TaskName 'Opened File Explorer for ZwiftMediaPath'
	}
	else {
		Write-Console "$(Get-Date): Path $ZwiftMediaPath does not exist. Skipping opening File Explorer for this path." -ForegroundColor Yellow
	}

	if (Test-Path -Path $ZwiftPicturesPath) {
		Start-Process -FilePath $ExplorerPath -ArgumentList "`"$ZwiftPicturesPath`""
		Add-CompletedTask -Tracker $taskTracker -TaskName 'Opened File Explorer for ZwiftPicturesPath'
	}
	else {
		Write-Console "$(Get-Date): Path $ZwiftPicturesPath does not exist. Skipping the opening of File Explorer for this path." -ForegroundColor Yellow
	}

	$openedPaths = @()
	if (Test-Path -Path $ZwiftMediaPath) {
		$openedPaths += $ZwiftMediaPath
	}
	if (Test-Path -Path $ZwiftPicturesPath) {
		$openedPaths += $ZwiftPicturesPath
	}
	if ($openedPaths.Count -gt 0) {
		Write-Console "$(Get-Date): File Explorer opened successfully with the following directories: $($openedPaths -join ', ')." -ForegroundColor Green
	}
	else {
		Write-Console "$(Get-Date): No directories were opened as none of the specified paths exist." -ForegroundColor Yellow
	}
}
catch {
	Write-Error "$(Get-Date): Error opening File Explorer: $($_.Exception.Message)"
}

# =============================
# Step 19: Reset PowerShell window transparency to opaque.
# =============================

try {
	Set-WindowTransparencyUWP -Transparency 0
	Write-Console "$(Get-Date): Window transparency reset to fully opaque." -ForegroundColor Green
	Add-CompletedTask -Tracker $taskTracker -TaskName 'Window transparency reset to fully opaque'
}
catch {
	Write-Error "$(Get-Date): Error resetting window transparency: $($_.Exception.Message)"
	Write-Console "$(Get-Date): Attempting fallback by resetting transparency using default Win32 API..." -ForegroundColor Yellow
	try {
		$hwnd = [Win32]::GetForegroundWindow()
		$style = [Win32]::GetWindowLong($hwnd, [Win32]::GWL_EXSTYLE)
		[Win32]::SetWindowLong($hwnd, [Win32]::GWL_EXSTYLE, $style -bor [Win32]::WS_EX_LAYERED)
		[Win32]::SetLayeredWindowAttributes($hwnd, 0, 255, [Win32]::LWA_ALPHA)
		Write-Console "$(Get-Date): Fallback succeeded. Window transparency reset to fully opaque using Win32 API." -ForegroundColor Green
		Add-CompletedTask -Tracker $taskTracker -TaskName 'Window transparency reset to fully opaque'
	}
	catch {
		Write-Error "$(Get-Date): Fallback failed: $($_.Exception.Message). Continuing script execution regardless."
	}
}

# =============================
# Step 20: Set PowerToys Awake if available.
# =============================

$PowerToysAwakeArgs = "--time-limit $PowerToysAwakeTime --display-on true"
try {
	if (Test-Path -LiteralPath $PowerToysAwakePath) {
		Write-Console "$(Get-Date): Setting PowerToys Awake to on for ($([TimeSpan]::FromSeconds($PowerToysAwakeTime).ToString('hh\:mm\:ss')))..." -ForegroundColor Cyan
		Start-Process -FilePath $PowerToysAwakePath -ArgumentList $PowerToysAwakeArgs -WindowStyle Hidden -ErrorAction Stop
		Write-Console "$(Get-Date): PowerToys Awake settings applied." -ForegroundColor Green
		Add-CompletedTask -Tracker $taskTracker -TaskName 'PowerToys Awake set'
	}
	else {
		Write-Console "$(Get-Date): PowerToys Awake executable not found at '$PowerToysAwakePath'. Skipping." -ForegroundColor Yellow
		Add-CompletedTask -Tracker $taskTracker -TaskName 'PowerToys Awake skipped'
	}
}
catch {
	Write-Error "$(Get-Date): Error setting PowerToys Awake: $($_.Exception.Message)"
	Add-CompletedTask -Tracker $taskTracker -TaskName 'PowerToys Awake failed'
}

# =============================
# Step 21: Show task completion summary and allow review/countdown before exit.
# =============================

try {
	Add-CompletedTask -Tracker $taskTracker -TaskName 'Final validation and review process started'
	Show-TaskCompletionSummary -Tracker $taskTracker -tasksCompleted $tasksCompleted
	$remainingTime = Get-RemainingTime -remainingTimeinHours $remainingTimeinHours -remainingTimeinMinutes $remainingTimeinMinutes -remainingTimeinSeconds $remainingTimeinSeconds
	Invoke-ReviewCountdownAndCleanup -remainingTime $remainingTime

	# --- Add prompt to keep window open after review period or key press ---
	Write-Console "`n$(Get-Date): Review period complete. Press Enter to close this window..." -ForegroundColor Cyan
	[void] (Read-Host)
}
catch {
	Write-Error "$(Get-Date): Unexpected error in the final validation and review process: $($_.Exception.Message)"
	return
}
