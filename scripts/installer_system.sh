#!/bin/bash

# Xác định phiên bản OS
OS_VERSION=$(lsb_release -c | awk '{print $2}')
if [[ "$OS_VERSION" == "bookworm" ]]; then
    CONFIG_PATH="/boot/firmware/config.txt"
else
    CONFIG_PATH="/boot/config.txt"
fi

echo -e "\n======================================="
echo "  🔄 Cập nhật hệ thống và cài đặt gói cần thiết"
echo "======================================="

sudo apt update && sudo apt upgrade -y

SYSTEM_LIBS=(
    libxml2-dev libxslt-dev mpv mplayer vlc python3 python3-pip python3-setuptools
    libatlas-base-dev libjack-jackd2-dev socat nmap git autoconf automake gcc
    bison libpcre3 libpcre3-dev python3-lxml zlib1g-dev sox libmpg123-dev
    libsox-fmt-mp3 build-essential mpg123 portaudio19-dev supervisor
)

for pkg in "${SYSTEM_LIBS[@]}"; do
    if ! dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q "install ok installed"; then
        echo "📦 Đang cài đặt '$pkg'..."
        sudo apt install -y "$pkg"
    else
        echo "✅ Gói '$pkg' đã được cài đặt, bỏ qua..."
    fi
done

if ! command -v flac &>/dev/null; then
    echo "⚠️ Không tìm thấy FLAC, đang cài đặt từ nguồn..."
    sudo apt install -y build-essential libflac-dev
    wget http://downloads.xiph.org/releases/flac/flac-1.3.4.tar.xz -O flac.tar.xz

    # Kiểm tra file tải về
    if [[ ! -f "flac.tar.xz" ]]; then
        echo "❌ Lỗi tải FLAC! Kiểm tra lại mạng."
        exit 1
    fi

    tar -xf flac.tar.xz
    cd flac-1.3.4 || exit 1
    ./configure && make -j$(nproc) && sudo make install
    cd ..
    rm -rf flac-1.3.4 flac.tar.xz
fi

echo -e "\n✅ Hoàn tất cài đặt hệ thống!"
