import 'package:camnangnauan/pages/favoritepage.dart';
import 'package:camnangnauan/pages/fooddetail.dart';
import 'package:camnangnauan/pages/homepage.dart';
import 'package:camnangnauan/screen/signin_screen.dart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final List<DocumentSnapshot> searchResults;
  final String searchKeyword; // Thêm trường để lưu từ khóa tìm kiếm

  const SearchPage({Key? key, required this.searchResults, required this.searchKeyword}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  void _setInitialSearchKeyword() {
    _searchController.text = widget.searchKeyword;
  }
  @override
  void initState() {
    super.initState();
    _setInitialSearchKeyword();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.orange,

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
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Tìm kiếm",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Kiểm tra xem ô tìm kiếm có rỗng không trước khi gọi searchFood
                    if (_searchController.text.isNotEmpty) {
                      searchFood(_searchController.text);
                    } else {
                      // Hiển thị thông báo hoặc thực hiện hành động phù hợp khi ô tìm kiếm trống
                      // Ví dụ:
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Vui lòng nhập từ khoá tìm kiếm.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.search, color: Colors.grey),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height, // Giới hạn chiều cao của Container
              ),
              child: GridView.builder(
                shrinkWrap: true, // Đặt thuộc tính shrinkWrap cho GridView
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: widget.searchResults.length,
                itemBuilder: (context, index) {
                  final document = widget.searchResults[index];
                  return buildItem(context, document);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
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
          MaterialPageRoute(
            builder: (context) => FoodPageDetail(
              documentId: document.id,
              ten: ten,
              anh: anh,
              moTa: moTa,
              thoiGian: thoiGian,
              huongDan: huongDan,
              nguyenLieu: nguyenLieu,
              typeMon: typeMon,
              UserNotes: UserNotes,
              UsersLike: UsersLike,
            ),
          ),
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(3),
              color: Colors.black.withOpacity(0.6),
              child: Text(
                thoiGian,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void searchFood(String searchText) async {
    final searchTextFormatted = formatSearchText(searchText);

    // Tạo một chuỗi chứa các ký tự đặc biệt để đảm bảo tìm kiếm chính xác
    final specialChar = String.fromCharCode(65535);
    final searchTextWithSpecialChar = '$searchTextFormatted$specialChar';

    // Truy vấn trên trường 'Ten'
    var snapshot = await FirebaseFirestore.instance.collection('food')
        .where('Ten', isGreaterThanOrEqualTo: searchTextFormatted)
        .where('Ten', isLessThan: searchTextWithSpecialChar)
        .get();

    // Nếu không tìm thấy kết quả trên trường 'Ten', thực hiện tìm kiếm trên trường 'normalizedname'
    if (snapshot.docs.isEmpty) {
      snapshot = await FirebaseFirestore.instance.collection('food')
          .where('Normalizedname', isGreaterThanOrEqualTo: searchTextFormatted)
          .where('Normalizedname', isLessThan: searchTextWithSpecialChar)
          .get();
    }

    // Lấy danh sách kết quả
    List<DocumentSnapshot> searchResults = snapshot.docs;
    print(searchResults);

    // Chuyển hướng đến trang SearchPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(searchResults: searchResults, searchKeyword: searchText),
      ),
    );
  }

  String formatSearchText(String input) {
    // Tách chuỗi thành các từ riêng biệt
    List<String> words = input.split(' ');
    // Chuyển đổi ký tự đầu tiên của mỗi từ thành chữ in hoa
    List<String> capitalizedWords = words.map((word) {
      return capitalizeFirstLetter(word);
    }).toList();
    // Kết hợp các từ lại thành một chuỗi mới
    return capitalizedWords.join(' ');
  }

  String capitalizeFirstLetter(String word) {
    if (word.isEmpty) {
      return word;
    }
    return word[0].toUpperCase() + word.substring(1);
  }
}



