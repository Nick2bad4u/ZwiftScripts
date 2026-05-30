# Function to display a three dots animation while waiting
function Show-WaitingAnimation {
	param (
		[string]$Message,
		[bool]$Continue = $false
	)

	if (-not $Continue) {
		Write-Host "$Message" -NoNewline
	}

	# Using more characters for smoother and faster animation
	$chars = @('|', '/', '-', '\', '|', '/', '-', '\')
	$script:animIndex = ($script:animIndex + 1) % $chars.Length
	Write-Host "`r$Message $($chars[$script:animIndex])" -NoNewline
}

# Initialize animation index
$script:animIndex = 0

# Function to wait with animation
function Wait-WithAnimation {
	param (
		[int]$Seconds,
		[string]$Message
	)

	$endTime = (Get-Date).AddSeconds($Seconds)

	while ((Get-Date) -lt $endTime) {
		Show-WaitingAnimation -Message $Message -Continue $true
		Start-Sleep -Milliseconds 100  # Short sleep for smooth animation
	}
}

# Function to check if a process is running by name (case-insensitive)
function Get-ProcessRunning {
	param ([string]$ProcessName)
	try {
		return $null -ne (Get-Process -Name $ProcessName -ErrorAction SilentlyContinue)
	}
	catch {
		Write-Host "$(Get-Date): Error checking process ${ProcessName}: $($_.Exception.Message)"
		return $false
	}
}

# Variables for testing
$ZwiftLauncher = 'ZwiftLauncher'
$PrimaryDisplayZwift = 4
$SleepInterval = 10

# Wait for Zwift launcher to start and set primary display to Zwift display (index: 4)
try {
	Write-Host "$(Get-Date): Waiting for Zwift launcher to start..."
	while (-not (Get-ProcessRunning -ProcessName $ZwiftLauncher)) {
		Wait-WithAnimation -Seconds $SleepInterval -Message "Waiting for Zwift launcher"
	}
	Write-Host "`r$(Get-Date): Zwift launcher detected. Switching primary display to $PrimaryDisplayZwift"
	# Set-PrimaryDisplay $PrimaryDisplayZwift  # Commented out to prevent actual action
}
catch {
	Write-Host "`r$(Get-Date): Error while waiting for Zwift launcher to start or switching primary display: $($_.Exception.Message)"
}

# Indicate that the task is complete
Write-Host "`rTask completed." # Clear the loading indicator and show completion message
