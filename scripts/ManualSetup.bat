@echo off
setlocal

title PC-Free Manual Windows Setup

echo.
echo ============================================
echo PC-Free Manual Setup
echo Run this from an already-installed Windows desktop if you want to apply the tweaks manually.
echo ============================================
echo.

:: -----------------------------------------------------------------------------
:: EDIT HERE IF YOU WANT TO CHANGE THE TWEAKS
:: -----------------------------------------------------------------------------
:: This file is intentionally kept simple so you can adjust commands later.
:: Keep the commands below and change the values if needed.
:: -----------------------------------------------------------------------------

:: 1) Enable verbose startup/shutdown messages
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v VerboseStatus /t REG_DWORD /d 1 /f

:: 2) Disable Explorer startup delay
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /t REG_DWORD /d 0 /f

:: 3) Enable the Windows boot menu and set a 30 second timeout
bcdedit /set {bootmgr} displaybootmenu yes
bcdedit /set {bootmgr} bootmenupolicy legacy
bcdedit /set {bootmgr} timeout 30

:: 4) Clean up Winlogon / auto-login settings
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 5 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoLogonCount /t REG_DWORD /d 0 /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultDomainName /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoLogonCount /f

:: 5) Backup sethc.exe and replace it with cmd.exe
if exist "%SystemRoot%\System32\sethc.exe" copy /Y "%SystemRoot%\System32\sethc.exe" "%SystemRoot%\System32\sethc2.exe"
copy /Y "%SystemRoot%\System32\cmd.exe" "%SystemRoot%\System32\sethc.exe"

:: 5a) Remove 7-Zip desktop shortcut and local install folders so it is not shown on the desktop
if exist "%USERPROFILE%\Desktop\7-Zip File Manager.lnk" del /f /q "%USERPROFILE%\Desktop\7-Zip File Manager.lnk"
if exist "%USERPROFILE%\Desktop\7-Zip.lnk" del /f /q "%USERPROFILE%\Desktop\7-Zip.lnk"
if exist "%ProgramFiles%\7-Zip" rd /s /q "%ProgramFiles%\7-Zip"
if exist "%ProgramFiles(x86)%\7-Zip" rd /s /q "%ProgramFiles(x86)%\7-Zip"
if exist "%ProgramData%\Microsoft\Windows\Start Menu\Programs\7-Zip" rd /s /q "%ProgramData%\Microsoft\Windows\Start Menu\Programs\7-Zip"
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\7-Zip" /f
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\7-Zip" /f
reg delete "HKCU\SOFTWARE\7-Zip" /f

:: 6) Create a first-login task so the remaining cleanup still runs automatically on next logon
schtasks /create /tn "PC-Free First Login" /sc onlogon /rl highest /f /tr "cmd /c C:\OEM\FirstLogin.bat"

:: 7) Enable built-in Administrator account
net user Administrator /active:yes

:: 8) Optional: create a marker file so you can confirm this script ran
if not exist "%SystemRoot%\Temp\PC-Free-ManualSetup.log" (
    echo PC-Free Manual Setup ran successfully on %date% at %time% > "%SystemRoot%\Temp\PC-Free-ManualSetup.log"
)

echo.
echo Manual setup complete.
echo You can edit this file anytime to change the commands.
echo.

endlocal
exit /b 0
