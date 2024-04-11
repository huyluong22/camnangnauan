import 'package:camnangnauan/pages/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:camnangnauan/main.dart';
import 'package:camnangnauan/screen/reset_password.dart.dart';
import 'package:camnangnauan/screen/signup_screen.dart.dart';

import 'package:camnangnauan/reusable_widgets/reusable_widgets.dart';
import 'package:camnangnauan/utils/color_utils.dart.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  bool _isObscure = true; // Trạng thái mặc định là ẩn mật khẩu

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("FF3300"),
              hexStringToColor("FF6600"),
              hexStringToColor("FF6666")
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).size.height * 0.2,
              20,
              0,
            ),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/chef1.png"),
                const SizedBox(height: 30),
                reusableTextField(
                  "Tên đăng nhập",
                  Icons.person_outline,
                  false,
                  _emailTextController,
                ),
                const SizedBox(height: 20),
                // Thêm nút ẩn/hiện mật khẩu
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    reusableTextField(
                      "Mật khẩu",
                      Icons.lock_outline,
                      _isObscure,
                      _passwordTextController,
                    ),
                    IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                forgetPassword(context),
                firebaseUIButton(context, "Đăng nhập", () async {
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: _passwordTextController.text,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  } on FirebaseAuthException catch (e) {
                    String errorMessage = '';
                    if (e.code == 'invalid-email') {
                      errorMessage = 'Không đúng định dạng email.';
                    } else if (e.code == 'wrong-password') {
                      errorMessage = 'Tên đăng nhập hoặc mật khẩu không đúng.';
                    } else {
                      errorMessage = e.message ?? 'Đã xảy ra lỗi.';
                    }
                    if (errorMessage.contains('The supplied auth credential is incorrect')) {
                      errorMessage = 'Thông tin đăng nhập không chính xác.';
                    }
                    // Hiển thị pop-up thông báo khi có lỗi xảy ra
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Lỗi đăng nhập'),
                          content: Text(errorMessage),
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
                signUpOption(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Không có tài khoản?",
          style: TextStyle(color: Colors.white70),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
          child: const Text(
            " Đăng ký",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Quên mật khẩu?",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResetPassword()),
        ),
      ),
    );
  }
}
