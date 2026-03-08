Set-StrictMode -Version 2.0

# =============================
# Logging
# =============================

$script:LogContext = [ordered]@{
  TranscriptEnabled = $false
  TranscriptPath    = $null
  JsonEnabled       = $false
  JsonPath          = $null
}

function Get-LogFilePath {
  param(
    [Parameter(Mandatory)] [string]$Directory,
    [Parameter(Mandatory)] [string]$Prefix
  )
  $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
  return (Join-Path $Directory "$Prefix-$stamp.log")
}

function Write-ZwiftLog {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    [ValidateSet('Info','Warn','Error','Debug')]
    [string]$Level,

    [Parameter(Mandatory, Position = 0)]
    [string]$Message,

    [hashtable]$Data,

    [ConsoleColor]$ForegroundColor
  )

  $ts = (Get-Date).ToString('o')
  $line = "[$ts] [$Level] $Message"

  # Human-readable output
  try {
    if ($Host -and $Host.UI) {
      $fgSpecified = $PSBoundParameters.ContainsKey('ForegroundColor')
      $fg = if ($fgSpecified) { $ForegroundColor } else {
        switch ($Level) {
          'Error' { 'Red' }
          'Warn'  { 'Yellow' }
          'Debug' { 'DarkGray' }
          default { 'Gray' }
        }
      }
      $Host.UI.WriteLine([ConsoleColor]$fg, $Host.UI.RawUI.BackgroundColor, $line)
    } else {
      Write-Output $line
    }
  } catch {
    Write-Output $line
  }

  # Optional JSONL
  if ($script:LogContext.JsonEnabled -and $script:LogContext.JsonPath) {
    try {
      $obj = [ordered]@{ timestamp = $ts; level = $Level; message = $Message }
      if ($Data) { $obj.data = $Data }
      ($obj | ConvertTo-Json -Depth 20 -Compress) | Add-Content -LiteralPath $script:LogContext.JsonPath -Encoding utf8
    } catch {
      Write-Verbose "JSON log write failed: $($_.Exception.Message)"
    }
  }
}

function Start-RunLogging {
  [CmdletBinding(SupportsShouldProcess = $true)]
  param(
    [Parameter(Mandatory)] $LoggingConfig,
    [Parameter(Mandatory)] [string]$Root
  )

  # Transcript
  try {
    if ($LoggingConfig.Transcript.Enabled) {
      $tDir = $LoggingConfig.Transcript.Directory
      if ([string]::IsNullOrWhiteSpace($tDir)) { $tDir = './logs' }
      $dir = Join-Path $Root $tDir
      $path = Get-LogFilePath -Directory $dir -Prefix 'MonitorZwift'

      if (-not (Test-Path -LiteralPath $dir)) {
        if ($PSCmdlet.ShouldProcess($dir, 'Create log directory')) {
          $null = New-Item -ItemType Directory -Path $dir -Force
        }
      }

      if ($PSCmdlet.ShouldProcess($path, 'Start transcript')) {
        Start-Transcript -LiteralPath $path -Append | Out-Null
      }
      $script:LogContext.TranscriptEnabled = $true
      $script:LogContext.TranscriptPath = $path
      Write-ZwiftLog -Level Info -Message "Transcript started: $path"
    }
  } catch {
    Write-ZwiftLog -Level Warn -Message "Failed to start transcript: $($_.Exception.Message)"
  }

  # JSONL
  try {
    if ($LoggingConfig.Json.Enabled) {
      $jDir = $LoggingConfig.Json.Directory
      if ([string]::IsNullOrWhiteSpace($jDir)) { $jDir = './logs' }
      $dir = Join-Path $Root $jDir
      if (-not (Test-Path -LiteralPath $dir)) { $null = New-Item -ItemType Directory -Path $dir -Force }
      $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
      $path = Join-Path $dir "MonitorZwift-$stamp.jsonl"
      $script:LogContext.JsonEnabled = $true
      $script:LogContext.JsonPath = $path
      Write-ZwiftLog -Level Info -Message "JSON log enabled: $path"
    }
  } catch {
    Write-ZwiftLog -Level Warn -Message "Failed to initialize JSON logging: $($_.Exception.Message)"
  }
}

function Stop-RunLogging {
  [CmdletBinding(SupportsShouldProcess = $true)]
  param()
  if ($script:LogContext.TranscriptEnabled) {
    try {
      if ($PSCmdlet.ShouldProcess($script:LogContext.TranscriptPath, 'Stop transcript')) {
        Stop-Transcript | Out-Null
      }
    } catch {
      Write-Verbose "Stop-Transcript failed: $($_.Exception.Message)"
    }
  }
}

# =============================
# Utilities
# =============================

function Resolve-ConfigPath {
  param([string]$Path)
  if (-not $Path) { return $null }
  $expanded = [Environment]::ExpandEnvironmentVariables($Path)
  return $expanded
}

function ConvertFrom-JsonDeep {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)] [string]$Json,
    [int]$Depth = 20
  )

  $cmd = Get-Command ConvertFrom-Json -ErrorAction SilentlyContinue
  if ($cmd -and $cmd.Parameters.ContainsKey('Depth')) {
    return ($Json | ConvertFrom-Json -Depth $Depth)
  }

  # Windows PowerShell 5.1 fallback (ConvertFrom-Json has no -Depth)
  Add-Type -AssemblyName System.Web.Extensions -ErrorAction SilentlyContinue
  $ser = New-Object System.Web.Script.Serialization.JavaScriptSerializer
  $ser.MaxJsonLength = [int]::MaxValue
  return $ser.DeserializeObject($Json)
}

function Start-PowerToysAwake {
  [CmdletBinding(SupportsShouldProcess = $true)]
  param(
    [Parameter(Mandatory)] [string]$AwakeExe,
    [Parameter(Mandatory)] [int]$Seconds,
    [bool]$DisplayOn = $true
  )

  $exe = Resolve-ConfigPath $AwakeExe
  if (-not $exe -or -not (Test-Path -LiteralPath $exe)) {
    Write-ZwiftLog -Level Warn -Message "PowerToys Awake not found: $exe"
    return $false
  }

  $awakeArgs = "--time-limit $Seconds --display-on $($DisplayOn.ToString().ToLower())"
  if ($PSCmdlet.ShouldProcess($exe, "Start PowerToys Awake ($Seconds s)")) {
    try {
      Start-Process -FilePath $exe -ArgumentList $awakeArgs -WindowStyle Hidden | Out-Null
      Write-ZwiftLog -Level Info -Message "PowerToys Awake started for $Seconds seconds."
      return $true
    } catch {
      Write-ZwiftLog -Level Warn -Message "Failed to start PowerToys Awake: $($_.Exception.Message)"
      return $false
    }
  }

  return $false
}

function Stop-PowerToysAwake {
  [CmdletBinding(SupportsShouldProcess = $true)]
  param()

  try {
    $proc = Get-Process -Name 'PowerToys.Awake' -ErrorAction SilentlyContinue
    if (-not $proc) { return $true }
    if ($PSCmdlet.ShouldProcess('PowerToys.Awake', 'Stop process')) {
      $proc | Stop-Process -Force
    }
    return $true
  } catch {
    Write-Verbose "Stop-PowerToysAwake failed: $($_.Exception.Message)"
    return $false
  }
}

function Get-IsInteractive {
  try {
    return [Environment]::UserInteractive -and $Host -and $Host.UI -and $Host.UI.RawUI
  } catch {
    return $false
  }
}

function Wait-Until {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)] [scriptblock]$Condition,
    [Parameter(Mandatory)] [int]$TimeoutSec,
    [int]$PollSec = 1,
    [string]$Description = 'condition',
    [ValidateSet('Prompt','Continue','Abort')]
    [string]$OnTimeout = 'Prompt'
  )

  $deadline = (Get-Date).AddSeconds($TimeoutSec)
  while ((Get-Date) -lt $deadline) {
    try {
      if (& $Condition) { return $true }
    } catch {
      Write-Verbose "Wait-Until condition error: $($_.Exception.Message)"
    }
    Start-Sleep -Seconds ([Math]::Max(1, $PollSec))
  }

  # Timeout handler
  $msg = "Timed out after ${TimeoutSec}s waiting for $Description."

  switch ($OnTimeout) {
    'Continue' {
      Write-ZwiftLog -Level Warn -Message $msg
      return $false
    }
    'Abort' {
      throw $msg
    }
    default {
      if (-not (Get-IsInteractive)) {
        Write-ZwiftLog -Level Warn -Message "$msg (non-interactive; continuing)"
        return $false
      }

      while ($true) {
        $choice = Read-Host "$msg  [A]bort / [C]ontinue / [R]etry"
        switch -Regex ($choice) {
          '^(A|a)$' { throw $msg }
          '^(C|c)$' { return $false }
          '^(R|r)$' {
            $deadline = (Get-Date).AddSeconds($TimeoutSec)
            break
          }
          default { }
        }
      }
    }
  }
}

function Wait-ForProcess {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)] [string]$ProcessName,
    [Parameter(Mandatory)] [int]$TimeoutSec,
    [int]$PollSec = 1,
    [ValidateSet('Prompt','Continue','Abort')]
    [string]$OnTimeout = 'Prompt'
  )

  $ok = Wait-Until -TimeoutSec $TimeoutSec -PollSec $PollSec -OnTimeout $OnTimeout -Description "process '$ProcessName'" -Condition {
    $p = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($p) { $script:__lastProcess = $p; return $true }
    return $false
  }

  if ($ok) { return $script:__lastProcess }
  return $null
}

function Wait-ForMainWindowHandle {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)] [System.Diagnostics.Process]$Process,
    [Parameter(Mandatory)] [int]$TimeoutSec,
    [int]$PollSec = 1,
    [ValidateSet('Prompt','Continue','Abort')]
    [string]$OnTimeout = 'Prompt'
  )

  $processId = $Process.Id
  $ok = Wait-Until -TimeoutSec $TimeoutSec -PollSec $PollSec -OnTimeout $OnTimeout -Description "MainWindowHandle for PID $processId" -Condition {
    $p = Get-Process -Id $processId -ErrorAction SilentlyContinue
    if (-not $p) { return $false }
    return ($p.MainWindowHandle -ne 0)
  }

  if (-not $ok) { return [IntPtr]::Zero }
  $p2 = Get-Process -Id $processId -ErrorAction SilentlyContinue
  return $p2.MainWindowHandle
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

function Wait-ForLogPatterns {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)] [string]$LiteralPath,
    [Parameter(Mandatory)] [string[]]$Patterns,
    [Parameter(Mandatory)] [int]$TimeoutSec,
    [int]$PollSec = 1,
    [int]$InitialTailLines = 2000,
    [string]$Description = 'log pattern',
    [ValidateSet('Prompt','Continue','Abort')]
    [string]$OnTimeout = 'Prompt'
  )

  if (-not (Test-Path -LiteralPath $LiteralPath)) {
    return $false
  }

  if ($InitialTailLines -gt 0) {
    try {
      $recentLines = Get-Content -LiteralPath $LiteralPath -Tail $InitialTailLines -ErrorAction Stop
      if (Test-LogPatternMatch -Lines $recentLines -Patterns $Patterns) {
        return $true
      }
    } catch {
      Write-Verbose "Initial log scan failed: $($_.Exception.Message)"
    }
  }

  $logStream = $null
  $reader = $null

  try {
    $logStream = [System.IO.File]::Open($LiteralPath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite)
    $reader = New-Object System.IO.StreamReader($logStream)
    $null = $reader.BaseStream.Seek(0, [System.IO.SeekOrigin]::End)

    return (Wait-Until -TimeoutSec $TimeoutSec -PollSec $PollSec -OnTimeout $OnTimeout -Description $Description -Condition {
      while ($null -ne ($line = $reader.ReadLine())) {
        foreach ($pattern in $Patterns) {
          if ($line -match $pattern) {
            return $true
          }
        }
      }

      return $false
    })
  } catch {
    Write-ZwiftLog -Level Warn -Message "Failed to monitor log file '$LiteralPath': $($_.Exception.Message)"
    return $false
  } finally {
    if ($reader) {
      $reader.Dispose()
    } elseif ($logStream) {
      $logStream.Dispose()
    }
  }
}

# =============================
# Display helpers (0-based externally)
# =============================

function Initialize-Win32WindowInterop {
  # Centralized Win32 interop for window management (position/size/transparency)
  if (([System.Management.Automation.PSTypeName]'ZwiftWin32Window').Type) { return }

  $code = @'
using System;
using System.Runtime.InteropServices;
public static class ZwiftWin32Window {
  [DllImport("user32.dll", SetLastError = true)]
  public static extern IntPtr GetForegroundWindow();

  [DllImport("user32.dll", SetLastError = true)]
  public static extern int GetWindowLong(IntPtr hWnd, int nIndex);

  [DllImport("user32.dll", SetLastError = true)]
  public static extern int SetWindowLong(IntPtr hWnd, int nIndex, int dwNewLong);

  [DllImport("user32.dll", SetLastError = true)]
  public static extern bool SetLayeredWindowAttributes(IntPtr hwnd, uint crKey, byte bAlpha, uint dwFlags);

  [DllImport("user32.dll", SetLastError = true)]
  public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);

  [DllImport("user32.dll", SetLastError = true)]
  public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

  public const int GWL_EXSTYLE = -20;
  public const int WS_EX_LAYERED = 0x80000;
  public const int LWA_ALPHA = 0x2;

  public const uint SWP_NOZORDER = 0x0004;
  public const uint SWP_SHOWWINDOW = 0x0040;

  public const int SW_MAXIMIZE = 3;
}
'@

  Add-Type -TypeDefinition $code -ErrorAction Stop
}

function Set-HostWindowTransparency {
  [CmdletBinding(SupportsShouldProcess = $true)]
  param(
    [Parameter(Mandatory)]
    [ValidateRange(0,100)]
    [int]$TransparencyPercent
  )

  Initialize-Win32WindowInterop
  $hWnd = [ZwiftWin32Window]::GetForegroundWindow()
  if ($hWnd -eq [IntPtr]::Zero) {
    Write-ZwiftLog -Level Warn -Message 'No foreground window handle; cannot set transparency.'
    return $false
  }

  # 0% means opaque
  $alpha = if ($TransparencyPercent -eq 0) { 255 } else { [byte]((100 - $TransparencyPercent) * 255 / 100) }
  if ($PSCmdlet.ShouldProcess('Foreground window', "Set transparency to $TransparencyPercent%")) {
    try {
      $style = [ZwiftWin32Window]::GetWindowLong($hWnd, [ZwiftWin32Window]::GWL_EXSTYLE)
      [void][ZwiftWin32Window]::SetWindowLong($hWnd, [ZwiftWin32Window]::GWL_EXSTYLE, $style -bor [ZwiftWin32Window]::WS_EX_LAYERED)
      [void][ZwiftWin32Window]::SetLayeredWindowAttributes($hWnd, 0, $alpha, [ZwiftWin32Window]::LWA_ALPHA)
      return $true
    } catch {
      Write-ZwiftLog -Level Warn -Message "Failed to set transparency: $($_.Exception.Message)"
      return $false
    }
  }
  return $false
}

function Set-HostWindowPosition {
  [CmdletBinding(SupportsShouldProcess = $true)]
  param(
    [Parameter(Mandatory)] [int]$DisplayIndex,
    [int]$X = 0,
    [int]$Y = 0,
    [int]$Width = 300,
    [int]$Height = 600
  )

  Add-Type -AssemblyName System.Windows.Forms -ErrorAction SilentlyContinue
  Initialize-Win32WindowInterop

  $screens = [System.Windows.Forms.Screen]::AllScreens
  if ($DisplayIndex -lt 0 -or $DisplayIndex -ge $screens.Count) {
    Write-ZwiftLog -Level Warn -Message "Invalid console display index: $DisplayIndex"
    return $false
  }
  $wa = $screens[$DisplayIndex].WorkingArea
  $targetX = $wa.X + $X
  $targetY = $wa.Y + $Y
  $hWnd = [ZwiftWin32Window]::GetForegroundWindow()
  if ($hWnd -eq [IntPtr]::Zero) { return $false }

  if ($PSCmdlet.ShouldProcess('Foreground window', "Move/resize to $targetX,$targetY $Width x $Height")) {
    try {
      [void][ZwiftWin32Window]::SetWindowPos($hWnd, [IntPtr]::Zero, $targetX, $targetY, $Width, $Height, [ZwiftWin32Window]::SWP_NOZORDER -bor [ZwiftWin32Window]::SWP_SHOWWINDOW)
      return $true
    } catch {
      Write-ZwiftLog -Level Warn -Message "Failed to set console window position: $($_.Exception.Message)"
      return $false
    }
  }
  return $false
}

function Set-ProcessMainWindowState {
  [CmdletBinding(SupportsShouldProcess = $true)]
  param(
    [Parameter(Mandatory)] [System.Diagnostics.Process]$Process,
    [ValidateSet('Maximize')]
    [string]$State = 'Maximize'
  )

  Initialize-Win32WindowInterop
  $hWnd = $Process.MainWindowHandle
  if ($hWnd -eq 0) { return $false }

  $action = "Set main window state: $State"
  if ($PSCmdlet.ShouldProcess($Process.ProcessName, $action)) {
    try {
      switch ($State) {
        'Maximize' { [void][ZwiftWin32Window]::ShowWindow($hWnd, [ZwiftWin32Window]::SW_MAXIMIZE) }
      }
      return $true
    } catch {
      Write-ZwiftLog -Level Warn -Message "Failed to set window state: $($_.Exception.Message)"
      return $false
    }
  }

  return $false
}

function Get-PrimaryDisplayIndex {
  Add-Type -AssemblyName System.Windows.Forms -ErrorAction SilentlyContinue
  $screens = [System.Windows.Forms.Screen]::AllScreens
  for ($i = 0; $i -lt $screens.Count; $i++) {
    if ($screens[$i].Primary) { return $i }
  }
  return 0
}

function Test-DisplayIndex {
  param([int]$Index)
  Add-Type -AssemblyName System.Windows.Forms -ErrorAction SilentlyContinue
  $count = [System.Windows.Forms.Screen]::AllScreens.Count
  return ($Index -ge 0 -and $Index -lt $count)
}

function Import-DisplayConfig {
  [CmdletBinding()]
  param(
    [switch]$InstallIfMissing
  )

  if (Get-Module -ListAvailable -Name DisplayConfig) {
    Import-Module DisplayConfig -ErrorAction Stop
    return $true
  }

  if ($InstallIfMissing) {
    try {
      Install-Module -Name DisplayConfig -Force -AllowClobber -Scope CurrentUser -ErrorAction Stop
      Import-Module DisplayConfig -ErrorAction Stop
      return $true
    } catch {
      Write-ZwiftLog -Level Warn -Message "DisplayConfig install/import failed: $($_.Exception.Message)"
      return $false
    }
  }

  Write-ZwiftLog -Level Warn -Message 'DisplayConfig module not found; display switching will be skipped.'
  return $false
}

function Set-PrimaryDisplaySafe {
  [CmdletBinding(SupportsShouldProcess = $true)]
  param(
    [Parameter(Mandatory)] [int]$ZeroBasedIndex
  )

  if (-not (Get-Command -Name Set-DisplayPrimary -ErrorAction SilentlyContinue)) {
    Write-ZwiftLog -Level Warn -Message 'Set-DisplayPrimary not available; skipping primary display change.'
    return $false
  }

  if (-not (Test-DisplayIndex -Index $ZeroBasedIndex)) {
    Write-ZwiftLog -Level Warn -Message "Invalid display index: $ZeroBasedIndex"
    return $false
  }

  $displayConfigIndex = $ZeroBasedIndex + 1
  if ($PSCmdlet.ShouldProcess("DisplayIndex=$ZeroBasedIndex", 'Set primary display')) {
    try {
      Set-DisplayPrimary $displayConfigIndex
      Write-ZwiftLog -Level Info -Message "Primary display set to index $ZeroBasedIndex (DisplayConfig=$displayConfigIndex)"
      return $true
    } catch {
      Write-ZwiftLog -Level Error -Message "Failed to set primary display: $($_.Exception.Message)"
      return $false
    }
  }

  return $false
}

# =============================
# Win32: SendInput for media keys (Spotify)
# =============================

function Initialize-Win32InputInterop {
  if (([System.Management.Automation.PSTypeName]'ZwiftWin32Input').Type) { return }

  $code = @'
using System;
using System.Runtime.InteropServices;
public static class ZwiftWin32Input {
  [StructLayout(LayoutKind.Sequential)]
  public struct INPUT {
    public uint type;
    public InputUnion U;
  }

  [StructLayout(LayoutKind.Explicit)]
  public struct InputUnion {
    [FieldOffset(0)] public KEYBDINPUT ki;
  }

  [StructLayout(LayoutKind.Sequential)]
  public struct KEYBDINPUT {
    public ushort wVk;
    public ushort wScan;
    public uint dwFlags;
    public uint time;
    public IntPtr dwExtraInfo;
  }

  public const uint INPUT_KEYBOARD = 1;
  public const uint KEYEVENTF_KEYUP = 0x0002;

  [DllImport("user32.dll", SetLastError=true)]
  public static extern uint SendInput(uint nInputs, INPUT[] pInputs, int cbSize);
}
'@

  Add-Type -TypeDefinition $code -ErrorAction Stop
}

function Send-MediaPlayPause {
  [CmdletBinding(SupportsShouldProcess = $true)]
  param()

  Initialize-Win32InputInterop

  # VK_MEDIA_PLAY_PAUSE = 0xB3
  $down = New-Object ZwiftWin32Input+INPUT
  $down.type = [ZwiftWin32Input]::INPUT_KEYBOARD
  $down.U = New-Object ZwiftWin32Input+InputUnion
  $down.U.ki = New-Object ZwiftWin32Input+KEYBDINPUT
  $down.U.ki.wVk = 0xB3
  $down.U.ki.dwFlags = 0

  $up = $down
  $up.U.ki.dwFlags = [ZwiftWin32Input]::KEYEVENTF_KEYUP

  $arr = @($down, $up)
  if ($PSCmdlet.ShouldProcess('System', 'Send media Play/Pause key')) {
    [ZwiftWin32Input]::SendInput(2, $arr, [System.Runtime.InteropServices.Marshal]::SizeOf([ZwiftWin32Input+INPUT])) | Out-Null
  }
}

# =============================
# OBS WebSocket (v5) - optional
# =============================

function ConvertFrom-SecureStringPlainText {
  [CmdletBinding()]
  param([Parameter(Mandatory)] [SecureString]$SecureString)

  $bstr = [IntPtr]::Zero
  try {
    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)
    return [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
  } finally {
    if ($bstr -ne [IntPtr]::Zero) {
      [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
    }
  }
}

function Get-ObsAuthToken {
  param(
    [Parameter(Mandatory)] [SecureString]$Password,
    [Parameter(Mandatory)] [string]$Salt,
    [Parameter(Mandatory)] [string]$Challenge
  )

  $pw = ConvertFrom-SecureStringPlainText -SecureString $Password

  $sha = [System.Security.Cryptography.SHA256]::Create()
  $secretBytes = $sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($pw + $Salt))
  $secret = [Convert]::ToBase64String($secretBytes)
  $authBytes = $sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($secret + $Challenge))
  return [Convert]::ToBase64String($authBytes)
}

function Receive-ObsMessage {
  param(
    [Parameter(Mandatory)] [System.Net.WebSockets.ClientWebSocket]$WebSocket,
    [int]$TimeoutSec = 10
  )

  $buffer = New-Object byte[] 8192
  $segment = [ArraySegment[byte]]::new($buffer)
  $cts = New-Object System.Threading.CancellationTokenSource
  $cts.CancelAfter([TimeSpan]::FromSeconds($TimeoutSec))

  $ms = New-Object System.IO.MemoryStream
  try {
    do {
      $result = $WebSocket.ReceiveAsync($segment, $cts.Token).GetAwaiter().GetResult()
      if ($result.Count -gt 0) {
        $ms.Write($buffer, 0, $result.Count)
      }
    } while (-not $result.EndOfMessage)

    $text = [Text.Encoding]::UTF8.GetString($ms.ToArray())
    return (ConvertFrom-JsonDeep -Json $text -Depth 50)
  } finally {
    $ms.Dispose()
    $cts.Dispose()
  }
}

function Send-ObsMessage {
  param(
    [Parameter(Mandatory)] [System.Net.WebSockets.ClientWebSocket]$WebSocket,
    [Parameter(Mandatory)] [object]$Message
  )

  $json = $Message | ConvertTo-Json -Depth 50 -Compress
  $bytes = [Text.Encoding]::UTF8.GetBytes($json)
  $segment = [ArraySegment[byte]]::new($bytes)
  $WebSocket.SendAsync($segment, [System.Net.WebSockets.WebSocketMessageType]::Text, $true, [Threading.CancellationToken]::None).GetAwaiter().GetResult() | Out-Null
}

function Connect-ObsWebSocket {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)] [string]$ObsHost,
    [Parameter(Mandatory)] [int]$Port,
    [SecureString]$Password,
    [int]$ConnectTimeoutSec = 10
  )

  $uri = [Uri]::new("ws://$ObsHost`:$Port")
  $ws = [System.Net.WebSockets.ClientWebSocket]::new()

  $cts = New-Object System.Threading.CancellationTokenSource
  $cts.CancelAfter([TimeSpan]::FromSeconds($ConnectTimeoutSec))
  try {
    $ws.ConnectAsync($uri, $cts.Token).GetAwaiter().GetResult() | Out-Null
  } finally {
    $cts.Dispose()
  }

  $hello = Receive-ObsMessage -WebSocket $ws -TimeoutSec $ConnectTimeoutSec
  if (-not $hello -or $hello.op -ne 0) {
    $ws.Dispose()
    throw 'OBS WebSocket: did not receive Hello.'
  }

  $auth = $null
  if ($hello.d.authentication -and $Password) {
    $auth = Get-ObsAuthToken -Password $Password -Salt $hello.d.authentication.salt -Challenge $hello.d.authentication.challenge
  }

  $identify = @{ op = 1; d = @{ rpcVersion = 1; eventSubscriptions = 0 } }
  if ($auth) { $identify.d.authentication = $auth }
  Send-ObsMessage -WebSocket $ws -Message $identify

  $identified = Receive-ObsMessage -WebSocket $ws -TimeoutSec $ConnectTimeoutSec
  if (-not $identified -or $identified.op -ne 2) {
    $ws.Dispose()
    throw 'OBS WebSocket: failed to identify.'
  }

  return $ws
}

function Invoke-ObsRequest {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)] [System.Net.WebSockets.ClientWebSocket]$WebSocket,
    [Parameter(Mandatory)] [string]$RequestType,
    [hashtable]$RequestData,
    [int]$TimeoutSec = 10
  )

  $rid = [Guid]::NewGuid().ToString('N')
  $msg = @{ op = 6; d = @{ requestType = $RequestType; requestId = $rid } }
  if ($RequestData) { $msg.d.requestData = $RequestData }
  Send-ObsMessage -WebSocket $WebSocket -Message $msg

  $deadline = (Get-Date).AddSeconds($TimeoutSec)
  while ((Get-Date) -lt $deadline) {
    $resp = Receive-ObsMessage -WebSocket $WebSocket -TimeoutSec $TimeoutSec
    if ($resp.op -eq 7 -and $resp.d.requestId -eq $rid) {
      return $resp
    }
  }
  throw "OBS WebSocket: timeout waiting for response to $RequestType"
}

function Get-ObsRecordStatus {
  param([System.Net.WebSockets.ClientWebSocket]$WebSocket)
  $resp = Invoke-ObsRequest -WebSocket $WebSocket -RequestType 'GetRecordStatus' -TimeoutSec 10
  return $resp.d.responseData
}

function Start-ObsRecordingApi {
  [CmdletBinding(SupportsShouldProcess = $true)]
  param([System.Net.WebSockets.ClientWebSocket]$WebSocket)
  if ($PSCmdlet.ShouldProcess('OBS', 'Start recording')) {
    $null = Invoke-ObsRequest -WebSocket $WebSocket -RequestType 'StartRecord' -TimeoutSec 10
  }
}

function Stop-ObsRecordingApi {
  [CmdletBinding(SupportsShouldProcess = $true)]
  param([System.Net.WebSockets.ClientWebSocket]$WebSocket)
  if ($PSCmdlet.ShouldProcess('OBS', 'Stop recording')) {
    $null = Invoke-ObsRequest -WebSocket $WebSocket -RequestType 'StopRecord' -TimeoutSec 15
  }
}

function Stop-ObsApplicationApi {
  [CmdletBinding(SupportsShouldProcess = $true)]
  param([System.Net.WebSockets.ClientWebSocket]$WebSocket)
  try {
    if ($PSCmdlet.ShouldProcess('OBS', 'Shutdown')) {
      $null = Invoke-ObsRequest -WebSocket $WebSocket -RequestType 'Shutdown' -TimeoutSec 10
    }
  } catch {
    Write-Verbose "OBS shutdown request failed: $($_.Exception.Message)"
  }
}

function Disconnect-ObsWebSocket {
  param([System.Net.WebSockets.ClientWebSocket]$WebSocket)
  try {
    if ($WebSocket -and $WebSocket.State -eq [System.Net.WebSockets.WebSocketState]::Open) {
      $WebSocket.CloseAsync([System.Net.WebSockets.WebSocketCloseStatus]::NormalClosure, 'bye', [Threading.CancellationToken]::None).GetAwaiter().GetResult() | Out-Null
    }
  } catch {
    Write-Verbose "OBS WebSocket close failed: $($_.Exception.Message)"
  }
  try { $WebSocket.Dispose() } catch { Write-Verbose "OBS WebSocket dispose failed: $($_.Exception.Message)" }
}

# =============================
# Process matching (avoid "name with spaces")
# =============================

function Get-ProcessMatch {
  [CmdletBinding()]
  param(
    [string]$PreferredProcessName,
    [string]$WindowTitleRegex,
    [string]$CommandLineRegex
  )

  $procs = Get-Process -ErrorAction SilentlyContinue

  if ($PreferredProcessName) {
    $hit = $procs | Where-Object { $_.ProcessName -ieq $PreferredProcessName } | Select-Object -First 1
    if ($hit) { return @($hit) }
  }

  if ($WindowTitleRegex) {
    $hits = $procs | Where-Object { $_.MainWindowTitle -and ($_.MainWindowTitle -match $WindowTitleRegex) }
    if ($hits) { return @($hits) }
  }

  if ($CommandLineRegex) {
    try {
      $cim = Get-CimInstance Win32_Process -ErrorAction Stop
      $ids = $cim | Where-Object { $_.CommandLine -and ($_.CommandLine -match $CommandLineRegex) } | Select-Object -ExpandProperty ProcessId
      if ($ids) {
        return @($ids | ForEach-Object { Get-Process -Id $_ -ErrorAction SilentlyContinue } | Where-Object { $_ })
      }
    } catch {
      Write-Verbose "CIM query failed: $($_.Exception.Message)"
    }
  }

  return @()
}

# =============================
# Preflight
# =============================

function Invoke-ZwiftPreflight {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)] $Config
  )

  Add-Type -AssemblyName System.Windows.Forms -ErrorAction SilentlyContinue

  $items = @()

  function Add-Item {
    param(
      [string]$Name,
      [string]$Kind,
      [string]$Path,
      [bool]$Mandatory
    )
    $resolved = Resolve-ConfigPath $Path
    $exists = $false
    if ($resolved) { $exists = Test-Path -LiteralPath $resolved }
    $items += [pscustomobject]@{
      Name      = $Name
      Kind      = $Kind
      Path      = $resolved
      Mandatory = $Mandatory
      Exists    = $exists
    }
  }

  # Mandatory
  Add-Item -Name 'ZwiftLauncher' -Kind 'Exe' -Path $Config.Paths.ZwiftLauncherExe -Mandatory $true
  Add-Item -Name 'FreeFileSync' -Kind 'Exe' -Path $Config.Paths.FreeFileSyncExe -Mandatory ([bool]$Config.FreeFileSync.RunOnExit)
  Add-Item -Name 'ZwiftPicsBatch' -Kind 'Batch' -Path $Config.Paths.ZwiftPicsBatch -Mandatory ([bool]$Config.FreeFileSync.RunOnExit)
  Add-Item -Name 'RecordingsToNasBatch' -Kind 'Batch' -Path $Config.Paths.RecordingsToNasBatch -Mandatory ([bool]$Config.FreeFileSync.RunOnExit)
  Add-Item -Name 'Edge' -Kind 'Exe' -Path $Config.Paths.EdgeExe -Mandatory ([bool]$Config.Browser.LaunchEdge)

  # Optional
  Add-Item -Name 'PowerToys' -Kind 'Exe' -Path $Config.Paths.PowerToysExe -Mandatory $false
  Add-Item -Name 'PowerToysWorkspacesLauncher' -Kind 'Exe' -Path $Config.Paths.PowerToysWorkspacesLauncherExe -Mandatory $false
  Add-Item -Name 'PowerToysAwake' -Kind 'Exe' -Path $Config.Paths.PowerToysAwakeExe -Mandatory $false
  Add-Item -Name 'OBS' -Kind 'Exe' -Path $Config.Paths.ObsExe -Mandatory $false
  Add-Item -Name 'OBSLogDir' -Kind 'Dir' -Path $Config.Paths.ObsLogDir -Mandatory $false

  Add-Item -Name 'ZwiftLog' -Kind 'File' -Path $Config.Paths.ZwiftLog -Mandatory $false
  Add-Item -Name 'ZwiftMediaDir' -Kind 'Dir' -Path $Config.Paths.ZwiftMediaDir -Mandatory $false
  Add-Item -Name 'ZwiftPicturesDir' -Kind 'Dir' -Path $Config.Paths.ZwiftPicturesDir -Mandatory $false

  # Displays
  $displayOk =
    (Test-DisplayIndex -Index $Config.Display.ZwiftDisplayIndex) -and
    (Test-DisplayIndex -Index $Config.Display.DefaultDisplayIndex) -and
    (Test-DisplayIndex -Index $Config.Display.TargetDisplayIndexForConsole)

  # Modules
  $displayConfigAvailable = $null -ne (Get-Module -ListAvailable -Name DisplayConfig)

  $missingMandatory = @($items | Where-Object { $_.Mandatory -and -not $_.Exists })
  $missingOptional  = @($items | Where-Object { -not $_.Mandatory -and -not $_.Exists })

  return [pscustomobject]@{
    Items                 = $items
    DisplayIndicesValid    = $displayOk
    DisplayConfigAvailable = $displayConfigAvailable
    MissingMandatory       = $missingMandatory
    MissingOptional        = $missingOptional
    Success               = ($missingMandatory.Count -eq 0 -and $displayOk)
  }
}

function Show-PreflightSummary {
  param($Report)

  Write-ZwiftLog -Level Info -Message '========== Preflight Summary =========='
  foreach ($i in $Report.Items) {
    $status = if ($i.Exists) { 'OK' } else { if ($i.Mandatory) { 'MISSING' } else { 'missing (optional)' } }
    $lvl = if ($i.Exists) { 'Info' } else { if ($i.Mandatory) { 'Error' } else { 'Warn' } }
    $pathText = if ($null -ne $i.Path) { $i.Path } else { '' }
    Write-ZwiftLog -Level $lvl -Message ("{0,-26} {1,-14} {2}" -f $i.Name, $status, $pathText)
  }

  if (-not $Report.DisplayIndicesValid) {
    Write-ZwiftLog -Level Error -Message "Display indices invalid. Check config.Display.ZwiftDisplayIndex and DefaultDisplayIndex."
  } else {
    Write-ZwiftLog -Level Info -Message 'Display indices: OK'
  }

  if (-not $Report.DisplayConfigAvailable) {
    Write-ZwiftLog -Level Warn -Message 'DisplayConfig module not found. Primary display switching will be skipped unless installed.'
  }

  Write-ZwiftLog -Level Info -Message '======================================='
}

# =============================
# Main orchestration
# =============================

function Invoke-MonitorZwift {
  [CmdletBinding(SupportsShouldProcess = $true)]
  param(
    [Parameter(Mandatory)] $Config
  )

  $root = Split-Path -Parent $MyInvocation.MyCommand.Path
  Start-RunLogging -LoggingConfig $Config.Logging -Root $root

  $preflight = Invoke-ZwiftPreflight -Config $Config
  Show-PreflightSummary -Report $preflight

  if (-not $preflight.Success) {
    Stop-RunLogging
    throw 'Preflight failed. Fix missing mandatory dependencies or invalid display indices.'
  }

  # Import DisplayConfig if available; do not auto-install by default (modern best practice)
  $null = Import-DisplayConfig -InstallIfMissing:$false

  $originalPrimaryDisplay = Get-PrimaryDisplayIndex
  $changedPrimary = $false
  $awakeStarted = $false
  $transparencyApplied = $false

  $obsWs = $null

  try {
    Write-ZwiftLog -Level Info -Message "Original primary display index (0-based): $originalPrimaryDisplay"

  # Config-driven poll interval
  $pollSec = 1
  if ($null -ne $Config.Timeouts.PollSec -and [int]$Config.Timeouts.PollSec -gt 0) {
    $pollSec = [int]$Config.Timeouts.PollSec
  }

  # Window management (best-effort) + MUST-RESTORE in finally
  try {
    $null = Set-HostWindowPosition -DisplayIndex $Config.Display.TargetDisplayIndexForConsole -X $Config.ConsoleWindow.PositionX -Y $Config.ConsoleWindow.PositionY -Width $Config.ConsoleWindow.Width -Height $Config.ConsoleWindow.Height
    $transparencyApplied = Set-HostWindowTransparency -TransparencyPercent $Config.ConsoleWindow.TransparencyPercent
  } catch {
    Write-ZwiftLog -Level Warn -Message "Host window management failed: $($_.Exception.Message)"
  }

  # PowerToys Awake (optional) + MUST-RESTORE in finally
  if ($Config.PowerToys.Awake.Enabled) {
    $seconds = [int]($Config.PowerToys.Awake.Hours * 3600)
    if ($seconds -gt 0) {
      $awakeStarted = Start-PowerToysAwake -AwakeExe $Config.Paths.PowerToysAwakeExe -Seconds $seconds -DisplayOn ([bool]$Config.PowerToys.Awake.DisplayOn)
    }
  }

    # (Optional) set transparency early
    # NOTE: MonitorZwift-v2.ps1 still owns the full window-management feature set.
    # This orchestrator focuses on preflight/timeouts/cleanup + API control.

    # Start Zwift Launcher if Zwift game not running
    $zwiftGame = Get-Process -Name $Config.Processes.ZwiftGameProcessName -ErrorAction SilentlyContinue
    if (-not $zwiftGame) {
      $launcher = Resolve-ConfigPath $Config.Paths.ZwiftLauncherExe
      Write-ZwiftLog -Level Info -Message "Starting Zwift Launcher: $launcher"
      Start-Process -FilePath $launcher | Out-Null
    } else {
      Write-ZwiftLog -Level Info -Message 'Zwift game already running; skipping launcher start.'
    }

    # Wait for launcher
    $launcherProc = Wait-ForProcess -ProcessName $Config.Processes.ZwiftLauncherProcessName -TimeoutSec $Config.Timeouts.ProcessStartSec -PollSec $pollSec -OnTimeout $Config.Timeouts.OnTimeout
    if ($launcherProc) {
      # Switch primary display to Zwift display
      $changedPrimary = Set-PrimaryDisplaySafe -ZeroBasedIndex $Config.Display.ZwiftDisplayIndex
    }

    # PowerToys Workspaces (optional)
    $wsLauncher = Resolve-ConfigPath $Config.Paths.PowerToysWorkspacesLauncherExe
    if ($wsLauncher -and (Test-Path -LiteralPath $wsLauncher)) {
      $missing = $false
      foreach ($p in $Config.PowerToys.LaunchWorkspacesIfAppsMissing) {
        if (-not (Get-Process -Name $p -ErrorAction SilentlyContinue)) { $missing = $true; break }
      }
      if ($missing) {
        Write-ZwiftLog -Level Info -Message 'Launching PowerToys Workspaces...'
        Start-Process -FilePath $wsLauncher -ArgumentList "${($Config.PowerToys.WorkspaceGuid)} 1" | Out-Null
      }
    }

    # Wait for Zwift game start
    $zwiftProc = Wait-ForProcess -ProcessName $Config.Processes.ZwiftGameProcessName -TimeoutSec $Config.Timeouts.ProcessStartSec -PollSec $pollSec -OnTimeout $Config.Timeouts.OnTimeout
    if (-not $zwiftProc) {
      Write-ZwiftLog -Level Warn -Message 'Zwift game did not start within timeout. Continuing with cleanup safeguards only.'
      return
    }

  # Harden window-handle logic: wait for Zwift main window handle then maximize
  try {
    $null = Wait-ForMainWindowHandle -Process $zwiftProc -TimeoutSec $Config.Timeouts.MainWindowHandleSec -PollSec $pollSec -OnTimeout $Config.Timeouts.OnTimeout
    # refresh process object
    $zwiftProc = Get-Process -Id $zwiftProc.Id -ErrorAction SilentlyContinue
    if ($zwiftProc) { $null = Set-ProcessMainWindowState -Process $zwiftProc -State 'Maximize' }
  } catch {
    Write-ZwiftLog -Level Warn -Message "Zwift window maximize failed: $($_.Exception.Message)"
  }

    # Optional: OBS websocket connect (preferred)
    if ($Config.OBS.WebSocket.Enabled) {
      try {
        $secPw = $null
        if ($Config.OBS.WebSocket.Password) {
          # NOTE: config stores the password as plaintext; we immediately convert to SecureString for API calls.
          $secPw = ConvertTo-SecureString -String $Config.OBS.WebSocket.Password -AsPlainText -Force
        }
        $obsWs = Connect-ObsWebSocket -ObsHost $Config.OBS.WebSocket.Host -Port $Config.OBS.WebSocket.Port -Password $secPw -ConnectTimeoutSec $Config.OBS.WebSocket.ConnectTimeoutSec
        Write-ZwiftLog -Level Info -Message 'Connected to OBS WebSocket.'
      } catch {
        Write-ZwiftLog -Level Warn -Message "OBS WebSocket connect failed; will fall back to legacy hotkeys if needed: $($_.Exception.Message)"
      }
    }

    # Spotify: global media play/pause (no focus required)
    if ($Config.Spotify.UseGlobalMediaPlayPause) {
      if (Get-Process -Name $Config.Processes.SpotifyProcessName -ErrorAction SilentlyContinue) {
        Write-ZwiftLog -Level Info -Message 'Toggling Spotify Play/Pause via global media key.'
        Send-MediaPlayPause
      }
    }

    # Wait for ride start marker (optional)
    $zwiftLog = Resolve-ConfigPath $Config.Paths.ZwiftLog
    if ($zwiftLog -and (Test-Path -LiteralPath $zwiftLog)) {
      Write-ZwiftLog -Level Info -Message 'Waiting for Zwift log ride-start markers...'
      $rideStartPatterns = @(
        '\\[ZWATCHDOG\\]: GameFlowState Riding',
        'INFO LEVEL: \\[GameState\\] Starting Ride\\.',
        'INFO LEVEL: \\[GameState\\] ZSF_INITIAL_CHALLENGE_SELECT -> ZSF_RIDE'
      )
      $ok = Wait-ForLogPatterns -LiteralPath $zwiftLog -Patterns $rideStartPatterns -TimeoutSec $Config.Timeouts.ZwiftRidingLogSec -PollSec $pollSec -OnTimeout $Config.Timeouts.OnTimeout -InitialTailLines 2000 -Description 'Zwift ride start in log'
      if ($ok) {
        Write-ZwiftLog -Level Info -Message 'Ride start detected.'
      }
    }

    # OBS recording start (API-first)
    if ($obsWs) {
      try {
        $status = Get-ObsRecordStatus -WebSocket $obsWs
        if (-not $status.outputActive) {
          Write-ZwiftLog -Level Info -Message 'Starting OBS recording via WebSocket.'
          Start-ObsRecordingApi -WebSocket $obsWs
        } else {
          Write-ZwiftLog -Level Info -Message 'OBS recording already active (WebSocket).'
        }
      } catch {
        Write-ZwiftLog -Level Warn -Message "OBS recording control via WebSocket failed: $($_.Exception.Message)"
      }
    }

    # Wait for Zwift game to close (bounded)
    Write-ZwiftLog -Level Info -Message 'Waiting for Zwift game to close...'
    $null = Wait-Until -TimeoutSec $Config.Timeouts.ZwiftSessionMaxSec -PollSec ([Math]::Max(1, [int]($pollSec * 5))) -OnTimeout $Config.Timeouts.OnTimeout -Description 'Zwift game to exit' -Condition {
      -not (Get-Process -Name $Config.Processes.ZwiftGameProcessName -ErrorAction SilentlyContinue)
    }

    Write-ZwiftLog -Level Info -Message 'Zwift session ended.'

  } finally {
    # MUST-RESTORE CLEANUP

  # Best-effort: reset host window transparency to opaque
  if ($transparencyApplied) {
    try { $null = Set-HostWindowTransparency -TransparencyPercent 0 } catch { Write-Verbose "Reset transparency failed: $($_.Exception.Message)" }
  }

    # Stop OBS recording (API-first)
    if ($obsWs) {
      try {
        $status = Get-ObsRecordStatus -WebSocket $obsWs
        if ($status.outputActive) {
          Write-ZwiftLog -Level Info -Message 'Stopping OBS recording via WebSocket.'
          Stop-ObsRecordingApi -WebSocket $obsWs
        }
      } catch {
        Write-ZwiftLog -Level Warn -Message "Failed stopping OBS recording via WebSocket: $($_.Exception.Message)"
      }

      try { Stop-ObsApplicationApi -WebSocket $obsWs } catch { Write-Verbose "Stop-ObsApplicationApi failed: $($_.Exception.Message)" }
      Disconnect-ObsWebSocket -WebSocket $obsWs
    }

    # Restore primary display
    if ($changedPrimary) {
      try {
        Set-PrimaryDisplaySafe -ZeroBasedIndex $originalPrimaryDisplay | Out-Null
      } catch {
        Write-ZwiftLog -Level Warn -Message "Failed to restore primary display: $($_.Exception.Message)"
      }
    }

  # Close Sauce (robust match; avoids assuming process names contain spaces)
  if ($Config.Processes.Sauce) {
    try {
      $sauceProcs = Get-ProcessMatch -PreferredProcessName $Config.Processes.Sauce.PreferredProcessName -WindowTitleRegex $Config.Processes.Sauce.WindowTitleRegex -CommandLineRegex $Config.Processes.Sauce.CommandLineRegex
      if ($sauceProcs -and $PSCmdlet.ShouldProcess('Sauce', 'Stop processes')) {
        $sauceProcs | Stop-Process -Force -ErrorAction SilentlyContinue
        Write-ZwiftLog -Level Info -Message "Closed Sauce-related processes: $($sauceProcs.Count)"
      }
    } catch {
      Write-ZwiftLog -Level Warn -Message "Sauce cleanup failed: $($_.Exception.Message)"
    }
  }

	# Stop PowerToys Awake if we started it
	if ($awakeStarted) {
		$null = Stop-PowerToysAwake
	}

    # FreeFileSync jobs
    if ($Config.FreeFileSync.RunOnExit) {
      try {
        $ffs = Resolve-ConfigPath $Config.Paths.FreeFileSyncExe
        $b1 = Resolve-ConfigPath $Config.Paths.ZwiftPicsBatch
        $b2 = Resolve-ConfigPath $Config.Paths.RecordingsToNasBatch
        Write-ZwiftLog -Level Info -Message 'Starting FreeFileSync batch jobs...'
        Start-Process -FilePath $ffs -ArgumentList "`"$b1`"" | Out-Null
        Start-Process -FilePath $ffs -ArgumentList "`"$b2`"" | Out-Null
      } catch {
        Write-ZwiftLog -Level Warn -Message "FreeFileSync launch failed: $($_.Exception.Message)"
      }
    }

    # Edge app mode
    if ($Config.Browser.LaunchEdge) {
      try {
        $edge = Resolve-ConfigPath $Config.Paths.EdgeExe
        if ($Config.Browser.UseAppMode) {
          foreach ($u in $Config.Browser.Urls) {
            Start-Process -FilePath $edge -ArgumentList @('--new-window', "--app=$u") | Out-Null
          }
        } else {
          Start-Process -FilePath $edge -ArgumentList @($Config.Browser.Urls) | Out-Null
        }
      } catch {
        Write-ZwiftLog -Level Warn -Message "Edge launch failed: $($_.Exception.Message)"
      }
    }

    # Explorer
    if ($Config.FileExplorer.OpenFolders) {
      foreach ($p in @($Config.Paths.ZwiftMediaDir, $Config.Paths.ZwiftPicturesDir)) {
        $rp = Resolve-ConfigPath $p
        if ($rp -and (Test-Path -LiteralPath $rp)) {
          try { Start-Process -FilePath 'explorer.exe' -ArgumentList "`"$rp`"" | Out-Null } catch { Write-Verbose "Explorer open failed: $($_.Exception.Message)" }
        }
      }
    }

    Stop-RunLogging
  }
}

Export-ModuleMember -Function Invoke-MonitorZwift, Invoke-ZwiftPreflight
