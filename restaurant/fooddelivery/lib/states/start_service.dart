import 'package:flutter/material.dart';
import 'package:fooddelivery/utility/my_constant.dart';
import 'package:fooddelivery/widgets/show_images.dart';
import 'package:fooddelivery/widgets/show_titles.dart';

class StartService extends StatefulWidget {
  const StartService({super.key});

  @override
  State<StartService> createState() => _StartServiceState();
}

class _StartServiceState extends State<StartService> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                BuildImages(size),
                BuildTitle('เริ่มต้นใช้บริการ'),
                BuildTitle1('ตั้งค่าพื้นฐานสำหรับการเปิดใช้งานหากยังไม่พร้อม'),
                BuildTitle2('คุณยังสามารถเปิดใช้งานได้ในภายหลัง'),
                BuildSkip(size),
                BuildStart(size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row BuildImages(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          width: size * 0.5,
          child: ShowImages(path: MyConstant.logo),
        ),
      ],
    );
  }

    Row BuildTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          child: ShowTitles(
            title: title,
            textStyle: TextStyle(
              color: Colors.black,
              fontFamily: "MN MINI Bold",
              fontSize: 30,
            ),
          ),
        ),
      ],
    );
  }

    Row BuildTitle1(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 5),
          child: ShowTitles(
            title: title,
            textStyle: TextStyle(
              color: Colors.grey.shade600,
              fontFamily: "MN MINI",
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

      Row BuildTitle2(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 5),
          child: ShowTitles(
            title: title,
            textStyle: TextStyle(
              color: Colors.grey.shade600,
              fontFamily: "MN MINI",
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Row BuildSkip(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 170),
          width: size * 0.9,
          height: 48,
          child: ElevatedButton(
            style: MyConstant().myButtonStyle2(),
            onPressed: () {},
            child: Text(
              'ข้าม ฉันจะเปิดใช้งานในภายหลัง',
              style: TextStyle(
                color: MyConstant.primary,
                fontSize: 20,
                fontFamily: "MN MINI",
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row BuildStart(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          width: size * 0.9,
          height: 48,
          child: ElevatedButton(
            style: MyConstant().myButtonStyle(),
            onPressed: () {},
            child: Text(
              'เปิดใช้บริการ',
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
