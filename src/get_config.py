# get_config.py

import codecs
import json
import os
import time
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import threading

# Khai báo biến global để lưu trữ cấu hình
configuration = {}
configText = ""
TTSChoice = ""
STTChoice = ""
ctr_chromecast = False

CURENT_PATH = os.path.realpath(os.path.join(__file__, '..'))
config_file_path = os.path.join(CURENT_PATH, 'config.json')

# Khai báo biến config_variables và khởi tạo ban đầu
config_variables = {
    'TTSChoice': '',
    'STTChoice': '',
    'gender': ''
}

class ConfigHandler(FileSystemEventHandler):
    def on_modified(self, event):
        if event.src_path.endswith("config.json"):
            load_config()

def load_config():
    global configuration, TTSChoice, STTChoice, ctr_chromecast, configText
    with codecs.open(config_file_path, 'r', encoding='utf8') as f:
        content = f.read()
        if content.strip() != configText.strip():
            try:
                configuration = json.loads(content)
                configText = content
                update_variables()
            except json.JSONDecodeError:
                print("Lỗi format JSON")

def update_variables():
    global config_variables
    config_variables['TTSChoice'] = configuration.get('TextToSpeech', {}).get('Choice', '').upper()
    config_variables['STTChoice'] = configuration.get('SpeechToText', {}).get('Choice', '').lower()
    config_variables['gender'] = configuration.get('TextToSpeech', {}).get('Voice_Gender', '').lower()

# Gọi lần đầu để khởi tạo giá trị ban đầu
load_config()
update_variables()

# Khởi động theo dõi sự thay đổi trong tệp config.json
event_handler = ConfigHandler()
observer = Observer()
observer.schedule(event_handler, path=CURENT_PATH, recursive=False)
observer.start()

def config_thread():
    try:
        while True:
            time.sleep(1)  # Kiểm tra sự thay đổi mỗi giây
    except KeyboardInterrupt:
        observer.stop()

    observer.join()

# Hàm main để chạy module get_config.py
def main():
    config_thread()

# Kiểm tra xem module get_config.py có được chạy trực tiếp hay không
if __name__ == "__main__":
    main()
