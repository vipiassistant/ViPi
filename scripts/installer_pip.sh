#!/bin/bash

# Mã màu ANSI
GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'

ENV_PATH="/home/pi/env"  # Đường dẫn cố định cho môi trường ảo

# Kiểm tra Python
if ! command -v python3 &>/dev/null; then
    echo -e "${RED}❌ Python3 chưa được cài đặt. Vui lòng cài đặt trước.${RESET}"
    exit 1
fi

# Kiểm tra và tạo môi trường ảo nếu chưa có
if [ ! -d "$ENV_PATH" ]; then
    echo -e "${GREEN}📁 Tạo môi trường ảo Python tại $ENV_PATH...${RESET}"
    python3 -m venv "$ENV_PATH"
else
    echo -e "${GREEN}📁 Môi trường ảo đã tồn tại.${RESET}"
fi

# Kích hoạt môi trường ảo
echo -e "${GREEN}🔄 Kích hoạt môi trường ảo...${RESET}"
source "$ENV_PATH/bin/activate" || { echo -e "${RED}❌ Lỗi khi kích hoạt môi trường ảo.${RESET}"; exit 1; }

# Cập nhật pip
echo -e "${GREEN}🔧 Cập nhật pip lên phiên bản mới nhất...${RESET}"
pip install --upgrade pip setuptools wheel

# Danh sách gói cần cài đặt
cat <<EOF > requirements.txt
ujson
pathlib2
pyaudio
soundfile
python-vlc
pydub
tenacity
sounddevice
gtts
rapidfuzz
yt-dlp
youtube-search-python
beautifulsoup4
pychromecast
pyyaml
validators
html2text
mutagen
paho-mqtt
edge-tts
psutil
numpy
h5py
typing-extensions
wheel
pvporcupine==3.0.0
urllib3
requests
flask
flask-bootstrap
flask-restful
cherrypy
aftership
feedparser
EOF

# Cài đặt các gói từ danh sách
echo -e "\n${GREEN}🚀 Bắt đầu cài đặt các gói Python...${RESET}"
if ! pip install --no-cache-dir -r requirements.txt; then
    echo -e "${RED}❌ Một số gói bị lỗi khi cài đặt.${RESET}"
    deactivate
    exit 1
fi

# Thoát môi trường ảo
echo -e "${GREEN}🔄 Thoát khỏi môi trường ảo...${RESET}"
deactivate

echo -e "\n${GREEN}✅ Hoàn thành cài đặt.${RESET}"
