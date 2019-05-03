@ECHO OFF
SETLOCAL enabledelayedexpansion
SET ROOTDIR=%1
SET WORKDIR=%CD%

dir /A-D /S /B %ROOTDIR% | findstr "\.c$ \.cpp$ \.h$ \.hpp$ \.cmake$ \.pc$" > %WORKDIR%\list.txt
FOR /F "usebackq" %%f IN (`type list.txt`) DO (
	SET FNAME1=%%f
	ECHO !FNAME1!
	
	REM	処理01
	REM	ループで出力されたファイルを一時的に別の名前にする
	FOR /F "usebackq" %%i IN (`%WORKDIR%\02_Extract_FileName.bat !FNAME1!`) DO (
		SET FNAME2=%%i
	)
	FOR /F "usebackq" %%j IN (`%WORKDIR%\03_Extract_DirPath.bat !FNAME1!`) DO (
		SET DPATH=%%j
	)
	cd !DPATH!
	SET FNAME3=!FNAME2!.tmp
	ECHO !FNAME3!
	REN !FNAME1! !FNAME3!
	
	REM	処理02
	REM	nkfを使い、tmpをSJISに変換する
	nkf -sLw !FNAME3! > !FNAME1!

	REM	処理03
	REM	使い終わったtmpファイルを削除する
	del /Q /S !FNAME3!
)

REM	処理04
REM	リストファイルを削除する
del /Q /S %WORKDIR%\list.txt
ENDLOCAL