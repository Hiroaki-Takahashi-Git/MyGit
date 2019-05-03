@ECHO OFF
SETLOCAL enabledelayedexpansion
	FOR /F "usebackq" %%f IN (`ECHO %~n1`) DO (
		SET BASENAME=%%f
	)
	FOR /F "usebackq" %%f IN (`ECHO %~x1`) DO (
		SET EXT=%%f
	)
	SET FNAME=!BASENAME!!EXT!
	ECHO !FNAME!
ENDLOCAL