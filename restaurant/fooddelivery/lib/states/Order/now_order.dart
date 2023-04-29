import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/models/order_model.dart';
import 'package:fooddelivery/states/Order/now_orderDetail.dart';
import 'package:fooddelivery/utility/app_controller.dart';
import 'package:fooddelivery/utility/app_service.dart';
import 'package:fooddelivery/utility/my_constant.dart';
import 'package:fooddelivery/widgets/show_progress.dart';
import 'package:fooddelivery/widgets/show_titles.dart';
import 'package:fooddelivery/widgets/widget_image_network.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NowOrder extends StatefulWidget {
  const NowOrder({Key? key}) : super(key: key);

  @override
  State<NowOrder> createState() => _NowOrderState();
}

class _NowOrderState extends State<NowOrder> {
  bool load = true;
  bool? haveData;

  @override
  void initState() {
    super.initState();
    processReadOrder();
  }

  void processReadOrder() {
    AppService().readOrderWhereResId().then((value) {
      setState(() {
        load = false;
      });
    });
  }

  Future<void> _refreshListt() async {
    await AppService().readOrderWhereResId();
  }

  Future<void> _refreshList() async {
    // ดึงข้อมูลใหม่จากฐานข้อมูลหรือ API ได้ตามต้องการ
    setState(() {
      load = true;
    });
    await AppService().readOrderWhereResId();

    // อัพเดต state ให้กับ ListView.builder
    setState(() {
      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double sizeH = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return Obx(() {
          final appController = Get.find<AppController>();
          print('OrderModel = ${appController.orderNowModels2.length}');
          print('IdShop = ${appController.res_ids.last}');
          return SizedBox(
            width: boxConstraints.maxWidth,
            height: boxConstraints.maxHeight,
            child: Stack(
              children: [
                load
                    ? const ShowProgress()
                    : ((appController.orderNowModels2.isEmpty) ||
                            (appController.custModelForListNowOrders2.isEmpty))
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ShowTitles(
                                    title: 'ตอนนี้ยังไม่มีคำสั่งซื้อเข้ามา',
                                    textStyle: TextStyle(
                                        fontFamily: 'MN MINI Bold',
                                        fontSize: 30)),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      load = true;
                                    });
                                    _refreshListt().then((value) {
                                      setState(() {
                                        load = false;
                                      });
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(120, 40),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.refresh),
                                      SizedBox(width: 5),
                                      Text('Refresh'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _refreshList,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ListView.builder(
                                itemCount: appController.orderNowModels2.length,
                                itemBuilder: (
                                  context,
                                  index,
                                ) =>
                                    InkWell(
                                  onTap: () {
                                    Get.to(NowOrderDetail(
                                        orderModel: appController
                                            .orderNowModels2[index]));
                                  },
                                  child: Card(
                                    elevation: 5,
                                    child: Container(
                                      height: sizeH * 0.12,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: 100.0,
                                              width: 70.0,
                                              decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    'images/clipboard.png',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ShowTitles(
                                                      title:
                                                          'เลขคำสั่งซื้อ : #LMF-670600${appController.orderNowModels2[index].id}',
                                                      textStyle: TextStyle(
                                                          fontFamily:
                                                              'MN MINI Bold',
                                                          fontSize: 20)),
                                                  if (appController
                                                          .orderNowModels2[
                                                              index]
                                                          .approveShop ==
                                                      "0") // ตรวจสอบค่า approveShop ว่าเท่ากับ 0 หรือไม่
                                                    const ShowTitles(
                                                      title:
                                                          'ยังไม่ได้รับคำสั่งซื้อ',
                                                      textStyle: TextStyle(
                                                          fontSize: 19,
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontFamily:
                                                              "MN MINI"),
                                                    ),
                                                  appController
                                                          .custModelForListNowOrders2
                                                          .isEmpty
                                                      ? const SizedBox()
                                                      : Row(
                                                          children: [
                                                            ShowTitles(
                                                                title: appController
                                                                    .custModelForListNowOrders2[
                                                                        index]
                                                                    .cust_firstname,
                                                                textStyle: TextStyle(
                                                                    fontFamily:
                                                                        'MN MINI',
                                                                    fontSize:
                                                                        18)),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            ShowTitles(
                                                                title: appController
                                                                    .custModelForListNowOrders2[
                                                                        index]
                                                                    .cust_lastname,
                                                                textStyle: TextStyle(
                                                                    fontFamily:
                                                                        'MN MINI',
                                                                    fontSize:
                                                                        18)),
                                                          ],
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
              ],
            ),
          );
        });
      }),
    );
  }
}
