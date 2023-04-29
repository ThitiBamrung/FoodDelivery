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

class DriverService extends StatefulWidget {
  const DriverService({Key? key}) : super(key: key);

  @override
  State<DriverService> createState() => _DriverServiceState();
}

class _DriverServiceState extends State<DriverService> {
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

  Future<void> processUpdateMySQL({
    required String driver_id,
  }) async {
    print('Process update data success');
    String apiUpdateOrder =
        '${MyConstant.domain}/Driver_OpenCloseWhereRriderId.php?isAdd=true&driver_id=$driver_id&open_close=1';
    await Dio().get(apiUpdateOrder).then((value) {
      if (value.toString() == 'true') {
        //Get.back();
        Navigator.pushNamed(context, MyConstant.routeAllNowOrder);
      } else {
        MyDialog()
            .normalDialog(context, 'Open Work Fail !!', 'Please try again');
      }
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
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ClipOval(
                                  child: WidgetImageNetwork(
                                    url:
                                        '${MyConstant.domain}${appController.currentUserModels.last.profile_image}',
                                    width: 70,
                                    height: 70,
                                    boxFit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 16.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'สวัสดี!',
                                      style: TextStyle(
                                        fontFamily: 'MN MINI',
                                        fontSize: 20,
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    Text(
                                      appController.currentUserModels.last
                                          .driver_firstname,
                                      style: TextStyle(
                                        fontFamily: 'MN MINI Bold',
                                        fontSize: 30,
                                        color: Color(0xffFF8126),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(children: [buildTitle('ประวัติ', size)]),
                      ),
                      Expanded(
                        child: Stack(
                          children: [
                            load
                                ? const ShowProgress()
                                : ((appController.orderModelsH.isEmpty) ||
                                        (appController
                                            .custModelForListOrdersHistory
                                            .isEmpty))
                                    ? const Center(
                                      child: ShowTitles(
                                      title: 'วัันนี้คุณกดรับงานบ้างรึยัง',
                                      textStyle: TextStyle(
                                          fontFamily: 'MN MINI Bold',
                                          fontSize: 30)),
                                    )
                                    : Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: ListView.builder(
                                           itemCount:
                                              appController.orderModelsH.length > 4 ? 4 : appController.orderModelsH.length,
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
                      buildOpen(size),
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

  Row buildOpen(double size) {
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
              SharedPreferences preference =
                  await SharedPreferences.getInstance();
              String? driver_id = preference.getString('driver_id');
              if (driver_id != null) {
                processUpdateMySQL(driver_id: driver_id);
              }

              //Insertdata();
            },
            child: Text(
              'พร้อมเริ่มงาน',
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
}
