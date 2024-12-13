
# File mở để bạn có thể thêm Skill cho Bot
# Bước 1: Thêm key vào keywords.jonson

###########################
#	"keyword": {
#		"cus__skill__1": [
#			"key 1",
#			"key 2",
#			"key 3",
#			"key 4"
#		],
#		"cus__skill__2": [
#			"key 1",
#			"key 2",
#			"key 3",
#			"key 4"
#		]
#	},
# Ví dụ với skill Happy__Birthday:
#		"skill__happy__birthday": [
#			"mừng sinh nhật",
#			"birthday",
# skill chúc Tết
#		"skill__happy__new__year": [
#			"chúc tết",
#			"tết nguyên đán",
#Bước 2 tạo hàm:
###########################

import random

#hàm chúc mừng sinh nhật
def skill__happy__birthday(skill,data):
    answers = [
        "Chúc mừng sinh nhật! Mong rằng bạn có một ngày thật vui vẻ và đầy ý nghĩa.",
        "Chúc mừng sinh nhật! Hy vọng năm mới của bạn sẽ đem lại nhiều thành công và niềm vui.",
        "Happy birthday! Chúc bạn luôn khỏe mạnh, hạnh phúc và thành công trong cuộc sống.",
        "Sinh nhật vui vẻ! Hãy tận hưởng ngày đặc biệt này cùng gia đình và bạn bè của bạn."
    ]
    answer = random.choice(answers)
    return answer, True
#hàm chúc Tết
def skill__happy__new__year(skill,data):
    answers = [
        "Chúc mừng năm mới! Mong rằng năm mới mang lại nhiều niềm vui, thành công và sức khỏe cho bạn.",
        "Chúc mừng năm mới! Hy vọng năm mới sẽ đem lại nhiều cơ hội và thành tựu lớn cho bạn.",
        "Happy New Year! Chúc bạn có một năm mới thật phát đạt và hạnh phúc.",
        "Năm mới an lành! Chúc bạn và gia đình có một kỳ nghỉ vui vẻ và đầy ý nghĩa."
    ]
    answer = random.choice(answers)
    return answer, True


