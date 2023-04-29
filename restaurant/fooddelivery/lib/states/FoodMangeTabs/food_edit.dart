import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fooddelivery/models/product_model.dart';
import 'package:fooddelivery/utility/app_controller.dart';
import 'package:fooddelivery/utility/app_service.dart';
import 'package:fooddelivery/utility/my_constant.dart';
import 'package:fooddelivery/utility/my_dialog.dart';
import 'package:fooddelivery/widgets/show_images.dart';
import 'package:fooddelivery/widgets/show_progress.dart';
import 'package:fooddelivery/widgets/show_titles.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;

class EditProduct extends StatefulWidget {
  final ProductModel productModel;
  const EditProduct({Key? key, required this.productModel}) : super(key: key);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  ProductModel? productModel;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  String? pathFoodImg;
  String? selectedValue;
  List categoryItemList = [];

  File? file;
  bool statusImage = false; // false => Not Change Image

  final formKey = GlobalKey<FormState>();

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
    AppService().resdCategoryWhereResIdEdit();
    productModel = widget.productModel;
    nameController.text = productModel!.food_name;
    priceController.text = productModel!.food_price;
    detailController.text = productModel!.description;
  }

  Future<Null> processEditFoodSeller(
      {required AppController appController}) async {
    String id_category = appController.ChooseCategoryModelsE.last!.cate_id;
    print('processEditFoodSeller Work');

    MyDialog().showProgressDialog(context);

    if (formKey.currentState!.validate()) {
      if (file == null) {
        print('## User Current Food');
          editValueToMySQL(productModel!.food_image);
      } else {
        String apiSaveAvatar = '${MyConstant.domain}/saveFoodImg.php';

        List<String> nameAvatars = productModel!.food_image.split('/');
        String nameFile = nameAvatars[nameAvatars.length - 1];
        nameFile = 'edit${Random().nextInt(100)}$nameFile';

        print('## User New Food nameFile ==>>> $nameFile');

        Map<String, dynamic> map = {};
        map['file'] =
            await dio.MultipartFile.fromFile(file!.path, filename: nameFile);
        dio.FormData formData = dio.FormData.fromMap(map);
        await Dio().post(apiSaveAvatar, data: formData).then((value) {
          print('Upload Succes');
           pathFoodImg = '/FoodImg/$nameFile';
          editValueToMySQL(
            id_category,
          );
        });
      }
    }
  }

  Future<void> editValueToMySQL(String id_category) async {
    String apiEditProfile =
        '${MyConstant.domain}/Restaurant_editFoodWhereFoodId.php?isAdd=true&food_id=${productModel!.food_id}&food_name=${nameController.text}&food_price=${priceController.text}&food_image=$pathFoodImg&description=${detailController.text}&cate_id=$id_category';
    await Dio().get(apiEditProfile).then((value) {
      print('Upload = $value');
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
        centerTitle: true,
        title: Text('เเก้ไขเมนู'),
        titleTextStyle: TextStyle(
            fontFamily: 'MN MINI Bold', fontSize: 36, color: Colors.black87),
      ),
        body: LayoutBuilder(
          builder: (context, constraints) => GetX(
              init: AppController(),
              builder: (AppController appController) {
                return SingleChildScrollView(
                  child: GestureDetector(
                    onTap: () =>
                        FocusScope.of(context).requestFocus(FocusScopeNode()),
                    behavior: HitTestBehavior.opaque,
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildFoodImg(constraints),
                          buildFoodName(constraints),
                          buildFoodPrice(constraints),
                          buildFoodDetail(constraints),
                          buildSelectCategory(
                              appController: appController, size: size),
                          buildeditFood(
                              appController: appController, size: size)
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ));
  }

  Row buildeditFood(
      {required AppController appController, required double size}) {
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
              if (appController.ChooseCategoryModelsE.last == null) {
                Get.snackbar('ยังไม่มีประเภท', 'กรุณาเลือกประเภท');
              } else {
                if (formKey.currentState!.validate()) {
                  processEditFoodSeller(appController: appController);
                  Navigator.pop(context);
                }
              }
            },
            child: Text(
              'เเก้ไขเมนู',
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

  Future<Null> chooseImage({ImageSource? source}) async {
    try {
      var result = await ImagePicker().getImage(
        source: source!,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Row buildFoodImg(BoxConstraints constraints) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: () => chooseImage(source: ImageSource.camera),
            icon: Icon(
              Icons.add_a_photo_outlined,
              size: 30,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: constraints.maxWidth * 0.6,
          height: constraints.maxWidth * 0.6,
          child: productModel == null
              ? ShowProgress()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: productModel!.food_image == null
                      ? ShowImages(path: MyConstant.food_imgDefault)
                      : file == null
                          ? buildShowImageNetwork()
                          : Image.file(file!),
                ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: () => chooseImage(source: ImageSource.gallery),
            icon: Icon(
              Icons.add_photo_alternate_outlined,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }

  CachedNetworkImage buildShowImageNetwork() {
    return CachedNetworkImage(
      imageUrl: '${MyConstant.domain}${productModel!.food_image}',
      placeholder: (context, url) => ShowProgress(),
    );
  }

  Row buildFoodName(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          width: constraints.maxWidth * 0.9,
          child: TextFormField(
            controller: nameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกชื่อเมนู';
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
              labelText: 'ชื่อเมนู',
              hintText: 'กรุณากรอกชื่อเมนู',
              contentPadding: EdgeInsets.only(left: 20),
              suffixIcon: IconButton(
                onPressed: () {
                  nameController.clear();
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

  Row buildFoodPrice(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          width: constraints.maxWidth * 0.9,
          child: TextFormField(
            controller: priceController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกราคาอาหาร';
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
              labelText: 'ราคา',
              hintText: 'กรุณากรอกราคาอาหาร',
              contentPadding: EdgeInsets.only(left: 20),
              suffixIcon: IconButton(
                onPressed: () {
                  priceController.clear();
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

  Row buildFoodDetail(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          width: constraints.maxWidth * 0.9,
          child: TextFormField(
            controller: detailController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกรายละเอียดอาหาร';
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
              labelText: 'รายละเอียด',
              hintText: 'กรุณากรอกรายละเอียดอาหาร',
              contentPadding: EdgeInsets.only(left: 20),
              suffixIcon: IconButton(
                onPressed: () {
                  detailController.clear();
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

  Widget buildSelectCategory(
      {required AppController appController, required double size}) {
    return appController.categoryModels.isEmpty
        ? const SizedBox()
        : Center(
          child: SizedBox(
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
                value: appController.ChooseCategoryModelsE.last,
                onChanged: (value) {
                  appController.ChooseCategoryModelsE.add(value);
                },
              ),
            ),
        );
  }
}
