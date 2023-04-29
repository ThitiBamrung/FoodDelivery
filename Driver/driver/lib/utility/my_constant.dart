import 'package:flutter/material.dart';

class MyConstant {
  //General
  static String appName = 'Food Delivery';
  static String domain = 'https://www.androidthai.in.th/edumall';
  //Route
  static String routeAuthen = '/authen';
  static String routeCreateAccount = '/createAccount';
  static String routeCreateAccount2 = '/createAccount2';
  static String routeShowNavbar = '/showNavbar';
  static String routeWidraw= '/widraw';
  static String routeAllNowOrder= '/allnoworder';
  static String routeDriverService= '/driverService';
  static String routeEditProfile= '/editProfile';
  //Image
  static String logo = 'images/logo.png';
  static String profile = 'images/profile.png';
  static String Done = 'images/done.png';

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

      ButtonStyle myCloseButtonStyle() => ElevatedButton.styleFrom(
        primary: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
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

        ButtonStyle mySignoutButtonStyle() => ElevatedButton.styleFrom(
        primary: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      );
}
