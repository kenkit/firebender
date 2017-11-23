set DLIB_ZIP=http://dlib.net/files/dlib-19.7.zip 
set OPEN_SSL_ZIP=https://www.openssl.org/source/openssl-1.0.2m.tar.gz
set LIB_CURL_ZIP=https://curl.haxx.se/download/curl-7.56.1.zip
set "PROJECT_DIR=%cd%"
set CURL=curl-7.56.1
set OPENSSL_ROOT_DIR=openssl-1.0.2m
set DLIB_DIR=dlib-19.7

set BOOST_ROOT= C:/Libraries/boost_1_60_0
set BOOST_LIBRARIES= %BOOST_ROOT%/lib32-msvc-14.0

call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86 
set CYG_ROOT=C:/cygwin/bin
set CYG_CACHE=C:/cygwin/var/cache/setup
set CYG_MIRROR=http://mirrors.kernel.org/sourceware/cygwin/
set CYG_ARCH=x86
set PATH=%PATH%;C:/cygwin/bin
::if not exist %DLIB_DIR% mkdir %DLIB_DIR%
::if not exist %CURL% mkdir %CURL%
::if not exist %OPENSSL_ROOT_DIR% mkdir %OPENSSL_ROOT_DIR%

cp c:\MinGW\bin\mingw32-make.exe c:\MinGW\bin\make.exe

cd %PROJECT_DIR%
curl -f -L %LIB_CURL_ZIP% -o curl-7.56.1.zip  || exit 1
echo "Finished downloading libcurl extracting"
echo "*******************************************************"
call 7z  -o. x curl-7.56.1.zip   -y 
echo "Building libcurl"
dir %CURL%
cd %CURL%
cd winbuild
call nmake /f Makefile.vc mode=dll VC=14
cd ..\builds\libcurl-vc14-x86-release-dll-ipv6-sspi-winssl
set "CURL=%cd%"

cd %PROJECT_DIR%
mv  %CURL%\bin\libcurl.dll Debug\
echo "Finished"


::curl -f -L %OPEN_SSL_ZIP% -o openssl-1.0.2m.tar.gz || exit 1
::echo "Finished downloading opnessl extracting"
::echo "*******************************************************"
::call 7z  -o. x openssl-1.0.2m.tar.gz -y  && 7z  -o. x   openssl-1.0.2m.tar -y 
::dir .

::cd  openssl*
::mkdir build
::call perl Configure VC-WIN32 no-asm --prefix=dist enable-static-engine
::call ms\do_ms.bat
::nmake -f ms/nt.mak
::nmake /f ms\nt.mak install
cd dist 
set "OPENSSL_ROOT_DIR=%cd%"
echo "Finished building openssl"

set OPENSSL_INCLUDE_DIR=%OPENSSL_ROOT_DIR%\include
set OPENSSL_LIBRARY_DIR=%OPENSSL_ROOT_DIR%\lib

echo "DOwnloading DLIB"
cd %PROJECT_DIR%
curl -f -L %DLIB_ZIP% -o dlib-19.7.zip  || exit 1
echo "Finished downloading extracting"
echo "*******************************************************"
7z  -o.  x dlib-19.7.zip   -y
dir .
echo "Building dlib"
cd  %DLIB_DIR%
set "DLIB_DIR2=%cd%"
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=dist ..\  
call msbuild INSTALL.vcxproj /p:Configuration=Debug /p:Platform=x86 /m
cd ..\
set DLIB_DIR=%DLIB_DIR%\build\dist
echo "Finished"

appveyor DownloadFile http://cygwin.com/setup-%CYG_ARCH%.exe -FileName setup.exe
setup.exe -gqnNdO -R "%CYG_ROOT%" -s "%CYG_MIRROR%" -l "%CYG_CACHE%" -P make,git,gcc-core,gcc-g++,ocaml,ocaml-camlp4,ocaml-compiler-libs,libncurses-devel,unzip,libmpfr-devel,patch,flexdll,libglpk-devel,openssl-devel
%CYG_ROOT%/bin/bash -lc "cygcheck -dc cygwin gcc-core

echo "Instlaling jsonpp"
cd %PROJECT_DIR% 
call git clone https://github.com/nlohmann/json.git
cd json\src
set "NLOHOMANN_JSON=%cd%"

echo "Instlaling eschalot"
cd %PROJECT_DIR% 
call git clone https://github.com/ReclaimYourPrivacy/eschalot.git
cd eschalot
make
cd %PROJECT_DIR% 
mv  eschalot\eschalot.exe Debug\
mv  eschalot\worgen.exe Debug\
mv  eschalot\nouns.txt Debug\
mv  eschalot\results.txt Debug\
mv  eschalot\top1000.txt Debug\
mv  eschalot\top150adjectives.txt Debug\
mv  eschalot\top400nouns.txt Debug\
mv  eschalot\LICENSE Debug\



cd %PROJECT_DIR% 
echo "Building app"
call msbuild Firebender.vcxproj /p:Configuration=Debug /p:Platform=x86   /m
echo "*******************************************************"

echo "Creating release zip"

call 7z.exe a -r Firebender.zip Debug 

