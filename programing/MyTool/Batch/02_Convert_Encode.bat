@ECHO OFF
SETLOCAL enabledelayedexpansion
SET ROOTDIR=%1
SET WORKDIR=%CD%

dir /A-D /S /B %ROOTDIR% | findstr "\.c$ \.cpp$ \.h$ \.hpp$ \.cmake$ \.pc$" > %WORKDIR%\list.txt
FOR /F "usebackq" %%f IN (`type list.txt`) DO (
	SET FNAME1=%%f
	ECHO !FNAME1!
	
	REM	����01
	REM	���[�v�ŏo�͂��ꂽ�t�@�C�����ꎞ�I�ɕʂ̖��O�ɂ���
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
	
	REM	����02
	REM	nkf���g���Atmp��SJIS�ɕϊ�����
	nkf -sLw !FNAME3! > !FNAME1!

	REM	����03
	REM	�g���I�����tmp�t�@�C�����폜����
	del /Q /S !FNAME3!
)

REM	����04
REM	���X�g�t�@�C�����폜����
del /Q /S %WORKDIR%\list.txt
ENDLOCAL