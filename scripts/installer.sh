#!/bin/bash

echo "======================================="
echo "  Trình cài đặt hệ thống và môi trường Python"
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
sudo apt install -y git python3-venv python3-pip

# Cài đặt các gói hệ thống từ file system.txt nếu có
if [ -f "/home/pi/ViPi/scripts/system.txt" ]; then
    echo "Cài đặt gói hệ thống từ system.txt..."
    sed 's/#.*//' /home/pi/ViPi/scripts/system.txt | xargs sudo apt-get install -y
else
    echo "Không tìm thấy file system.txt, bỏ qua..."
fi

echo ""
echo "======================================="
echo "  Thiết lập môi trường ảo (venv)"
echo "======================================="
echo ""

# Tạo môi trường ảo trong thư mục chính nếu chưa tồn tại
if [ ! -d "/home/pi/ViPi/env" ]; then
    echo "Tạo môi trường ảo tại /home/pi/ViPi/env..."
    python3 -m venv /home/pi/ViPi/env
fi

echo "Kích hoạt môi trường ảo..."
source /home/pi/ViPi/env/bin/activate

echo ""
echo "======================================="
echo "  Cài đặt các thư viện Python"
echo "======================================="
echo ""

# Cập nhật pip trước khi cài đặt
pip install --upgrade pip

# Cài đặt các thư viện cần thiết
pip install ujson pathlib2 pyaudio soundfile python-vlc
pip install pydub tenacity sounddevice gtts rapidfuzz yt_dlp
pip install youtube-search-python bs4 pychromecast SpeechRecognition
pip install git+https://github.com/Uberi/speech_recognition.git
pip install gitpython git+https://github.com/googleapis/google-api-python-client.git
pip install pyyaml validators html2text mutagen paho-mqtt edge-tts
pip install psutil pvporcupine==3.0.0 numpy

# Cài đặt các gói từ pip.txt nếu có
if [ -f "/home/pi/ViPi/scripts/pip.txt" ]; then
    echo "Cài đặt gói Python từ pip.txt..."
    pip install -r /home/pi/ViPi/scripts/pip.txt
else
    echo "Không tìm thấy file pip.txt, bỏ qua..."
fi

# Hủy kích hoạt môi trường ảo
deactivate

echo ""
echo "======================================="
echo "  Cài đặt hoàn tất!"
echo "  Hệ thống sẽ khởi động lại sau 10 giây..."
echo "======================================="
sleep 10
sudo reboot
