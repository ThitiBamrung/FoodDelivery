import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/models/category_model.dart';
import 'package:fooddelivery/models/product_model.dart';
import 'package:fooddelivery/models/user_model.dart';
import 'package:fooddelivery/states/FoodMangeTabs/category.dart';
import 'package:fooddelivery/states/Navmenu/managemenu.dart';
import 'package:fooddelivery/utility/my_constant.dart';
import 'package:fooddelivery/utility/my_dialog.dart';
import 'package:fooddelivery/widgets/show_images.dart';
import 'package:fooddelivery/widgets/show_progress.dart';
import 'package:fooddelivery/widgets/show_titles.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditCategory extends StatefulWidget {
  final CategoryModel categoryModel;
  const EditCategory({Key? key, required this.categoryModel}) : super(key: key);

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  CategoryModel? categoryModel;
  TextEditingController CategorynameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categoryModel = widget.categoryModel;
    CategorynameController.text = categoryModel!.cate_name;
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
        centerTitle: true,
        title: Text('เเก้ไขข้อมูลหมวดหมู่'),
        titleTextStyle: TextStyle(
            fontFamily: 'MN MINI Bold', fontSize: 36, color: Colors.black87),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: formKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                buildCateName(constraints),
                BuildNextPage(size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> editValueToMySQL() async {
    String apiEditCategory =
        '${MyConstant.domain}/Restaurant_editCategoryWhereCateId.php?isAdd=true&cate_id=${widget.categoryModel.cate_id}&cate_name=${CategorynameController.text}';
    await Dio().get(apiEditCategory).then((value) {
      print('Upload = $value');
      Navigator.pop(context);
    });
  }

  Row buildCateName(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          width: constraints.maxWidth * 0.9,
          child: TextFormField(
            controller: CategorynameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกชื่อหมวดหมู่';
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
              labelText: 'ชื่อหมวดหมู่',
              hintText: 'กรุณากรอกชื่อหมวดหมู่',
              contentPadding: EdgeInsets.only(left: 20),
              suffixIcon: IconButton(
                onPressed: () {
                  CategorynameController.clear();
                },
                icon: const Icon(Icons.clear_outlined),
                color: Colors.black87,
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
            onPressed: () async {
              if (CategorynameController.text.isEmpty) {
                //have data
                Get.snackbar('ประเภท', 'กรุณากรอกประเภท',
                    backgroundColor: Colors.red, colorText: Colors.white);
              } else {
                
                processEdit();
                Navigator.pop(context);
              }
              //Insertdata();
            },
            child: Text(
              'เเก้ไขหมวดหมู่',
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

  ShowTitles buildTitle(String title) {
    return ShowTitles(
      title: title,
      textStyle: MyConstant().h2Style(),
    );
  }

  Future<Null> processEdit() async {
    if (formKey.currentState!.validate()) {
      MyDialog().showProgressDialog(context);

      String name = CategorynameController.text;

      String apiEditCategory =
          '${MyConstant.domain}/Restaurant_editCategoryWhereCateId.php?isAdd=true&cate_id=${widget.categoryModel.cate_id}&cate_name=$name';
      await Dio().get(apiEditCategory).then(
            (value) => Navigator.pop(context)
            );
    }
  }
}
