import 'package:dio/dio.dart';
import 'package:driver/utility/app_controller.dart';
import 'package:driver/utility/app_service.dart';
import 'package:driver/utility/my_constant.dart';
import 'package:driver/utility/my_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Widraw extends StatefulWidget {
  const Widraw({super.key});

  @override
  State<Widraw> createState() => _WidrawState();
}

class _WidrawState extends State<Widraw> {
  TextEditingController widraw_moneyController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? SelectedBank;
  List listBank = [
    "ธนาคารกรุงเทพ",
    "ธนาคารกสิกรไทย",
    "ธนาคารกรุงไทย",
    "ธนาคารทหารไทยธนชาต"
  ];

  Future<void> widrawInserAndupdateMySQL({
    required String wallet,
    required String driver_id,
  }) async {
    print('Process insert data success');

    String apiUpdateWalletwhereUser =
        '${MyConstant.domain}/Driver_UpdateWalletWhereDriverId.php?isAdd=true&wallet=$wallet&driver_id=$driver_id';
    await Dio().get(apiUpdateWalletwhereUser).then((value) {
      if (value.toString() == 'true') {
        Get.back();
        AppController().currentUserModels.clear();
        AppController().widrawModels.clear();
      } else {
        MyDialog()
            .normalDialog(context, 'ถอนเงินไม่สำเร็จ', 'กรุณาลองใหม่อีกครั้ง');
      }
    });
    String apiTopupHistoryWallet =
        '${MyConstant.domain}/Driver_WidrawWallet.php?isAdd=true&driver_id=$driver_id&widraw_amount=$wallet&dateTime=${DateTime.now().toString()}';
    await Dio().get(apiTopupHistoryWallet).then((value) {
      if (value.toString() == 'true') {
        Get.back();
        AppController().currentUserModels.clear();
        AppController().widrawModels.clear();
      } else {
        MyDialog()
            .normalDialog(context, 'ถอนเงินไม่สำเร็จ', 'กรุณาลองใหม่อีกครั้ง');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        centerTitle: true,
        elevation: 0,
        title: Text(
          'ถอนเงิน',
          style: TextStyle(
              color: Colors.black87, fontSize: 36, fontFamily: "MN MINI"),
        ),
        backgroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildBankSelect(size),
                  buildWidrawMoney(size),
                  buildEnterWidraw(size),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row buildWidrawMoney(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          width: size * 0.9,
          child: TextFormField(
            controller: widraw_moneyController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกจำนวนเงินที่ต้องการถอน';
              } else {
                return null;
              }
            },
            maxLength: 255,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: TextStyle(
                color: Colors.black87,
                fontFamily: "MN MINI",
                fontSize: 19,
              ),
              hintStyle: TextStyle(
                fontFamily: "MN MINI",
                fontSize: 16,
              ),
              labelText: 'จำนวนเงิน',
              hintText: 'กรุณากรอกจำนวนเงินที่ต้องการ',
              contentPadding: EdgeInsets.only(left: 20),
              suffixIcon: IconButton(
                onPressed: () {
                  widraw_moneyController.clear();
                },
                icon: const Icon(Icons.clear_outlined),
                color: Colors.black87,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black87),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildBankSelect(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          width: size * 0.9,
          child: DropdownButtonFormField<String>(
            value: SelectedBank,
            onChanged: (value) {
              setState(() {
                SelectedBank = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'กรุณาเลือกบัญชีธนาคาร';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: TextStyle(
                color: Colors.black,
                fontFamily: "MN MINI",
                fontSize: 19,
              ),
              hintStyle: TextStyle(
                fontFamily: "MN MINI",
                fontSize: 16,
              ),
              labelText: 'ธนาคาร',
              hintText: 'กรุณาเลือกธนาคาร',
              contentPadding: EdgeInsets.only(left: 20),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            items: listBank.map((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Container(
                    child: Text(value,
                        style: TextStyle(
                            height: 0.0, fontFamily: 'MN MINI', fontSize: 16))),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Row buildEnterWidraw(double size) {
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
              if (widraw_moneyController.text.isEmpty) {
                Future.delayed(Duration(seconds: 1), () {
                  Get.snackbar(
                      'จำนวนเงิน', 'กรุณากรอกจำนวนเงินที่ต้องการถอนเงิน',
                      backgroundColor: Colors.red, colorText: Colors.white);
                });
              } else {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                String? driver_id = preferences.getString('driver_id');

                if (driver_id != null) {
                  // ignore: use_build_context_synchronously
                  MyDialog().normalDialogSneck(
                      context, 'ถอนเงิน', 'ยืนยันที่จะถอนเงินหรือไม่',
                      firstAction: TextButton(
                          onPressed: () {
                            widrawInserAndupdateMySQL(
                                wallet: widraw_moneyController.text,
                                driver_id: driver_id);
                            Future.delayed(Duration(seconds: 1), () {
                              Get.snackbar('ถอนเงิน', 'ถอนเงินเสร็จสิ้น',
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white);
                            });
                          },
                          child: Text('ยืนยัน')));
                }
              }
              //Insertdata();
            },
            child: const Text(
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
