import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:driver/models/user_model.dart';
import 'package:driver/utility/my_constant.dart';
import 'package:driver/utility/my_dialog.dart';
import 'package:driver/widgets/show_images.dart';
import 'package:driver/widgets/show_titles.dart';
import 'package:driver/widgets/show_signout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authen extends StatefulWidget {
  const Authen({super.key});

  @override
  State<Authen> createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  bool statusRedEye = true;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BuildImages(size),
                  BuildWelcome(),
                  BuildPlease(),
                  BuildUsers(size),
                  BuildPassword(size),
                  BuildLogin(size),
                  BuildCreateAccount(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row BuildCreateAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 40),
          child: ShowTitles(
            title: 'คุณเป็นสมาชิกเเล้วหรือไม่?',
            textStyle: MyConstant().h3Style(),
          ),
        ),
        TextButton(
          onPressed: () =>
              Navigator.pushNamed(context, MyConstant.routeCreateAccount),
          child: Text(
            'สมัครสมาชิก',
            style: TextStyle(fontFamily: "MN MINI", fontSize: 16),
          ),
        ),
      ],
    );
  }

  Row BuildLogin(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 40),
          width: size * 0.9,
          height: 48,
          child: ElevatedButton(
            style: MyConstant().myButtonStyle(),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                String email = emailController.text;
                String password = passwordController.text;
                checkAuthen(email: email,password:password);
              }
            },
            child: Text(
              'เข้าสู่ระบบ',
              style: TextStyle(
                fontSize: 20,
                fontFamily: "MN MINI",
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<Null?> checkAuthen({String? email, String? password}) async {
    String apiCheckAuthen =
        '${MyConstant.domain}/Driver_getUserWhereUser.php?isAdd=true&email_address=$email';
        await Dio().get(apiCheckAuthen).then((value)async {
          if (value.toString() == 'null') {
          MyDialog().normalDialog(context,'User False !!', 'ไม่มีข้อมูล $email อยู่ในระบบ');
        } else {
          for (var item in json.decode(value.data)) {
            UserModel model = UserModel.fromMap(item);
            if (password == model.password) {
              SharedPreferences preferences = await SharedPreferences.getInstance();
              preferences.setString('driver_id', model.driver_id);
              preferences.setString('email_address', model.email_address);
              Navigator.pushNamedAndRemoveUntil(
                    context, MyConstant.routeShowNavbar, (route) => false);
            } else {
              MyDialog().normalDialog(context, 'Password Fail !!', 'กรุณากรอกรหัสผ่านอักครั้ง');
            }
          }
        }
        });
  }

  Row BuildUsers(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 40),
          width: size * 0.9,
          child: TextFormField(
            controller: emailController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกอีเมลของท่าน';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: TextStyle(
                color: Colors.black,
                fontFamily: "MN MINI",
                fontSize: 19,
              ),
              labelText: 'อีเมล',
              hintText: 'กรุณากรอกอีเมลของคุณ',
              hintStyle: TextStyle(
                fontFamily: "MN MINI",
                fontSize: 16,
              ),
              contentPadding: EdgeInsets.only(left: 20),
              suffixIcon: Icon(
                Icons.mail_outline,
                color: Colors.black,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(25),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row BuildPassword(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 40),
          width: size * 0.9,
          child: TextFormField(
            controller: passwordController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกกรอกรหัสผ่านของท่าน';
              } else {
                return null;
              }
            },
            obscureText: statusRedEye,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    statusRedEye = !statusRedEye;
                  });
                },
                icon: statusRedEye
                    ? Icon(
                        Icons.remove_red_eye,
                        color: Colors.black,
                      )
                    : Icon(
                        Icons.remove_red_eye_outlined,
                        color: Colors.black,
                      ),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: TextStyle(
                color: Colors.black,
                fontFamily: "MN MINI",
                fontSize: 19,
              ),
              labelText: 'รหัสผ่าน',
              hintText: 'กรุณากรอกรหัสผ่านของคุณ',
              hintStyle: TextStyle(
                fontFamily: "MN MINI",
                fontSize: 16,
              ),
              contentPadding: EdgeInsets.only(left: 20),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(25),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row BuildWelcome() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(top: 70),
            child: ShowTitles(
                title: 'ยินดีต้อนรับ', textStyle: MyConstant().h4Style())),
      ],
    );
  }

  Row BuildPlease() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 5),
          child: ShowTitles(
              title: 'กรุณาเข้าสู่ระบบของท่าน',
              textStyle: MyConstant().h5Style()),
        ),
      ],
    );
  }

  Row BuildImages(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          width: size * 0.5,
          child: ShowImages(path: MyConstant.logo),
        ),
      ],
    );
  }
}
