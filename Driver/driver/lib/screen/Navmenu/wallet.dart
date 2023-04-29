import 'package:driver/models/widraw_model.dart';
import 'package:driver/utility/app_controller.dart';
import 'package:driver/utility/app_service.dart';
import 'package:driver/utility/my_constant.dart';
import 'package:driver/widgets/show_progress.dart';
import 'package:driver/widgets/show_titles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  final appController = Get.put(AppController());
  bool load = true;
  late final WidrawModel walletModel;

  @override
  void initState() {
    super.initState();
    AppService().findCurrentUsermodel();
    processReadWallet();
  }

  void processReadWallet() {
    AppService().readWidrawWhereDriverId().then((value) {
      appController.widrawModels.sort((a, b) => DateTime.parse(b.dateTime)
          .millisecondsSinceEpoch
          .compareTo(DateTime.parse(a.dateTime).millisecondsSinceEpoch));
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
    await AppService().readWidrawWhereDriverId();
    AppService().findCurrentUsermodel();


    // อัพเดต state ให้กับ ListView.builder
    setState(() {
      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    double sizeH = MediaQuery.of(context).size.height;
    return GetX(
      init: AppController(),
      builder: (AppController appController) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: appController.currentUserModels.isEmpty &&
                  appController.widrawModels.isEmpty
              ? const SizedBox()
              : RefreshIndicator(
                onRefresh: _refreshList,
                child: Column(
                      children: [
                        buildBalance(size, sizeH, appController: appController),
                        buildWidrawbutton(size),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Stack(
                              children: [
                                load
                                    ? const ShowProgress()
                                    : appController.widrawModels.isEmpty
                                        ? const SizedBox()
                                        : Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: appController
                                                      .widrawModels.isNotEmpty
                                                  ? appController
                                                      .widrawModels.length
                                                  : 0,
                                              itemBuilder: (context, index) =>
                                                  InkWell(
                                                child: Card(
                                                  elevation: 5,
                                                  child: Container(
                                                    height: sizeH * 0.12,
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Container(
                                                            height: 100.0,
                                                            width: 70.0,
                                                            decoration:
                                                                const BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image: AssetImage(
                                                                  'images/widraw.png',
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                ShowTitles(
                                                                    title:
                                                                        'จำนวนเงิน ${appController.widrawModels[index].widraw_amount} บาท',
                                                                    textStyle: TextStyle(
                                                                        fontFamily:
                                                                            'MN MINI Bold',
                                                                        fontSize:
                                                                            20)),
                                                                ShowTitles(
                                                                    title:
                                                                        '${DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.parse(
                                                                      appController
                                                                          .widrawModels[
                                                                              index]
                                                                          .dateTime,
                                                                    ))}',
                                                                    textStyle: TextStyle(
                                                                        fontFamily:
                                                                            'MN MINI Bold',
                                                                        fontSize:
                                                                            18))
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
                        ),
                      ],
                    ),
              ),
        );
      },
    );
  }

  Padding buildBalance(double size, double sizeH,
      {required AppController appController}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: MyConstant.primary,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: sizeH * 0.13,
            width: size * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      appController.currentUserModels.last.driver_firstname,
                      style: TextStyle(
                          fontFamily: 'MN MINI Bold',
                          fontSize: 30,
                          color: Colors.white),
                    ),
                    SizedBox(width: 10),
                    Text(
                      appController.currentUserModels.last.driver_lastname,
                      style: TextStyle(
                          fontFamily: 'MN MINI Bold',
                          fontSize: 30,
                          color: Colors.white),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      appController.currentUserModels.last.wallet,
                      style: TextStyle(
                          fontFamily: 'MN MINI',
                          fontSize: 30,
                          color: Colors.white),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ยอดเงินที่ถอนได้',
                                style: TextStyle(
                                    fontFamily: 'MN MINI',
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                              Text(
                                appController.currentUserModels.last.wallet,
                                style: TextStyle(
                                  fontFamily: 'MN MINI',
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildWalletCard(BuildContext context, double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 2),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    child: SizedBox(
                      width: 300,
                      height: 100,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                child: Text(
                                  'ร้าน มีเเสงถนัดขาย',
                                  style: TextStyle(
                                      fontFamily: 'MN MINI', fontSize: 25),
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
          ),
        ),
      ],
    );
  }

  Row buildWidrawbutton(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 30),
          width: size * 0.9,
          height: 48,
          child: ElevatedButton(
            style: MyConstant().myButtonStyle(),
            onPressed: () {
              Navigator.pushNamed(context, MyConstant.routeWidraw);
            },
            child: Text(
              'ถอนเงิน',
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
