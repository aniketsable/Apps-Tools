@echo off
setlocal

:: Create a log file
set "LOGFILE=%TEMP%\cleanup_log.txt"
echo Cleanup and Optimization Log > "%LOGFILE%"

:: Function to log messages
:log
echo %~1 >> "%LOGFILE%"
echo %~1
goto :eof

:: Start logging
call :log "Starting system cleanup and optimization..."

:: Disable Windows Defender Real-Time Protection temporarily
echo Disabling Windows Defender Real-Time Protection...
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true" >nul 2>&1
if %ERRORLEVEL% neq 0 (
    call :log "Failed to disable Windows Defender Real-Time Protection."
) else (
    call :log "Successfully disabled Windows Defender Real-Time Protection."
)

:: Clear Temporary Files
echo Clearing Temporary Files...
del /q/f/s "%TEMP%\*" 2>nul
if %ERRORLEVEL% neq 0 (
    call :log "Failed to clear Temporary Files."
) else (
    call :log "Successfully cleared Temporary Files."
)

:: Clear Prefetch Files
echo Clearing Prefetch Files...
del /q/f/s "C:\Windows\Prefetch\*" 2>nul
if %ERRORLEVEL% neq 0 (
    call :log "Failed to clear Prefetch Files."
) else (
    call :log "Successfully cleared Prefetch Files."
)

:: Clear Recent Documents
echo Clearing Recent Documents...
del /q/f "%APPDATA%\Microsoft\Windows\Recent\*" 2>nul
if %ERRORLEVEL% neq 0 (
    call :log "Failed to clear Recent Documents."
) else (
    call :log "Successfully cleared Recent Documents."
)

:: Clear Windows Update Cache
echo Clearing Windows Update Cache...
net stop wuauserv 2>nul
del /f/q "%windir%\SoftwareDistribution\*" 2>nul
net start wuauserv 2>nul
if %ERRORLEVEL% neq 0 (
    call :log "Failed to clear Windows Update Cache."
) else (
    call :log "Successfully cleared Windows Update Cache."
)

:: Empty Recycle Bin
echo Emptying Recycle Bin...
rd /s/q "%systemdrive%\$Recycle.Bin" 2>nul
if %ERRORLEVEL% neq 0 (
    call :log "Failed to empty Recycle Bin."
) else (
    call :log "Successfully emptied Recycle Bin."
)

:: Clear Thumbnail Cache
echo Clearing Thumbnail Cache...
del /f/q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" 2>nul
if %ERRORLEVEL% neq 0 (
    call :log "Failed to clear Thumbnail Cache."
) else (
    call :log "Successfully cleared Thumbnail Cache."
)

:: Clear Temporary Internet Files
echo Clearing Temporary Internet Files...
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8
if %ERRORLEVEL% neq 0 (
    call :log "Failed to clear Temporary Internet Files."
) else (
    call :log "Successfully cleared Temporary Internet Files."
)

:: Clear Windows Error Reporting Logs
echo Clearing Windows Error Reporting Logs...
del /q/f "%LOCALAPPDATA%\CrashDumps\*" 2>nul
del /q/f "%LOCALAPPDATA%\Microsoft\Windows\WER\*" 2>nul
if %ERRORLEVEL% neq 0 (
    call :log "Failed to clear Windows Error Reporting Logs."
) else (
    call :log "Successfully cleared Windows Error Reporting Logs."
)

:: Clear Event Logs
echo Clearing Event Logs...
for /f "tokens=*" %%V in ('wevtutil.exe el') do (
    wevtutil.exe cl "%%V" 2>nul
)
if %ERRORLEVEL% neq 0 (
    call :log "Failed to clear Event Logs."
) else (
    call :log "Successfully cleared Event Logs."
)

:: Run Disk Cleanup
echo Running Disk Cleanup...
cleanmgr /sageset:65535 >nul
cleanmgr /sagerun:65535 >nul
if %ERRORLEVEL% neq 0 (
    call :log "Failed to run Disk Cleanup."
) else (
    call :log "Successfully ran Disk Cleanup."
)

:: Defragment and Optimize Drives
echo Defragmenting and Optimizing Drives...
defrag "%systemdrive%" /O
if %ERRORLEVEL% neq 0 (
    call :log "Failed to defragment and optimize drives."
) else (
    call :log "Successfully defragmented and optimized drives."
)

:: Run System File Checker
echo Running System File Checker...
sfc /scannow
if %ERRORLEVEL% neq 0 (
    call :log "System File Checker found issues."
) else (
    call :log "System File Checker completed successfully."
)

:: Run Disk Check (Optional)
echo Running Disk Check...
echo This may require a restart if errors are found.
chkdsk /f /r
if %ERRORLEVEL% neq 0 (
    call :log "Failed to run Disk Check."
) else (
    call :log "Disk Check completed successfully."
)

:: Enable Windows Defender Real-Time Protection
echo Enabling Windows Defender Real-Time Protection...
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $false" >nul 2>&1
if %ERRORLEVEL% neq 0 (
    call :log "Failed to enable Windows Defender Real-Time Protection."
) else (
    call :log "Successfully enabled Windows Defender Real-Time Protection."
)

:: Update Windows Defender Definitions
echo Updating Windows Defender Definitions...
powershell -Command "Update-MpSignature" >nul 2>&1
if %ERRORLEVEL% neq 0 (
    call :log "Failed to update Windows Defender Definitions."
) else (
    call :log "Successfully updated Windows Defender Definitions."
)

:: Quick Scan with Windows Defender
echo Running Quick Scan with Windows Defender...
start "" "C:\Program Files\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1
if %ERRORLEVEL% neq 0 (
    call :log "Failed to run Quick Scan with Windows Defender."
) else (
    call :log "Successfully initiated Quick Scan with Windows Defender."
)

:: Adjust System Settings for Performance
echo Adjusting System Settings for Performance...
powershell -Command "Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'MenuShowDelay' -Value '0'" >nul 2>&1
powershell -Command "Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Performance\PerformanceData' -Name 'Enable' -Value '0'" >nul 2>&1
if %ERRORLEVEL% neq 0 (
    call :log "Failed to adjust system settings for performance."
) else (
    call :log "Successfully adjusted system settings for performance."
)

:: Additional Optimizations
echo Performing Additional Optimizations...
powercfg /hibernate off >nul 2>&1
powercfg /change monitor-timeout-ac 5 >nul 2>&1
powercfg /change monitor-timeout-dc 2 >nul 2>&1
if %ERRORLEVEL% neq 0 (
    call :log "Failed to perform additional optimizations."
) else (
    call :log "Successfully performed additional optimizations."
)

:: End of script
call :log "All tasks completed successfully!"
echo All tasks completed successfully!
pause
