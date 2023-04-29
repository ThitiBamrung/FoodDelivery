import 'dart:io';
import 'package:driver/screen/Delivery/all_now_order_delivery.dart';
import 'package:driver/screen/Delivery/step_one.dart';
import 'package:driver/screen/Navmenu/edit_profile.dart';
import 'package:driver/screen/Navmenu/widraw.dart';
import 'package:driver/screen/driver_service.dart';
import 'package:driver/utility/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:driver/screen/authen.dart';
import 'package:driver/screen/create_account.dart';
import 'package:driver/screen/create_account2.dart';
import 'package:driver/utility/my_constant.dart';
import 'package:driver/widgets/show_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/createAccount': (BuildContext context) => CreateAccount(),
  '/createAccount2': (BuildContext context) => CreateAccount2(
        phone: '',
        firstname: '',
        lastname: '',
        email: '',
        password: '',
      ),

  '/showNavbar': (BuildContext context) => Navbar(),
  '/widraw': (BuildContext context) => Widraw(),
  '/allnoworder': (BuildContext context) => AllNowOrder(),
  '/driverService': (BuildContext context) => DriverService(),
  '/editProfile': (BuildContext context) => EditProfile(),
};

String? initalRoute;

Future<void> main() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  HttpOverrides.global = MyHttpOveride();

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? email = preferences.getString('email_address');
  print('## email ===> $email');
  String? driver_id = preferences.getString('driver_id');

  if (driver_id != null) {
    AppController appController = Get.put(AppController());
    appController.rider_ids.add(driver_id);
    print('RiderId = ${appController.rider_ids}');
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
