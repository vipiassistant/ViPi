echo "======================================="
echo "  Trình cài đặt gói                    "
echo "======================================="
echo ""

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
