import 'package:driver/screen/Navmenu/history.dart';
import 'package:driver/screen/Navmenu/profile.dart';
import 'package:driver/screen/Navmenu/wallet.dart';
import 'package:driver/screen/driver_service.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:driver/widgets/show_signout.dart';
import 'package:driver/utility/my_constant.dart';
import 'package:driver/widgets/show_titles.dart';
import 'package:driver/widgets/widget_icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _index = 0;
  final screens = [
    DriverService(),
    History(),
    Wallet(),
    Profile(),
  ];

  var titles = <String>['หน้าหลัก', 'ประวัติ', 'กระเป๋าเงิน', 'โปรไฟล์'];

  void onTabTapped(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShowTitles(
          title: titles[_index],
          textStyle: TextStyle(fontFamily: 'MN MINI Bold',fontSize: 36,color: Colors.black87),
        ),
        // actions: [
        //   WidgetIconButton(
        //     iconData: Icons.exit_to_app,
        //     tapFunc: () async {
        //       SharedPreferences preferences =
        //         await SharedPreferences.getInstance();
        //     preferences.clear().then(
        //           (value) => Navigator.pushNamedAndRemoveUntil(
        //               context, MyConstant.routeAuthen, (route) => false),
        //         );
        //     },
        //   )
        // ],
      ),
      body: screens[_index],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          currentIndex: _index,
          onTap: onTabTapped,
          selectedItemColor: Color(0xffFF8126),
          unselectedItemColor: Colors.black87,
          selectedLabelStyle: TextStyle(fontFamily: 'MN MINI',fontSize: 18),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'หน้าหลัก',
              backgroundColor: Color(0xffFFC077),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'ประวัติ',
              backgroundColor: Color(0xffFFC077),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              label: 'กระเป๋าเงิน',
              backgroundColor: Color(0xffFFC077),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              label: 'โปรไฟล์',
              backgroundColor: Color(0xffFFC077),
            ),
          ],
        ),
      ),
    );
  }
}
