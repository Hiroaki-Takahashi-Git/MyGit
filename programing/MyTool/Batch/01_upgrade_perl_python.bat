@echo off
setlocal
rem	set DEVELOPROOT=C:\Develop
set PERLROOT=C:\Perl
set PYTHONROOT=C:\Python
set PYTHON27=%PYTHONROOT%\Python27
set PYTHON36=%PYTHONROOT%\Python36

rem	perlのアップグレード
ppm upgrade -install

rem	pythonのアップグレード
rem	python2.7
rem	python2.7のpipのアップグレード
rem cd /d %PYTHON27%
rem python -m pip install --upgrade pip
rem rem	モジュールの一括アップグレード
rem python -c "import sys;from subprocess import call,check_output;p=[sys.executable,'-m','pip'];[call(p+['install','-U',n.split('=')[0]])for n in['pip']+check_output(p+['freeze']).decode().splitlines()]"

rem python3.6
rem	python3.6のpipのアップグレード
cd /d %PYTHON36%
python -m pip install --upgrade pip
rem	モジュールの一括アップグレード
python -c "import sys;from subprocess import call,check_output;p=[sys.executable,'-m','pip'];[call(p+['install','-U',n.split('=')[0]])for n in['pip']+check_output(p+['freeze']).decode().splitlines()]"

endlocal
@echo on