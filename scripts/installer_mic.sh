#!/bin/bash

# Kiểm tra quyền sudo
if [[ $EUID -ne 0 ]]; then
    echo "❌ Vui lòng chạy script với quyền root (sudo)."
    exit 1
fi

# Xác định phiên bản OS
OS_VERSION=$(lsb_release -c | awk '{print $2}')
if [[ "$OS_VERSION" == "bookworm" ]]; then
    CONFIG_PATH="/boot/firmware/config.txt"
else
    CONFIG_PATH="/boot/config.txt"
fi

echo "======================================="
echo "         🎙 Trình cài đặt Mic "
echo "======================================="
echo "1️⃣ USB Mic"
echo "2️⃣ ReSpeaker"
echo "3️⃣ Mic ViPi V3"
read -p "🔍 Vui lòng chọn mic (1-3): " MIC_CHOICE

case $MIC_CHOICE in
    1)
        echo "🔎 Đang kiểm tra thiết bị âm thanh..."
        arecord -l
        read -p "🎙 Nhập số card USB mic: " MIC_NUMBER
        aplay -l
        read -p "🔊 Nhập số card loa: " SPEAKER_NUMBER

        if ! arecord -l | grep -q "card $MIC_NUMBER:" || ! aplay -l | grep -q "card $SPEAKER_NUMBER:"; then
            echo "❌ Lỗi: Số card không hợp lệ!"
            exit 1
        fi

        echo "🔧 Cấu hình mic & loa..."
        sudo tee /etc/asound.conf > /dev/null <<EOT
pcm.dsnooper {
    type dsnoop
    ipc_key 816357492
    ipc_key_add_uid 0
    ipc_perm 0666
    slave {
        pcm "hw:$MIC_NUMBER,0"
        channels 1
    }
}
pc.!default {
    type asym
    playback.pcm {
        type plug
        slave.pcm "hw:$SPEAKER_NUMBER,0"
    }
    capture.pcm {
        type plug
        slave.pcm "dsnooper"
    }
}
EOT
        echo "✅ Cấu hình USB Mic hoàn tất!"
        ;;
    2)
        echo "🔄 Đang tải về & cài đặt driver ReSpeaker..."
        git clone https://github.com/HinTak/seeed-voicecard
        cd seeed-voicecard
        sudo ./install.sh
        echo "✅ Cài đặt ReSpeaker hoàn tất!"
        ;;
    3)
        echo "🔧 Cấu hình Mic ViPi V3..."
        sudo tee /etc/asound.conf > /dev/null <<EOT
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
EOT
        
        echo "🔄 Cập nhật config.txt..."
        grep -q "dtoverlay=googlevoicehat-soundcard" "$CONFIG_PATH" || echo "dtoverlay=googlevoicehat-soundcard" | sudo tee -a "$CONFIG_PATH"
        grep -q "dtoverlay=i2s-mmap" "$CONFIG_PATH" || echo "dtoverlay=i2s-mmap" | sudo tee -a "$CONFIG_PATH"
        grep -q "dtparam=i2s=on" "$CONFIG_PATH" || echo "dtparam=i2s=on" | sudo tee -a "$CONFIG_PATH"
        
        sudo tee -a "$CONFIG_PATH" > /dev/null <<EOT
core_freq=250
spidev.bufsiz=32768
dtparam=i2s=on
EOT

        echo "✅ Cấu hình Mic ViPi V3 hoàn tất!"
        sudo tee /etc/systemd/system/noise.service > /dev/null <<EOT
[Unit]
Description=No pop noise
After=sound.target

[Service]
ExecStart=/usr/bin/aplay -D default -t raw -r 48000 -c 2 -f S32_LE /dev/zero
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOT

        sudo systemctl daemon-reload
        sudo systemctl enable noise.service
        sudo systemctl restart noise.service
        ;;
    *)
        echo "❌ Lựa chọn không hợp lệ!"
        exit 1
        ;;
esac

echo "======================================="
echo "  ✅ Cài đặt hoàn tất!"
echo "======================================="

