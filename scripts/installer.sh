#!/bin/bash

echo "======================================="
echo "  🔧 Trình cài đặt ViPi"
echo "======================================="

SCRIPTS_DIR="/home/pi/ViPi/scripts"

# Kiểm tra thư mục scripts
if [ ! -d "$SCRIPTS_DIR" ]; then
    echo "❌ Thư mục $SCRIPTS_DIR không tồn tại! Kiểm tra lại đường dẫn."
    exit 1
fi

# Xác nhận cài đặt hệ thống
read -p "❓ Bạn có muốn cài đặt hệ thống không? (y/n): " install_system
if [[ "$install_system" == "y" || "$install_system" == "Y" ]]; then
    echo "======================================="
    echo "  🔄 Đang cài đặt hệ thống..."
    echo "======================================="
    cd "$SCRIPTS_DIR"
    chmod +x installer_system.sh
    sudo ./installer_system.sh
    echo "✅ Hệ thống đã được cài đặt thành công!"
else
    echo "⚠️ Bỏ qua cài đặt hệ thống."
fi

# Cài đặt gói Python
read -p "❓ Bạn có muốn tiếp tục cài đặt gói Python không? (y/n): " install_pip
if [[ "$install_pip" == "y" || "$install_pip" == "Y" ]]; then
    echo "======================================="
    echo "  🔄 Đang cài đặt gói Python..."
    echo "======================================="
    cd "$SCRIPTS_DIR"
    chmod +x installer_pip.sh
    sudo ./installer_pip.sh
    echo "✅ Gói Python đã được cài đặt thành công!"
else
    echo "⚠️ Bỏ qua cài đặt gói Python."
fi

# Cài đặt Mic
read -p "❓ Bạn có muốn tiếp tục cài đặt cấu hình mic không? (y/n): " install_mic
if [[ "$install_mic" == "y" || "$install_mic" == "Y" ]]; then
    echo "======================================="
    echo "  🔄 Đang cài đặt cấu hình Mic..."
    echo "======================================="
    cd "$SCRIPTS_DIR"
    chmod +x installer_mic.sh
    sudo ./installer_mic.sh
    echo "✅ Mic đã được cài đặt thành công!"
else
    echo "⚠️ Bỏ qua cài đặt Mic."
fi

# Cài đặt WiFi Connect
read -p "❓ Bạn có muốn tiếp tục cài đặt WiFi Connect không? (y/n): " install_wifi
if [[ "$install_wifi" == "y" || "$install_wifi" == "Y" ]]; then
    echo "======================================="
    echo "  🔄 Đang cài đặt WiFi Connect..."
    echo "======================================="
    cd "$SCRIPTS_DIR"
    chmod +x installer_wifi_connect.sh
    sudo ./installer_wifi_connect.sh
    echo "✅ WiFi Connect đã được cài đặt thành công!"
else
    echo "⚠️ Bỏ qua cài đặt WiFi Connect."
fi

echo "======================================="
echo "  ✅ Hoàn tất quá trình cài đặt!"
echo "======================================="
