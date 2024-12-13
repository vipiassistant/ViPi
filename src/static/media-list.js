$(document).ready(function() {
  // Lấy danh sách file từ server
  $.ajax({
    url: "/get-file-list",
    type: "GET",
    success: function(response) {
      var fileList = response.fileList;

      // Sắp xếp danh sách file từ mới tới cũ
      fileList.sort(function(a, b) {
        var dateA = new Date(a.date);
        var dateB = new Date(b.date);
        return dateB - dateA;
      });

      // Hiển thị danh sách file
      fileList.forEach(function(fileData) {
        var li = $("<li></li>");

        // Hiển thị tên file
        var fileName = $("<span></span>").text(fileData.name);
        li.append(fileName);

        // Hiển thị dung lượng file
        var fileSize = $("<span></span>").text("Dung lượng: " + formatFileSize(fileData.size));
        li.append(fileSize);

        // Hiển thị ngày giờ file được tạo
		var fileDate = $("<span></span>").text("Ngày tạo: " + formatDate(fileData.date));
		li.append(fileDate);

		// Hàm định dạng ngày giờ
		function formatDate(dateString) {
		  var date = new Date(dateString);
		  var formattedDate = date.toLocaleString("vi-VN", { timeZone: "Asia/Ho_Chi_Minh" });
		  return formattedDate;
		}


        // Tạo nút xóa
        var deleteButton = $("<button></button>").text("Xóa");
        li.append(deleteButton);

        // Gắn sự kiện xóa file khi click vào nút xóa
        deleteButton.on("click", function() {
          var fileToDelete = $(this).parent().data("fileName");
          deleteFile(fileToDelete);
        });

        // Gắn dữ liệu fileName vào phần tử li để sử dụng trong sự kiện xóa file
        li.data("fileName", fileData.name);

        // Thêm phần tử li vào danh sách file
        $("#fileList").append(li);
      });
    },
    error: function(error) {
      console.log("Đã xảy ra lỗi trong quá trình lấy danh sách file.");
    }
  });
});

function formatFileSize(size) {
  var units = ["bytes", "KB", "MB", "GB", "TB"];
  var index = 0;
  while (size >= 1024 && index < units.length - 1) {
    size /= 1024;
    index++;
  }
  return size.toFixed(2) + " " + units[index];
}

function formatDate(dateString) {
  var date = new Date(dateString);
  return date.toLocaleString();
}

function deleteFile(fileName) {
  // Gửi yêu cầu xóa file đến server
  $.ajax({
    url: "/delete-file",
    type: "POST",
    data: JSON.stringify({ fileName: fileName }),
    contentType: "application/json",
    success: function(response) {
      console.log("File đã được xóa thành công.");

      // Xóa phần tử li tương ứng với file đã bị xóa
      $("li[data-fileName='" + fileName + "']").remove();
    },
    error: function(error) {
      console.log("Đã xảy ra lỗi trong quá trình xóa file.");
    }
  });
}


