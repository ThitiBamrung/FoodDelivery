import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/utility/my_constant.dart';
import 'package:dio/dio.dart';
import 'package:fooddelivery/utility/my_dialog.dart';
import 'package:fooddelivery/widgets/show_titles.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateCategory extends StatefulWidget {
  const CreateCategory({super.key});

  @override
  State<CreateCategory> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  final formKey = GlobalKey<FormState>();
  TextEditingController cate_nameController = TextEditingController();

  Future<void> processInsertMySQL({
    required String cate_name,required String res_id,
  }) async {
    print('Process insert data success');
    
    String apiInsertCategory =
        '${MyConstant.domain}/insertCategory.php?isAdd=true&cate_name=$cate_name&res_id=$res_id';
    await Dio().get(apiInsertCategory).then((value) {
      if (value.toString() == 'true') {
        // Navigator.pushNamed(context, MyConstant.routeManagemenu);
        Get.back();
      } else {
        MyDialog().normalDialog(
            context, 'Create Category Fail !!', 'Please try again');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        centerTitle: true,
        elevation: 0,
        title: Text(
          'เพิ่มหมวดหมู่',
          style: TextStyle(
              color: Colors.black87, fontSize: 36, fontFamily: "MN MINI"),
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
                BuildTitle('สร้างประเภทเมนู', size),
                BuildNameCategory(size),
                BuildNextPage(size),
                //BuildType(size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container BuildTitle(String title, double size) {
    return Container(
      width: size * 0.9,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 30),
      child: ShowTitles(
        title: title,
        textStyle: TextStyle(
          color: Colors.black87,
          fontFamily: "MN MINI",
          fontSize: 20,
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
            onPressed: () async {
              if (cate_nameController.text.isEmpty) {
                //have data
                Get.snackbar('ประเภท', 'กรุณากรอกประเภท',
                    backgroundColor: Colors.red, colorText: Colors.white);
              } else {
                SharedPreferences preference =
                  await SharedPreferences.getInstance();

              String? res_id = preference.getString('res_id');
              if (res_id != null) {
                processInsertMySQL(cate_name: cate_nameController.text, res_id: res_id);
              }
              }
              //Insertdata();
            },
            child: Text(
              'เพิ่มหมวดหมู่',
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

  Row BuildNameCategory(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          width: size * 0.9,
          child: TextFormField(
            controller: cate_nameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกชื่อหมวดหมู่ที่ต้องการ';
              } else {}
            },
            maxLength: 255,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: TextStyle(
                color: Colors.black87,
                fontFamily: "MN MINI",
                fontSize: 19,
              ),
              hintStyle: TextStyle(
                fontFamily: "MN MINI",
                fontSize: 16,
              ),
              labelText: 'ประเภท',
              hintText: 'กรุณากรอกชื่อหมวดหมู่',
              contentPadding: EdgeInsets.only(left: 20),
              suffixIcon: IconButton(
                onPressed: () {
                  cate_nameController.clear();
                },
                icon: const Icon(Icons.clear_outlined),
                color: Colors.black87,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black87),
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
}
