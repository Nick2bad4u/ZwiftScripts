param (
	[string]$ZwiftLauncherPath = 'C:\Program Files (x86)\Zwift\ZwiftLauncher.exe',
	[string]$MonitorZwiftScriptPath = 'C:\Users\Nick\Dropbox\Cycling\ZwiftScripts\MonitorZwift-v2.ps1',
	[string]$ZwiftLauncher = 'ZwiftLauncher',
	# Zwift launcher process name
	[string]$ZwiftGame = 'ZwiftApp',
	# Zwift game process name
	[int]$ZwiftGameMaximizeDelay = 180,
	# Delay before maximizing the Zwift game window (in seconds)
	[int]$PrimaryDisplayZwift = 3,
	# Zero-based index of the display to be used for Zwift (Zero-based)
	[int]$PrimaryDisplayDefault = 1,
	# Index of the default primary display (zero-based)
	[int]$TargetDisplayIndex = 1,
	# Index of the target display (zero-based) for positioning the PowerShell window
	[int]$WindowPositionX = 0,
	# Default window position X (offset from the display's top-left corner)
	[int]$WindowPositionY = 50,
	# Default window position Y (offset from the display's top-left corner)
	[int]$WindowWidth = 300,
	# Default window width (in pixels)
	[int]$WindowHeight = 600,
	# Default window height (in pixels)
	[string]$PowerToysPath = 'C:\Program Files\PowerToys\PowerToys.WorkspacesLauncher.exe',
	# Path to PowerToys Workspaces executable file (default installation path)
	[string]$WorkspaceGuid = '{E2CDEA2A-6E33-4CFD-A26B-0C5CC2E55F40}',
	# GUID for the PowerToys Workspace for Zwift
	[string]$FreeFileSyncPath = 'C:\Program Files\FreeFileSync\FreeFileSync.exe',
	# Path to FreeFileSync executable file (default installation path)
	[string]$BatchJobPath = 'C:\Users\Nick\Dropbox\Random Save\Task Scheduler Rules\ZwiftPics.ffs_batch',
	# Path to FreeFileSync batch job file for synchronizing files after Zwift session
	[string]$ZwiftMediaPath = 'C:\Users\Nick\Dropbox\Cycling\ZwiftMedia',
	[string]$ZwiftPicturesPath = 'C:\Users\Nick\Dropbox\PC (2)\Pictures\Zwift',
	[string]$EdgePath = 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe',
	# Path to Microsoft Edge executable file
	[string]$EdgeUrl1 = 'https://studio.youtube.com/channel/UCyYwMWui3Opy2yZyom2QM0g/videos/upload?filter=%5B%5D&sort=%7B%22columnType%22%3A%22date%22%2C%22sortOrder%22%3A%22DESCENDING%22%7D',
	# URL to open in Microsoft Edge in app mode (YouTube Studio) Opens Edge URL 1
	[string]$EdgeUrl2 = 'https://www.strava.com/athlete/training',
	# URL to open in Microsoft Edge in app mode (Strava) Opens Edge URL 2
	[string]$EdgeUrl3 = 'https://connect.garmin.com/modern/home',
	# URL to open in Microsoft Edge in app mode (Garmin Connect) Opens Edge URL 3
	[string[]]$AppsToCheck = @('Spotify', 'obs64', 'Sauce for Zwift'),
	# List of additional apps to check for and close when Zwift is detected
	[string[]]$AnimationChars = @('|', '/', '-', '\', '|', '/', '-', '\'),
	# Animation characters for waiting animation
	[int]$Transparency = 75,
	# Window transparency percentage (0-100) 100 = fully transparent, 0 = opaque
	[int]$SleepInterval = 10,
	# Reduced interval for faster detection of Zwift launcher and game processes
	[string[]]$Colors = @('Black', 'DarkBlue', 'DarkGreen', 'DarkCyan', 'DarkRed', 'DarkMagenta', 'DarkYellow', 'Gray', 'DarkGray', 'Blue', 'Green', 'Cyan', 'Red', 'Magenta', 'Yellow', 'White'),
	# List of colors for the waiting animation
	[string]$randomColor = ($Colors | Get-Random),
	# Random color for the waiting animation
	[int]$AnimIndex = 0,
	# Animation index for the waiting animation
	[string]$ObsProcessName = 'obs64',
	# OBS process name (default: obs64)
	[string]$StopRecordingHotkey = '^{F11}',
	# Hotkey to stop recording in OBS (default: Ctrl+F11)
	[string]$CloseObsHotkey = '%{F4}',
	# Hotkey to close OBS gracefully (default: Alt+F4)
	[string[]]$tasksCompleted = @(
		'Resized and positioned PowerShell window',
		'Imported DisplayConfig module',
		'Set Window Transparency',
		'Zwift Launcher path resolved',
		'ZwiftApp already running or Zwift Launcher started',
		'Zwift launcher running',
		'Primary display set for Zwift',
		'PowerToys Workspaces launched or skipped',
		'Zwift game started',
		'Zwift game window maximized',
		'Zwift game closed',
		'Sauce for Zwift closed or skipped',
		'Primary display restored',
		'FreeFileSync batch job completed',
		'OBS recording stopped and closed',
		'Spotify closed',
		'Microsoft Edge launched',
		'Opened File Explorer for ZwiftMediaPath',
		'Opened File Explorer for ZwiftPicturesPath'
	),
	# [int]$remainingTimeinHours = 3
	# Remaining time in hours for the script to run before closing
	# Uncomment the following variables if you prefer to specify the remaining time in minutes or seconds
	# [int]$remainingTimeinMinutes = 180 # Time in minutes for the script to remain open for review
	[int]$remainingTimeinSeconds = 3 # Time in seconds for the script to remain open for review
)
# Initialize animation characters and random color
$AnimationChars = @('|', '/', '-', '\')
$script:randomColor = 'Yellow'
$script:animIndex = 0

function Show-WaitingAnimation {
	param (
		[string]$Message,
		[bool]$Continue
	)
	$script:animIndex = ($script:animIndex + 1) % $AnimationChars.Length
	Write-Host "`r$Message $($AnimationChars[$script:animIndex])" -NoNewline -ForegroundColor $script:randomColor
}

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

	# Calculate the remaining time in seconds based on the provided input
	if ($null -ne $remainingTimeinHours) {
		$remainingTime = $remainingTimeinHours * 3600
	} elseif ($null -ne $remainingTimeinMinutes) {
		$remainingTime = $remainingTimeinMinutes * 60
	} elseif ($null -ne $remainingTimeinSeconds) {
		$remainingTime = $remainingTimeinSeconds
	} else {
		Write-Host "$(Get-Date): No valid remaining time parameter provided. Exiting script." -ForegroundColor Red
		exit
	}

	Write-Host "$(Get-Date): Script execution completed. The window will remain open for review for $([TimeSpan]::FromSeconds($remainingTime).ToString('hh\:mm\:ss'))." -ForegroundColor Yellow
	# Store the original remaining time for accurate display
	$originalRemainingTime = $remainingTime
	# In-place countdown timer using Wait-WithAnimation
	while ($remainingTime -gt 0) {
		$formattedTime = [TimeSpan]::FromSeconds($remainingTime).ToString('hh\:mm\:ss')
		Wait-WithAnimation -Seconds 1 -Message "Time remaining: $formattedTime"
		$remainingTime--
	}
	Write-Host "`n$(Get-Date): Script review time over. $([TimeSpan]::FromSeconds($originalRemainingTime).ToString('hh\:mm\:ss')) has passed since the script ended." -ForegroundColor Yellow
	Write-Host "$(Get-Date): Closing the script now." -ForegroundColor Yellow
	exit
