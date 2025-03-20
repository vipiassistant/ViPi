#!/bin/bash

echo "🔧 Bắt đầu cài đặt Microphone I2S V3.0 cho Raspberry Pi..."

# 1️⃣ Cập nhật hệ thống và cài đặt các gói cần thiết
echo "📦 Đang cập nhật hệ thống..."
sudo apt update && sudo apt upgrade -y

echo "📦 Cài đặt thư viện âm thanh cần thiết..."
sudo apt install -y alsa-utils libasound2 libasound2-dev

# 2️⃣ Chỉnh sửa alsa.conf
echo "🛠️ Chỉnh sửa /usr/share/alsa/alsa.conf..."
sudo sed -i 's/^defaults\.ctl\.card 0/#&/' /usr/share/alsa/alsa.conf
sudo sed -i 's/^defaults\.pcm\.card 0/#&/' /usr/share/alsa/alsa.conf

# 3️⃣ Thêm cấu hình overlay cho sound card
echo "📝 Thêm dtoverlay=googlevoicehat-soundcard vào /boot/config.txt..."
echo "dtoverlay=googlevoicehat-soundcard" | sudo tee -a /boot/config.txt

# 4️⃣ Tạo và thiết lập /etc/asound.conf
echo "📝 Cấu hình âm thanh trong /etc/asound.conf..."
sudo tee /etc/asound.conf > /dev/null <<EOL
options snd_rpi_googlemihat_soundcard index=0

pcm.softvol {
    type softvol
    slave.pcm dmix
    control {
        name Master
        card sndrpigooglevoi
    }
}

pcm.micboost {
    type route
    slave.pcm dsnoop
    ttable {
        0.0 50.0
        1.1 50.0
    }
}

pcm.!default {
    type asym
    playback.pcm "plug:softvol"
    capture.pcm "plug:micboost"
}

ctl.!default {
    type hw
    card sndrpigooglevoi
}
EOL

# 5️⃣ Cài đặt các thư viện Python cần thiết cho microphone I2S
echo "🐍 Cài đặt pip và các thư viện Python cho âm thanh..."
sudo apt install -y python3-pip python3-dev
pip3 install --upgrade pip
pip3 install sounddevice pyaudio SpeechRecognition numpy

# 6️⃣ Hoàn tất, yêu cầu khởi động lại
echo "✅ Cài đặt hoàn tất! Hãy khởi động lại Raspberry Pi để áp dụng thay đổi."
echo "⚠️ Hệ thống sẽ khởi động lại sau 10 giây..."
sleep 10
sudo reboot
