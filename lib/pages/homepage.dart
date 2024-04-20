import 'package:camnangnauan/pages/favoritepage.dart';
import 'package:camnangnauan/pages/fooddetail.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contained_tab_bar_view_with_custom_page_navigator/contained_tab_bar_view_with_custom_page_navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screen/signin_screen.dart.dart';

final List<String> imgList = [
  "assets/images/content1.png",
  "assets/images/content2.jpg",
  "assets/images/content3.jpg"
];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false, // loại bỏ nút back về
        title: Text("Công thức nấu ăn"),
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
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          // đặt lề ngang là 20 và lề dọc là 10
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.search),
                    ),
                    hintText: "Tìm kiếm",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    fillColor: Colors.white,
                    //màu khung
                    filled: true,
                  ),
                ),
                SizedBox(height: 15,),
                Container(
                  color: Colors.black,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 2.0, // tỉ lệ khung hình
                      enlargeCenterPage: true, // hình ở giữa sẽ lớn hơn
                      scrollDirection: Axis.horizontal, // cuộn theo chiều ngang
                      autoPlay: true, // tự động chuyển đổi
                    ),
                    items: imgList.map((String imagePath) {
                      return Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.black,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: 600,
                  child: ContainedTabBarView(
                    tabs: [
                      Text('Các Bạn Bếp',
                        style: TextStyle(color: Colors.white, fontSize: 20),),
                      Text('Kho Cảm Hứng',
                        style: TextStyle(color: Colors.white, fontSize: 20),),
                    ],
                    views: [
                      Container( //<Các bạn bếp
                        color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          //chỉnh độ cao lề trên
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  child: Image.asset(
                                    "assets/images/logo2rm.png",
                                    fit: BoxFit.cover,
                                  ),
                                  alignment: Alignment.center,
                                ),
                              ),
                              SizedBox(height: 20,),
                              Center(
                                child: Text(
                                  "Chào bạn! Hãy cùng nhau học hỏi và làm những món ăn mới trên CookNew "
                                      "cho gia đình và người thân và bạn bè nhé",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              SizedBox(height: 15,),
                              Center(
                                child: Text(
                                  "Theo dõi và đừng bỏ lỡ những món mới trên NewCook, "
                                      "hãy chia sẻ và nấu những người thân của bạn về những món ăn mới mà bạn học được nhé! ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                              SizedBox(height: 15,),
                            ],
                          ),
                        ),
                      ), //Các bạn bếp>
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        color: Colors.black,
                        width: MediaQuery.of(context).size.width,
                        // Hãy thay đổi chiều cao của Container bằng cách sử dụng Expanded hoặc SizedBox
                        child: SizedBox(
                          height: 600, // Đặt chiều cao tối đa của Container
                          child: SingleChildScrollView(
                            child: FutureBuilder(
                              future: FirebaseFirestore.instance.collection('food').limit(20).get(),
                              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }
                                if (snapshot.hasError || snapshot.data == null) {
                                  return Text('Error: ${snapshot.error}');
                                }
                                final List<DocumentSnapshot> documents = snapshot.data!.docs;
                                return GridView.builder(
                                  physics: ScrollPhysics(), //  danh sách có thể cuộn được.
                                  shrinkWrap: true, // Thuộc tính này xác định xem danh sách có thu gọn lại để phù hợp với nội dung hay không. true có nghĩa là danh sách chỉ chiếm một khoảng không gian cần thiết.
                                  primary: true, // Thuộc tính này xác định xem danh sách là danh sách chính của màn hình hay không.
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( // Thuộc tính này xác định cách bố trí các phần tử trong lưới
                                      crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15), // Ngăn chặn GridView cuộn
                                  itemCount: documents.length,
                                  itemBuilder: (context, index) {
                                    final document = documents[index];
                                    return buildItem(document);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                    onChange: (index) => print(index),
                  ),
                ),
                SizedBox(height: 15),
                Center(
                  child: Text("Chúc bạn nấu thành công nha",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 15),
                Center(
                  child: Image.asset(
                    'assets/images/logo3rm.png',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItem(DocumentSnapshot document) {
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

      setState(() {
        if (isLiked) {
          // Nếu đã thích, xoá UID của người dùng hiện tại khỏi danh sách UsersLike của món ăn
          FirebaseFirestore.instance.collection('food').doc(documentID).update({
            'UsersLike': FieldValue.arrayRemove([currentUserUID]),
          });
        } else {
          // Nếu chưa thích, thêm UID của người dùng hiện tại vào danh sách UsersLike của món ăn
          FirebaseFirestore.instance.collection('food').doc(documentID).update({
            'UsersLike': FieldValue.arrayUnion([currentUserUID]),
          });
        }
      });
    } else {
      // Người dùng chưa đăng nhập, bạn có thể xử lý tương ứng ở đây.
      print('User is not logged in.');
    }
  }
}
