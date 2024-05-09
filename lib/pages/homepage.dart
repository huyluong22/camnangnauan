import 'package:camnangnauan/pages/chatgemini.dart';
import 'package:camnangnauan/pages/favoritepage.dart';
import 'package:camnangnauan/pages/fooddetail.dart';
import 'package:camnangnauan/pages/searchpage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contained_tab_bar_view_with_custom_page_navigator/contained_tab_bar_view_with_custom_page_navigator.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../screen/signin_screen.dart.dart';

final List<String> imgList = [];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> typeMonList = [];// Danh sách các loại TypeMon từ Firestore
  List<DocumentSnapshot> foodList = [];// Danh sách các món ăn từ Firestore
  Map<String, bool> isSelected = {};
  List<DocumentSnapshot> filteredFoodList = [];
  List<DocumentSnapshot> foodListByViews = [];
  @override
  void initState() {
    super.initState();
    fetchTypeMon(); // Gọi hàm để truy vấn các loại TypeMon từ Firestore
    fetchFoodList(); // Gọi hàm để truy vấn danh sách các món ăn từ Firestore
    fetchFoodListByViews();
    // Thiết lập Timer để đặt views của tất cả các món ăn về 0 sau một tuần
    Timer(Duration(days: 7), () {
      resetViews();
    });
  }
  void fetchFoodListByViews() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('food')
          .orderBy('views', descending: true) // Sắp xếp theo lượt views giảm dần
          .get();
      setState(() {
        foodListByViews = querySnapshot.docs.cast<DocumentSnapshot>().toList();
      });
    } catch (e) {
      print("Error fetching food list by views: $e");
    }
  }
  void resetViews() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('food').get();
      querySnapshot.docs.forEach((doc) {
        FirebaseFirestore.instance.collection('food').doc(doc.id).update({
          'views': 0,
        });
      });
    } catch (e) {
      print("Error resetting views: $e");
    }
  }
  void fetchFoodList() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('food').get();
      setState(() {
        foodList = querySnapshot.docs.cast<DocumentSnapshot>().toList();
      });
    } catch (e) {
      print("Error fetching food list: $e");
    }
  }

  void fetchTypeMon() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('food').get();
      Set<String> typeMonSet = Set<String>();
      querySnapshot.docs.forEach((doc) {
        typeMonSet.add(doc['TypeMon']);
      });
      typeMonSet.forEach((typeMon) {
        isSelected[typeMon] = false; // Khởi tạo giá trị ban đầu là false cho mỗi TypeMon
      });
      setState(() {
        typeMonList = typeMonSet.toList();
      });
    } catch (e) {
      print("Error fetching TypeMon: $e");
    }
  }
// Widget để hiển thị danh sách FilterChip
  Widget buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: typeMonList.map((typeMon) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(typeMon),
              onSelected: (bool selected) {
                handleFilterChipSelection(typeMon);
              },
              selected: isSelected[typeMon] ?? false,
              selectedColor: Colors.blue,
              backgroundColor: Colors.grey[300],
              checkmarkColor: Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }

  void handleFilterChipSelection(String selectedTypeMon) {
    setState(() {
      // Đặt tất cả các giá trị về false trước khi đặt true cho filter chip được chọn
      isSelected.forEach((key, value) {
        isSelected[key] = false;
      });
      isSelected[selectedTypeMon] = true; // Đặt true cho filter chip được chọn
    });
    // Lọc danh sách món ăn để chỉ bao gồm những món có loại TypeMon tương ứng với loại đã chọn
    filteredFoodList = foodList.where((doc) => doc['TypeMon'] == selectedTypeMon).toList();
    // Cập nhật danh sách ảnh chỉ bao gồm các ảnh của món ăn đã lọc
    setState(() {
      imgList.clear(); // Xóa danh sách ảnh cũ
      // Thêm ảnh của các món ăn đã lọc vào danh sách ảnh
      imgList.addAll(filteredFoodList.map<String>((doc) => doc['Anh'] as String)); // Chuyển đổi thành List<String>
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Danh sách các URL ảnh:');
    imgList.forEach((url) {
      print(url);
    });
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false, // loại bỏ nút back về
        title: Text("Công thức nấu ăn"),
        flexibleSpace: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 16.0),
          child: GestureDetector(
            onTap: () {
              // Điều hướng đến trang chat của Gemini khi ấn vào hình ảnh
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatScreen()),
              );
            },
            child: Image.asset('assets/images/gemini.png', width: 30, height: 30), // Thay đổi đường dẫn và kích thước ảnh theo yêu cầu của bạn
          ),
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
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          // đặt lề ngang là 20 và lề dọc là 10
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
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
                SizedBox(height: 15,),
                buildFilterChips(),
                Container(
                  color: Colors.black,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 2.0, // tỉ lệ khung hình
                      enlargeCenterPage: true, // hình ở giữa sẽ lớn hơn
                      scrollDirection: Axis.horizontal, // cuộn theo chiều ngang
                      autoPlay: true, // tự động chuyển đổi
                    ),
                    items: filteredFoodList.map((DocumentSnapshot document) {
                      String imageUrl = document['Anh'];
                      String ten = document['Ten'];
                      String thoiGian = document['ThoiGian'];
                      String moTa = document['MoTa'];
                      String huongDan = document['HuongDan'];
                      String typeMon = document['TypeMon'];
                      List<dynamic> UserNotes = document['UserNotes'];
                      String nguyenLieu = document['NguyenLieu'];
                      List<dynamic> UsersLike = document['UsersLike'];
                      return Builder(
                        builder: (BuildContext context) {
                          return Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FoodPageDetail(
                                        documentId: document.id,
                                        ten: ten,
                                        anh: imageUrl,
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
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  color: Colors.black.withOpacity(0.6),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ten,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        thoiGian,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 15,),
                Container(
                  color: Colors.black,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          'Tuần này nấu gì ?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      CarouselSlider(
                        options: CarouselOptions(
                          aspectRatio: 2.0, // tỉ lệ khung hình
                          enlargeCenterPage: true, // hình ở giữa sẽ lớn hơn
                          scrollDirection: Axis.horizontal, // cuộn theo chiều ngang
                          autoPlay: true, // tự động chuyển đổi
                        ),
                        items: foodListByViews.map((DocumentSnapshot document) {
                          String imageUrl = document['Anh'];
                          String ten = document['Ten'];
                          String thoiGian = document['ThoiGian'];
                          String moTa = document['MoTa'];
                          String huongDan = document['HuongDan'];
                          String typeMon = document['TypeMon'];
                          List<dynamic> UserNotes = document['UserNotes'];
                          String nguyenLieu = document['NguyenLieu'];
                          List<dynamic> UsersLike = document['UsersLike'];
                          return Builder(
                            builder: (BuildContext context) {
                              return Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FoodPageDetail(
                                            documentId: document.id,
                                            ten: ten,
                                            anh: imageUrl,
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
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      color: Colors.black.withOpacity(0.6),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ten,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            thoiGian,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ],
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

    // Tạo truy vấn Firestore
    final snapshot = await FirebaseFirestore.instance.collection('food')
        .where('Ten', isGreaterThanOrEqualTo: searchTextFormatted)
        .where('Ten', isLessThan: searchTextWithSpecialChar)
        .get();

    // Lấy danh sách kết quả
    List<DocumentSnapshot> searchResults = snapshot.docs;
    print(searchResults);

    // Chuyển hướng đến trang SearchPage và truyền từ khoá tìm kiếm
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
