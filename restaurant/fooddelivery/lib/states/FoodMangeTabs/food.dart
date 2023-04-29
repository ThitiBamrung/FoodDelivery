import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/models/product_model.dart';
import 'package:fooddelivery/states/FoodMangeTabs/food_edit.dart';
import 'package:fooddelivery/utility/app_controller.dart';
import 'package:fooddelivery/utility/app_service.dart';
import 'package:fooddelivery/utility/my_constant.dart';
import 'package:dio/dio.dart';
import 'package:fooddelivery/utility/my_dialog.dart';
import 'package:fooddelivery/widgets/show_images.dart';
import 'package:fooddelivery/widgets/show_progress.dart';
import 'package:fooddelivery/widgets/show_titles.dart';
import 'package:fooddelivery/widgets/widget_image_network.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Food extends StatefulWidget {
  const Food({Key? key}) : super(key: key);

  @override
  State<Food> createState() => _FoodState();
}

class _FoodState extends State<Food> {
  bool load = true;
  bool? haveData;

  @override
  void initState() {
    super.initState();
    processReadProduct();
  }

  void processReadProduct() {
    setState(() {
      load = true;
    });
    AppService().readProduct().then((value) {
      setState(() {
        load = false;
      });
    });
  }

  Future<void> _refreshList() async {
    // ดึงข้อมูลใหม่จากฐานข้อมูลหรือ API ได้ตามต้องการ
    setState(() {
      load = true;
    });
    await AppService().readProduct();

    // อัพเดต state ให้กับ ListView.builder
    setState(() {
      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return GetX(
            init: AppController(),
            builder: (AppController appController) {
              print('ProductModel = ${appController.productModels.length}');
              return SizedBox(
                width: boxConstraints.maxWidth,
                height: boxConstraints.maxHeight,
                child: Stack(
                  children: [
                    load
                        ? const ShowProgress()
                        : ((appController.productModels.isEmpty) ||
                                (appController
                                    .categoryModelForListProducts.isEmpty))
                            ? const SizedBox()
                            : RefreshIndicator(
                                onRefresh: _refreshList,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: ListView.builder(
                                    itemCount:
                                        appController.productModels.length,
                                    itemBuilder: (
                                      context,
                                      index,
                                    ) =>
                                        Expanded(
                                      child: Card(
                                        color: Colors.white,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: WidgetImageNetwork(
                                                url:
                                                    '${MyConstant.domain}${appController.productModels[index].food_image}',
                                                width: 120,
                                                height: 120,
                                                boxFit: BoxFit.cover,
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ShowTitles(
                                                  title: appController
                                                      .productModels[index]
                                                      .food_name,
                                                  textStyle: TextStyle(
                                                      fontFamily:
                                                          'MN MINI Bold',
                                                      fontSize: 20),
                                                ),
                                                ShowTitles(
                                                  title:
                                                      'ราคา ${appController.productModels[index].food_price} บาท',
                                                  textStyle: TextStyle(
                                                      fontFamily: 'MN MINI',
                                                      fontSize: 16),
                                                ),
                                                appController
                                                        .categoryModelForListProducts
                                                        .isEmpty
                                                    ? const SizedBox()
                                                    : ShowTitles(
                                                        title: appController
                                                            .categoryModelForListProducts[
                                                                index]
                                                            .cate_name,
                                                        textStyle: TextStyle(
                                                            fontFamily:
                                                                'MN MINI',
                                                            fontSize: 16),
                                                      ),
                                                Container(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 90, top: 5),
                                                    child: Row(
                                                      children: [
                                                        IconButton(
                                                          icon:
                                                              Icon(Icons.edit),
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) =>
                                                                    EditProduct(
                                                                        productModel:
                                                                            appController.productModels[index]),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                        IconButton(
                                                          icon: Icon(
                                                              Icons.delete),
                                                          onPressed: () {
                                                            // ทำงานเมื่อกดปุ่ม Delete
                                                            print(
                                                                'Delete Category = $index');
                                                            confirmDialogDelete(
                                                                appController
                                                                        .productModels[
                                                                    index]);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          buildNextPage(size, boxConstraints: boxConstraints),
                        ],
                      ),
                    )
                  ],
                ),
              );
            });
      }),
    );
  }

  Widget buildNextPage(double size, {required BoxConstraints boxConstraints}) {
    return SizedBox(
      width: boxConstraints.maxWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 30),
            width: size * 0.9,
            height: 48,
            child: ElevatedButton(
              style: MyConstant().myButtonStyle(),
              onPressed: () {
                Navigator.pushNamed(context, MyConstant.routeCreateFood)
                    .then((value) {
                  AppService().readProduct();
                });
              },
              child: Text(
                'เพิ่มเมนูใหม่',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "MN MINI",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> confirmDialogDelete(ProductModel productModel) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          title: ShowTitles(
            title: 'ต้องการลบ ${productModel.food_name} ใช่หรือไม่ ?',
            textStyle: MyConstant().h2Style(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              print('comfirm delete = ${productModel.food_id}');
              String apiDeleteCategoryWhereId =
                  '${MyConstant.domain}/Restaurant_deleteFoodWhereId.php?isAdd=true&food_id=${productModel.food_id}';
              await Dio().get(apiDeleteCategoryWhereId).then((value) {
                Navigator.pop(context);
                processReadProduct();
              });
            },
            child: Text('Delete'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
