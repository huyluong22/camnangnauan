import 'package:camnangnauan/pages/favoritepage.dart';
import 'package:camnangnauan/pages/homepage.dart';
import 'package:camnangnauan/screen/signin_screen.dart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FoodPageDetail extends StatefulWidget {
  final String documentId;
  final String anh;
  final String huongDan;
  final String moTa;
  final String nguyenLieu;
  final String ten;
  final String thoiGian;
  final String typeMon;

  final List<dynamic> UserNotes;
  final List<dynamic> UsersLike;

  const FoodPageDetail({
    required this.anh,
    required this.huongDan,
    required this.moTa,
    required this.nguyenLieu,
    required this.ten,
    required this.thoiGian,
    required this.typeMon,
    required this.UserNotes,
    required this.UsersLike,
    required this.documentId,
  });

  @override
  _FoodPageDetailState createState() => _FoodPageDetailState();
}


class _FoodPageDetailState extends State<FoodPageDetail> {

  final _notesController = TextEditingController();
  void _showNotesDialog() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final currentUserUID = user.uid;

      // Kiểm tra xem đã có notes của người dùng hiện tại chưa
      final DocumentSnapshot document = await FirebaseFirestore.instance.collection('food').doc(widget.documentId).get();
      final List<dynamic> userNotes = document['UserNotes'] ?? [];

      String initialNotes = ''; // Biến lưu trữ nội dung của notes
      for (int i = 0; i < userNotes.length; i++) {
        final String userNote = userNotes[i];
        if (userNote.startsWith(currentUserUID)) {
          initialNotes = userNote.substring(currentUserUID.length + 1); // Lấy nội dung của notes
          break;
        }
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Take Notes'),
          backgroundColor: Colors.orange,
          content: Container(
            height: MediaQuery.of(context).size.height * 0.7, // Thiết lập chiều cao của hộp thoại là 70% của chiều cao màn hình
            padding: EdgeInsets.symmetric(vertical: 8.0), // Khoảng cách giữa nội dung và biên của hộp thoại
            child: TextField(
              controller: _notesController..text = initialNotes, // Hiển thị nội dung của notes (nếu có) trong TextField
              expands: true, // Cho phép TextField mở rộng theo chiều dọc khi có nhiều nội dung hơn
              minLines: null, // Số dòng tối thiểu hiển thị khi nhập
              maxLines: null, // Số dòng tối đa hiển thị khi nhập, null để không giới hạn
              textAlignVertical: TextAlignVertical.top, // Đặt vị trí bắt đầu nhập ở dòng trên cùng
              decoration: InputDecoration(
                hintText: 'Nhập nội dung notes',
                border: OutlineInputBorder(), // Định dạng viền cho TextField
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng hộp thoại
              },
              child: Text('Hủy',style: TextStyle(color: Colors.white),),

            ),
            ElevatedButton(
              onPressed: () {
                _saveNotes(); // Lưu notes khi ấn nút Xác nhận
                Navigator.pop(context); // Đóng hộp thoại
              },
              style: ElevatedButton.styleFrom(
              ),
              child: Text(
                'Xác nhận',
                style: TextStyle(color: Colors.black), // Đặt màu chữ của nút là màu đen
              ),
            ),
          ],
        ),
      );
    }
  }

  void _saveNotes() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final currentUserUID = user.uid;
      final notes = _notesController.text;
      final combinedNotes = '$currentUserUID-$notes'; // Kết hợp uid và notes

      // Kiểm tra xem đã có notes của người dùng hiện tại chưa
      final DocumentSnapshot document = await FirebaseFirestore.instance.collection('food').doc(widget.documentId).get();
      final List<dynamic> userNotes = document['UserNotes'] ?? [];

      // Tìm và cập nhật lại notes của người dùng nếu đã tồn tại
      for (int i = 0; i < userNotes.length; i++) {
        final String userNote = userNotes[i];
        if (userNote.startsWith(currentUserUID)) {
          userNotes[i] = combinedNotes; // Thay đổi nội dung của notes
          await FirebaseFirestore.instance.collection('food').doc(widget.documentId).update({
            'UserNotes': userNotes,
          });
          return; // Thoát khỏi hàm sau khi cập nhật notes thành công
        }
      }

      // Nếu không tìm thấy notes của người dùng, thêm mới vào mảng UserNotes
      await FirebaseFirestore.instance.collection('food').doc(widget.documentId).update({
        'UserNotes': FieldValue.arrayUnion([combinedNotes]),
      });
    }
  }
  bool isLiked = false; // Khai báo biến isLiked ở mức trang thái để sử dụng trong toàn bộ trang

  void showLike() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final List<dynamic> usersLiked = widget.UsersLike; // Sử dụng UsersLike từ widget
      final String currentUserUID = user.uid;
      isLiked = usersLiked.contains(currentUserUID); // Xác định isLiked dựa trên danh sách người dùng thích
      setState(() {}); // Cập nhật trạng thái của widget
    }
  }
  void toggleLike(String documentID) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final String currentUserUID = user.uid;
      final DocumentSnapshot document = await FirebaseFirestore.instance.collection('food').doc(documentID).get();
      final List<dynamic> usersLiked = document['UsersLike'] ?? [];
      final bool isAlreadyLiked = usersLiked.contains(currentUserUID);

      setState(() {
        if (isAlreadyLiked) {
          // Nếu đã thích, xoá UID của người dùng hiện tại khỏi danh sách UsersLike của món ăn
          FirebaseFirestore.instance.collection('food').doc(documentID).update({
            'UsersLike': FieldValue.arrayRemove([currentUserUID]),
          });
          isLiked = false; // Cập nhật lại biến isLiked
        } else {
          // Nếu chưa thích, thêm UID của người dùng hiện tại vào danh sách UsersLike của món ăn
          FirebaseFirestore.instance.collection('food').doc(documentID).update({
            'UsersLike': FieldValue.arrayUnion([currentUserUID]),
          });
          isLiked = true; // Cập nhật lại biến isLiked
        }
      });
      print("Is Liked: $isLiked");
    } else {
      // Người dùng chưa đăng nhập, bạn có thể xử lý tương ứng ở đây.
      print('User is not logged in.');
    }
  }

  List<String> splitHuongDan(String huongDan) {
    return huongDan.split('-').map((step) => step.trim()).toList();
  }

  List<String> extractNguyenLieu(String nguyenLieu) {
    return nguyenLieu.split('-').map((step) => step.trim()).toList();
  }
  @override
  void initState() {
    super.initState();
    showLike(); // Gọi hàm showLike trong initState để cập nhật trạng thái isLiked khi trang được khởi tạo
    updateViews();
  }
  Future<void> updateViews() async {
    try {
      // Lấy tham chiếu đến tài liệu món ăn từ Firestore
      DocumentReference foodRef = FirebaseFirestore.instance.collection('food').doc(widget.documentId);

      // Bắt đầu một giao dịch Firestore để cập nhật lượt views
      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot foodSnapshot = await transaction.get(foodRef);
        if (foodSnapshot.exists) {
          // Lấy giá trị hiện tại của lượt views
          int currentViews = foodSnapshot['views'] ?? 0;

          // Tăng lượt views lên 1
          int updatedViews = currentViews + 1;

          // Cập nhật lượt views mới vào tài liệu món ăn
          transaction.update(foodRef, {'views': updatedViews});
        }
      });
    } catch (e) {
      print("Error updating views: $e");
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          "Công thức nấu ăn",
          style: TextStyle(color: Colors.white), // Màu chữ là màu trắng
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.note_add), // Icon cho chức năng take notes
            onPressed: () {
              _showNotesDialog();
            },
          ),
          IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.white,
            ),
            onPressed: () => toggleLike(widget.documentId),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.orange,
        selectedItemColor: Colors.white,
        currentIndex: 0,
        onTap: (int index) {
          switch (index) {
            case 0: // Home button
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
              break;
            case 1: // Favorites button
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritePage()),
              );
              break;
            case 2: // Logout button
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInScreen()),
              );
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Yêu thích",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: "Đăng xuất",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              widget.anh,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16.0),
            Text(
              '${widget.ten}',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Màu chữ là màu trắng
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Loại món ăn: ${widget.typeMon}',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white, // Màu chữ là màu trắng
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '${widget.moTa}',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white, // Màu chữ là màu trắng
              ),
            ),
            SizedBox(height: 8.0),
            Divider(color: Colors.white),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Căn giữa các thành phần trong hàng
              children: [
                Icon(
                  Icons.access_time, // Icon đồng hồ
                  color: Colors.white, // Màu của icon
                ),
                SizedBox(width: 8.0), // Khoảng cách giữa Icon và Text
                Text(
                  '${widget.thoiGian}',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white, // Màu chữ là màu trắng
                  ),
                ),
              ],
            ),
            Divider(color: Colors.white),
            SizedBox(height: 16.0),
            Text(
              'Nguyên liệu:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Màu chữ là màu trắng
              ),
            ),
            SizedBox(height: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: extractNguyenLieu(widget.nguyenLieu).expand((bua) {
                return [
                  Text(
                    bua.trim(),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white, // Màu chữ là màu trắng
                    ),
                  ),
                  Divider(color: Colors.white), // Đường kẻ giữa các dòng
                ];
              }).toList(),
            ),
            SizedBox(height: 16.0),
            Text(
              'Hướng dẫn:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Màu chữ là màu trắng
              ),
            ),
            SizedBox(height: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: splitHuongDan(widget.huongDan).map((bua) {
                return Text(
                  bua.trim(),
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white, // Màu chữ là màu trắng
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

}
