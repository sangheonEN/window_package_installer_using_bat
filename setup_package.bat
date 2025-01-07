@echo off

:: 관리자 권한 확인
:: 관리자 권한이 아닌 경우, 관리자 권한으로 재실행 요청
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo 관리자 권한으로 실행해야 합니다!
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

setlocal

set BASE_PATH=%~dp0
set INSTALLER_PATH=%BASE_PATH%_install_package
:: 공통 경로 변수 설정
set BASE_PATH=D:\package_install_dev\_install_package

:: NVIDIA 드라이버 설치
echo NVIDIA 드라이버를 설치합니다...
start /wait "" "%INSTALLER_PATH%\565.90-notebook-win10-win11-64bit-international-nsd-dch-whql.exe" /s

:: NVIDIA 드라이버 설치 확인
echo 설치된 항목을 확인합니다...
echo ----------------------------------------
echo NVIDIA 드라이버 확인:
nvidia-smi


:: CUDA 설치
echo CUDA v12.1을 설치합니다...
start /wait "" "%INSTALLER_PATH%\cuda_12.1.0_531.14_windows.exe" -s

:: CUDA 설치 확인
echo ----------------------------------------
echo CUDA 버전 확인:
nvcc --version


:: cuDNN 복사 작업
echo cuDNN 파일을 복사합니다...
xcopy "%INSTALLER_PATH%\cudnn\bin" "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.1\bin" /E /H /C /I /Y
xcopy "%INSTALLER_PATH%\cudnn\include" "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.1\include" /E /H /C /I /Y
xcopy "%INSTALLER_PATH%\cudnn\lib" "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.1\lib" /E /H /C /I /Y

:: CUDNN 설치 확인
echo ----------------------------------------
echo cuDNN 설치 확인 (cudnn_version.h 확인):

:: cudnn_version.h 파일 경로
set CUDNN_HEADER="C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v12.1\include\cudnn_version.h"

:: 파일 존재 여부 확인
if not exist %CUDNN_HEADER% (
    echo cudnn_version.h 파일이 존재하지 않습니다.
    exit /b 1
)

:: cudnn_version.h에서 버전 정보 검색 및 출력
for /f "tokens=3" %%A in ('findstr /R /C:"#define CUDNN_MAJOR" %CUDNN_HEADER%') do set CUDNN_MAJOR=%%A
for /f "tokens=3" %%A in ('findstr /R /C:"#define CUDNN_MINOR" %CUDNN_HEADER%') do set CUDNN_MINOR=%%A
for /f "tokens=3" %%A in ('findstr /R /C:"#define CUDNN_PATCHLEVEL" %CUDNN_HEADER%') do set CUDNN_PATCHLEVEL=%%A

echo cuDNN Version: %CUDNN_MAJOR%.%CUDNN_MINOR%.%CUDNN_PATCHLEVEL%


:: Python 설치
echo Python 3.11.5를 설치합니다...
start /wait "" "%INSTALLER_PATH%\python-3.11.5-amd64.exe" /quiet InstallAllUsers=1 PrependPath=1

:: Python 설치 확인
echo ----------------------------------------
echo Python 버전 확인:
python --version


:: FFmpeg 설치
echo FFmpeg를 설치합니다...
mkdir "C:\ffmpeg"
xcopy "%INSTALLER_PATH%\ffmpeg" "C:\ffmpeg" /E /H /C /I /Y

:: FFmpeg 환경 변수 설정
echo 시스템 환경 변수에 FFmpeg 경로를 추가합니다...
setx PATH "%PATH%;C:\ffmpeg\bin"

echo ----------------------------------------
echo FFmpeg 설치 확인:
ffmpeg -version

:: 실행 테스트
echo 실행 테스트를 진행합니다...
start "" "D:\STT_V1\STT\RealtimeSTT_EXE_Build\tests\dist\qt_test_design_gridlayout_tab_adjust\qt_test_design_gridlayout_tab_adjust.exe"

echo ----------------------------------------
echo 모든 작업이 완료되었습니다!
pause
