@ECHO OFF
SETLOCAL enabledelayedexpansion
FOR /F "usebackq" %%f IN (`ECHO %~dp1`) DO (
REM	FOR /F "usebackq" %%f in (`ECHO %~fs1`) DO (
		SET DIRPATH=%%f
	)
	ECHO !DIRPATH!
ENDLOCAL