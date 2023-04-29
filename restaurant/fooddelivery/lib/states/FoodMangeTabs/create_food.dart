import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/utility/app_controller.dart';
import 'package:fooddelivery/utility/app_service.dart';
import 'package:fooddelivery/utility/my_constant.dart';
import 'package:dio/dio.dart' as dio;
import 'package:fooddelivery/utility/my_dialog.dart';
import 'package:fooddelivery/widgets/show_titles.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:fooddelivery/widgets/show_images.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateFood extends StatefulWidget {
  const CreateFood({super.key});

  @override
  State<CreateFood> createState() => _CreateFoodState();
}

class _CreateFoodState extends State<CreateFood> {
  String? selectedValue;
  List categoryItemList = [];

  Future getAllCategory() async {
    var apigetcategory = "${MyConstant.domain}/getCategory.php";
    var response = await http.get(Uri.parse(apigetcategory));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        categoryItemList = jsonData;
      });
    }
    print(categoryItemList);
  }

  @override
  void initState() {
    super.initState();
    getAllCategory();

    AppService().resdCategoryWhereResId();
  }


  final formKey = GlobalKey<FormState>();
  TextEditingController food_nameController = TextEditingController();
  TextEditingController food_priceController = TextEditingController();
  TextEditingController food_descriptionController = TextEditingController();
  TextEditingController food_categoryController = TextEditingController();
  TextEditingController id_restaurantController = TextEditingController();
  TextEditingController id_categoryController = TextEditingController();
  String food_img = '';
  File? file;

  Future<void> insertdata({required AppController appController}) async {
    String name_food = food_nameController.text;
    String food_price = food_priceController.text;
    String food_description = food_descriptionController.text;
    String food_category = appController.ChooseCategoryModels.last!.cate_name;

    String id_restaurant = appController.res_ids.last;
    String id_category = appController.ChooseCategoryModels.last!.cate_id;
    if (file == null) {
      processInsertMySQL(
        name_food: name_food,
        food_price: food_price,
        food_description: food_description,
        food_category: food_category,
        id_category: id_category,
      );
    } else {
      String apiSaveImg = '${MyConstant.domain}/saveFoodImg.php';
      int i = Random().nextInt(100000);
      String nameRIMG = 'F_Img$i.jpg';
      Map<String, dynamic> map = Map();
      map['file'] =
          await dio.MultipartFile.fromFile(file!.path, filename: nameRIMG);
      dio.FormData data = dio.FormData.fromMap(map);
      await dio.Dio().post(apiSaveImg, data: data).then((value) {
        food_img = '/FoodImg/$nameRIMG';

        processInsertMySQL(
          name_food: name_food,
          food_price: food_price,
          food_description: food_description,
          food_category: food_category,
          id_category: id_category,
        );
      });
    }
  }

  Future<Null> processInsertMySQL({
    String? name_food,
    String? food_price,
    String? food_description,
    String? food_category,
    String? id_category,
  }) async {
    print('Process insert data success');
    SharedPreferences preference = await SharedPreferences.getInstance();

    String id_restaurant = preference.getString('res_id')!;
    String apiInsertUser =
        '${MyConstant.domain}/insertProduct.php?isAdd=true&res_id=$id_restaurant&food_name=$name_food&food_price=$food_price&food_image=$food_img&description=$food_description&cate_id=$id_category&option_id=id_option&food_status=1';
    await dio.Dio().get(apiInsertUser).then((value) {
      if (value.toString() == 'true') {
        Get.back();
      } else {
        MyDialog()
            .normalDialog(context, 'Create Food Fail !!', 'Please try again');
      }
    });
  }

  //---------------------------------------------------

  Future<Null> chooseImages(ImageSource source) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
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
        title: const Text(
          'เพิ่มเมนูอาหาร',
          style: TextStyle(
              color: Colors.black87, fontSize: 36, fontFamily: "MN MINI"),
        ),
        backgroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GetX(
            init: AppController(),
            builder: (AppController appController) {
              print('category = ${appController.categoryModels.length}');
              return GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        BuildTitle('เพิ่มเมนู/สินค้า 1 รายการ', size),
                        BuildStoreImg(size),
                        BuildNameFood(size),
                        BuildFoodPrice(size),
                        BuildFoodDescription(size),
                        buildSelectCategory(
                            appController: appController, size: size),
                        buildNextPage(appController: appController, size: size),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget buildSelectCategory(
      {required AppController appController, required double size}) {
    return appController.categoryModels.isEmpty
        ? const SizedBox()
        : SizedBox(
            width: size * 0.9,
            child: DropdownButton(
              hint: ShowTitles(
                title: 'โปรเลือกประเภท',
                textStyle: MyConstant().h3Style(),
              ),
              isExpanded: true,
              items: appController.categoryModels
                  .map(
                    (element) => DropdownMenuItem(
                      child: ShowTitles(
                        title: element.cate_name,
                        textStyle: MyConstant().h3Style(),
                      ),
                      value: element,
                    ),
                  )
                  .toList(),
              value: appController.ChooseCategoryModels.last,
              onChanged: (value) {
                appController.ChooseCategoryModels.add(value);
              },
            ),
          );
  }

  Container BuildTitle(String title, double size) {
    return Container(
      width: size * 0.9,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 10),
      child: ShowTitles(
        title: title,
        textStyle: TextStyle(
          color: Colors.black87,
          fontFamily: "MN MINI",
          fontSize: 19,
        ),
      ),
    );
  }

  Container BuildSubTitle(String title, double size) {
    return Container(
      width: size * 0.9,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 10),
      child: ShowTitles(
        title: title,
        textStyle: TextStyle(
          color: Colors.grey,
          fontFamily: "MN MINI",
          fontSize: 19,
        ),
      ),
    );
  }

  Row buildNextPage(
      {required AppController appController, required double size}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 30),
          width: size * 0.9,
          height: 48,
          child: ElevatedButton(
            style: MyConstant().myButtonStyle(),
            onPressed: () {
              if (file == null) {
                Get.snackbar('ยังไม่มีภาพ', 'กรุณาถ่ายภาพ');
              }
              if (appController.ChooseCategoryModels.last == null) {
                Get.snackbar('ยังไม่มีประเภท', 'กรุณาเลือกประเภท');
              } else {
                if (formKey.currentState!.validate()) {
                  insertdata(appController: appController);
                }
              }
            },
            child: const Text(
              'เพิ่มรายการ',
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

  Row BuildNameFood(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          width: size * 0.9,
          child: TextFormField(
            controller: food_nameController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกชื่อเมนู';
              } else {
                return null;
              }
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
              labelText: 'ชื่อเมนู',
              hintText: 'กรุณากรอกชื่อเมนู',
              contentPadding: EdgeInsets.only(left: 20),
              suffixIcon: IconButton(
                onPressed: () {
                  food_nameController.clear();
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
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row BuildFoodPrice(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          width: size * 0.9,
          child: TextFormField(
            controller: food_priceController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกราคาอาหาร';
              } else {
                return null;
              }
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
              labelText: 'ราคา',
              hintText: '฿',
              contentPadding: EdgeInsets.only(left: 20),
              suffixIcon: IconButton(
                onPressed: () {
                  food_priceController.clear();
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
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row BuildFoodDescription(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          width: size * 0.9,
          child: TextFormField(
            controller: food_descriptionController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณาเพิ่มคำอธิบาย';
              } else {
                return null;
              }
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
              labelText: 'คำอธิบาย',
              contentPadding: EdgeInsets.only(left: 20),
              suffixIcon: IconButton(
                onPressed: () {
                  food_descriptionController.clear();
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
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row BuildStoreImg(double size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: () => chooseImages(ImageSource.camera),
            icon: Icon(
              Icons.add_a_photo_outlined,
              size: 30,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: size * 0.4,
          child: file == null
              ? ShowImages(path: MyConstant.food_imgDefault)
              : Image.file(file!),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: () => chooseImages(ImageSource.gallery),
            icon: Icon(
              Icons.add_photo_alternate_outlined,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }
}
