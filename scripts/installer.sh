#!/bin/bash

echo "======================================="
echo "  🔧 Trình cài đặt ViPi"
echo "======================================="

# Kiểm tra thư mục scripts
if [ ! -d "/vipi/scripts/" ]; then
    echo "❌ Thư mục /vipi/scripts/ không tồn tại! Kiểm tra lại đường dẫn."
    exit 1
fi

# Xác nhận cài đặt hệ thống
read -p "❓ Bạn có muốn cài đặt hệ thống không? (y/n): " install_system
if [[ "$install_system" == "y" || "$install_system" == "Y" ]]; then
    echo "======================================="
    echo "  🔄 Đang cài đặt hệ thống..."
    echo "======================================="
    cd /vipi/scripts/
    chmod +x install_system.sh
    sudo ./install_system.sh
    echo "✅ Hệ thống đã được cài đặt thành công!"
else
    echo "⚠️ Bỏ qua cài đặt hệ thống."
fi

read -p "❓ Bạn có muốn tiếp tục cài đặt gói Python không? (y/n): " install_pip
if [[ "$install_pip" == "y" || "$install_pip" == "Y" ]]; then
    echo "======================================="
    echo "  🔄 Đang cài đặt gói Python..."
    echo "======================================="
    cd /vipi/scripts/
    chmod +x install_pip.sh
    sudo ./install_pip.sh
    echo "✅ Gói Python đã được cài đặt thành công!"
else
    echo "⚠️ Bỏ qua cài đặt gói Python."
fi

read -p "❓ Bạn có muốn tiếp tục cài đặt cấu hình mic không? (y/n): " install_mic
if [[ "$install_mic" == "y" || "$install_mic" == "Y" ]]; then
    echo "======================================="
    echo "  🔄 Đang cài đặt cấu hình Mic..."
    echo "======================================="
    cd /vipi/scripts/
    chmod +x install_mic.sh
    sudo ./install_mic.sh
    echo "✅ Mic đã được cài đặt thành công!"
else
    echo "⚠️ Bỏ qua cài đặt Mic."
fi
read -p "❓ Bạn có muốn tiếp tục cài đặt wifi_connect không? (y/n): " install_mic
if [[ "$install_mic" == "y" || "$install_mic" == "Y" ]]; then
    echo "======================================="
    echo "  🔄 Đang cài đặt wifi_connect..."
    echo "======================================="
    cd /vipi/scripts/
    chmod +x install_wifi_connect.sh.sh
    sudo ./install_wifi_connect.sh.sh
    echo "✅ Mic đã được cài đặt thành công!"
else
    echo "⚠️ Bỏ qua cài đặt wifi_connect."
fi

echo "======================================="
echo "  ✅ Hoàn tất quá trình cài đặt!"
echo "======================================="
