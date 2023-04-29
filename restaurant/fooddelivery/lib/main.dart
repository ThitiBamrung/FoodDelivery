import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fooddelivery/models/order_model.dart';
import 'package:fooddelivery/states/FoodMangeTabs/addon.dart';
import 'package:fooddelivery/states/FoodMangeTabs/category.dart';
import 'package:fooddelivery/states/FoodMangeTabs/create_addon.dart';
import 'package:fooddelivery/states/FoodMangeTabs/create_food.dart';
import 'package:fooddelivery/states/FoodMangeTabs/food.dart';
import 'package:fooddelivery/states/Navmenu/edit_profile.dart';
import 'package:fooddelivery/states/Navmenu/history.dart';
import 'package:fooddelivery/states/Navmenu/managemenu.dart';
import 'package:fooddelivery/states/Navmenu/profile.dart';
import 'package:fooddelivery/states/Navmenu/wallet.dart';
import 'package:fooddelivery/states/Navmenu/widraw.dart';
import 'package:fooddelivery/states/Order/now_order.dart';
import 'package:fooddelivery/states/Order/now_orderDetail.dart';
import 'package:fooddelivery/states/authen.dart';
import 'package:fooddelivery/states/create_account.dart';
import 'package:fooddelivery/states/create_account2.dart';
import 'package:fooddelivery/states/saler_service.dart';
import 'package:fooddelivery/states/start_service.dart';
import 'package:fooddelivery/utility/app_controller.dart';
import 'package:fooddelivery/utility/my_constant.dart';
import 'package:fooddelivery/widgets/show_navbar.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fooddelivery/states/FoodMangeTabs/create_category.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/createAccount': (BuildContext context) => CreateAccount(),
  '/salerService': (BuildContext context) => SalerService(),
  '/createAccount2': (BuildContext context) => CreateBussinessDetail(
        phone: '',
        ownername: '',
        //lastname: '',
        email: '',
        password: '',
      ),
  '/startService': (BuildContext context) => StartService(),
  '/managemenu': (BuildContext context) => ManageMenu(),
  '/history': (BuildContext context) => History(),
  '/wallet': (BuildContext context) => Wallet(),
  '/profile': (BuildContext context) => Profile(),
  '/shownavbar': (BuildContext context) => Navbar(),
  '/category': (BuildContext context) => CategoryFood(),
  '/createCategory': (BuildContext context) => CreateCategory(),
  '/addon': (BuildContext context) => Addon(),
  '/createAddon': (BuildContext context) => CreateAddon(),
  '/food': (BuildContext context) => Food(),
  '/createFood': (BuildContext context) => CreateFood(),
  '/widraw': (BuildContext context) => Widraw(),
  '/editProfile': (BuildContext context) => EditProfile(),
  '/nowOrder': (BuildContext context) => NowOrder(),
  
};

String? initalRoute;

Future<void> main() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  HttpOverrides.global = MyHttpOveride();

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? email = preferences.getString('email_address');
  print('## email ===> $email');
  String? res_id = preferences.getString('res_id');

  if (res_id != null) {
    AppController appController = Get.put(AppController());
    appController.res_ids.add(res_id);
    print('ResId = ${appController.res_ids}');
  }

  if (email?.isEmpty ?? true) {
    initalRoute = MyConstant.routeAuthen;
    runApp(const MyApp());
  } else {
    initalRoute = MyConstant.routeShowNavbar;
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: MyConstant.appName,
      routes: map,
      initialRoute: initalRoute,
      theme: ThemeData(
          appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: MyConstant.primary,
      )),
    );
  }
}

class MyHttpOveride extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    // TODO: implement createHttpClient
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
