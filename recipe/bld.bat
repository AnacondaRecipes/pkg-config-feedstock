@echo ON

:: Determine platform (PLAT) and linker machine type (LDFLAGS_ARCH) from target_platform
:: Makefile.vc outputs to $(CFG)\$(PLAT)\pkg-config.exe
if "%target_platform%" == "win-arm64" (
  set "PLAT=ARM64"
  set "LDFLAGS_ARCH=/machine:ARM64"
) else if "%target_platform%" == "win-64" (
  set "PLAT=x64"
  set "LDFLAGS_ARCH=/machine:X64"
) else if "%target_platform%" == "win-32" (
  set "PLAT=Win32"
  set "LDFLAGS_ARCH=/machine:X86"
) else (
  :: Fallback for older conda-build versions using ARCH
  if "%ARCH%" == "64" (
    set "PLAT=x64"
    set "LDFLAGS_ARCH=/machine:X64"
  ) else (
    set "PLAT=Win32"
    set "LDFLAGS_ARCH=/machine:X86"
  )
)

echo Building for platform: %PLAT% (linker: %LDFLAGS_ARCH%)

:: Pre-create output directories (Makefile.vc's mkdir may fail due to Unix mkdir in PATH)
if not exist release\%PLAT%\pkg-config mkdir release\%PLAT%\pkg-config

nmake /f Makefile.vc CFG=release GLIB_PREFIX=%LIBRARY_PREFIX% PLAT=%PLAT% LDFLAGS_ARCH=%LDFLAGS_ARCH%
if errorlevel 1 exit 1

copy release\%PLAT%\pkg-config.exe %LIBRARY_PREFIX%\bin\pkg-config.exe
if errorlevel 1 exit 1
