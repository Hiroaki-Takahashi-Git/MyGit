@echo off
setlocal
rem	set DEVELOPROOT=C:\Develop
rem set PERLROOT=C:\Develop\Perl
rem set PYTHONROOT=C:\Develop\Python
rem set PYTHON2=%PYTHONROOT%\Python2
rem set PYTHON3=%PYTHONROOT%\Python3

rem	perlのアップグレード
rem	ppm upgrade -install

rem	pythonのアップグレード
rem	python2.7
rem	python2.7のpipのアップグレード
rem cd /d %PYTHON2%
rem python -m pip install --upgrade pip
rem rem	モジュールの一括アップグレード
rem python -c "import sys;from subprocess import call,check_output;p=[sys.executable,'-m','pip'];[call(p+['install','-U',n.split('=')[0]])for n in['pip']+check_output(p+['freeze']).decode().splitlines()]"

rem python3.6
rem	python3.6のpipのアップグレード
rem cd /d %PYTHON3%
python -m pip install --upgrade pip
rem	モジュールの一括アップグレード
python -c "import sys;from subprocess import call,check_output;p=[sys.executable,'-m','pip'];[call(p+['install','-U',n.split('=')[0]])for n in['pip']+check_output(p+['freeze']).decode().splitlines()]"

endlocal
@echo on