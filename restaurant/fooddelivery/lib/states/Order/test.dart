// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:numfu/model/wallet_model.dart';
// import 'package:numfu/screen/success.dart';
// import 'package:numfu/utility/app_controller.dart';
// import 'package:numfu/utility/app_service.dart';
// import 'package:numfu/utility/my_constant.dart';
// import 'package:numfu/utility/my_dialog.dart';
// import 'package:numfu/widgets/show_progress.dart';
// import 'package:numfu/widgets/show_title.dart';
// import 'package:numfu/widgets/widget_image_network.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/date_symbol_data_local.dart';

// class Wallet extends StatefulWidget {
//   static const routeName = '/';

//   const Wallet({Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() {
//     return _WalletState();
//   }
// }

// class _WalletState extends State<Wallet> {
//   final appController = Get.put(AppController());

//   @override
//   void initState() {
//     super.initState();
//     AppService().findCurrentUsermodel();
//     processReadWallet();
//   }

//   void processReadWallet() {
//     AppService().readWalletWhereCustId().then((value) {
//       appController.walletModel.sort((a, b) => DateTime.parse(b.dateTime)
//           .millisecondsSinceEpoch
//           .compareTo(DateTime.parse(a.dateTime).millisecondsSinceEpoch));
//       setState(() {
//         load = false;
//       });
//     });
//   }

//   late final WalletModel walletModel;
//   final formKey = GlobalKey<FormState>();
//   bool load = true;
//   TextEditingController walletcontroller = TextEditingController();

//   int price = 0;

//   Future<void> topupInserAndupdateMySQL({
//     required String wallet,
//     required String cust_id,
//   }) async {
//     print('Process insert data success');

//     String apiUpdateWalletwhereUser =
//         '${MyCostant.domain}/customer_UpdateWalletWhereCust_id.php?isAdd=true&wallet=$wallet&cust_id=$cust_id';
//     await Dio().get(apiUpdateWalletwhereUser).then((value) {
//       if (value.toString() == 'true') {
//         // Navigator.pushNamed(context, MyConstant.routeManagemenu);
//         Get.back();
//       } else {
//         MyDialog()
//             .normalDialog(context, 'เติมเงินไม่สำเร็จ', 'กรุณาลองใหม่อีกครั้ง');
//       }
//     });
//     String apiTopupHistoryWallet =
//         '${MyCostant.domain}/customer_topupWallet.php?isAdd=true&cust_id=$cust_id&wallet_amount=$wallet&dateTime=${DateTime.now().toString()}';
//     await Dio().get(apiTopupHistoryWallet).then((value) {
//       if (value.toString() == 'true') {
//         // Navigator.pushNamed(context, MyConstant.routeManagemenu);
//         Get.back();
//       } else {
//         MyDialog()
//             .normalDialog(context, 'เติมเงินไม่สำเร็จ', 'กรุณาลองใหม่อีกครั้ง');
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     initializeDateFormatting('th_TH', null);
//     double size = MediaQuery.of(context).size.width;
//     return GetX(
//         init: AppController(),
//         builder: (AppController appController) {
//           print('##walletlist = ${appController.datas}');
//           return Scaffold(
//             appBar: AppBar(
//               automaticallyImplyLeading: false,
//               centerTitle: true,
//               title: Text(
//                 'กระเป๋าเงิน',
//                 style: MyCostant().headStyle(),
//               ),
//               backgroundColor: Colors.white,
//               elevation: 0,
//             ),
//             backgroundColor: Colors.white,
//             body: appController.currentUserModels.isEmpty &&
//                     appController.walletModel.isEmpty
//                 ? const SizedBox()
//                 : Center(
//                     child: GestureDetector(
//                       onTap: () {
//                         FocusScopeNode currentFocus = FocusScope.of(context);
//                         if (!currentFocus.hasPrimaryFocus) {
//                           currentFocus.unfocus();
//                         }
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
//                         child: ListView(
//                           children: <Widget>[
//                             buildBalance(size, appController: appController),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             Text(
//                               'ระบุจำนวนเงิน (THB)',
//                               style: MyCostant().h2Style(),
//                             ),
//                             buildTopup(size),
//                             buildFixnum(size),
//                             buildEnterTopup(size),
//                             ListView.builder(
//                               shrinkWrap: true,
//                               physics: NeverScrollableScrollPhysics(),
//                               itemCount: appController.walletModel.length,
//                               itemBuilder: (context, index) => InkWell(
//                                 child: Card(
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Icon(
//                                             Icons.add_home,
//                                             size: 45,
//                                             color: Colors.black54,
//                                           ),
//                                           SizedBox(width: 10),
//                                           Text('เงินเข้า'),
//                                           SizedBox(width: 10),
//                                           Text(
//                                               '+฿${appController.walletModel[index].wallet_amount}'),
//                                         ],
//                                       ),
//                                       Text(
//                                         DateFormat('dd MMM yy HH:mm', 'th_TH')
//                                             .format(DateTime.parse(appController
//                                                 .walletModel[index].dateTime)),
//                                         style: MyCostant().h4Style(),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//           );
//         });
//   }

//   Row buildFixnum(double size) {
//     return Row(
//       children: [
//         GestureDetector(
//           onTap: () {
//             int currentValue = int.tryParse(walletcontroller.text) ?? 0;
//             walletcontroller.text = (currentValue + 100).toString();
//           },
//           child: Container(
//             margin: EdgeInsets.only(top: size * 0.1, left: 15),
//             width: size * 0.19,
//             height: 40,
//             decoration: BoxDecoration(
//               border: Border.all(color: MyCostant.dark, width: 2),
//               borderRadius: BorderRadius.circular(20),
//               color: MyCostant.white,
//             ),
//             child: Center(
//               child: Text(
//                 "+100",
//                 style: MyCostant().h6_3button(),
//               ),
//             ),
//           ),
//         ),
//         SizedBox(width: 10),
//         GestureDetector(
//           onTap: () {
//             int currentValue = int.tryParse(walletcontroller.text) ?? 0;
//             walletcontroller.text = (currentValue + 200).toString();
//           },
//           child: Container(
//             margin: EdgeInsets.only(top: size * 0.1),
//             width: size * 0.19,
//             height: 40,
//             decoration: BoxDecoration(
//               border: Border.all(color: MyCostant.dark, width: 2),
//               borderRadius: BorderRadius.circular(20),
//               color: MyCostant.white,
//             ),
//             child: Center(
//               child: Text(
//                 "+200",
//                 style: MyCostant().h6_3button(),
//               ),
//             ),
//           ),
//         ),
//         SizedBox(width: 10),
//         GestureDetector(
//           onTap: () {
//             int currentValue = int.tryParse(walletcontroller.text) ?? 0;
//             walletcontroller.text = (currentValue + 500).toString();
//           },
//           child: Container(
//             margin: EdgeInsets.only(top: size * 0.1),
//             width: size * 0.19,
//             height: 40,
//             decoration: BoxDecoration(
//               border: Border.all(color: MyCostant.dark, width: 2),
//               borderRadius: BorderRadius.circular(20),
//               color: MyCostant.white,
//             ),
//             child: Center(
//               child: Text(
//                 "+500",
//                 style: MyCostant().h6_3button(),
//               ),
//             ),
//           ),
//         ),
//         SizedBox(width: 10),
//         GestureDetector(
//           onTap: () {
//             int currentValue = int.tryParse(walletcontroller.text) ?? 0;
//             walletcontroller.text = (currentValue + 1000).toString();
//           },
//           child: Container(
//             margin: EdgeInsets.only(top: size * 0.1),
//             width: size * 0.19,
//             height: 40,
//             decoration: BoxDecoration(
//               border: Border.all(color: MyCostant.dark, width: 2),
//               borderRadius: BorderRadius.circular(20),
//               color: MyCostant.white,
//             ),
//             child: Center(
//               child: Text(
//                 "+1,000",
//                 style: MyCostant().h6_3button(),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Container buildBalance(double size, {required AppController appController}) {
//     return Container(
//       width: size * 0.8,
//       height: 110,
//       decoration: BoxDecoration(
//         color: MyCostant.primary,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Text(
//             '  ยอดเงินคงเหลือ',
//             style: TextStyle(fontSize: 30, color: Colors.white),
//           ),
//           Text(
//             '฿ ${(int.parse(appController.currentUserModels.last.wallet!) - int.parse(appController.currentUserModels.last.payment!))}   ',
//             style: TextStyle(fontSize: 25, color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }

//   Row buildEnterTopup(double size) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           margin: EdgeInsets.symmetric(vertical: 30),
//           width: size * 0.9,
//           height: 38,
//           child: ElevatedButton(
//             style: MyCostant().myButtonStyle(),
//             onPressed: () async {
//               if (walletcontroller.text.isEmpty) {
//                 Future.delayed(Duration(seconds: 1), () {
//                   Get.snackbar(
//                       'จำนวนเงิน', 'กรุณากรอกจำนวนเงินที่ต้องการเติมเงิน',
//                       backgroundColor: Colors.red, colorText: Colors.white);
//                 });
//               } else {
//                 SharedPreferences preferences =
//                     await SharedPreferences.getInstance();
//                 var datas = preferences.getStringList('datas');

//                 print('### cust_id = ${datas}');
//                 if (datas != null) {
//                   // ignore: use_build_context_synchronously
//                   MyDialog().normalDialog(context, 'เติมเงิน',
//                       'ยืนยันที่จะเติมเงินเข้าสู่ระบบหรือไม่',
//                       firstAction: TextButton(
//                           onPressed: () {
//                             topupInserAndupdateMySQL(
//                                 wallet: walletcontroller.text,
//                                 cust_id: datas[0]);
//                             Future.delayed(Duration(seconds: 1), () {
//                               Get.snackbar(
//                                   'เติมเงิน', 'เติมเงินเข้าสู่ระบบเสร็จสิ้น',
//                                   backgroundColor: Colors.green,
//                                   colorText: Colors.white);
//                               walletcontroller.clear();
//                               AppService().findCurrentUsermodel();
//                               processReadWallet();
//                             });
//                           },
//                           child: Text('ยืนยัน')));
//                 }
//               }
//               //Insertdata();
//             },
//             child: Text(
//               'เติมเงิน',
//               style: MyCostant().h5button(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Row buildTopup(double size) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           margin: EdgeInsets.only(top: 20),
//           width: size * 0.9,
//           child: TextFormField(
//             controller: walletcontroller,
//             keyboardType: TextInputType.number,
//             inputFormatters: [
//               FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
//             ],
//             decoration: InputDecoration(
//               labelStyle: MyCostant().h4Style(),
//               labelText: 'ใส่จำนวนเงิน',
//               hintText: "ใส่จำนวนเงินที่ต้องการเติม..",

//               //suffixIcon: Icon(Icons.person),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
