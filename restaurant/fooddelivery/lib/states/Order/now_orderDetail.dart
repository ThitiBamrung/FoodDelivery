// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/models/order_model.dart';
import 'package:fooddelivery/utility/app_controller.dart';
import 'package:fooddelivery/utility/app_service.dart';
import 'package:fooddelivery/utility/my_constant.dart';
import 'package:fooddelivery/utility/my_dialog.dart';
import 'package:fooddelivery/widgets/show_navbar.dart';
import 'package:fooddelivery/widgets/show_titles.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NowOrderDetail extends StatefulWidget {
  const NowOrderDetail({
    Key? key,
    required this.orderModel,
  }) : super(key: key);
  final OrderModel orderModel;

  @override
  State<NowOrderDetail> createState() => _NowOrderDetailState();
}

class _NowOrderDetailState extends State<NowOrderDetail> {
  String totalPrice = '';
  bool load = true;
  @override
  void initState() {
    super.initState();
    AppService().readNowOrderDetailWhereOrderId(
        id: widget.orderModel.id, cust_id: widget.orderModel.idCustomer);
    print(
        'IDC = ${widget.orderModel.id} CUSTID = ${widget.orderModel.idCustomer}');
  }

  Future<void> processUpdateMySQL() async {
    print('Process insert data success');
    String apiUpdateOrder =
        '${MyConstant.domain}/Restaurant_AcceptOrderWhereOrderId.php?isAdd=true&id=${widget.orderModel.id}&approveShop=1';
    await Dio().get(apiUpdateOrder).then((value) {
      if (value.toString() == 'true') {
        //Navigator.pushNamed(context, MyConstant.routeNowOrder);
        Get.back();
      } else {
        MyDialog()
            .normalDialog(context, 'Accept Order Fail !!', 'Please try again');
      }
    });
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
          style: MyConstant().h4Style(),
        ),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios),
        //   onPressed: () {
        //     Get.offAll(() => Navbar());
        //     Get.to(() => Navbar());
        //   },
        // ),
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
                  appController.custModelForListNowOrdersDetail.isEmpty
                      ? SizedBox()
                      : Container(
                          child: Text(
                            appController.custModelForListNowOrdersDetail.last
                                .cust_firstname,
                            style: TextStyle(
                              fontFamily: 'MN MINI Bold',
                              fontSize: 30,
                              color: Color(0xffFF8126),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                  Container(
                    child: Text(
                      'เลขคำสั่งซื้อ LMF-670600${widget.orderModel.id}',
                      style: MyConstant().h3Style(),
                    ),
                  ),
                  Container(
                    child: Text(
                      'วันที่ ${DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.parse(widget.orderModel.dateTime))} ',
                      style: MyConstant().h3Style(),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'จำนวน',
                              style: MyConstant().h3Style(),
                            ),
                            Text(
                              widget.orderModel.amounts
                                  .replaceAll('[', '')
                                  .replaceAll(']', '')
                                  .replaceAll(', ', '\n'),
                              style: MyConstant().h3Style(),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'รายการ',
                              style: MyConstant().h3Style(),
                            ),
                            Text(
                              widget.orderModel.names
                                  .replaceAll('[', '')
                                  .replaceAll(']', '')
                                  .replaceAll(', ', '\n'),
                              style: MyConstant().h3Style(),
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
                              style: MyConstant().h3Style(),
                            ),
                            for (var name in widget.orderModel.prices
                                .replaceAll('[', '')
                                .replaceAll(']', '')
                                .split(','))
                              Text(
                                name,
                                style: MyConstant().h3Style(),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  buildDivider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShowTitles(
                            title: 'ค่าอาหาร',
                            textStyle: MyConstant().h2Style()),
                        ShowTitles(
                            title: '${widget.orderModel.total} บาท',
                            textStyle: MyConstant().h2Style()),
                      ],
                    ),
                  ),
                  buildAcceptOrder(size),
                  // Text(
                  //   'ค่าอาหาร',
                  //   style: MyConstant().h2Style(),
                  // ),
                ],
              ),
            );
          }),
    );
  }

  Row buildAcceptOrder(double size) {
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
              // Navigator.pushNamed(context, MyConstant.routeCreateAccount2);
              processUpdateMySQL();
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
    );
  }

  Divider buildDivider() {
    return const Divider(
      height: 25,
      color: Color(0xff4A4949),
    );
  }
}
