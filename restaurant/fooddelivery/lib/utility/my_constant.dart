import 'package:flutter/material.dart';

class MyConstant {
  //General
  static String appName = 'Food Delivery';
  static String domain = 'https://www.androidthai.in.th/edumall';
  //Route
  static String routeAuthen = '/authen';
  static String routeCreateAccount = '/createAccount';
  static String routeBuyerService = '/buyerService';
  static String routeSalerService = '/salerService';
  static String routeRiderService = '/riderService';
  static String routeCreateAccount2 = '/createAccount2';
  static String routeStartService = '/startService';
  static String routeShowNavbar = '/shownavbar';
  static String routeManagemenu = '/managemenu';
  static String routeHistory = '/history';
  static String routeWallet = '/wallet';
  static String routeCategory = '/category';
  static String routeProfile = '/profile';
  static String routeCreateCategory = '/createCategory';
  static String routeAddon = '/addon';
  static String routeCreateAddon = '/createAddon';
  static String routeFood = '/food';
  static String routeCreateFood = '/createFood';
  static String routeWidraw = '/widraw';
  static String routeEditProfile = '/editProfile';
  static String routeNowOrder = '/nowOrder';

  //Image
  static String logo = 'images/logo.png';
  // ignore: non_constant_identifier_names
  static String store_img = 'images/store.png';
  // ignore: non_constant_identifier_names
  static String food_imgDefault = 'images/fooddefault.png';

  //color
  static Color primary = Color(0xffFF8126);
  static Color dark = Color(0xffC55200);
  static Color light = Color(0xffFFC077);

  //style
  TextStyle h1Style() => TextStyle(
        fontSize: 24,
        color: dark,
        fontWeight: FontWeight.bold,
      );
  TextStyle h2Style() => TextStyle(
        fontSize: 18,
        color: dark,
        fontWeight: FontWeight.w700,
      );
  TextStyle h3Style() => TextStyle(
      fontSize: 16,
      color: dark,
      fontWeight: FontWeight.normal,
      fontFamily: "MN MINI");
  TextStyle h4Style() => TextStyle(
        fontSize: 25,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontFamily: "MN MINI Bold",
      );
  TextStyle h5Style() => TextStyle(
        fontSize: 25,
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontFamily: "MN MINI",
      );

  ButtonStyle myButtonStyle() => ElevatedButton.styleFrom(
        primary: MyConstant.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      );
  ButtonStyle mySignoutButtonStyle() => ElevatedButton.styleFrom(
        primary: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      );
  ButtonStyle myButtonStyle2() => ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      side: const BorderSide(
        color: Color(0xffFF8126),
      ));
}
