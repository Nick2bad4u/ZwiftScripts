<#
.SYNOPSIS
  Modern entrypoint for Zwift session automation.

.DESCRIPTION
  Thin orchestrator that loads configuration, starts structured logging, and calls into the
  ZwiftScripts.Automation module.

.NOTES
  - Requires Windows.
  - Works in Windows PowerShell 5.1+ and PowerShell 7+.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
  [string]$ConfigPath = "$PSScriptRoot\MonitorZwift.config.json",

  [ValidateSet('Prompt','Continue','Abort')]
  [string]$OnTimeout,

  [switch]$NoTranscript,
  [switch]$NoJsonLog
)

$ErrorActionPreference = 'Stop'

$modulePath = Join-Path $PSScriptRoot 'modules\ZwiftScripts.Automation\ZwiftScripts.Automation.psd1'
Import-Module $modulePath -Force

function ConvertFrom-JsonDeep {
  param(
    [Parameter(Mandatory)] [string]$Json,
    [int]$Depth = 20
  )
  $cmd = Get-Command ConvertFrom-Json -ErrorAction SilentlyContinue
  if ($cmd -and $cmd.Parameters.ContainsKey('Depth')) {
    return ($Json | ConvertFrom-Json -Depth $Depth)
  }
  Add-Type -AssemblyName System.Web.Extensions -ErrorAction SilentlyContinue
  $ser = New-Object System.Web.Script.Serialization.JavaScriptSerializer
  $ser.MaxJsonLength = [int]::MaxValue
  return $ser.DeserializeObject($Json)
}

if (-not (Test-Path -LiteralPath $ConfigPath)) {
	throw "Config file not found: $ConfigPath"
}

$json = Get-Content -LiteralPath $ConfigPath -Raw
$config = ConvertFrom-JsonDeep -Json $json -Depth 50

# Optional overrides
if ($PSBoundParameters.ContainsKey('OnTimeout')) {
	$config.Timeouts.OnTimeout = $OnTimeout
}
if ($NoTranscript) {
	$config.Logging.Transcript.Enabled = $false
}
if ($NoJsonLog) {
	$config.Logging.Json.Enabled = $false
}

Invoke-MonitorZwift -Config $config
