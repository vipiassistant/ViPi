#!/bin/bash

# Mã màu ANSI
GREEN='\033[0;32m'  # Xanh lá
RED='\033[0;31m'    # Đỏ
RESET='\033[0m'     # Reset màu về mặc định

echo -e "${GREEN}=======================================${RESET}"
echo -e "${GREEN}  🔧 Trình cài đặt ViPi${RESET}"
echo -e "${GREEN}=======================================${RESET}"

SCRIPTS_DIR="/home/pi/ViPi/scripts"

# Kiểm tra thư mục tồn tại
if [ ! -d "$SCRIPTS_DIR" ]; then
    echo -e "❌ ${RED}Thư mục cài đặt $SCRIPTS_DIR không tồn tại, thoát trình cài đặt!${RESET}"
    exit 1
fi

# Danh sách các script cài đặt
declare -A INSTALL_SCRIPTS
INSTALL_SCRIPTS["Hệ thống"]="installer_system.sh"
INSTALL_SCRIPTS["Gói Python"]="installer_pip.sh"
INSTALL_SCRIPTS["Mic"]="installer_mic.sh"
INSTALL_SCRIPTS["WiFi Connect"]="install_wifi_connect.sh"  # WiFi Connect sẽ được cài cuối cùng

# Hỏi người dùng có muốn cập nhật hệ thống trước không
echo -e "\n🔄 ${GREEN}Bạn có muốn cập nhật hệ thống trước khi cài đặt không? (y/n)${RESET}"
echo -e "👉 ${GREEN}Nếu không nhập gì sau 15 giây, mặc định sẽ cập nhật!${RESET}"

UPDATE_CHOICE=""
for ((i=15; i>0; i--)); do
    echo -ne "\r⏳ Còn $i giây... "
    read -t 1 -n 1 UPDATE_CHOICE
    if [[ -n "$UPDATE_CHOICE" ]]; then
        break
    fi
done
echo

if [[ -z "$UPDATE_CHOICE" || "$UPDATE_CHOICE" =~ ^[Yy]$ ]]; then
    echo -e "🔄 ${GREEN}Đang cập nhật hệ thống...${RESET}"
    sudo apt update && sudo apt upgrade -y
    echo -e "✅ ${GREEN}Cập nhật hệ thống hoàn tất!${RESET}"
else
    echo -e "⚠️ ${RED}Bỏ qua cập nhật hệ thống.${RESET}"
fi

# Cấp quyền thực thi cho tất cả script
echo -e "\n🔄 ${GREEN}Đang cấp quyền thực thi cho các script...${RESET}"
for script in "${INSTALL_SCRIPTS[@]}"; do
    if [ -f "$SCRIPTS_DIR/$script" ]; then
        chmod +x "$SCRIPTS_DIR/$script"
    else
        echo -e "⚠️ ${RED}Không tìm thấy $script, bỏ qua...${RESET}"
    fi
done

# Hàm cài đặt với đếm ngược
auto_continue() {
    local desc="$1"
    local script="$2"

    # Kiểm tra script có tồn tại không
    if [ ! -f "$SCRIPTS_DIR/$script" ]; then
        echo -e "🚫 ${RED}Lỗi: Không tìm thấy $script! Bỏ qua...${RESET}"
        return
    fi

    echo -e "\n❓ ${GREEN}Bạn có muốn cài đặt $desc không? (y/n)${RESET}"
    echo -e "👉 ${GREEN}Nếu không nhập gì sau 30 giây, sẽ tự động cài đặt!${RESET}"

    local user_input=""
    for ((i=30; i>0; i--)); do
        echo -ne "\r⏳ Còn $i giây... "
        read -t 1 -n 1 user_input
        if [[ -n "$user_input" ]]; then
            break
        fi
    done
    echo

    if [[ -z "$user_input" || "$user_input" =~ ^[Yy]$ ]]; then
        echo -e "🔄 ${GREEN}Đang cài đặt $desc...${RESET}"
        sudo "$SCRIPTS_DIR/$script"
        echo -e "✅ ${GREEN}Cài đặt $desc hoàn tất!${RESET}"
    else
        echo -e "⚠️ ${RED}Bỏ qua $desc.${RESET}"
    fi
}

# Chạy lần lượt các bước cài đặt
for key in "${!INSTALL_SCRIPTS[@]}"
do
    auto_continue "$key" "${INSTALL_SCRIPTS[$key]}"
done

echo -e "\n${GREEN}=======================================${RESET}"
echo -e "  ✅ ${GREEN}Quá trình cài đặt hoàn tất!${RESET}"
echo -e "${GREEN}=======================================${RESET}"
