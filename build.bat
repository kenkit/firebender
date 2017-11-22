set DLIB_ZIP=http://dlib.net/files/dlib-19.7.zip 
set OPEN_SSL_ZIP=https://www.openssl.org/source/openssl-1.0.2m.tar.gz
set LIB_CURL_ZIP=https://s3-us-west-2.amazonaws.com/deaddevice/curl-7.56.1.zip
set "PROJECT_DIR=%cd%"
set CURL=curl-7.56.1
set OPENSSL_ROOT_DIR=openssl-1.0.2m
set DLIB_DIR=dlib-19.7
set BOOST_ROOT=C:\Libraries\boost_1_62_0
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86 

::if not exist %DLIB_DIR% mkdir %DLIB_DIR%
::if not exist %CURL% mkdir %CURL%
::if not exist %OPENSSL_ROOT_DIR% mkdir %OPENSSL_ROOT_DIR%

cd %PROJECT_DIR%
call :downloadfile %LIB_CURL_ZIP% curl-7.56.1.zip  
echo "Finished downloading libcurl extracting"
echo "*******************************************************"
7z  -o. x curl-7.56.1.zip   -y 
echo "Building libcurl"
dir %CURL%
cd %CURL%
mkdir build
cd build
::cmake -D BUILD_CURL_TESTS=BOOL:OFF  -D CMAKE_INSTALL_PREFIX=%CURL%\dist ../
:::msbuild curl.sln /p:Configuration=Debug /p:Platform="Win32" /m
::msbuild INSTALL.vcxproj /p:Configuration=Debug
set CURL=%CURL%
cp  %CURL%\bin\libcurl.dll %PROJECT_DIR%\Debug

echo "Finished"



cd %PROJECT_DIR%
call :downloadfile %OPEN_SSL_ZIP% openssl-1.0.2m.tar.gz
echo "Finished downloading opnessl extracting"
echo "*******************************************************"
7z  -o. x openssl-1.0.2m.tar.gz -y  && 7z  -o. x   openssl-1.0.2m.tar -y 
dir .
echo "Building opnessl "
cd  openssl*
set "OPENSSL_ROOT_DIR=%cd%"
mkdir build
perl Configure VC-WIN32 no-asm --prefix=%OPENSSL_ROOT_DIR%\build enable-static-engine
::call ms\do_ms.bat
::nmake -f ms/nt.mak
::nmake /f ms\nt.mak install
echo "Finished building openssl"
cd %OPENSSL_ROOT_DIR%\build
set "OPENSSL_ROOT_DIR=%cd%"
set OPENSSL_INCLUDE_DIR=%OPENSSL_ROOT_DIR%\build\include
set OPENSSL_LIBRARY_DIR=%OPENSSL_ROOT_DIR%\build\lib

echo "DOwnloading DLIB"
cd %PROJECT_DIR%
call :downloadfile %DLIB_ZIP% dlib-19.7.zip 
echo "Finished downloading extracting"
echo "*******************************************************"
7z  -o.  x dlib-19.7.zip   -y
dir .
echo "Building dlib"
mkdir %DLIB_DIR%\build
cd %DLIB_DIR%\build
cmake ..  -DCMAKE_INSTALL_PREFIX=%DLIB_DIR%\dist
msbuild INSTALL.vcxproj /p:Configuration=Debug /p:Platform=x86 /m
cd %DLIB_DIR%\dist
set "DLIB_DIR=%cd%"
echo "Finished"



echo "Instlaling jsonpp"
cd %PROJECT_DIR% 
git clone https://github.com/nlohmann/json.git
cd json\src
set "NLOHOMANN_JSON=%cd%"


cd %PROJECT_DIR% 
echo "Building app"
msbuild Firebender.vcxproj /p:Configuration=Debug /p:Platform=x86   /m
echo "*******************************************************"

echo "Creating release zip"
7z.exe a -r Firebender.zip Debug

:downloadfile
:: ----------------------------------------------------------------------
:: call :downloadfile <URL> <localfile>
if not exist %2 (
  curl -f -L %1 -o %2 || exit 1
)
goto :eof
