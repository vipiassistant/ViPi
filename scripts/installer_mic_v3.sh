#!/bin/bash

set -e  # Dừng script nếu có lỗi

echo "🔧 Bắt đầu cài đặt Microphone I2S và LED Mic V3 trên Raspberry Pi..."

# 1️⃣ Kiểm tra hệ điều hành và chọn đường dẫn `config.txt`
OS_VERSION=$(grep -oP '(?<=VERSION_CODENAME=)\w+' /etc/os-release)
CONFIG_PATH="/boot/config.txt"

if [ "$OS_VERSION" = "bookworm" ]; then
    CONFIG_PATH="/boot/firmware/config.txt"
    echo "📝 Phát hiện hệ điều hành Bookworm, sử dụng cấu hình: $CONFIG_PATH"
else
    echo "📝 Phát hiện hệ điều hành khác, sử dụng cấu hình: $CONFIG_PATH"
fi

# 2️⃣ Cấu hình `config.txt` cho Mic V3
echo "🛠️ Đang cập nhật cấu hình âm thanh và LED Mic V3..."
sed -i \
  -e "s/^dtparam=audio=on/#\0/" \
  -e "s/^#\(dtparam=i2s=on\)/\1/" \
  "$CONFIG_PATH"

# Thêm các dòng nếu chưa có
grep -q "dtoverlay=i2s-mmap" "$CONFIG_PATH" || echo "dtoverlay=i2s-mmap" >> "$CONFIG_PATH"
grep -q "dtoverlay=googlevoicehat-soundcard" "$CONFIG_PATH" || echo "dtoverlay=googlevoicehat-soundcard" >> "$CONFIG_PATH"
grep -q "dtparam=i2s=on" "$CONFIG_PATH" || echo "dtparam=i2s=on" >> "$CONFIG_PATH"
grep -q "dtparam=spi=on" "$CONFIG_PATH" || echo "dtparam=spi=on" >> "$CONFIG_PATH"
grep -q "core_freq=250" "$CONFIG_PATH" || echo "core_freq=250" >> "$CONFIG_PATH"
grep -q "spidev.bufsiz=32768" "$CONFIG_PATH" || echo "spidev.bufsiz=32768" >> "$CONFIG_PATH"

# 3️⃣ Cài đặt các gói cần thiết
echo "📦 Cập nhật hệ thống và cài đặt thư viện..."
sudo apt update && sudo apt install -y \
    alsa-utils libasound2 libasound2-dev python3-pip python3-dev

# 4️⃣ Chỉnh sửa alsa.conf
echo "🛠️ Cấu hình ALSA..."
sudo sed -i 's/^defaults\.ctl\.card 0/#&/' /usr/share/alsa/alsa.conf
sudo sed -i 's/^defaults\.pcm\.card 0/#&/' /usr/share/alsa/alsa.conf

# 5️⃣ Tạo hoặc cập nhật `/etc/asound.conf`
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
        0.0 30.0
        1.1 30.0
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

# 6️⃣ Cài đặt thư viện Python
echo "🐍 Cài đặt pip và thư viện Python..."
pip3 install --upgrade pip
pip3 install sounddevice pyaudio SpeechRecognition numpy rpi-ws281x

# 7️⃣ Hoàn tất, yêu cầu khởi động lại
echo "✅ Cài đặt hoàn tất! Hệ thống sẽ khởi động lại sau 10 giây..."
sleep 10
sudo reboot
