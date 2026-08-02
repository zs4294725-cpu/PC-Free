echo off
title Windows VM Install Tweaks

echo Applying install tweaks...

:: Enable verbose startup/shutdown messages
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v VerboseStatus /t REG_DWORD /d 1 /f

:: Disable Explorer startup delay
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /t REG_DWORD /d 0 /f

:: Enable built-in Administrator account
net user Administrator /active:yes

echo Install complete.

exit /b 0
