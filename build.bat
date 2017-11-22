set DLIB_ZIP=http://dlib.net/files/dlib-19.7.zip 
set OPEN_SSL_ZIP=https://www.openssl.org/source/openssl-1.0.2m.tar.gz
set LIB_CURL_ZIP=https://curl.haxx.se/download/curl-7.56.1.zip  
set "PROJECT_DIR=%cd%"
set CURL=curl-7.56.1
set OPEN_SSL=openssl-1.0.2m
set DLIB_DIR=dlib-19.7

if not exist %DLIB_DIR% mkdir %DLIB_DIR%
if not exist %CURL% mkdir %CURL%
if not exist %OPEN_SSL% mkdir %OPEN_SSL%

call :downloadfile %DLIB_ZIP% file.zip

echo "Finished downloading extracting"
7z  -o.  x file.zip  -y
echo "Building dlib"
dir  %DLIB_DIR%
mkdir %DLIB_DIR%\build
cd %DLIB_DIR%\build
cmake ..
msbuild INSTALL.vcxproj /p:Configuration=Debug /p:Platform=x86
echo "Finished"

call :downloadfile %OPEN_SSL_ZIP% file.zip
echo "Finished downloading opnessl extracting"
7z  -o. x file.zip  -y
echo "Building opnessl "
dir %OPEN_SSL%	
mkdir %OPEN_SSL%\build
cd %OPEN_SSL%\build
cmake ..
msbuild INSTALL.vcxproj /p:Configuration=Debug /p:Platform=x86
echo "Finished building openssl"


call :downloadfile %LIB_CURL_ZIP% file.zip
echo "Finished downloading libcurl extracting"
7z  -o. x file.zip  -y
echo "Building libcurl"
dir %CURL%
Set RTLIBCFG=static
mkdir %CURL%\build
cd %CURL%\build
msbuild INSTALL.vcxproj /p:Configuration=Debug /p:Platform=x86
msbuild INSTALL.vcxproj
echo "Finished"


cd %PROJECT_DIR% 
echo "Building app"
ls *.sln > tmp  && echo msbuild /t:Build /p:Configuration=Debug /p:Platform=x86  > tmp2 && set /p myvar= < tmp && set /p myvar2= < tmp2 &&  echo %myvar2% %myvar% > builds.bat 
call builds.bat  
echo "Creating release zip"

7z.exe a -r Firebender.zip Debug

:downloadfile
:: ----------------------------------------------------------------------
:: call :downloadfile <URL> <localfile>
if not exist %2 (
  curl -f -L %1 -o %2 || exit 1
)
goto :eof
