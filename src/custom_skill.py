# File để bạn có thể thêm các kỹ năng (Skills) cho Bot
# Hướng dẫn thực hiện:

# Bước 1: Thêm từ khóa (keys) vào file keywords.json
# Mỗi skill được định nghĩa dưới dạng một danh sách từ khóa đại diện.
# Ví dụ:
# "keyword": {
#     "cus__skill__1": [  # Tên của skill
#         "key 1",        # Từ khóa đại diện cho skill này
#         "key 2",
#         "key 3",
#         "key 4"
#     ],
#     "cus__skill__2": [
#         "key 1",
#         "key 2"
#     ]
# }
# Cụ thể:
# - skill chúc mừng sinh nhật:
#     "skill__happy__birthday": [
#         "mừng sinh nhật",
#         "birthday"
#     ]
# - skill chúc Tết:
#     "skill__happy__new__year": [
#         "chúc tết",
#         "tết nguyên đán"
#     ]
# - skill dự đoán vietlot:
#     "skill__predict__vietlott": [
#         "vietlott"
#     ]


# Bước 2: Tạo hàm xử lý logic cho từng skill.
# Các hàm này sẽ được gọi khi từ khóa tương ứng được phát hiện trong câu hỏi của người dùng.



# Lưu ý để skill có hiệu lực bắt buộc phải thêm ở keywords.json, và không trùng muốn xóa skill nào của hệ thống thì xóa ở file keywords.json hệ thống bỏ qua
import random  # Thư viện để lựa chọn ngẫu nhiên các câu trả lời


# Hàm chúc mừng sinh nhật
def skill__happy__birthday(skill, data):
    """
    Hàm xử lý logic cho skill chúc mừng sinh nhật.
    
    Args:
        skill (str): Tên của skill (không sử dụng trong logic này).
        data (str): Chuỗi đầu vào từ người dùng.

    Returns:
        Tuple[str, bool, bool]: 
            - Một chuỗi văn bản chúc mừng sinh nhật.
            - `True` để tiếp tục hỏi lại cuộc hội thoại, `False` nếu không tiếp tục hỏi.
            - `True` để lưu câu trả lời để sử dụng lại sau, `False` nếu không lưu.
    """
    answers = [
        "Chúc mừng sinh nhật! Mong rằng bạn có một ngày thật vui vẻ và đầy ý nghĩa.",
        "Chúc mừng sinh nhật! Hy vọng năm mới của bạn sẽ đem lại nhiều thành công và niềm vui.",
        "Happy birthday! Chúc bạn luôn khoẻ mạnh, hạnh phúc và thành công trong cuộc sống.",
        "Sinh nhật vui vẻ! Hãy tận hưởng ngày đặc biệt này cùng gia đình và bạn bè của bạn."
    ]
    text = random.choice(answers)
    continue_asking = True  # Tiếp tục hỏi lại cuộc hội thoại
    temporary_save = True  # Lưu câu trả lời để sử dụng lại sau
    return text, continue_asking, temporary_save

# Hàm chúc mừng năm mới
def skill__happy__new__year(skill, data):
    """
    Hàm xử lý logic cho skill chúc mừng năm mới.
    
    Args:
        skill (str): Tên của skill (không sử dụng trong logic này).
        data (str): Chuỗi đầu vào từ người dùng.

    Returns:
        Tuple[str, bool, bool]: 
            - Một chuỗi văn bản chúc mừng năm mới.
            - `True` để tiếp tục hỏi lại cuộc hội thoại, `False` nếu không tiếp tục hỏi.
            - `True` để lưu câu trả lời để sử dụng lại sau, `False` nếu không lưu.
    """
    answers = [
        "Chúc mừng năm mới! Mong rằng năm mới mang lại nhiều niềm vui, thành công và sức khỏe cho bạn.",
        "Chúc mừng năm mới! Hy vọng năm mới sẽ đem lại nhiều cơ hội và thành tựu lớn cho bạn.",
        "Happy New Year! Chúc bạn có một năm mới thật phát đạt và hạnh phúc.",
        "Năm mới an lành! Chúc bạn và gia đình có một kỳ nghỉ vui vẻ và đầy ý nghĩa."
    ]
    text = random.choice(answers)
    continue_asking = True  # Tiếp tục hỏi lại cuộc hội thoại
    temporary_save = True  # Lưu câu trả lời để sử dụng lại sau
    return text, continue_asking, temporary_save

#skill dự đoán vé số Vietlott.
def skill__predict__vietlott(skill, data):
    """
    Hàm xử lý logic cho skill dự đoán vé số Vietlott.
    """
    # Tạo một bộ số ngẫu nhiên trong phạm vi từ 1 đến 45 (giả định vé số Vietlott có 45 số)
    predicted_numbers = random.sample(range(1, 46), 6)  # Chọn 6 số ngẫu nhiên
    predicted_numbers.sort()  # Sắp xếp lại các số cho dễ nhìn

    # Đảm bảo các số có định dạng 2 chữ số (thêm số 0 nếu là số có 1 chữ số)
    formatted_numbers = [f"{num:02d}" for num in predicted_numbers]

    return f"Dự đoán vé số Vietlott của bạn là: {', '.join(formatted_numbers)}", True, False


# Hàm tạo động lực (Motivate)
def skill__motivate(skill, data):
    """
    Hàm xử lý logic cho skill tạo động lực.
    """
    answers = [
        "Bạn đang làm rất tốt, hãy tiếp tục cố gắng!",
        "Không có gì là không thể, bạn chỉ cần bắt đầu.",
        "Hãy tin tưởng vào bản thân, bạn có thể đạt được bất kỳ điều gì.",
        "Mỗi ngày là một cơ hội mới để trở nên tốt hơn."
    ]
    text = random.choice(answers)
    continue_asking = True  # Tiếp tục hỏi lại cuộc hội thoại
    temporary_save = False  # Không cần lưu câu trả lời
    return text, continue_asking, temporary_save



def skill__tell__fairytale(skill, data):
    """
    Hàm xử lý logic cho skill kể chuyện cổ tích.
    """
    fairytales = [
        "Ngày xưa có một cô bé tên là Lọ Lem, cô sống với bà mẹ kế và hai chị em khó ưa. Nhưng cuối cùng, nhờ có một bà tiên tốt bụng, cô đã trở thành công chúa.",
        "Có một chàng trai tên là Cô bé Lúa Mì, chàng gặp rất nhiều thử thách trong hành trình, nhưng nhờ lòng dũng cảm, chàng đã cứu được vương quốc khỏi nguy cơ diệt vong.",
        "Ngày xưa, có một con rùa và một con thỏ, chúng thi chạy đua. Con thỏ tự tin rằng mình sẽ thắng, nhưng rùa kiên nhẫn và quyết tâm, cuối cùng rùa là người chiến thắng."
    ]
    text = random.choice(fairytales)
    continue_asking = True
    temporary_save = False
    return text, continue_asking, temporary_save

def skill__introduce__event(skill, data):
    """
    Hàm xử lý logic cho skill giới thiệu sự kiện.
    """
    events = [
        "Sự kiện hội chợ mùa xuân sẽ diễn ra vào cuối tuần này tại công viên thành phố, với các hoạt động vui chơi và mua sắm thú vị.",
        "Vào tháng tới, sẽ có một buổi hòa nhạc của ban nhạc rock nổi tiếng tại sân vận động lớn. Đừng bỏ lỡ!",
        "Một hội thảo về kỹ năng lãnh đạo sẽ được tổ chức vào cuối tháng này tại trung tâm hội nghị. Đây là cơ hội tuyệt vời để học hỏi và kết nối."
    ]
    text = random.choice(events)
    continue_asking = True
    temporary_save = False
    return text, continue_asking, temporary_save


def skill__tell_joke(skill, data):
    """
    Hàm xử lý logic cho skill kể chuyện cười.
    """
    jokes = [
        "Tại sao gà qua đường? Để đến phía bên kia!",
        "Làm thế nào để con voi giấu mình trong rừng? Nó sơn móng chân màu xanh lá và trốn trên cây."
        "Bạn có thấy con voi nào trên cây không? Đó là vì nó trốn rất giỏi!",
        "Tại sao lập trình viên không thích ra ngoài? Vì họ không thích giải quyết lỗi trong thế giới thực."
    ]
    text = random.choice(jokes)
    continue_asking = True  # Tiếp tục hỏi lại cuộc hội thoại
    temporary_save = False  # Không cần lưu câu trả lời
    return text, continue_asking, temporary_save

def skill__tell_fairytale(skill, data):
    """
    Hàm xử lý logic cho skill kể chuyện cổ tích.
    """
    fairytales = [
        "Ngày xưa có một cô bé tên là Lọ Lem, cô sống với bà mẹ kế và hai chị em khó ưa. Nhưng cuối cùng, nhờ có một bà tiên tốt bụng, cô đã trở thành công chúa.",
        "Có một chàng trai tên là Cô bé Lúa Mì, chàng gặp rất nhiều thử thách trong hành trình, nhưng nhờ lòng dũng cảm, chàng đã cứu được vương quốc khỏi nguy cơ diệt vong.",
        "Ngày xưa, có một con rùa và một con thỏ, chúng thi chạy đua. Con thỏ tự tin rằng mình sẽ thắng, nhưng rùa kiên nhẫn và quyết tâm, cuối cùng rùa là người chiến thắng."
    ]
    text = random.choice(fairytales)
    continue_asking = True
    temporary_save = False
    return text, continue_asking, temporary_save

def skill__introduce__event(skill, data):
    """
    Hàm xử lý logic cho skill giới thiệu sự kiện.
    """
    events = [
        "Sự kiện hội chợ mùa xuân sẽ diễn ra vào cuối tuần này tại công viên thành phố, với các hoạt động vui chơi và mua sắm thú vị.",
        "Vào tháng tới, sẽ có một buổi hòa nhạc của ban nhạc rock nổi tiếng tại sân vận động lớn. Đừng bỏ lỡ!",
        "Một hội thảo về kỹ năng lãnh đạo sẽ được tổ chức vào cuối tháng này tại trung tâm hội nghị. Đây là cơ hội tuyệt vời để học hỏi và kết nối."
    ]
    text = random.choice(events)
    continue_asking = True
    temporary_save = False
    return text, continue_asking, temporary_save
    
def skill__get_gold_price(skill, data):
    """
    Hàm xử lý logic cho skill lấy giá vàng.
    """
    # Đây chỉ là một giá vàng giả định, thay thế bằng dữ liệu thực tế nếu cần
    gold_price = "1 lượng vàng 24K hiện tại có giá khoảng 56 triệu VND."
    continue_asking = True  # Tiếp tục hỏi lại cuộc hội thoại
    temporary_save = False  # Không cần lưu câu trả lời
    return gold_price, continue_asking, temporary_save

def skill__listen_radio(skill, data):
    """
    Hàm xử lý logic cho skill nghe radio.
    """
    radio_channels = [
        "Kênh VOV1 - Tin tức thời sự, cập nhật liên tục.",
        "Kênh Radio Nhạc Vàng - Nghe nhạc vàng bất hủ.",
        "Kênh FM 99.0 - Âm nhạc nhẹ nhàng, dễ chịu cho buổi sáng.",
        "Kênh Rock Radio - Những bản nhạc rock sôi động, mạnh mẽ."
    ]
    selected_channel = random.choice(radio_channels)
    continue_asking = True
    temporary_save = False
    return f"Hiện tại bạn có thể nghe {selected_channel}.", continue_asking, temporary_save



def skill__get_weather(skill, data):
    """
    Hàm xử lý logic cho skill lấy thông tin thời tiết.
    """
    # Giả sử API có thể trả về thời tiết của một thành phố
    city = data if data else "Hà Nội"  # Lấy tên thành phố từ data, nếu không có thì mặc định là Hà Nội
    api_key = "your_api_key_here"  # Thay bằng API key thực của bạn
    url = f"http://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}&units=metric"
    
    response = requests.get(url)
    weather_data = response.json()
    
    if weather_data.get("cod") == 200:
        temp = weather_data["main"]["temp"]
        description = weather_data["weather"][0]["description"]
        return f"Thời tiết tại {city}: {temp}°C, {description}.", True, False
    else:
        return "Không thể lấy thông tin thời tiết, vui lòng thử lại.", True, False



def skill__recommend_movie_or_book(skill, data):
    """
    Hàm xử lý logic cho skill giới thiệu phim hoặc sách.
    """
    movies = [
        "Phim 'Inception' - Một bộ phim khoa học viễn tưởng về giấc mơ.",
        "Phim 'The Shawshank Redemption' - Câu chuyện về tình bạn và sự hy vọng trong nhà tù.",
        "Phim 'The Dark Knight' - Một bộ phim siêu anh hùng đầy kịch tính và hành động."
    ]
    books = [
        "Sách '1984' của George Orwell - Một tác phẩm nổi tiếng về xã hội tương lai.",
        "Sách 'To Kill a Mockingbird' của Harper Lee - Câu chuyện về sự bất công và phân biệt chủng tộc.",
        "Sách 'Harry Potter and the Sorcerer's Stone' của J.K. Rowling - Câu chuyện về một cậu bé phù thủy."
    ]

    if "phim" in data.lower():
        text = random.choice(movies)
    elif "sách" in data.lower():
        text = random.choice(books)
    else:
        text = "Xin vui lòng yêu cầu một bộ phim hoặc sách để tôi gợi ý."
    
    continue_asking = True
    temporary_save = False
    return text, continue_asking, temporary_save
    
def skill__simple_calculator(skill, data):
    """
    Hàm xử lý logic cho skill tính toán đơn giản.
    """
    try:
        result = eval(data)  # Dùng eval để tính toán chuỗi biểu thức toán học
        return f"Kết quả của phép toán {data} là: {result}", True, False
    except:
        return "Xin vui lòng nhập một phép toán hợp lệ.", True, False
        
        
from datetime import datetime

def skill__get_current_time(skill, data):
    """
    Hàm xử lý logic cho skill lấy thời gian hiện tại.
    """
    current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    return f"Thời gian hiện tại là: {current_time}", True, False


import random

def skill__generate_random_name(skill, data):
    """
    Hàm xử lý logic cho skill tạo tên ngẫu nhiên.
    """
    names = ["Aiden", "Sophia", "Mason", "Isabella", "Jackson", "Olivia"]
    random_name = random.choice(names)
    return f"Tên ngẫu nhiên cho bạn là: {random_name}", True, False


def skill__listen_podcast(skill, data):
    """
    Hàm xử lý logic cho skill nghe podcast.

    """
    # Giả sử data là tên podcast hoặc thể loại người dùng muốn nghe
    # Tạo một số liên kết mẫu cho podcast
    podcast_database = {
        "chuyện ma": "https://spotify.com/podcast/xyz",
        "tâm sự cuộc sống": "https://apple.com/podcast/xyz",
        "kinh doanh": "https://google.com/podcast/xyz",
        "chuyện cười": "https://spotify.com/podcast/abc"
    }
    
    # Tìm kiếm podcast dựa trên dữ liệu đầu vào
    podcast_link = podcast_database.get(data.lower())
    
    if podcast_link:
        return f"Bạn có thể nghe podcast '{data}' tại: {podcast_link}", True, False
    else:
        return "Không tìm thấy podcast theo yêu cầu của bạn, vui lòng thử lại với tên podcast khác.", True, False
