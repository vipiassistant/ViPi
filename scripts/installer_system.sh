#!/bin/bash

# Mã màu ANSI
GREEN='\033[0;32m'  # Xanh lá
RESET='\033[0m'     # Reset màu về mặc định

LOG_FILE="/var/log/install_errors.log"

# Danh sách các gói cần cài
SYSTEM_LIBS=(
    libxml2-dev
    libxslt-dev
    mpv
    mplayer
    vlc
    python3
    python3-pip
    python3-setuptools
    libatlas-base-dev
    libjack-jackd2-dev
    socat
    nmap
    git
    autoconf
    automake
    gcc
    bison
    libpcre3
    libpcre3-dev
    python3-lxml
    zlib1g-dev
    sox
    libmpg123-dev
    libsox-fmt-mp3
    build-essential
    mpg123
    portaudio19-dev
    supervisor
)

ERROR_PACKAGES=()

# Kiểm tra quyền sudo
if [ "$EUID" -ne 0 ]; then
    echo -e "${GREEN}⚠️  Vui lòng chạy script với quyền root hoặc sudo.${RESET}"
    exit 1
fi

# Đảm bảo log file tồn tại
touch "$LOG_FILE"

echo -e "\n${GREEN}=======================================${RESET}"
echo -e "${GREEN}  🚀 Bắt đầu cài đặt các gói cần thiết...${RESET}"
echo -e "${GREEN}=======================================${RESET}\n"

for pkg in "${SYSTEM_LIBS[@]}"; do
    echo -e "${GREEN}---------------------------------------${RESET}"
    if ! dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q "install ok installed"; then
        echo -e "${GREEN}📦 Đang cài đặt: $pkg...${RESET}"
        
        START_TIME=$(date +%s)  # Bắt đầu tính thời gian
        if ! sudo apt install -y "$pkg"; then
            echo -e "❌ Lỗi khi cài đặt: $pkg, bỏ qua..."
            ERROR_PACKAGES+=("$pkg")
            echo "Lỗi khi cài đặt: $pkg" >> "$LOG_FILE"
        else
            END_TIME=$(date +%s)
            DIFF_TIME=$((END_TIME - START_TIME))
            echo -e "✅ Cài đặt thành công: $pkg ⏳ (${DIFF_TIME} giây)"
        fi
    else
        echo -e "✅ Đã cài đặt: $pkg, bỏ qua..."
    fi
    echo -e "${GREEN}---------------------------------------${RESET}\n"
done

# Hiển thị các gói lỗi
if [ ${#ERROR_PACKAGES[@]} -gt 0 ]; then
    echo -e "${GREEN}=======================================${RESET}"
    echo -e "❌ Các gói bị lỗi khi cài đặt:"
    for err in "${ERROR_PACKAGES[@]}"; do
        echo -e "   - $err"
    done
    echo -e "${GREEN}📜 Log lỗi đã được lưu tại: ${LOG_FILE}${RESET}"
    echo -e "${GREEN}=======================================${RESET}"
else
    echo -e "\n✅ Tất cả gói đã được cài đặt thành công!"
fi

echo -e "\n${GREEN}✅ Hoàn thành cài đặt.${RESET}"
