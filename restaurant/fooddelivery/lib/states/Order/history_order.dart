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

class HistoryOrder extends StatefulWidget {
  const HistoryOrder({Key? key}) : super(key: key);

  @override
  State<HistoryOrder> createState() => _HistoryOrderState();
}

class _HistoryOrderState extends State<HistoryOrder> {
  bool load = true;
  bool? haveData;

  @override
  void initState() {
    super.initState();
    processReadHistoryOrder();
  }

  void processReadHistoryOrder() {
    AppService().readHistoryOrderWhereResId().then((value) {
      setState(() {
        load = false;
      });
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
          print('OrderModel = ${appController.orderModelsH.length}');
          print('IdShop = ${appController.res_ids.last}');
          return SizedBox(
            width: boxConstraints.maxWidth,
            height: boxConstraints.maxHeight,
            child: Stack(
              children: [
                load
                    ? const ShowProgress()
                    : ((appController.orderModelsH.isEmpty) ||
                            (appController.custModelForListOrdersH.isEmpty))
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListView.builder(
                              itemCount: appController.orderModelsH.length,
                              itemBuilder: (
                                context,
                                index,
                              ) =>
                                  InkWell(
                                onTap: () {
                                  // Get.to(HistoryOrderDetail(
                                  //     orderModel: appController
                                  //         .orderModelsH[index]));
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
                                                  'images/done.png',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ShowTitles(
                                                    title:
                                                        'เลขคำสั่งซื้อ : #LMF-670600${appController.orderModelsH[index].id}',
                                                    textStyle: TextStyle(
                                                        fontFamily:
                                                            'MN MINI Bold',
                                                        fontSize: 20)),
                                                if (appController
                                                        .orderModelsH[index]
                                                        .approveShop ==
                                                    "2") // ตรวจสอบค่า approveShop ว่าเท่ากับ 0 หรือไม่
                                                  const ShowTitles(
                                                    title:
                                                        'คำสั่งซื้อเสร็จสิ้น',
                                                    textStyle: TextStyle(
                                                        fontSize: 19,
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontFamily: "MN MINI"),
                                                  ),
                                                appController
                                                        .custModelForListOrdersH
                                                        .isEmpty
                                                    ? const SizedBox()
                                                    : Row(
                                                        children: [
                                                          ShowTitles(
                                                              title: appController
                                                                  .custModelForListOrdersH[
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
                                                                  .custModelForListOrdersH[
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
              ],
            ),
          );
        });
      }),
    );
  }
}
