import 'package:flutter/material.dart';

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 240,
    height: 240,
    color: Colors.white,
  );
}

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,//ẩn đi nếu là mật Khẩu
    enableSuggestions: !isPasswordType,//gợi ý từ vựng và ngữ pháp nên được bật hay không
    autocorrect: !isPasswordType,//tự động sửa lỗi chính tả nên được bật hay không
    cursorColor: Colors.white,//màu của con trỏ (caret) khi người dùng đang nhập liệu vào
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(//icon nhập
        icon,
        color: Colors.white70,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),//độ trong suốt của Icon TextFill
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,//Tắt nổi lên khi được chọn
      fillColor: Colors.white.withOpacity(0.3),//độ trong suốt của Textfill
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),//Bo tròn đường viền khung nhập
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswordType//xác định loại bàn phím hiển thị khi người dùng tương tác với TextField.
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container firebaseUIButton(BuildContext context, String title, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),//left,top,right,bottom
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),//Bo tròn góc của Container
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        title,
        style: const TextStyle(//Căn chỉnh Text của nút
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ButtonStyle(//Xác định mùa nút khi nhấn
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {//Nếu nút được nhấn sẽ là màu black26
              return Colors.black26;
            }
            return Colors.white;//Nếu không nhấn sẽ mặc định màu trắng
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(//Kiểu nút bo tròn
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
          )
      ),
    ),
  );
}