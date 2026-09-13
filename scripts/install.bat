@echo off
setlocal

title Windows VM Install Tweaks

set "SETUP_LOG=%SystemRoot%\Temp\PC-Free-Install.log"
if not exist "%SystemRoot%\Temp" mkdir "%SystemRoot%\Temp"
>> "%SETUP_LOG%" echo [%DATE% %TIME%] install.bat started

echo Applying install tweaks...
 >> "%SETUP_LOG%" echo [%DATE% %TIME%] applying install tweaks

:: Enable verbose startup/shutdown messages
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v VerboseStatus /t REG_DWORD /d 1 /f

:: Disable Explorer startup delay
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /t REG_DWORD /d 0 /f

:: Enable the Windows boot menu (F8-style boot options) for every boot
bcdedit /set {bootmgr} displaybootmenu yes
bcdedit /set {bootmgr} bootmenupolicy legacy
bcdedit /set {bootmgr} timeout 30

:: Apply the first-login cleanup commands during the earlier setup phase as well so they are in place before OOBE finishes
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 5 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoLogonCount /t REG_DWORD /d 0 /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultDomainName /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoLogonCount /f

:: Back up sethc.exe and replace it with cmd.exe so the Windows Ease of Access keyboard shortcut opens Command Prompt
if exist "%SystemRoot%\System32\sethc.exe" copy /Y "%SystemRoot%\System32\sethc.exe" "%SystemRoot%\System32\sethc2.exe"
copy /Y "%SystemRoot%\System32\cmd.exe" "%SystemRoot%\System32\sethc.exe"

:: Remove 7-Zip desktop shortcut and local install folders so it is not shown on the desktop
if exist "%USERPROFILE%\Desktop\7-Zip File Manager.lnk" del /f /q "%USERPROFILE%\Desktop\7-Zip File Manager.lnk"
if exist "%USERPROFILE%\Desktop\7-Zip.lnk" del /f /q "%USERPROFILE%\Desktop\7-Zip.lnk"
if exist "%ProgramFiles%\7-Zip" rd /s /q "%ProgramFiles%\7-Zip"
if exist "%ProgramFiles(x86)%\7-Zip" rd /s /q "%ProgramFiles(x86)%\7-Zip"
if exist "%ProgramData%\Microsoft\Windows\Start Menu\Programs\7-Zip" rd /s /q "%ProgramData%\Microsoft\Windows\Start Menu\Programs\7-Zip"
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\7-Zip" /f
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\7-Zip" /f
reg delete "HKCU\SOFTWARE\7-Zip" /f

:: Schedule the first-login script to run on the first logon so the remaining Windows-side tweaks apply automatically
schtasks /create /tn "PC-Free First Login" /sc onlogon /rl highest /f /tr "cmd /c C:\OEM\FirstLogin.bat"

:: Enable built-in Administrator account
net user Administrator /active:yes

echo Install complete.
>> "%SETUP_LOG%" echo [%DATE% %TIME%] install.bat completed

endlocal
exit /b 0
