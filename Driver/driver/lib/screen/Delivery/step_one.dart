// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:driver/models/order_model.dart';
import 'package:driver/screen/Delivery/step_one.dart';
import 'package:driver/screen/Delivery/step_two.dart';
import 'package:driver/utility/app_controller.dart';
import 'package:driver/utility/app_service.dart';
import 'package:driver/utility/my_constant.dart';
import 'package:driver/utility/my_dialog.dart';
import 'package:driver/widgets/show_titles.dart';
import 'package:flutter/material.dart';
import 'package:driver/widgets/show_navbar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class StepOne extends StatefulWidget {
  const StepOne({
    Key? key,
    required this.orderModel,
  }) : super(key: key);
  final OrderModel orderModel;

  @override
  State<StepOne> createState() => _StepOneState();
}

class _StepOneState extends State<StepOne> {
  String totalPrice = '';
  bool load = true;
  double? lat, lng;
  @override
  void initState() {
    super.initState();
    AppService().readNowOrderDetailWhereOrderIdS1(
        id: widget.orderModel.id,
        cust_id: widget.orderModel.idCustomer,
        res_id: widget.orderModel.idShop);
    print(
        'ROID = ${widget.orderModel.id} CUSTID = ${widget.orderModel.idCustomer} RESID = ${widget.orderModel.idShop}');
    findLatLng();
    print('lat = ${lat} lng = ${lng}');
  }

  void _launchMapsUrl(
      double fromLat, double fromLng, double toLat, double toLng) async {
    final url =
        'https://www.google.com/maps/dir/?api=1&origin=$fromLat,$fromLng&destination=$toLat,$toLng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<Null> findLatLng() async {
    print('findLatLan ==> Work');
    Position? position = await findPosition();
    setState(() {
      lat = position!.latitude;
      lng = position.longitude;
      print('lat = $lat, lng = $lng');
    });
  }

  Future<Position?> findPosition() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    int totalPriceInt = int.tryParse(totalPrice) ?? 0;
    int totalAmount = int.parse(widget.orderModel.delivery) +
        int.parse(widget.orderModel.total) +
        totalPriceInt;

    totalPrice = totalPriceInt.toString();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'รายละเอียดการสั่งซื้อ',
          style: TextStyle(
              color: Colors.black87, fontSize: 36, fontFamily: "MN MINI Bold"),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: GetX(
          init: AppController(),
          builder: (AppController appController) {
            return Center(
              child: Column(
                children: [
                  appController.resModelForListNowOrdersDetailS1.isEmpty ||
                          appController
                              .custModelForListNowOrdersDetailS1.isEmpty
                      ? SizedBox()
                      : Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'เลขคำสั่งซื้อ',
                                      style: TextStyle(
                                          fontFamily: 'MN MINI Bold',
                                          fontSize: 20,
                                          color: Colors.black87),
                                    ),
                                    Text(
                                      'LMF-670600${widget.orderModel.id}',
                                      style: TextStyle(
                                          fontFamily: 'MN MINI Bold',
                                          fontSize: 20,
                                          color: Colors.black87),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 2, right: 16),
                    child: Container(
                      child: Row(
                        children: [
                          Text(
                            appController.custModelForListNowOrdersDetailS1.last
                                .cust_firstname,
                            style: TextStyle(
                              fontFamily: 'MN MINI Bold',
                              fontSize: 27,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          SizedBox(width: 10),
                          Text(
                            appController.custModelForListNowOrdersDetailS1.last
                                .cust_lastname,
                            style: TextStyle(
                              fontFamily: 'MN MINI Bold',
                              fontSize: 27,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Container(
                      child: Row(
                        children: [
                          Text(
                            'วันที่ ${DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.parse(widget.orderModel.dateTime))} ',
                            style: TextStyle(
                                fontFamily: 'MN MINI',
                                fontSize: 18,
                                color: Color(0xffA8A5A5)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextButton(
                          onPressed: () {
                            _launchMapsUrl(
                              lat!, // fromLat
                              lng!, // fromLng
                              double.parse(appController
                                  .resModelForListNowOrdersDetailS1
                                  .last
                                  .latitude), // toLat
                              double.parse(appController
                                  .resModelForListNowOrdersDetailS1
                                  .last
                                  .longitude), // toLng
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            overlayColor: MaterialStateProperty.all(
                                Colors.black.withOpacity(0.1)),
                            side: MaterialStateProperty.all(
                                BorderSide(color: Colors.black, width: 2)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0))),
                          ),
                          child: Container(
                            width: size * 0.4,
                            padding: EdgeInsets.only(
                                top: 5, bottom: 5, left: 10, right: 10),
                            child: Text(
                              'ดูเเผนที่',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'MN MINI',
                                  fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, top: 2, right: 16,bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'รับอาหารเรียบร้อยเเล้ว',
                                style: TextStyle(
                                  fontFamily: 'MN MINI Bold',
                                  fontSize: 27,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'รายการที่สั่ง',
                                style: TextStyle(
                                  fontFamily: 'MN MINI Bold',
                                  fontSize: 20,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ],
                          ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              'จำนวน',
                              style: TextStyle(
                                  fontFamily: 'MN MINI Bold',
                                  fontSize: 18,
                                  color: Colors.black87),
                            ),
                            Text(
                              widget.orderModel.amounts
                                  .replaceAll('[', '')
                                  .replaceAll(']', '')
                                  .replaceAll(', ', '\n'),
                              style: TextStyle(
                                  fontFamily: 'MN MINI',
                                  fontSize: 18,
                                  color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              'รายการ',
                              style: TextStyle(
                                  fontFamily: 'MN MINI Bold',
                                  fontSize: 18,
                                  color: Colors.black87),
                            ),
                            Text(
                              widget.orderModel.names
                                  .replaceAll('[', '')
                                  .replaceAll(']', '')
                                  .replaceAll(', ', '\n'),
                              style: TextStyle(
                                  fontFamily: 'MN MINI',
                                  fontSize: 18,
                                  color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              'ราคา',
                              style: TextStyle(
                                  fontFamily: 'MN MINI Bold',
                                  fontSize: 18,
                                  color: Colors.black87),
                            ),
                            for (var name in widget.orderModel.prices
                                .replaceAll('[', '')
                                .replaceAll(']', '')
                                .split(','))
                              Text(
                                name,
                                style: TextStyle(
                                    fontFamily: 'MN MINI',
                                    fontSize: 18,
                                    color: Colors.black87),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  buildLine(size),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 2, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShowTitles(
                            title: 'ค่าอาหาร',
                            textStyle: TextStyle(
                                fontFamily: 'MN MINI Bold',
                                fontSize: 20,
                                color: Colors.black87)),
                        ShowTitles(
                            title: '${widget.orderModel.total} บาท',
                            textStyle: TextStyle(
                                fontFamily: 'MN MINI Bold',
                                fontSize: 20,
                                color: Colors.black87)),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShowTitles(
                            title: 'ค่าส่ง',
                            textStyle: TextStyle(
                                fontFamily: 'MN MINI Bold',
                                fontSize: 20,
                                color: Colors.black87)),
                        ShowTitles(
                            title: '${widget.orderModel.delivery} บาท',
                            textStyle: TextStyle(
                                fontFamily: 'MN MINI Bold',
                                fontSize: 20,
                                color: Colors.black87)),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 30),
                        width: size * 0.9,
                        height: 48,
                        child: ElevatedButton(
                          style: MyConstant().myButtonStyle(),
                          onPressed: () async {
                            print('Process insert data success');
                            String apiUpdateOrder =
                                '${MyConstant.domain}/Driver_PickupFoodOrderWhereOrderId.php?isAdd=true&id=${widget.orderModel.id}&approveShop=2&approveRider=2';
                            await Dio().get(apiUpdateOrder).then((value) {
                              if (value.toString() == 'true') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StepTwo(
                                      orderModel: widget.orderModel,
                                    ),
                                  ),
                                );
                              } else {
                                MyDialog().normalDialog(context,
                                    'Accept Order Fail !!', 'Please try again');
                              }
                            });
                            

                            String apiUpdateRestaurant =
                                '${MyConstant.domain}/Driver_UpdateOrderWhereResId.php?isAdd=true&res_id=${widget.orderModel.idShop}&wallet=${widget.orderModel.total}';
                            await Dio().get(apiUpdateRestaurant).then((value) {
                              if (value.toString() == 'true') {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => StepTwo(
                                //       orderModel: widget.orderModel,
                                //     ),
                                //   ),
                                // );
                                print('เงินเข้า = ${value.toString()}');
                              } else {
                                MyDialog().normalDialog(context,
                                    'Update Restaurant Fail !!', 'Please try again');
                              }
                            });
                          },
                          child: Text(
                            'ยืนยันการรับอาหาร',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: "MN MINI",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }

  Padding buildLine(double size) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 1,
        width: size * 0.9,
        color: Color(0xffA8A5A5),
      ),
    );
  }
}
