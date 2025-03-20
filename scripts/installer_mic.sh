#!/bin/bash

OS_VERSION=$(lsb_release -c | awk '{print $2}')
if [[ "$OS_VERSION" == "bookworm" ]]; then
    CONFIG_PATH="/boot/firmware/config.txt"
else
    CONFIG_PATH="/boot/config.txt"
fi
echo "======================================="
echo "         Trình cài đặt mic để cài đặt  "
echo "======================================="
echo "1️⃣ USB Mic"
echo "2️⃣ ReSpeaker"
echo "3️⃣ Mic ViPi V3"
read -p "🔍 Vui lòng chọn mic (1-3): " MIC_CHOICE

case $MIC_CHOICE in
    1)
        arecord -l
        read -p "Nhập số card USB mic: " MIC_NUMBER
        aplay -l
        read -p "Nhập số card loa: " SPEAKER_NUMBER
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
pcm.!default {
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
        ;;
    2)
        git clone https://github.com/HinTak/seeed-voicecard
        cd seeed-voicecard
        sudo ./install.sh
        ;;
    3)
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
        echo "dtoverlay=googlevoicehat-soundcard" | sudo tee -a "$CONFIG_PATH"
        sudo sed -i -e "s/^dtparam=audio=on/#\0/" -e "s/^#\(dtparam=i2s=on\)/\1/" "$CONFIG_PATH"
        grep -q "dtoverlay=i2s-mmap" "$CONFIG_PATH" || echo "dtoverlay=i2s-mmap" >> "$CONFIG_PATH"
        grep -q "dtparam=i2s=on" "$CONFIG_PATH" || echo "dtparam=i2s=on" >> "$CONFIG_PATH"
        sudo tee -a "$CONFIG_PATH" > /dev/null <<EOT
core_freq=250
spidev.bufsiz=32768
dtparam=i2s=on
EOT
        ;;
    *)
        echo "❌ Lựa chọn không hợp lệ!"
        exit 1
        ;;
esac

echo "======================================="
echo "  ✅ Cài đặt hoàn tất! Hệ thống sẽ khởi động lại sau 10 giây..."
echo "======================================="
sleep 10
