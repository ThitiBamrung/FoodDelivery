import 'package:driver/screen/Delivery/all_now_order_delivery.dart';
import 'package:driver/screen/driver_service.dart';
import 'package:driver/utility/my_constant.dart';
import 'package:driver/widgets/show_navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliverySucess extends StatelessWidget {
  const DeliverySucess({super.key});

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: buildBody(context, size),
    );
  }

  Widget buildBody(BuildContext context, double size) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/success.png',
              width: size * 0.5,
              fit: BoxFit.fitWidth,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'จัดส่งสำเร็จ!!',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "MN MINI",
                ),
              ),
            ),
            Text(
              'ทำงานต่อไปกันดีกว่า',
              style: TextStyle(
                fontSize: 20,
                fontFamily: "MN MINI",
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            buildButton(context, size),
          ],
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, double size) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      width: size * 0.9,
      height: 48,
      child: ElevatedButton(
        style: MyConstant().myButtonStyle(),
        onPressed: () async {
          Get.offAll(const Navbar());
        },
        child: const Text(
          'ต่อไป',
          style: TextStyle(
            fontSize: 20,
            fontFamily: "MN MINI",
          ),
        ),
      ),
    );
  }
}
