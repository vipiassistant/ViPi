#!/bin/bash

echo "Trình cài đặt WIFI connect"
echo ""

sudo mv ViPi/scripts/wifi-connect-start.service /lib/systemd/system/wifi-connect-start.service
sudo systemctl enable wifi-connect-start.service
sudo systemctl start wifi-connect-start.service

set -u
trap "exit 1" TERM
export TOP_PID=$$

: "${WFC_REPO:=balena-os/wifi-connect}"
: "${WFC_INSTALL_ROOT:=/usr/local}"

SCRIPT='raspbian-install.sh'
NAME='WiFi Connect Raspbian Installer'

INSTALL_BIN_DIR="$WFC_INSTALL_ROOT/sbin"
INSTALL_UI_DIR="$WFC_INSTALL_ROOT/share/wifi-connect/ui"

RELEASE_URL="https://api.github.com/repos/balena-os/wifi-connect/releases/latest"

CONFIRMATION=false

main() {
    for arg in "$@"; do
        case "$arg" in
            -h|--help)
                usage
                exit 0
                ;;
            -y)
                CONFIRMATION=false
                ;;
            *)
                ;;
        esac
    done

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
        err "Distributions based on Debian 8 (jessie) are not supported"
    fi
}

install_wfc() {
    local _regex='browser_download_url": "\K.*armv7-unknown-linux-gnueabihf\.tar\.gz'
    local _arch_url
    local _download_dir

    echo "Đang lấy đường dẫn tải về..."
    _arch_url=$(curl -s "$RELEASE_URL" | grep -hoP "$_regex")
    
    if [ -z "$_arch_url" ]; then
        err "Không tìm thấy URL tải WiFi Connect. Kiểm tra lại mạng hoặc API GitHub!"
    fi

    echo "Tải file WiFi Connect..."
    _download_dir=$(mktemp -d)
    
    curl -Ls "$_arch_url" -o "$_download_dir/wifi-connect.tar.gz"
    if [ $? -ne 0 ]; then
        err "Tải file thất bại, kiểm tra lại mạng!"
    fi

    tar -xz -f "$_download_dir/wifi-connect.tar.gz" -C "$_download_dir"
    if [ $? -ne 0 ]; then
        err "Giải nén thất bại, có thể file bị lỗi!"
    fi

    sudo cp "$_download_dir/wifi-connect" $INSTALL_BIN_DIR
    sudo mkdir -p $INSTALL_UI_DIR
    sudo rm -rdf $INSTALL_UI_DIR
    sudo cp ViPi/scripts/ui $INSTALL_UI_DIR
    rm -rdf "$_download_dir"

    _wfc_version=$(wifi-connect --version)
    echo "Cài đặt thành công $_wfc_version"
}

activate_network_manager() {
    if [ "$(systemctl is-active NetworkManager)" = "inactive" ]; then
        echo 'NetworkManager chưa được kích hoạt, đang kích hoạt...'
        sudo systemctl enable NetworkManager
        sudo systemctl start NetworkManager
    fi

    if [ ! "$(systemctl is-active NetworkManager)" = "active" ]; then
        err 'Không thể kích hoạt NetworkManager'
    fi
}

need_cmd() {
    if ! command -v "$1" > /dev/null 2>&1; then
        err "Cần cài đặt '$1' (không tìm thấy lệnh)"
    fi
}

err() {
    printf '\33[1;31m%s:\33[0m %s\n' "$NAME" "$1" >&2
    exit 1
}

main "$@" || exit 1

echo "Hoàn thành cài đặt, vui lòng reboot..."
