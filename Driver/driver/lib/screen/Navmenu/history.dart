import 'package:dio/dio.dart';
import 'package:driver/screen/history_orderdetail.dart';
import 'package:driver/utility/app_controller.dart';
import 'package:driver/utility/app_service.dart';
import 'package:driver/utility/my_constant.dart';
import 'package:driver/utility/my_dialog.dart';
import 'package:driver/widgets/show_progress.dart';
import 'package:driver/widgets/show_titles.dart';
import 'package:driver/widgets/widget_image_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:driver/widgets/show_signout.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool load = true;

  @override
  void initState() {
    super.initState();
    AppService().readDriverWhereDriverId();
    processReadHistoryOrder();
  }

  void processReadHistoryOrder() {
    AppService().readHistoryOrderWhereDriverId().then((value) {
      setState(() {
        load = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    double sizeH = MediaQuery.of(context).size.height;
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print('userModel --> ${appController.currentUserModels.length}');
          return Scaffold(
            backgroundColor: Colors.white,
            body: appController.currentUserModels.isEmpty
                ? const SizedBox()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     Expanded(
                        child: Stack(
                          children: [
                            load
                                ? const ShowProgress()
                                : ((appController.orderModelsH.isEmpty) ||
                                        (appController
                                            .custModelForListOrdersHistory
                                            .isEmpty))
                                    ? const SizedBox()
                                    : Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: ListView.builder(
                                           itemCount:
                                              appController.orderModelsH.length,
                                          itemBuilder: (
                                            context,
                                            index,
                                          ) =>
                                              InkWell(
                                            onTap: () {
                                              Get.to(HistoryOrderDetail(
                                                  orderModel: appController
                                                      .orderModelsH[index]));
                                            },
                                            child: Card(
                                              elevation: 5,
                                              child: Container(
                                                height: sizeH*0.12,
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Container(
                                                        height: 100.0,
                                                        width: 70.0,
                                                        decoration:
                                                            const BoxDecoration(
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
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            ShowTitles(
                                                                title:
                                                                    'เลขคำสั่งซื้อ : #LMF-670600${appController.orderModelsH[index].id}',
                                                                textStyle:
                                                                    TextStyle(fontFamily: 'MN MINI Bold',fontSize: 20)),
                                                            if (appController
                                                                    .orderModelsH[
                                                                        index]
                                                                    .approveRider ==
                                                                "4") // ตรวจสอบค่า approveShop ว่าเท่ากับ 0 หรือไม่
                                                              const ShowTitles(
                                                                title:
                                                                    'คำสั่งซื้อเสร็จสิ้น',
                                                                textStyle: TextStyle(
                                                                    fontSize:
                                                                        19,
                                                                    color: Colors
                                                                        .green,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontFamily:
                                                                        "MN MINI"),
                                                              ),
                                                            appController
                                                                    .custModelForListOrdersHistory
                                                                    .isEmpty
                                                                ? const SizedBox()
                                                                : Row(
                                                                  children: [
                                                                    ShowTitles(
                                                                    title: appController
                                                                        .custModelForListOrdersHistory[
                                                                            index]
                                                                        .cust_firstname,
                                                                    textStyle:
                                                                        TextStyle(fontFamily: 'MN MINI',fontSize: 18)),
                                                                    SizedBox(width: 10,),
                                                                    ShowTitles(
                                                                    title: appController
                                                                        .custModelForListOrdersHistory[
                                                                            index]
                                                                        .cust_lastname,
                                                                    textStyle:
                                                                        TextStyle(fontFamily: 'MN MINI',fontSize: 18)),
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
                      ),
                    ],
                  ),
          );
        });
  }

  Container buildTitle(String title, double size) {
    return Container(
      width: size * 0.9,
      alignment: Alignment.centerLeft,
      child: ShowTitles(
        title: title,
        textStyle: TextStyle(
          color: Colors.black87,
          fontFamily: "MN MINI Bold",
          fontSize: 20,
        ),
      ),
    );
  }

}
