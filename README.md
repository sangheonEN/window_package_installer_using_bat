# window_package_installer_using_bat
Automation program bat file for installing essential packages that nvidia-driver, cuda, cudnn, ffmpeg, python ...

python 프로그램 실행을 위한 사전 필수 패키지 설치 자동화 cli code bat 파일.

설치 패키지: nvidia-driver, cuda, cudnn, python, ffmpeg 

bat 코드에서 아래와 같은 환경 변수에 설치 패키지 파일들을 저장하는 폴더를 지정해주시고, 각 설치 패키지의 파일명으로 수정해주시면 됩니다.

EX) 설치 패키지 저장 폴더 경로 지정
set BASE_PATH=%~dp0
set INSTALLER_PATH=%BASE_PATH%_install_package

EX) 패키지 파일명 수정
:: NVIDIA 드라이버 설치
echo NVIDIA 드라이버를 설치합니다...
start /wait "" "%INSTALLER_PATH%\{수정필요}" /s
