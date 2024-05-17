# Cẩm nang nấu ăn
# Các chức năng của ứng dụng
- Tạo tài khoản
- Tra cứu thông tin món ăn
- Thêm món ăn vào danh sách ưa thích
- Thêm note, chỉnh note cho món ăn
- Tra cứu món ăn thông qua filter
- Gợi ý, đề xuất món ăn 
- Tìm lại mật khẩu cho người dùng
- Tra cứu qua chat bot Gemini
# Cơ sở dữ liệu Firebase
 1 colletion có tên là **food** bao gồm các trường sau
![dâtbase]([gs://camnangnauan-edaf6.appspot.com/database.png](https://firebasestorage.googleapis.com/v0/b/camnangnauan-edaf6.appspot.com/o/database.png?alt=media&token=67f21ee4-5537-4736-b4f5-1fec9a85cf4b))
# Hướng dẫn cài đặt
Phải có Android Studio, Firebase
**Đây là phiên bản Flutter và Dart hiện tại của tôi**
- Flutter 3.19.6  
- Dart 3.3.4 

Bạn có thể cập nhật phiên bản Dart thông qua Android Studio như sau : **Tool > Flutter > Upgrade Flutter**
Sau đó bạn có thể Download code trên về và khởi chạy.
# Một số hình ảnh minh hoạ
**Trang đăng nhập**

![dangnhap](https://firebasestorage.googleapis.com/v0/b/camnangnauan-edaf6.appspot.com/o/dangnhap.png?alt=media&token=825944ae-4687-4c53-8493-cc8c2a42ed3c)

**Giao diện trang chủ**

![trangchu1](https://firebasestorage.googleapis.com/v0/b/camnangnauan-edaf6.appspot.com/o/trangchu1.png?alt=media&token=8fdf344f-52a0-401c-b3e0-474ee72ae8e1)

![trangchu2](https://firebasestorage.googleapis.com/v0/b/camnangnauan-edaf6.appspot.com/o/trangchu2.png?alt=media&token=8405cae6-4345-479e-8e1a-6327784236ec)

**Kết quả tìm kiếm**

![timkiem](https://firebasestorage.googleapis.com/v0/b/camnangnauan-edaf6.appspot.com/o/timkiem.png?alt=media&token=529e026a-9fe2-46dc-85c4-b6306f157a36)

**Chi tiết món ăn**

![ctmonan](https://firebasestorage.googleapis.com/v0/b/camnangnauan-edaf6.appspot.com/o/chitietmonan.png?alt=media&token=6e3784f8-fbe0-4867-b1f0-fdb2a2bc424b)

**Khi bạn ấn vào Icon note ở trên thanh AppBar sẽ xuất hiện phần cho bạn nhập để lưu ghi chú của mình**

![note](https://firebasestorage.googleapis.com/v0/b/camnangnauan-edaf6.appspot.com/o/takenote.png?alt=media&token=45531aa1-d009-4d0f-9b02-e43bcb3dbe6c)

**Tiếp đến nếu bạn ấn vào Icon trái tim thì nó sẽ lưu món ăn đó vào danh sách món ăn ưa thích của bạn**

![thich](https://firebasestorage.googleapis.com/v0/b/camnangnauan-edaf6.appspot.com/o/thich.png?alt=media&token=07a59898-e296-4bac-8940-c864f79f76a0)

**Danh sách món ăn ưa thích**(Nếu bạn ấn nút bên cạnh danh sách thì sẽ xoá món ăn đó khỏi danh sách món ăn ưa thích)

![dsthich](https://firebasestorage.googleapis.com/v0/b/camnangnauan-edaf6.appspot.com/o/dsthich.png?alt=media&token=6b4dd416-bbff-4436-8579-abd4b6893f5d)

**Filter lọc món ăn**(Đây là kết quả sau khi lọc với mục được chọn là Cơm)

![filter](https://firebasestorage.googleapis.com/v0/b/camnangnauan-edaf6.appspot.com/o/filter.png?alt=media&token=1ebdcab5-b506-4d05-ba64-bd2dae039985)

**ChatBot Gemini**(Khi bạn ấn vào Icon Gemini ở trang chủ sẽ xuất hiện trang để chat với Gemini như sau)

![trangchuupdate](https://firebasestorage.googleapis.com/v0/b/camnangnauan-edaf6.appspot.com/o/trangchuupdate.png?alt=media&token=e00c26fc-2f8c-4f07-a1ae-c6e1587607f7)

![gemini](https://firebasestorage.googleapis.com/v0/b/camnangnauan-edaf6.appspot.com/o/gemini.png?alt=media&token=1ea10cc6-02e4-4216-a470-250138e73051)

