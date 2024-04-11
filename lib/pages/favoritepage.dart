import 'package:camnangnauan/pages/fooddetail.dart';
import 'package:camnangnauan/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
 // Import trang FoodPageDetail
import 'package:camnangnauan/screen/signin_screen.dart.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false,
        title: Text(
          "Công thức nấu ăn",
          style: TextStyle(color: Colors.white), // Đặt màu chữ thành màu trắng
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.orange,
        selectedItemColor: Colors.white,
        currentIndex: 1,
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('food').where('UsersLike', arrayContains: _auth.currentUser!.uid).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text('Đã xảy ra lỗi', style: TextStyle(color: Colors.white)));
          }
          final List<DocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
              return ListTile(
                leading: Image.network(document['Anh']),
                title: Text(document['Ten'], style: TextStyle(color: Colors.white)),
                subtitle: Text(document['ThoiGian'], style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FoodPageDetail(
                      ten: document['Ten'],
                      anh: document['Anh'],
                      moTa: document['MoTa'],
                      thoiGian: document['ThoiGian'],
                      huongDan: document['HuongDan'],
                      nguyenLieu: document['NguyenLieu'],
                      typeMon: document['TypeMon'],
                      UserNotes: document['UserNotes'],
                      UsersLike: document['UsersLike'],
                    )),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
