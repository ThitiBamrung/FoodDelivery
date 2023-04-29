import 'package:flutter/material.dart';
import 'package:driver/screen/accept_order2.dart';
import '../utility/my_constant.dart';

class ACPT_order1 extends StatefulWidget {
  const ACPT_order1({super.key});

  @override
  State<ACPT_order1> createState() => _ACPT_order1State();
}

class _ACPT_order1State extends State<ACPT_order1> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
          child: Center(
            child: ListView(
              children: [
                buildState(),
                Text(
                  '10/22/2022 | 11:04',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'LMS-675038383',
                  style: TextStyle(fontSize: 20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, top: 10),
                      width: size * 0.4,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: MyConstant.dark,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        color: MyConstant.dark,
                      ),
                      child: Center(
                        child: Text(
                          "ดูแผนที่",
                          style: MyConstant().h3Style(),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, top: 10),
                      width: size * 0.4,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: MyConstant.dark,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        color: MyConstant.dark,
                      ),
                      child: Center(
                        child: Text(
                          "รายละเอียดงาน",
                          style: MyConstant().h1Style(),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.keyboard_double_arrow_right_rounded),
                    Text(
                      'ไปที่ร้านอาหาร',
                      style: TextStyle(fontSize: 20, color: MyConstant.primary),
                    ),
                  ],
                ),
                Text(
                  'ร้าน กรีนฟู้ดส์ (Green Food)',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  '2 ซอย พระยาสุเรนทร์ 30 ปากทางเเยก 6',
                  style: TextStyle(fontSize: 20),
                ),
                Row(
                  children: [
                    Icon(Icons.keyboard_double_arrow_right_rounded),
                    Text(
                      'คำเเนะนำ',
                      style: TextStyle(fontSize: 20, color: MyConstant.primary),
                    ),
                  ],
                ),
                Text(
                  'ใช้เวลา 6 นาที  เพื่อเดินทางไปยัง กรีนฟู้ดส์ (Green Food)',
                  style: TextStyle(fontSize: 20),
                ),
                buildNext(context, size),
              ],
            ),
          )),
    );
  }

  Row buildState() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Color(0xffFF8126),
                  borderRadius: BorderRadius.circular(1000),
                  border: Border.all(width: 2, color: Color(0xffFF8126))),
              child: Text(
                ' 1 ',
                style: TextStyle(color: MyConstant.light),
              ),
            ),
            Text(
              'ไปที่ร้านค้า',
              style: MyConstant().h3Style(),
            ),
          ],
        ),
        SizedBox(
          width: 20,
        ),
        Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Color(0xffF6F6F6),
                  borderRadius: BorderRadius.circular(1000),
                  border: Border.all(width: 2, color: Color(0xffF6F6F6))),
              child: Text(' 2 '),
            ),
            Text(
              'รับอาหาร',
              style: MyConstant().h3Style(),
            ),
          ],
        ),
        SizedBox(
          width: 20,
        ),
        Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Color(0xffF6F6F6),
                  borderRadius: BorderRadius.circular(1000),
                  border: Border.all(width: 2, color: Color(0xffF6F6F6))),
              child: Text(' 3 '),
            ),
            Text(
              'ส่งอาหาร',
              style: MyConstant().h3Style(),
            ),
          ],
        ),
        SizedBox(
          width: 20,
        ),
        Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Color(0xffF6F6F6),
                  borderRadius: BorderRadius.circular(1000),
                  border: Border.all(width: 2, color: Color(0xffF6F6F6))),
              child: Text(' 4 '),
            ),
            Text(
              'เสร็จสิ้น',
              style: MyConstant().h3Style(),
            ),
          ],
        ),
      ],
    );
  }

  GestureDetector buildNext(BuildContext context, double size) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ACPT_order2();
        }));
      },
      child: Container(
        margin: EdgeInsets.only(top: 50),
        width: size * 0.9,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: MyConstant.primary,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            "ยินยันว่าถึงที่หมายแล้ว",
            style: MyConstant().h5Style(),
          ),
        ),
      ),
    );
  }
}
