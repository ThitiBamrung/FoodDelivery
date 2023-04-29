import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fooddelivery/states/create_account2.dart';
import 'package:fooddelivery/widgets/show_titles.dart';
import 'package:fooddelivery/utility/my_constant.dart';
import 'package:fooddelivery/widgets/show_images.dart';
import 'package:fooddelivery/utility/my_dialog.dart';
import 'package:fooddelivery/widgets/show_progress.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController ownernameController = TextEditingController();
  //TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool statusRedEye = true;

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        actions: [
          //BuildCreate(),
          //BuildNextPage(size),
        ],
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 0,
        title: Text(
          'สมัครสมาชิก',
          style: TextStyle(
              color: Colors.black, fontSize: 36, fontFamily: "MN MINI"),
        ),
        backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                BuildPhone(size),
                BuildName(size),
                //BuildLastName(size),
                BuildEmail(size),
                BuildPassword(size),
                BuildNextPage(size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> Insertdata() async {
    String phone = phoneController.text;
    String ownername = ownernameController.text;
    //String lastname = lastnameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    print(
        '##phone = $phone, name = $ownername, email = $email, password = $password');
    String path =
        '${MyConstant.domain}/fooddelivery/getUserWhereUser.php?isAdd=true&email=$email';
    await Dio().get(path).then((value) {
      print('## value ==>> $value');
      if (value.toString() == 'null') {
        print('Email Success');
        Navigator.pushNamed(context, MyConstant.routeCreateAccount2);
      } else {
        MyDialog().normalDialog(context, 'Email Fale?', 'Please change email');
      }
    });
  }

  Row BuildNextPage(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 30),
          width: size * 0.9,
          height: 48,
          child: ElevatedButton(
            style: MyConstant().myButtonStyle(),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreateBussinessDetail(
                        phone: phoneController.text,
                        ownername: ownernameController.text,
                        //lastname: lastnameController.text,
                        email: emailController.text,
                        password: passwordController.text),
                  ),
                );
              }
            },
            child: Text(
              'ต่อไป',
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

  Row BuildPassword(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          width: size * 0.9,
          child: TextFormField(
            controller: passwordController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกกรอกรหัสผ่านของท่าน';
              } else {}
            },
            maxLength: 255,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
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
              hintStyle: TextStyle(
                fontFamily: "MN MINI",
                fontSize: 16,
              ),
              labelText: 'รหัสผ่าน',
              hintText: 'กรุณากรอกรหัสผ่านของท่าน',
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

  Row BuildEmail(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          width: size * 0.9,
          child: TextFormField(
            controller: emailController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกอีเมลของท่าน';
              } else {}
            },
            maxLength: 255,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: TextStyle(
                color: Colors.black,
                fontFamily: "MN MINI",
                fontSize: 19,
              ),
              hintStyle: TextStyle(
                fontFamily: "MN MINI",
                fontSize: 16,
              ),
              labelText: 'อีเมล',
              hintText: 'กรุณากรอกอีเมลของท่าน',
              contentPadding: EdgeInsets.only(left: 20),
              suffixIcon: Icon(
                Icons.email_outlined,
                color: Colors.black,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row BuildPhone(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 60),
          width: size * 0.9,
          child: TextFormField(
            controller: phoneController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกเบอร์โทรศัพท์ของท่าน';
              } else {}
            },
            maxLength: 10,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            // keyboardType: TextInputType.numberWithOptions(
            //   decimal: true,
            //   signed: true,
            // ),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: TextStyle(
                color: Colors.black,
                fontFamily: "MN MINI",
                fontSize: 19,
              ),
              hintStyle: TextStyle(
                fontFamily: "MN MINI",
                fontSize: 16,
              ),
              labelText: 'เบอร์โทรศัพท์',
              hintText: 'กรุณากรอกเบอโทรศัพท์ของท่าน',
              contentPadding: EdgeInsets.only(left: 20),
              suffixIcon: Icon(
                Icons.smartphone_outlined,
                color: Colors.black,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row BuildName(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          width: size * 0.9,
          child: TextFormField(
            controller: ownernameController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกชื่อจริงของท่าน';
              } else {}
            },
            maxLength: 255,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: TextStyle(
                color: Colors.black,
                fontFamily: "MN MINI",
                fontSize: 19,
              ),
              hintStyle: TextStyle(
                fontFamily: "MN MINI",
                fontSize: 16,
              ),
              labelText: 'ชื่อ',
              hintText: 'กรุณากรอกชื่อจริงของท่าน',
              contentPadding: EdgeInsets.only(left: 20),
              suffixIcon: Icon(
                Icons.person_outline,
                color: Colors.black,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Row BuildLastName(double size) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Container(
  //         margin: EdgeInsets.only(top: 20),
  //         width: size * 0.9,
  //         child: TextFormField(
  //           controller: lastnameController,
  //           autovalidateMode: AutovalidateMode.onUserInteraction,
  //           validator: (value) {
  //             if (value!.isEmpty) {
  //               return 'กรุณากรอกนามสกุลของท่าน';
  //             } else {}
  //           },
  //           maxLength: 255,
  //           maxLengthEnforcement: MaxLengthEnforcement.enforced,
  //           decoration: InputDecoration(
  //             floatingLabelBehavior: FloatingLabelBehavior.always,
  //             labelStyle: TextStyle(
  //               color: Colors.black,
  //               fontFamily: "MN MINI",
  //               fontSize: 19,
  //             ),
  //             hintStyle: TextStyle(
  //               fontFamily: "MN MINI",
  //               fontSize: 16,
  //             ),
  //             labelText: 'นามสกุล',
  //             hintText: 'กรุณากรอกนามสกุลของท่าน',
  //             contentPadding: EdgeInsets.only(left: 20),
  //             suffixIcon: Icon(
  //               Icons.person_outline,
  //               color: Colors.black,
  //             ),
  //             enabledBorder: OutlineInputBorder(
  //               borderSide: BorderSide(color: Colors.black),
  //               borderRadius: BorderRadius.circular(30),
  //             ),
  //             focusedBorder: OutlineInputBorder(
  //               borderSide: BorderSide(color: MyConstant.light),
  //               borderRadius: BorderRadius.circular(30),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
