import 'package:camnangnauan/pages/favoritepage.dart';
import 'package:camnangnauan/pages/homepage.dart';
import 'package:camnangnauan/screen/signin_screen.dart.dart';
import 'package:flutter/material.dart';

class FoodPageDetail extends StatefulWidget {
  final String anh;
  final String huongDan;
  final String moTa;
  final String nguyenLieu;
  final String ten;
  final String thoiGian;
  final String typeMon;
  final String UserNotes;
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
  });

  @override
  _FoodPageDetailState createState() => _FoodPageDetailState();
}

class _FoodPageDetailState extends State<FoodPageDetail> {
  List<String> splitHuongDan(String huongDan) {
    return huongDan.split('-').map((step) => step.trim()).toList();
  }

  List<String> extractNguyenLieu(String nguyenLieu) {
    return nguyenLieu.split('-').map((step) => step.trim()).toList();
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
              'Tên món: ${widget.ten}',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Màu chữ là màu trắng
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Thời gian: ${widget.thoiGian}',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white, // Màu chữ là màu trắng
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Loại món: ${widget.typeMon}',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white, // Màu chữ là màu trắng
              ),
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
            SizedBox(height: 16.0),
            Text(
              'Mô tả: ${widget.moTa}',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white, // Màu chữ là màu trắng
              ),
            ),
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
              children: extractNguyenLieu(widget.nguyenLieu).map((bua) {
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
