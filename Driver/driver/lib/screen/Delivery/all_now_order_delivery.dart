import 'package:dio/dio.dart';
import 'package:driver/screen/Delivery/accept_order.dart';
import 'package:driver/screen/Delivery/step_one.dart';
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

class AllNowOrder extends StatefulWidget {
  const AllNowOrder({Key? key}) : super(key: key);

  @override
  State<AllNowOrder> createState() => _AllNowOrderState();
}

class _AllNowOrderState extends State<AllNowOrder> {
  bool load = true;

  @override
  void initState() {
    super.initState();
    processReadNowDateOrder();
  }

  void processReadNowDateOrder() {
    AppService().readNowDateOrderWhereDriverId().then((value) {
      setState(() {
        load = false;
      });
    });
  }

    Future<void> _refreshListt() async {
    await AppService().readNowDateOrderWhereDriverId();
  }

  Future<void> _refreshList() async {
    // ดึงข้อมูลใหม่จากฐานข้อมูลหรือ API ได้ตามต้องการ
    setState(() {
    load = true;
  });
    await AppService().readNowDateOrderWhereDriverId();

    // อัพเดต state ให้กับ ListView.builder
    setState(() {
      load = false;
    });
  }

  Future<void> processUpdateMySQL({
    required String driver_id,
  }) async {
    print('Process update data success');
    String apiUpdateOrder =
        '${MyConstant.domain}/Driver_OpenCloseWhereRriderId.php?isAdd=true&driver_id=$driver_id&open_close=0';
    await Dio().get(apiUpdateOrder).then((value) {
      if (value.toString() == 'true') {
        Get.back();
      } else {
        MyDialog()
            .normalDialog(context, 'Open Work Fail !!', 'Please try again');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print('userModel --> ${appController.currentUserModels.length}');
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black87),
              centerTitle: true,
              elevation: 0,
              title: Text(
                'พร้อมเริ่มงาน',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 36,
                    fontFamily: "MN MINI Bold"),
              ),
              actions: [
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  _refreshListt();
                },
              ),
            ],
              backgroundColor: Colors.white,
              automaticallyImplyLeading:
                  false, // กำหนดค่าเป็น false เพื่อไม่ให้แสดงปุ่ม back
            ),
            backgroundColor: Colors.white,
            body: appController.currentUserModels.isEmpty
                ? const SizedBox()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(children: [
                          buildClose(size),
                        ]),
                      ),
                      Expanded(
                        child: Stack(
                          children: [
                            load
                                ? const ShowProgress()
                                : ((appController.orderModels.isEmpty) ||
                                        (appController
                                            .resModelForListOrders.isEmpty))
                                    ? Center(
                                      child: ShowTitles(
                                      title: 'ตอนนี้ยังไม่มีคำสั่งซื้อเข้ามา',
                                      textStyle: TextStyle(
                                          fontFamily: 'MN MINI Bold',
                                          fontSize: 30)),
                                    )
                                    : RefreshIndicator(
                                      onRefresh: _refreshList,
                                      child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: ListView.builder(
                                            itemCount:
                                                appController.orderModels.length,
                                            itemBuilder: (
                                              context,
                                              index,
                                            ) =>
                                                InkWell(
                                              onTap: () {
                                                Get.to(AcceptOrder(
                                                    orderModel: appController
                                                        .orderModels[index]));
                                              },
                                              child: Card(
                                                elevation: 5,
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      height: 120,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                                16.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            ShowTitles(
                                                                title:
                                                                    'เลขคำสั่งซื้อ : #LMF-670600${appController.orderModels[index].id}',
                                                                textStyle:
                                                                    MyConstant()
                                                                        .h2Style()),
                                                            if (appController
                                                                    .orderModels[
                                                                        index]
                                                                    .approveRider ==
                                                                "0") // ตรวจสอบค่า approveShop ว่าเท่ากับ 0 หรือไม่
                                                              const ShowTitles(
                                                                title:
                                                                    'ยังไม่ได้รับออเดอร์',
                                                                textStyle: TextStyle(
                                                                    fontSize: 16,
                                                                    color: Colors
                                                                        .red,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontFamily:
                                                                        "MN MINI"),
                                                              ),
                                                            if (appController
                                                                    .orderModels[
                                                                        index]
                                                                    .approveRider ==
                                                                "1") // ตรวจสอบค่า approveShop ว่าเท่ากับ 1 หรือไม่
                                                              const ShowTitles(
                                                                title:
                                                                    'รับออเดอร์สำเร็จ',
                                                                textStyle: TextStyle(
                                                                    fontSize: 16,
                                                                    color: Colors
                                                                        .green,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontFamily:
                                                                        "MN MINI"),
                                                              ),
                                                            ShowTitles(
                                                                title:
                                                                    'ราคา ${appController.orderModels[index].total} บาท',
                                                                textStyle:
                                                                    MyConstant()
                                                                        .h3Style()),
                                                            appController
                                                                    .resModelForListOrders
                                                                    .isEmpty
                                                                ? const SizedBox()
                                                                : ShowTitles(
                                                                    title: appController
                                                                        .resModelForListOrders[
                                                                            index]
                                                                        .res_name,
                                                                    textStyle:
                                                                        MyConstant()
                                                                            .h3Style()),
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

  Row buildClose(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: size * 0.4,
          height: 48,
          child: ElevatedButton(
            style: MyConstant().myCloseButtonStyle(),
            onPressed: () async {
              SharedPreferences preference =
                  await SharedPreferences.getInstance();
              String? driver_id = preference.getString('driver_id');
              if (driver_id != null) {
                processUpdateMySQL(driver_id: driver_id);
              }

              //Insertdata();
            },
            child: Text(
              'งดรับงาน',
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
