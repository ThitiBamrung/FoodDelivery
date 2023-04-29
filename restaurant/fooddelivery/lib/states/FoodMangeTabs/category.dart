import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/models/category_model.dart';
import 'package:fooddelivery/models/product_model.dart';
import 'package:fooddelivery/states/FoodMangeTabs/category_edit.dart';
import 'package:fooddelivery/utility/app_controller.dart';
import 'package:fooddelivery/utility/app_service.dart';
import 'package:fooddelivery/utility/my_constant.dart';
import 'package:dio/dio.dart';
import 'package:fooddelivery/utility/my_dialog.dart';
import 'package:fooddelivery/widgets/show_titles.dart';
import 'package:get/get.dart';

class CategoryFood extends StatefulWidget {
  const CategoryFood({super.key});

  @override
  State<CategoryFood> createState() => _CategoryFoodState();
}

class _CategoryFoodState extends State<CategoryFood> {
  bool load = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppService().resdCategoryWhereResId();
  }

    Future<void> _refreshList() async {
    // ดึงข้อมูลใหม่จากฐานข้อมูลหรือ API ได้ตามต้องการ
    setState(() {
      load = true;
    });
    await AppService().resdCategoryWhereResId();

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
              print('categoryModels = ${appController.categoryModels.length}');
              return SizedBox(
                width: boxConstraints.maxWidth,
                height: boxConstraints.maxHeight,
                child: Stack(
                  children: [
                    appController.categoryModels.isEmpty
                        ? const SizedBox()
                        : RefreshIndicator(
                          onRefresh: _refreshList,
                          child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ListView.builder(
                                itemCount: appController.categoryModels.length,
                                itemBuilder: (context, index) => Card(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: ShowTitles(
                                              title: appController
                                                  .categoryModels[index]
                                                  .cate_name,
                                              textStyle: TextStyle(
                                                      fontFamily: 'MN MINI Bold',
                                                      fontSize: 20),),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => EditCategory(categoryModel: appController.categoryModels[index]),
                                            ),);
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            // ทำงานเมื่อกดปุ่ม Delete
                                            print('Delete Category = $index');
                                            confirmDialogDelete(appController
                                                .categoryModels[index]);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ),
                    Positioned(
                        bottom: 0,
                        child: buildNextPage(size,
                            boxConstraints: boxConstraints)),
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
                Navigator.pushNamed(context, MyConstant.routeCreateCategory)
                    .then((value) {
                  AppService().resdCategoryWhereResId();
                });
              },
              child: Text(
                'เพิ่มหมวดหมู่ใหม่',
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

  Future<Null> confirmDialogDelete(CategoryModel categoryModel) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          title: ShowTitles(
            title: 'ต้องการลบ ${categoryModel.cate_name} ใช่หรือไม่ ?',
            textStyle: MyConstant().h2Style(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: ()async{
              print('comfirm delete = ${categoryModel.cate_id}');
              String apiDeleteCategoryWhereId = '${MyConstant.domain}/deleteCategoryWhereId.php?isAdd=true&cate_id=${categoryModel.cate_id}';
              await Dio().get(apiDeleteCategoryWhereId).then((value) {
                Navigator.pop(context);
                AppService().resdCategoryWhereResId();
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
