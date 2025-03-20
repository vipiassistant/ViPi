#!/bin/bash

echo "======================================="
echo "  📶 Trình cài đặt WiFi Connect"
echo "======================================="
echo ""

echo ""
echo "🔍 Kiểm tra & di chuyển file cấu hình WiFi Connect..."
echo ""

# Định nghĩa file service
SERVICE_FILE="/lib/systemd/system/wifi-connect-start.service"

if [ -f "ViPi/scripts/wifi-connect-start.service" ]; then
    if [ ! -f "$SERVICE_FILE" ]; then
        echo "📂 Di chuyển file wifi-connect-start.service..."
        sudo mv ViPi/scripts/wifi-connect-start.service "$SERVICE_FILE"
    else
        echo "⚠️ File wifi-connect-start.service đã tồn tại, bỏ qua..."
    fi
else
    echo "❌ Không tìm thấy file wifi-connect-start.service, kiểm tra lại thư mục ViPi/scripts/!"
    exit 1
fi

# Kích hoạt dịch vụ
echo "✅ Kích hoạt dịch vụ WiFi Connect..."
sudo systemctl enable wifi-connect-start.service
sudo systemctl restart wifi-connect-start.service

set -u
trap "exit 1" TERM
export TOP_PID=$$

: "${WFC_REPO:=balena-os/wifi-connect}"
: "${WFC_INSTALL_ROOT:=/usr/local}"

INSTALL_BIN_DIR="$WFC_INSTALL_ROOT/sbin"
INSTALL_UI_DIR="$WFC_INSTALL_ROOT/share/wifi-connect/ui"
RELEASE_URL="https://api.github.com/repos/balena-os/wifi-connect/releases/latest"

main() {
    need_cmd id
    need_cmd curl
    need_cmd systemctl
    need_cmd apt-get
    need_cmd grep
    need_cmd mktemp

    check_os_version
    install_wfc
    activate_network_manager
}

check_os_version() {
    local _version=""
    if [ -f /etc/os-release ]; then
        _version=$(grep -oP 'VERSION="\K[^"]+' /etc/os-release)
    fi

    if [ "$_version" = "8 (jessie)" ]; then
        err "🚫 Không hỗ trợ Debian 8 (jessie)."
    fi
}

install_wfc() {
    local _regex='browser_download_url": "\K.*armv7-unknown-linux-gnueabihf\.tar\.gz'
    local _arch_url
    local _download_dir

    echo "🌐 Đang lấy đường dẫn tải về..."
    _arch_url=$(curl -s "$RELEASE_URL" | grep -hoP "$_regex")
    
    if [ -z "$_arch_url" ]; then
        err "❌ Không tìm thấy URL tải WiFi Connect. Kiểm tra lại mạng hoặc API GitHub!"
    fi

    echo "📥 Đang tải WiFi Connect..."
    _download_dir=$(mktemp -d)
    
    curl -Ls "$_arch_url" -o "$_download_dir/wifi-connect.tar.gz"
    if [ $? -ne 0 ]; then
        err "❌ Tải file thất bại, kiểm tra lại kết nối mạng!"
    fi

    echo "📂 Giải nén WiFi Connect..."
    tar -xz -f "$_download_dir/wifi-connect.tar.gz" -C "$_download_dir"
    if [ $? -ne 0 ]; then
        err "❌ Giải nén thất bại! Có thể file bị lỗi hoặc tải về không đúng."
    fi

    echo "🚀 Cài đặt WiFi Connect..."
    sudo cp "$_download_dir/wifi-connect" "$INSTALL_BIN_DIR"

    # Xóa UI cũ trước khi tạo lại
    sudo rm -rf "$INSTALL_UI_DIR"
    sudo mkdir -p "$INSTALL_UI_DIR"
    if [ -d "ViPi/scripts/ui" ]; then
        sudo cp -r ViPi/scripts/ui "$INSTALL_UI_DIR"
    else
        echo "⚠️ Thư mục UI không tồn tại, bỏ qua..."
    fi

    rm -rf "$_download_dir"

    if ! command -v wifi-connect &> /dev/null; then
        err "❌ Cài đặt thất bại! Kiểm tra lại thư mục cài đặt."
    fi

    echo "✅ Cài đặt thành công WiFi Connect phiên bản: $(wifi-connect --version)"
}

activate_network_manager() {
    echo "🔄 Kiểm tra trạng thái NetworkManager..."
    if [ "$(systemctl is-active NetworkManager)" = "inactive" ]; then
        echo "⚙️  Kích hoạt NetworkManager..."
        sudo systemctl enable NetworkManager
        sudo systemctl start NetworkManager
    fi

    if [ ! "$(systemctl is-active NetworkManager)" = "active" ]; then
        err "❌ Không thể kích hoạt NetworkManager!"
    fi
}

need_cmd() {
    if ! command -v "$1" > /dev/null 2>&1; then
        err "⚠️ Cần cài đặt '$1' nhưng không tìm thấy lệnh này!"
    fi
}

err() {
    printf '\33[1;31m%s:\33[0m %s\n' "🚨 Lỗi" "$1" >&2
    exit 1
}

main "$@" || exit 1

echo ""
echo "======================================="
echo "  ✅ Cài đặt hoàn tất!"
echo "  🔄 Hệ thống sẽ khởi động lại sau 10 giây..."
echo "======================================="
sleep 10
sudo reboot
