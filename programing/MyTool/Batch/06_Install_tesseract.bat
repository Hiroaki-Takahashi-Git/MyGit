@echo off
setlocal
SET DEVELOPDIR=C:\Develop

SET VCPKGROOT=%DEVELOPDIR%\vcpkg\installed
SET VCPKG_X64=%VCPKGROOT%\x64-windows
SET VCPKG_SHARE=%VCPKG_X64%\share
SET VCPKG_LIBS=%VCPKG_X64%\lib
SET VCPKG_INCLUDE=%VCPKG_X64%\include

SET TESSERACT_ROOT=%DEVELOPDIR%\OCR

SET TESSERACT_BUILD=%TESSERACT_ROOT%\tesseract_build
SET TESSERACT_INSTALL=%TESSERACT_BASE%\tesseract_install

cd /d %TESSERACT_BUILD%
del /Q /S .\*.vcxproj
IF EXIST "CmakeCache.txt" (
	del /Q /S CmakeCache.txt
)
echo "CMake実行中"
cmake -G "Visual Studio 15 2017 Win64" %TESSERACT_ROOT%\tesseract ^
-DCMAKE_INSTALL_PREFIX=%TESSERACT_INSTALL% ^
-DCMAKE_TOOLCHAIN_FILE=C:\Develop\vcpkg\scripts\buildsystems\vcpkg.cmake > cmake_configure.log 2>&1
echo "CMake完了"
echo "Tesseract(Release)ビルド中"
msbuild Tesseract.sln /t:clean;rebuild /p:Configuration=Release;Platform="x64" > build_release.log 2>&1
echo "Tesseract(Release)ビルド終了"
echo "Tesseract(Debug)ビルド中"
msbuild Tesseract.sln /t:clean;rebuild /p:Configuration=Debug;Platform="x64" > build_debug.log 2>&1
echo "Tesseract(Debug)ビルド終了"
endlocal
@echo on
