$(document).ready(function(){
  var slider = $('.slider').slick({
    dots: false,
    arrows: false,
    infinite: true,
    speed: 500,
    slidesToShow: 1,
    slidesToScroll: 1,
    asNavFor: '.navigation',
    autoplay: false,
    easing: 'easeInOutQuad', // Tùy chọn easing
    fade: true,
    swipe: true
  });

  var navigation = $('.navigation').slick({
    dots: false,
    arrows: false,
    infinite: true,
    speed: 500,
    slidesToShow: 4,
    slidesToScroll: 1,
    asNavFor: '.slider',
    focusOnSelect: true
  });

  $('.navigation').on('afterChange', function(event, slick, currentSlide){
    $('.nav-link').removeClass('active');
    $('.nav-link[data-slick-index="' + currentSlide + '"]').addClass('active');
  });

  $('.nav-link').on('click', function(e){
    e.preventDefault();
    var index = $(this).data('slick-index');
    slider.slick('slickGoTo', index);
  });

  slider.on('beforeChange', function(event, slick, currentSlide, nextSlide) {
    $('.navigation .slick-track').css('transform', 'none'); // Xóa thuộc tính transform của slick-track trong navigation
  });

  slider.on('beforeChange', function(event, slick, currentSlide, nextSlide) {
    $('.navigation .slick-slide').css('width', ''); // Xóa thuộc tính width của slick-slide trong navigation khi chuyển slide
  });
});


// Lưu nút
$(document).ready(function() {
	// Lấy trạng thái toggle button từ file JSON
	$.getJSON("/get-state-btn", function(data) {
		if (data) {
			$("#hassSwitch").prop("checked", data.hassSwitch);
			$("#microSwitch").prop("checked", data.microSwitch);
			// Kiểm tra trạng thái toggle trong JSON
			if (data.hassSwitch) {
                    $("#hass-config-box").show(); // Hiển thị div khi nút ở trạng thái true
                } else {
                    $("#hass-config-box").hide(); // Ẩn div khi nút ở trạng thái false
            }
		}
	});

	// Xử lý sự kiện khi toggle button thay đổi
	$("#hassSwitch").change(function() {
		var toggleState = $(this).prop("checked");

		// Gửi trạng thái toggle button đến server để lưu vào file JSON
		$.ajax({
			type: "POST",
			url: "/save-state-btn",
			data: JSON.stringify({ hassSwitch: toggleState }),
			contentType: "application/json",
			success: function(response) {
				console.log(response);
				// Kiểm tra trạng thái hiện tại
				if (toggleState) {
                    $("#hass-config-box").show(); // Hiển thị div khi nút ở trạng thái true
                } else {
                    $("#hass-config-box").hide(); // Ẩn div khi nút ở trạng thái false
                }
			},
			error: function(error) {
				console.log(error);
			}
		});
	});
	
	// Xử lý sự kiện khi toggle button thay đổi
	$("#microSwitch").change(function() {
		var toggleState = $(this).prop("checked");

		// Gửi trạng thái toggle button đến server để lưu vào file JSON
		$.ajax({
			type: "POST",
			url: "/save-state-btn",
			data: JSON.stringify({ microSwitch: toggleState }),
			contentType: "application/json",
			success: function(response) {
				console.log(response);
				
				if (toggleState) {
                    $("#hass-config-box").show(); // Hiển thị div khi nút ở trạng thái true
                } else {
                    $("#hass-config-box").hide(); // Ẩn div khi nút ở trạng thái false
                }
			},
			error: function(error) {
				console.log(error);
			}
		});
	});
});


// Chatbox
document.addEventListener('DOMContentLoaded', function() {
  var chatboxToggle = document.getElementById('chatbox-toggle');
  var chatbox = document.getElementById('chatbox');
  var chatboxClose = document.getElementById('chatbox-close');
  var messageInput = document.getElementById('message-input');
  var sendButton = document.getElementById('send-button');
  var chatLog = document.getElementById('chat-log');

  chatboxToggle.addEventListener('click', function() {
    chatbox.classList.add('open');
    chatboxToggle.classList.add('hidden');
    messageInput.focus();
  });

  chatboxClose.addEventListener('click', function() {
    chatbox.classList.remove('open');
    chatboxToggle.classList.remove('hidden');
  });

  sendButton.addEventListener('click', function(event) {
    event.preventDefault();
    sendMessage();
  });

  messageInput.addEventListener('keydown', function(event) {
    if (event.key === 'Enter' && !event.shiftKey) {
      event.preventDefault();
      sendMessage();
    }
  });

  function sendMessage() {
    var message = messageInput.value;
    if (message.trim() !== '') {
      appendMessage('Bạn', message);
      sayToBot(message);
      messageInput.value = '';
    }
  }

  function appendMessage(sender, message) {
    var messageElement = document.createElement('div');
    messageElement.textContent = sender + ': ' + message;
	messageElement.classList.add('me');
    chatLog.appendChild(messageElement);
    chatLog.scrollTop = chatLog.scrollHeight;
  }

  function sayToBot(text) {
    document.getElementById("message-input").placeholder = "Hỏi ViPi gì đi nào.";
    $.post("/chat", {
      text: text,
    }, function(jsondata, status) {
      if (jsondata["status"] == "success") {
        response = jsondata["response"];
        console.log(jsondata);
        if (response) {
          showBotMessage("ViPi: ", response);
        }
      }
    });
  }

  function showBotMessage(msg, response) {
    var messageElement = document.createElement('div');
    messageElement.textContent = msg + response;
    messageElement.classList.add('bot'); // Thêm class để căn lề tin nhắn bên trái
    chatLog.appendChild(messageElement);
    chatLog.scrollTop = chatLog.scrollHeight;
  }
});
