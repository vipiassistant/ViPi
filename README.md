# ViPi Assistant

IMG đã cài driver Mic USB: https://drive.google.com/file/d/1YFjD6JKGK988xVYs0a4X9dlci9CsNG4Q/view?usp=sharing  
IMG đã cài driver Mic I2S: https://drive.google.com/file/d/1kYYMQDG7XgeOlvEzkzaJaYIteIJmDFv3/view?usp=drive_link
IMG đã cài Google Drive MIC 2 HATs new 22-12-2024: https://drive.google.com/file/d/16UJK7hH8EPBpHvvVJD5qkbRXBiWYeh4i/view

 - Linux kernel 5.15.84 
 - User/pass Pi :(pi/raspberry)
# Kết nối SSH vào Raspberry Pi:
Đảm bảo Raspberry Pi đã bật SSH.
Dùng terminal hoặc công cụ SSH client (như PuTTY) để kết nối:
```sh
ssh pi@<IP_ADDRESS>
User/pass Pi :(pi/raspberry)
```

# Để dùng với MicReSpeaker hãy chạy các lệnh sau:
```sh
cd /home/${USER}/
git clone https://github.com/HinTak/seeed-voicecard
cd seeed-voicecard
sudo ./install.sh

sudo nano /usr/share/alsa/alsa.conf
```
tìm đến dòng số 14 "~/.asoundrc" và thêm # vào đầu để tắt .asoundrc xomh rồi "sudo reboot"

# Xóa ViPi cũ và clone code mới về:
```sh
cd /home/${USER}/
rm -rf /home/pi/ViPi
git clone https://github.com/vipiassistant/ViPi.git /home/pi/ViPi
sudo reboot
```
 * Để dùng bản mới nhất vui lòng bấm cập nhật trên Wed: IP_ADDRESS:8888
 * Để xem hoạt đông vào Wed tại địa chỉ: IP_ADDRESS:9001 (user/pass: vipi/vipi)
 * Truy cập: https://console.picovoice.ai/ để lấy AccessKey
 * Truy cập : IP_ADDRESS:8888 để dán AccessKey vừa tạo vào cài đặt khởi động lại
 * Chúc bạn thành công
   
# Để chạy thủ công:
Vào IP_ADDRESS:9001 (user/pass: vipi/vipi) stop chương trình:
```sh
cd /home/${USER}/
source env/bin/activate
pkill -9 python
cd ViPi
cd src
python3 start.py
```

--------------------------
# Revision: 13-12-2024.
--------------------------
* Fix lỗi tìm kiếm nhạc
* Update Gemini API
chạy các lệnh sau
```sh
cd /home/${USER}/
source env/bin/activate
pip install --upgrade pip
pip install yt_dlp
```
# Bắt đầu với API Gemini
* Truy cập vào Google AI Studio.
* Đăng nhập bằng tài khoản Google của bạn.
* Tạo khoá API, dán vào Vipi/src/config/apiGemini:"XXXXX'
--------------------------
# Revision: 07-11-2023.
--------------------------
* Update MQTT cho Bot để phát thông báo từ Hass sang Bot
* Có thể phát bằng API nhưng lười

Cài đặt trong config.json trong Bot:
```sh
    "MQTT": {
        "control": "on",
        "mqtt_bocker": "192.168.1.150",
        "mqtt_topic": "my/mqtt/topic",
        "username": "pi",
        "password": "abc123"
    },
```

cài đặt trong Hass:
```sh
script:
  #Scrip phát thông báo ra loa ViPi
  phat_loa_vipi:
    alias: "scrip phat loa vipi"
    sequence:
      - service: mqtt.publish
        data_template:
          topic: "my/mqtt/topic"  # Chủ đề MQTT bạn muốn sử dụng
          payload: "{{ message }}"
  #Scrip test phát thông báo ra loa ViPi
  test_play_vipi:
    alias: "test scrip phát qua loa vipi"
    sequence:
      - service: script.phat_loa_vipi
        data:
          message: 'đây là scrip test phát nội dung ra loa vipi'
#Auto phát nội dung ra loa
automation:
  - alias: Phát cảnh báo khi đèn thay đổi trạng thái
    trigger:
      - platform: state
        entity_id: switch.sw_staire_1_right
    action:
      - service: script.phat_loa_vipi
        data_template:
          message: >
            Đèn cầu thang đã {{ 'bật' if is_state('switch.sw_staire_1_right', 'on') else 'tắt' }}.
```
--------------------------
# Revision: 05-09-2023.
--------------------------
* Thay đổi hiệu ứng Led APA Echo, bổ sung Màu cho led âm lượng, thêm trạng thái đèn led nhấp nháy khi có lỗi xảy ra
* Đơn giản cách thức hoạt động của cus_skill
* Thay đổi giao diện mới (+ thêm nhiều lỗi mới)
* Thay đổi nguồn tìm kiếm nhạc mặc định sang Youtube

--------------------------
# Revision: 30-06-2023
--------------------------
* Để dùng bản mới nhất vui lòng bấm cập nhật trên Wed: IP:8888 hoặc hostname:8888
 * Mặc định phím bấm, Để thay đổi vào setting cài đặt lại
```sh
      Phím: Volume - , Mức logic: 0, GPIO: 26
      Phím: Volume + , Mức logic: 0, GPIO: 22
      Phím: Play/stop, Mức logic: 0, GPIO: 13
      Phím: Assistant, Mức logic: 0, GPIO: 25 (nhấn single để gọi nhanh Asistant, nhấn double để bật tắt mic)
```
* Để bật tắt chế độ nghe liên tục hãy thay đổi on/off ở dòng sau trong config.json
```sh
     "Ask_again": {
         "control": "on"
     },
```
* Để nghe nhạc trên youtube: Hotword + Khẩu lệnh + Tên bài hát + Youtube
```sh
Ví dụ: Tèo ơi, phát bài hát hai mùa mưa trên Youtube
       vipi ơi, phát bài hát hai mùa mưa trên du tút
```
--------------------------
# Revision: 19-05-2023
--------------------------
 * Thay đổi sang môi trường Virtual Environment 
 Mở terminal và kích hoạt môi trường ảo bằng lệnh:
```sh
   source env/bin/activate
```
 * Không bắt buộc phải đăng ký tài khoản với Google
 * Ra lệnh đổi giọng trực tiếp bằng lời nó
 * Để dùng bản mới nhất vui lòng bấm cập nhật trên Wed: IP:8888
 * Xem hoạt đông : IP:9001 (user/pass: vipi/vipi)
 * Truy cập: https://console.picovoice.ai/ để lấy AccessKey

--------------------
# TÍNH NĂNG:
--------------------

# 1. Âm nhạc:
    a. Mở nhạc
    b. Điều khiển nhạc
    c. Điều chỉnh âm lượng
# 2. Smarthome:
    a. Điều khiển thiết bị
    b. Điều khiển kịch bản
    c. Tra cứu trạng thái
# 3. Đồng hồ & ngày giờ:
    a. Hỏi thời gian
    b. hỏi ngày tháng
    c. Hỏi âm lịch
# 4. Tra cứu thông tin:
    a. Hỏi thời tiết
    b. Hỏi tin tức
        - Vi Pi ơi, hôm nay có tin gì mới
        - Vi Pi ơi, đọc tin thể thao
    c. Tra cứu thông tin covid:
        - ok google, tin tức về covid
        - ok google, Việt Nam có bao nhiêu ca covid
# 5. Trẻ em:
    a. Kể chuyện
    b. Đánh vần
# 6. Tiện ích:
    a. Tính toán
    b. Chọn số ngẫu nhiên
    c. Hỏi giá vàng
    d. Hỏi giá ngoại tệ
# 7. Tra cứu:
    a. Tra cứu thông tin người nổi tiếng
    b. Tra cứu thông tin địa danh
    c. Tra cứu thông tin tổ chức
    d. Tra cứu thông tin văn học
    e. Hỏi đáp kiến thức
# 8. Chế độ trò truyện liên tục
    a. Bật chế độ hội thoại: (hotword + ['hỏi đáp','hội thoại','trò chuyện','liên tục','nói chuyện'])
        - Vi Pi ơi, bật hội thoại
    b. Tắt chế độ hội thoại
        - Dừng lại, ngừng lại, thoát
# 9. Nghe radio:
     - Bot hỗ trợ các kênh radio sau: VOV1, VOV2, VOV3, VOV GIAO THÔNG HÀ NỘI, VOV GIAO THÔNG HCM
    a. Mở radio
    b. Tắt radio
# 10. Gửi tin nhắn đến Telegram:
     a. Kích hoạt
        - Vi Pi ơi, gửi lời nhắn cho bố
        - Vi Pi ơi, nhắn tin cho mẹ
     b. Đọc nội dung cần gửi
        - bố ơi về đi, con đói bụng lắm rồi
# 11. Điều khiển thiết bị chromecast:
     a. Mở thiết bị chromecast
       - ok google, phát bài hát vĩnh biệt màu xanh trên tivi
     b. Điều khiển âm lượng thiết bị chromecast
       - ok google, tăng âm lượng trên tivi
# 12. Đa lệnh
     - Vi Pi ơi, bật đèn phòng khách và phát bài hát vĩnh biệt màu xanh
     - Vi Pi ơi, bật đèn phòng khách tắt đèn phòng ngủ thời tiết hôm nay

# 12. Đổi giọng đọc
     - Vi Pi ơi, đổi giọng edge nam
     - Vi Pi ơi, đổi giọng zalo nam
     - Vi Pi ơi, đổi giọng google nam
## Email liên hệ:  vipi.tearm@gmail.com
## Facebook: https://www.facebook.com/groups/285131860062315/
