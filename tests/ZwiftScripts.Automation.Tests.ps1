Import-Module "$PSScriptRoot\..\modules\ZwiftScripts.Automation\ZwiftScripts.Automation.psd1" -Force

Describe 'ZwiftScripts.Automation log monitoring' {
	InModuleScope ZwiftScripts.Automation {
		It 'detects a ride-start marker that already exists outside the last 50 lines' {
			$logPath = Join-Path $TestDrive 'zwift.log'
			$before = 1..200 | ForEach-Object { "noise-before $_" }
			$marker = '[16:43:47] [ZWATCHDOG]: GameFlowState Riding'
			$after = 1..75 | ForEach-Object { "noise-after $_" }
			Set-Content -LiteralPath $logPath -Value ($before + $marker + $after)

			$result = Wait-ForLogPatterns -LiteralPath $logPath -Patterns @('\[ZWATCHDOG\]: GameFlowState Riding') -TimeoutSec 1 -PollSec 1 -OnTimeout Continue -InitialTailLines 500 -Description 'ride marker'

			$result | Should -BeTrue
		}

		It 'detects a ride-start marker appended after monitoring begins' {
			$logPath = Join-Path $TestDrive 'zwift-stream.log'
			Set-Content -LiteralPath $logPath -Value 'initial line'

			$job = Start-Job -ScriptBlock {
				param($Path)
				Start-Sleep -Milliseconds 500
				Add-Content -LiteralPath $Path -Value '[16:43:47] INFO LEVEL: [GameState] Starting Ride. {rideId: abc}'
			} -ArgumentList $logPath

			try {
				$result = Wait-ForLogPatterns -LiteralPath $logPath -Patterns @('INFO LEVEL: \[GameState\] Starting Ride\.') -TimeoutSec 5 -PollSec 1 -OnTimeout Continue -InitialTailLines 10 -Description 'ride marker'

				$result | Should -BeTrue
			}
			finally {
				$null = Receive-Job -Job $job -Wait -AutoRemoveJob -ErrorAction SilentlyContinue
			}
		}
	}
}
