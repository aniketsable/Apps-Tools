@echo off
echo Running System Cleanup and Optimization Script...

:: Disable Windows Defender Real-Time Protection temporarily
echo Disabling Windows Defender Real-Time Protection...
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true" || exit /b %errorlevel%

:: Clear Temporary Files
echo Clearing Temporary Files...
del /q/f/s %TEMP%\* 2>nul || exit /b %errorlevel%

:: Clear Prefetch Files
echo Clearing Prefetch Files...
del /q/f/s C:\Windows\Prefetch\* 2>nul || exit /b %errorlevel%

:: Clear Recent Documents
echo Clearing Recent Documents...
del /q/f %APPDATA%\Microsoft\Windows\Recent\* 2>nul || exit /b %errorlevel%

:: Clear Windows Update Cache
echo Clearing Windows Update Cache...
net stop wuauserv 2>nul || exit /b %errorlevel%
del /f/q %windir%\SoftwareDistribution\* 2>nul || exit /b %errorlevel%
net start wuauserv 2>nul || exit /b %errorlevel%

:: Empty Recycle Bin
echo Emptying Recycle Bin...
rd /s/q %systemdrive%\$Recycle.Bin 2>nul || exit /b %errorlevel%

:: Clear Thumbnail Cache
echo Clearing Thumbnail Cache...
del /f/q %LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db 2>nul || exit /b %errorlevel%

:: Clear Temporary Internet Files
echo Clearing Temporary Internet Files...
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8 || exit /b %errorlevel%

:: Clear Windows Error Reporting Logs
echo Clearing Windows Error Reporting Logs...
del /q/f %LOCALAPPDATA%\CrashDumps\* 2>nul || exit /b %errorlevel%
del /q/f %LOCALAPPDATA%\Microsoft\Windows\WER\* 2>nul || exit /b %errorlevel%

:: Clear Event Logs
echo Clearing Event Logs...
for /f "tokens=*" %%V in ('wevtutil.exe el') do wevtutil.exe cl "%%V" 2>nul || exit /b %errorlevel%

:: Run Disk Cleanup
echo Running Disk Cleanup...
cleanmgr /sageset:65535 >nul || exit /b %errorlevel%
cleanmgr /sagerun:65535 >nul || exit /b %errorlevel%

:: Defragment and Optimize Drives
echo Defragmenting and Optimizing Drives...
defrag %systemdrive% /O || exit /b %errorlevel%

:: Run System File Checker
echo Running System File Checker...
sfc /scannow || exit /b %errorlevel%

:: Run Disk Check (Optional)
echo Running Disk Check...
echo This may require a restart if errors are found.
chkdsk /f /r || exit /b %errorlevel%

:: Enable Windows Defender Real-Time Protection
echo Enabling Windows Defender Real-Time Protection...
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $false" || exit /b %errorlevel%

:: Update Windows Defender Definitions
echo Updating Windows Defender Definitions...
powershell -Command "Update-MpSignature" || exit /b %errorlevel%

:: Quick Scan with Windows Defender
echo Running Quick Scan with Windows Defender...
start "" "C:\Program Files\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1 || exit /b %errorlevel%

:: Adjust System Settings for Performance
echo Adjusting System Settings for Performance...
powershell -Command "Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'MenuShowDelay' -Value '0'" || exit /b %errorlevel%
powershell -Command "Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Performance\PerformanceData' -Name 'Enable' -Value '0'" || exit /b %errorlevel%

:: Additional Optimizations
echo Performing Additional Optimizations...
powercfg /hibernate off || exit /b %errorlevel%
powercfg /change monitor-timeout-ac 5 || exit /b %errorlevel%
powercfg /change monitor-timeout-dc 2 || exit /b %errorlevel%

echo All tasks completed successfully!
pause
