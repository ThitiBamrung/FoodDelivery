import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/utility/my_constant.dart';
import 'package:dio/dio.dart';
import 'package:fooddelivery/utility/my_dialog.dart';

class Addon extends StatefulWidget {
  const Addon({super.key});

  @override
  State<Addon> createState() => _AddonState();
}

class _AddonState extends State<Addon> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                BuildNextPage(size),
              ],
            ),
          ),
        ),
      ),
    );
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
              Navigator.pushNamed(context, MyConstant.routeCreateAddon);
            },
            child: Text(
              'เพิ่มตัวเลือกเสริม',
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
}
