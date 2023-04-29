// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:driver/models/order_model.dart';
import 'package:driver/screen/Delivery/step_one.dart';
import 'package:driver/utility/app_controller.dart';
import 'package:driver/utility/app_service.dart';
import 'package:driver/utility/my_constant.dart';
import 'package:driver/utility/my_dialog.dart';
import 'package:driver/widgets/show_titles.dart';
import 'package:flutter/material.dart';
import 'package:driver/widgets/show_navbar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AcceptOrder extends StatefulWidget {
  const AcceptOrder({
    Key? key,
    required this.orderModel,
  }) : super(key: key);
  final OrderModel orderModel;

  @override
  State<AcceptOrder> createState() => _AcceptOrderState();
}

class _AcceptOrderState extends State<AcceptOrder> {
  String totalPrice = '';
  bool load = true;
  @override
  void initState() {
    super.initState();
    AppService().readNowOrderDetailWhereOrderIdA1(
        id: widget.orderModel.id, cust_id: widget.orderModel.idCustomer);
    print(
        'IDC = ${widget.orderModel.id} CUSTID = ${widget.orderModel.idCustomer}');
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
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      backgroundColor: Colors.white,
      body: GetX(
          init: AppController(),
          builder: (AppController appController) {
            return Center(
              child: Column(
                children: [
                  appController.custModelForListNowOrdersDetailA1.isEmpty
                      ? const SizedBox()
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
                            appController.custModelForListNowOrdersDetailA1.last
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
                            appController.custModelForListNowOrdersDetailA1.last
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
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 15),
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
                            SharedPreferences preference =
                                await SharedPreferences.getInstance();

                            String driver_id =
                                preference.getString('driver_id')!;
                            String apiUpdateOrder =
                                '${MyConstant.domain}/Driver_AcceptOrderWhereOrderId.php?isAdd=true&idRidder=$driver_id&id=${widget.orderModel.id}&approveRider=1';
                            await Dio().get(apiUpdateOrder).then((value) {
                              if (value.toString() == 'true') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StepOne(
                                      orderModel: widget.orderModel,
                                    ),
                                  ),
                                );
                              } else {
                                MyDialog().normalDialog(context,
                                    'Accept Order Fail !!', 'Please try again');
                              }
                            });
                          },
                          child: Text(
                            'รับออเดอร์',
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
