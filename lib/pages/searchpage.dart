import 'package:camnangnauan/pages/favoritepage.dart';
import 'package:camnangnauan/pages/fooddetail.dart';
import 'package:camnangnauan/pages/homepage.dart';
import 'package:camnangnauan/screen/signin_screen.dart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final List<DocumentSnapshot> searchResults;

  const SearchPage({Key? key, required this.searchResults}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false,
        title: Text(
          "Kết quả tìm kiếm",
          style: TextStyle(color: Colors.white), // Đặt màu chữ thành màu trắng
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.orange,
        selectedItemColor: Colors.white,
        // Đặt màu mặc định cho các mục đã chọn thành màu trắng
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
              label: "Home"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Yêu thích"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: "Đăng xuất"
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15),
        itemCount: widget.searchResults.length,
        itemBuilder: (context, index) {
          final document = widget.searchResults[index];
          return buildItem(context, document);
        },
      ),
    );
  }

  Widget buildItem(BuildContext context,DocumentSnapshot document) {
    final List<dynamic> usersLiked = document['UsersLike'] ?? [];
    final User? user = _auth.currentUser;
    bool isLiked = false;

    // Check if the current user's ID is in the list of users who liked the food
    if (user != null && usersLiked.contains(user.uid)) {
      isLiked = true;
    }
    final String ten = document['Ten'] ?? '';
    final String anh = document['Anh'] ?? '';
    final String moTa = document['MoTa'] ?? '';
    final String thoiGian = document['ThoiGian'] ?? '';
    final String huongDan = document['HuongDan'] ?? ''; // Thêm thông tin hướng dẫ
    final String typeMon = document['TypeMon'] ?? ''; // Thêm thông tin loại món
    final List<dynamic> UserNotes = document['UserNotes'] ?? [];
    final List<dynamic> UsersLike = document['UsersLike'] ?? [];
    final String nguyenLieu = document['NguyenLieu'] ?? {};


    return InkWell(
      onTap: () {
        // Xử lý sự kiện khi nhấn vào hình ảnh
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FoodPageDetail(
            documentId: document.id,
            ten: ten,
            anh: anh,
            moTa: moTa,
            thoiGian: thoiGian,
            huongDan: huongDan,
            nguyenLieu: nguyenLieu,
            typeMon: typeMon,
            UserNotes:UserNotes,
            UsersLike: UsersLike,
          )),
        );
      },
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          // tuỳ chỉnh trang trí cho vùng hộp
          image: DecorationImage(
            // để đặt hình ảnh làm nền cho vùng chứa
            fit: BoxFit.cover,
            image: NetworkImage(anh),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(3),
              color: Colors.black.withOpacity(0.6),
              child: Text(
                ten,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            IconButton(
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : Colors.white,
              ),
              onPressed: () => toggleLike(document.id),
            ),
          ],
        ),
      ),
    );

  }

  void toggleLike(String documentID) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final String currentUserUID = user.uid;
      final DocumentSnapshot document = await FirebaseFirestore.instance.collection('food').doc(documentID).get();
      final List<dynamic> usersLiked = document['UsersLike'] ?? [];
      final bool isLiked = usersLiked.contains(currentUserUID);

      if (isLiked) {
        await FirebaseFirestore.instance.collection('food').doc(documentID).update({
          'UsersLike': FieldValue.arrayRemove([currentUserUID]),
        });
      } else {
        await FirebaseFirestore.instance.collection('food').doc(documentID).update({
          'UsersLike': FieldValue.arrayUnion([currentUserUID]),
        });
      }
    } else {
      print('User is not logged in.');
    }
  }
}



