import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:camnangnauan/screen/signin_screen.dart.dart';

import 'package:camnangnauan/reusable_widgets/reusable_widgets.dart';
import 'package:camnangnauan/utils/color_utils.dart.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _confirmPasswordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();

  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Đăng ký",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("CB2B93"),
              hexStringToColor("9546C4"),
              hexStringToColor("5E61F4")
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                  "Nhập tên người dùng",
                  Icons.person_outline,
                  false,
                  _userNameTextController,
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                  "Nhập Email",
                  Icons.person_outline,
                  false,
                  _emailTextController,
                ),
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    reusableTextField(
                      "Nhập mật khẩu",
                      Icons.lock_outlined,
                      _isPasswordObscured,
                      _passwordTextController,
                    ),
                    IconButton(
                      icon: Icon(
                        _isPasswordObscured ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordObscured = !_isPasswordObscured;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    reusableTextField(
                      "Nhập lại mật khẩu",
                      Icons.lock_outlined,
                      _isConfirmPasswordObscured,
                      _confirmPasswordTextController,
                    ),
                    IconButton(
                      icon: Icon(
                        _isConfirmPasswordObscured ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                firebaseUIButton(context, "Đăng ký", () {
                  String userName = _userNameTextController.text.trim();
                  String email = _emailTextController.text.trim();
                  String password = _passwordTextController.text;
                  String confirmPassword = _confirmPasswordTextController.text;

                  // Kiểm tra định dạng email
                  if (!isValidEmail(email)) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Lỗi đăng ký'),
                          content: Text('Định dạng email không hợp lệ.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Đóng pop-up
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                    return; // Dừng quá trình đăng ký nếu email không hợp lệ
                  }

                  // Kiểm tra xem mật khẩu và nhập lại mật khẩu có khớp nhau không
                  if (password == confirmPassword) {
                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    )
                        .then((value) {
                      print("Tạo tài khoản mới");
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignInScreen(),
                        ),
                      );
                    }).catchError((error) {
                      print("Error ${error.toString()}");
                    });
                  } else {
                    // Hiển thị thông báo nếu mật khẩu và nhập lại mật khẩu không khớp nhau
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Lỗi đăng ký'),
                          content: Text('Mật khẩu và nhập lại mật khẩu không khớp nhau.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Đóng pop-up
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Hàm kiểm tra định dạng email
  bool isValidEmail(String email) {
    // Sử dụng biểu thức chính quy để kiểm tra định dạng email
    String pattern =
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }
}