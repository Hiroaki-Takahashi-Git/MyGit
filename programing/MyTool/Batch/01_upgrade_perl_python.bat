@echo off
setlocal
rem	set DEVELOPROOT=C:\Develop
set PERLROOT=C:\Develop\Perl
set PYTHONROOT=C:\Develop\Python
set PYTHON2=%PYTHONROOT%\Python2
set PYTHON3=%PYTHONROOT%\Python3

rem	perlのアップグレード
rem	ppm upgrade -install

rem	pythonのアップグレード
rem	python2.7
rem	python2.7のpipのアップグレード
cd /d %PYTHON2%
python -m pip install --upgrade pip
rem	モジュールの一括アップグレード
python -c "import sys;from subprocess import call,check_output;p=[sys.executable,'-m','pip'];[call(p+['install','-U',n.split('=')[0]])for n in['pip']+check_output(p+['freeze']).decode().splitlines()]"

rem python3.6
rem	python3.6のpipのアップグレード
cd /d %PYTHON3%
python -m pip install --upgrade pip
rem	モジュールの一括アップグレード
python -c "import sys;from subprocess import call,check_output;p=[sys.executable,'-m','pip'];[call(p+['install','-U',n.split('=')[0]])for n in['pip']+check_output(p+['freeze']).decode().splitlines()]"

endlocal
@echo on