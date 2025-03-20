echo "======================================="
echo "  Trình cài đặt gói                    "
echo "======================================="
echo ""

if [ ! -d "/home/pi/ViPi/env" ]; then
    python3 -m venv /home/pi/ViPi/env
fi

#!/bin/bash

echo "======================================="
echo "  📦 Trình cài đặt gói Python"
echo "======================================="
echo ""

#!/bin/bash

echo "======================================="
echo "  📦 Trình cài đặt gói Python"
echo "======================================="
echo ""

# Kiểm tra và cài đặt gói python3-venv nếu chưa có
if ! dpkg -l | grep -q python3-venv; then
    echo "🔧 Cài đặt python3-venv..."
    sudo apt update && sudo apt install -y python3-venv
fi

# Tạo môi trường ảo nếu chưa có
if [ ! -d "/home/pi/ViPi/env" ]; then
    echo "📁 Tạo môi trường ảo Python..."
    python3 -m venv /home/pi/ViPi/env
fi

# Kích hoạt môi trường ảo
echo "🔄 Kích hoạt môi trường ảo..."
source /home/pi/ViPi/env/bin/activate

# Cập nhật pip lên phiên bản mới nhất
pip install --upgrade pip setuptools wheel

# Danh sách các thư viện Python cần cài đặt
PYTHON_LIBS=(
    ujson pathlib2 pyaudio soundfile python-vlc pydub tenacity sounddevice gtts
    rapidfuzz yt_dlp youtube-search-python bs4 pychromecast pyyaml validators
    html2text mutagen paho-mqtt edge-tts psutil numpy h5py typing-extensions
    wheel pvporcupine==3.0.0 gTTS youtube_dl PyChromecast==9.1.2 urllib3 requests
    flask flask-bootstrap flask-restful cherrypy aftership feedparser fp free-proxy
)

# Cài đặt tất cả gói một lần
echo "📦 Cài đặt các gói Python..."
pip install --no-cache-dir "${PYTHON_LIBS[@]}"

# Cài đặt thư viện từ GitHub
echo "🔄 Cài đặt thư viện từ GitHub..."
pip install --no-cache-dir git+https://github.com/Uberi/speech_recognition.git
pip install --no-cache-dir git+https://github.com/googleapis/google-api-python-client.git
pip install --no-cache-dir gitpython

# Hoàn tất
echo "✅ Hoàn tất cài đặt gói Python!"
deactivate
