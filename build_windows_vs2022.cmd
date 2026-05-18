@echo off

echo Check Visual Studio version
IF EXIST "c:\Program Files\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe" (
echo -- Using Visual Studio 2022 Professional Path
set "MSBUILD=c:\Program Files\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe"
) else (
   IF EXIST "c:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe" (
      echo -- Using Visual Studio 2022 Community Path
      set "MSBUILD=c:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe"
   ) else (   
      set "MSBUILD=c:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe"
   )
)

set "JOLT_PHYSICS_ROOT=%cd%\submodules\JoltPhysics"
set "JOLTC_ROOT=%cd%\submodules\joltc"
set "JOLTC_CMAKE_PATCH=%cd%\csrc\joltc_cmake.patch"
set "JOLTC_PATCH_APPLIED=0"

git -C "%JOLTC_ROOT%" apply --check "%JOLTC_CMAKE_PATCH%"
IF %ERRORLEVEL% EQU 0 (
   git -C "%JOLTC_ROOT%" apply "%JOLTC_CMAKE_PATCH%"
   set "JOLTC_PATCH_APPLIED=1"
) else (
   git -C "%JOLTC_ROOT%" apply --reverse --check "%JOLTC_CMAKE_PATCH%"
   IF %ERRORLEVEL% EQU 0 (
      echo joltc CMake patch is already applied
      set "JOLTC_PATCH_APPLIED=1"
   ) else (
      echo Failed to apply joltc CMake patch
      exit /b 1
   )
)

pushd submodules\joltc\build
call cmake_vs2022_x64.bat -DJPH_BUILD_SHARED=OFF -DJPH_SAMPLES=OFF -DJPH_INSTALL=OFF
set "CMAKE_ERRORLEVEL=%ERRORLEVEL%"
popd
IF NOT "%CMAKE_ERRORLEVEL%"=="0" (
   IF "%JOLTC_PATCH_APPLIED%"=="1" (
      git -C "%JOLTC_ROOT%" apply --reverse "%JOLTC_CMAKE_PATCH%"
      set "JOLTC_PATCH_APPLIED=0"
   )
   exit /b %CMAKE_ERRORLEVEL%
)

IF EXIST "%MSBUILD%" (
echo Building box2d Debug in Visual Studio 2022
call "%MSBUILD%" "submodules\joltc\build\vs2022_x64\joltc.sln" -consoleLoggerParameters:ShowTimestamp;Summary -verbosity:minimal -maxCpuCount -p:Platform=x64 -p:Configuration=Debug /m
echo ErrorLevel:%ERRORLEVEL%
IF %ERRORLEVEL% EQU 0 (
   echo Build successful!
) else (
   echo Build failed!
)
echo Building box2d Release in Visual Studio 2022
call "%MSBUILD%" "submodules\joltc\build\vs2022_x64\joltc.sln" -consoleLoggerParameters:ShowTimestamp;Summary -verbosity:minimal -maxCpuCount -p:Platform=x64 -p:Configuration=Release /m
echo ErrorLevel:%ERRORLEVEL%
IF %ERRORLEVEL% EQU 0 (
   echo Build successful!
) else (
   echo Build failed!
)
) else (
echo Visual Studio 2022 not found! Open '.build\projects\vs2022\box2d.sln' yourself and build it with your own version (NOTE you'll need to change vs2022 above to your installed version)
)

IF "%JOLTC_PATCH_APPLIED%"=="1" (
   git -C "%JOLTC_ROOT%" apply --reverse "%JOLTC_CMAKE_PATCH%"
   set "JOLTC_PATCH_APPLIED=0"
)
