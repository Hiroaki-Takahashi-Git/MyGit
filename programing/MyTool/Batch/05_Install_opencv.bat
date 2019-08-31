@echo off
setlocal
SET DEVELOPDIR=C:\Develop

SET VCPKGROOT=%DEVELOPDIR%\vcpkg\installed
SET VCPKG_X64=%VCPKGROOT%\x64-windows
SET VCPKG_SHARE=%VCPKG_X64%\share
SET VCPKG_LIBS=%VCPKG_X64%\lib
SET VCPKG_INCLUDE=%VCPKG_X64%\include

SET OPENCV_ROOT=%DEVELOPDIR%\OpenCV
SET OPENCV_BASE=%OPENCV_ROOT%\opencv_base
SET OPENCV_EXTRA=%OPENCV_ROOT%\opencv_extra\opencv_contrib

SET OPENCV_BUILD=%OPENCV_BASE%\opencv_build
SET OPENCV_INSTALL=%OPENCV_BASE%\opencv_install

cd /d %OPENCV_BUILD%
del /Q /S .\*.vcxproj
IF EXIST "CmakeCache.txt" (
	del /Q /S CmakeCache.txt
)
cmake -G "Visual Studio 15 2017 Win64" %OPENCV_BASE%\opencv ^
-DCMAKE_INSTALL_PREFIX=%OPENCV_INSTALL% ^
-DOPENCV_EXTRA_MODULES_PATH=%OPENCV_EXTRA%\modules ^
-DCMAKE_TOOLCHAIN_FILE=C:\Develop\vcpkg\scripts\buildsystems\vcpkg.cmake ^
-DBUILD_opencv_text=ON

msbuild INSTALL.vcxproj /t:clean;rebuild /p:Configuration=Release;Platform="x64"
msbuild INSTALL.vcxproj /t:clean;rebuild /p:Configuration=Debug;Platform="x64"
endlocal
@echo on
