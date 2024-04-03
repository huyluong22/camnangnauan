import 'package:carousel_slider/carousel_slider.dart';
import 'package:contained_tab_bar_view_with_custom_page_navigator/contained_tab_bar_view_with_custom_page_navigator.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
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
                MaterialPageRoute(builder: (context) => SignInScreen()),
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


      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        // đặt lề ngang là 20 và lề dọc là 10
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {

                    },
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
              //<CarouselSlider
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
              //CarouselSlider>

              //<ContainedTabBarView
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

                      ),
                  ],
                  onChange: (index) => print(index),
                ),
              ),
              //ContainedTabBarView>
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
    );
  }
}
