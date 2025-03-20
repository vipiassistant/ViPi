#!/bin/bash

# Xác định phiên bản OS

OS_VERSION=$(lsb_release -c | awk '{print $2}')
if [[ "$OS_VERSION" == "bookworm" ]]; then
    CONFIG_PATH="/boot/firmware/config.txt"
else
    CONFIG_PATH="/boot/config.txt"
fi

echo "======================================="
echo "  Trình cài đặt hệ thống & môi trường Python"
echo "======================================="
echo ""

# Xác nhận trước khi cài đặt
read -p "Bạn có muốn tiếp tục cài đặt? (y/n): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Hủy bỏ cài đặt."
    exit 0
fi

echo "\n======================================="
echo "  Cập nhật hệ thống và cài đặt gói cần thiết"
echo "======================================="

sudo apt update && sudo apt upgrade -y

SYSTEM_LIBS=(
    libxml2-dev libxslt-dev mpv mplayer vlc python3 python3-pip python3-setuptools
    libatlas-base-dev libjack-jackd2-dev socat nmap git autoconf automake gcc
    bison libpcre3 libpcre3-dev python3-lxml zlib1g-dev sox libmpg123-dev
    libsox-fmt-mp3 build-essential mpg123 portaudio19-dev supervisor
)

for pkg in "${SYSTEM_LIBS[@]}"; do
    if ! dpkg -l | grep -q "^ii  $pkg "; then
        echo "📦 Đang cài đặt '$pkg'..."
        sudo apt install -y "$pkg"
    fi
done

if ! command -v flac &>/dev/null; then
    echo "⚠️ Không tìm thấy FLAC, đang cài đặt từ nguồn..."
    sudo apt install -y build-essential libflac-dev
    wget http://downloads.xiph.org/releases/flac/flac-1.3.4.tar.xz
    tar -xf flac-1.3.4.tar.xz
    cd flac-1.3.4
    ./configure && make && sudo make install
    cd ..
    rm -rf flac-1.3.4 flac-1.3.4.tar.xz
fi

if [ ! -d "/home/pi/ViPi/env" ]; then
    python3 -m venv /home/pi/ViPi/env
fi

source /home/pi/ViPi/env/bin/activate
pip install --upgrade pip

PYTHON_LIBS=(
    ujson pathlib2 pyaudio soundfile python-vlc pydub tenacity sounddevice gtts
    rapidfuzz yt_dlp youtube-search-python bs4 pychromecast
    git+https://github.com/Uberi/speech_recognition.git gitpython
    git+https://github.com/googleapis/google-api-python-client.git
    pyyaml validators html2text mutagen paho-mqtt edge-tts psutil numpy h5py
    typing-extensions wheel pvporcupine==3.0.0
    gTTS youtube_dl PyChromecast==9.1.2 psutil urllib3 requests python-vlc
    flask flask-bootstrap flask-restful cherrypy aftership feedparser fp free-proxy
)

for lib in "${PYTHON_LIBS[@]}"; do
    if ! pip show "$(echo "$lib" | cut -d= -f1)" &>/dev/null; then
        pip install "$lib"
    fi
done

deactivate

