@echo off
setlocal
rem	set DEVELOPROOT=C:\Develop
set PERLROOT=C:\Perl
set PYTHONROOT=C:\Python
set PYTHON27=%PYTHONROOT%\Python27
set PYTHON36=%PYTHONROOT%\Python36

rem	perl�̃A�b�v�O���[�h
ppm upgrade -install

rem	python�̃A�b�v�O���[�h
rem	python2.7
rem	python2.7��pip�̃A�b�v�O���[�h
rem cd /d %PYTHON27%
rem python -m pip install --upgrade pip
rem rem	���W���[���̈ꊇ�A�b�v�O���[�h
rem python -c "import sys;from subprocess import call,check_output;p=[sys.executable,'-m','pip'];[call(p+['install','-U',n.split('=')[0]])for n in['pip']+check_output(p+['freeze']).decode().splitlines()]"

rem python3.6
rem	python3.6��pip�̃A�b�v�O���[�h
cd /d %PYTHON36%
python -m pip install --upgrade pip
rem	���W���[���̈ꊇ�A�b�v�O���[�h
python -c "import sys;from subprocess import call,check_output;p=[sys.executable,'-m','pip'];[call(p+['install','-U',n.split('=')[0]])for n in['pip']+check_output(p+['freeze']).decode().splitlines()]"

endlocal
@echo on