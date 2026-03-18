@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
set "SCRIPT=%SCRIPT_DIR%MonitorZwift.ps1"

if not exist "%SCRIPT%" (
  echo MonitorZwift.ps1 not found:
  echo   "%SCRIPT%"
  pause
  exit /b 1
)

where pwsh.exe >nul 2>nul
if %ERRORLEVEL% EQU 0 (
  set "PS_EXE=pwsh.exe"
) else (
  set "PS_EXE=powershell.exe"
)

echo Launching modern MonitorZwift via %PS_EXE%...
"%PS_EXE%" -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT%"
set "EXITCODE=%ERRORLEVEL%"

if not "%EXITCODE%"=="0" (
  echo.
  echo MonitorZwift exited with code %EXITCODE%.
  pause
)

exit /b %EXITCODE%
