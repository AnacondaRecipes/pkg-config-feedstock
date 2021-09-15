@echo ON

if "%ARCH%" == "64" (
  mkdir release\
  mkdir release\x64
  mkdir release\x64\pkg-config

) else (
  mkdir release\
  mkdir release\Win32
  mkdir release\Win32\pkg-config
)
nmake /f Makefile.vc CFG=release GLIB_PREFIX=%LIBRARY_PREFIX%
if errorlevel 1 exit 1

if "%ARCH%" == "64" (
  copy release\x64\pkg-config.exe %LIBRARY_PREFIX%\bin\pkg-config.exe
) else (
  copy release\Win32\pkg-config.exe %LIBRARY_PREFIX%\bin\pkg-config.exe
)

if errorlevel 1 exit 1
