import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/states/Order/history_order.dart';
import 'package:fooddelivery/states/Order/now_order.dart';
import 'package:fooddelivery/utility/app_controller.dart';
import 'package:fooddelivery/utility/app_service.dart';
import 'package:fooddelivery/utility/my_constant.dart';
import 'package:fooddelivery/states/Navmenu/managemenu.dart';
import 'package:fooddelivery/states/Navmenu/history.dart';
import 'package:fooddelivery/states/Navmenu/wallet.dart';
import 'package:fooddelivery/widgets/show_images.dart';
import 'package:fooddelivery/widgets/show_progress.dart';
import 'package:fooddelivery/widgets/show_signout.dart';
import 'package:fooddelivery/widgets/show_navbar.dart';
import 'package:fooddelivery/widgets/show_titles.dart';
import 'package:fooddelivery/widgets/widget_image_network.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalerService extends StatefulWidget {
  const SalerService({super.key});

  @override
  State<SalerService> createState() => _SalerServiceState();
}

class _SalerServiceState extends State<SalerService> {
  bool load = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppService().readRestaurantWhereResId();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print('userModel --> ${appController.currentUserModels.length}');
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: ShowTitles(
                  title: 'หน้าหลัก',
                  textStyle: TextStyle(
                      fontFamily: 'MN MINI Bold',
                      fontSize: 36,
                      color: Colors.black87),
                ),
              ),
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
                                          '${MyConstant.domain}${appController.currentUserModels.last.company_logo}',
                                      width: 70,
                                      height: 70,
                                      boxFit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 16.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'ร้าน',
                                        style: TextStyle(
                                          fontFamily: 'MN MINI',
                                          fontSize: 25,
                                          color: Colors.black87,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                      Text(
                                        appController
                                            .currentUserModels.last.res_name,
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
                          child: Column(
                              children: [BuildTitle('ออเดอร์ของวันนี้', size)]),
                        ),
                        Expanded(child: buildSliderMenu()),
                      ],
                    ),
            ),
          );
        });
  }

  Text buildTextname({required AppController appController}) {
    return Text(
      appController.currentUserModels.last.res_name,
      style: TextStyle(
          fontFamily: 'MN MINI Bold', fontSize: 30, color: Color(0xffFF8126)),
    );
  }

  Row buildImage({required AppController appController}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipOval(
          child: WidgetImageNetwork(
            url:
                '${MyConstant.domain}${appController.currentUserModels.last.company_logo}',
            width: 70,
            height: 70,
            boxFit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Column buildSliderMenu() {
    return Column(
      children: const [
        TabBar(
          labelColor: Color(0xffFF8126),
          indicatorColor: Color(0xffFF8126),
          unselectedLabelColor: Colors.black,
          tabs: [
            Tab(
              child: Text(
                'ตอนนี้',
                overflow: TextOverflow.clip,
                maxLines: 1,
                style: TextStyle(fontFamily: 'MN MINI', fontSize: 16),
              ),
            ),
            Tab(
              child: Text(
                'ประวัติ',
                overflow: TextOverflow.clip,
                maxLines: 1,
                style: TextStyle(fontFamily: 'MN MINI', fontSize: 16),
              ),
            ),
          ],
        ),
        Expanded(
            child: TabBarView(
          children: [
            NowOrder(),
            HistoryOrder(),
          ],
        ))
      ],
    );
  }

  Container BuildTitle(String title, double size) {
    return Container(
      width: size * 0.9,
      alignment: Alignment.centerLeft,
      child: ShowTitles(
        title: title,
        textStyle: TextStyle(
          color: Colors.black87,
          fontFamily: "MN MINI Bold",
          fontSize: 30,
        ),
      ),
    );
  }
}
