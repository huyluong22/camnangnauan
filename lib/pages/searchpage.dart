import 'package:camnangnauan/pages/fooddetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  final List<DocumentSnapshot> searchResults;

  const SearchPage({Key? key, required this.searchResults}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kết quả tìm kiếm'),
      ),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final document = searchResults[index];
          // Hiển thị thông tin cơ bản về món ăn
          return ListTile(
            title: Text(document['Ten']),
            subtitle: Text(document['MoTa']),
            onTap: () {
              // Chuyển hướng đến trang chi tiết món ăn khi người dùng chọn một món
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoodPageDetail(
                    documentId: document.id,
                    ten: document['Ten'],
                    anh: document['Anh'],
                    moTa: document['MoTa'],
                    thoiGian: document['ThoiGian'],
                    huongDan: document['HuongDan'],
                    nguyenLieu: document['NguyenLieu'],
                    typeMon: document['TypeMon'],
                    UserNotes: document['UserNotes'],
                    UsersLike: document['UsersLike'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
