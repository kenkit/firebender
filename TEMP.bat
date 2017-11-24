call "C:\Program Files\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86 
set BOOST_INCLUDE=E:\programming\boost_1_55_0
set BOOST_LIBRARIES=E:\programming\boost_1_55_0\stage\lib
set BOOST_ROOT=E:\programming\boost_1_55_0
set CommonProgramFiles=C:\Program Files\Common Files
set COMPUTERNAME=DEADDEVICE
set ComSpec=C:\Windows\system32\cmd.exe
set CRYPTO=E:\programming\cryptopp
set CURL=E:\programming\curl-7.54.1\build\CURL
set CURL_INCLUDE_DIR=E:\programming\curl-7.54.1\build\CURL\include
set CURL_LIBRARY=E:\programming\curl-7.54.1\build\CURL\lib
set DevEnvDir=C:\Program Files\Microsoft Visual Studio 14.0\Common7\IDE\
set DLIB=E:\programming\dlib-19.7
set DLIB_DI2=E:\programming\dlib-19.7\
set DLIB_DIR=E:\programming\dlib-19.7\build\dlib\Debug
set DLIB_DIR2=E:\programming\dlib-19.7
set FPS_BROWSER_APP_PROFILE_STRING=Internet Explorer
set FPS_BROWSER_USER_PROFILE_STRING=Default
set NLOHOMANN_JSON=E:\programming\json-2.1.1\src

call msbuild Firebender.vcxproj /p:Configuration=Debug /p:Platform=x86   /m
echo "*******************************************************"

echo "Creating release zip"
del Firebender.zip
call zip -r Firebender.zip Debug
