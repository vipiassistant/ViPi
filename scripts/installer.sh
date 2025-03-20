#!/bin/bash

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

echo ""
echo "======================================="
echo "  Cập nhật hệ thống và cài đặt gói cần thiết"
echo "======================================="
echo ""

# Cập nhật hệ thống
sudo apt update && sudo apt upgrade -y

# Danh sách gói hệ thống cần cài đặt
SYSTEM_LIBS=(
    libxml2-dev libxslt-dev mpv mplayer vlc python3 python3-pip python3-setuptools
    libatlas-base-dev libjack-jackd2-dev socat nmap git autoconf automake gcc
    bison libpcre3 libpcre3-dev python3-lxml zlib1g-dev sox libmpg123-dev
    libsox-fmt-mp3 build-essential mpg123 portaudio19-dev supervisor
)

# Kiểm tra & cài đặt từng gói hệ thống
for pkg in "${SYSTEM_LIBS[@]}"; do
    if dpkg -l | grep -q "^ii  $pkg "; then
        echo "✅ Gói '$pkg' đã có, bỏ qua..."
    else
        echo "📦 Đang cài đặt '$pkg'..."
        sudo apt install -y "$pkg"
    fi
done

echo ""
echo "======================================="
echo "  Thiết lập môi trường ảo (venv)"
echo "======================================="
echo ""

# Tạo môi trường ảo nếu chưa có
if [ ! -d "/home/pi/ViPi/env" ]; then
    echo "📦 Đang tạo môi trường ảo tại /home/pi/ViPi/env..."
    python3 -m venv /home/pi/ViPi/env
fi

echo "✅ Kích hoạt môi trường ảo..."
source /home/pi/ViPi/env/bin/activate

echo ""
echo "======================================="
echo "  Cập nhật pip và cài đặt thư viện Python"
echo "======================================="
echo ""

# Cập nhật pip trước khi cài đặt
pip install --upgrade pip

# Danh sách thư viện Python cần cài đặt
PYTHON_LIBS=(
    ujson pathlib2 pyaudio soundfile python-vlc pydub tenacity sounddevice gtts
    rapidfuzz yt_dlp youtube-search-python bs4 pychromecast
    git+https://github.com/Uberi/speech_recognition.git gitpython
    git+https://github.com/googleapis/google-api-python-client.git
    pyyaml validators html2text mutagen paho-mqtt edge-tts psutil numpy h5py
    typing-extensions wheel pvporcupine==3.0.0
    gTTS gTTS-token youtube_dl PyChromecast==9.1.2
    psutil urllib3 requests python-vlc pyyaml spidev
    gpiozero pycryptodomex==3.7.2 adafruit-io==2.1
    pywemo==0.4.39 cryptography==3.3.2 mock==3.0.5
    pyusb futures==3.1.1 fuzzywuzzy termcolor python-vlc rpi-ws281x
    python-Levenshtein mutagen youtube-search-python flask flask-bootstrap
    flask-restful cherrypy aftership feedparser fp free-proxy
)

# Kiểm tra & cài đặt từng thư viện Python
for lib in "${PYTHON_LIBS[@]}"; do
    if pip show "$(echo "$lib" | cut -d= -f1)" &>/dev/null; then
        echo "✅ Thư viện '$lib' đã có, bỏ qua..."
    else
        echo "📦 Đang cài đặt '$lib'..."
        pip install "$lib"
    fi
done

# Hủy kích hoạt môi trường ảo
deactivate

echo ""
echo "======================================="
echo "  Cài đặt hoàn tất!"
echo "  Hệ thống sẽ khởi động lại sau 10 giây..."
echo "======================================="
sleep 10
sudo reboot
