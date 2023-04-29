import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:driver/utility/my_constant.dart';
import 'package:driver/widgets/show_images.dart';
import 'package:driver/widgets/show_titles.dart';

class MyDialog {
  Future<Null> alertLocationService(
      BuildContext context, String title, String message) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: ShowImages(
            path: MyConstant.logo,
          ),
          title: ShowTitles(
            title: title,
            textStyle: TextStyle(
              fontSize: 20,
              fontFamily: "MN MINI Bold",
            ),
          ),
          subtitle: ShowTitles(
            title: message,
            textStyle: TextStyle(
              fontSize: 16,
              fontFamily: "MN MINI",
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                //Navigator.pop(context);
                await Geolocator.openLocationSettings();
                exit(0);
              },
              child: Text('OK'))
        ],
      ),
    );
  }

  Future<Null> normalDialog(
      BuildContext context, String title, String message) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          leading: ShowImages(
            path: MyConstant.logo,
          ),
          title: ShowTitles(
            title: title,
            textStyle: MyConstant().h2Style(),
          ),
          subtitle: ShowTitles(title: message, textStyle: MyConstant().h3Style(),),
        ),children: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
      ),
    );
  }

      Future<Null> showProgressDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => WillPopScope(
        child: Center(
            child: CircularProgressIndicator(
          color: Colors.white,
        )),
        onWillPop: () async {
          return false;
        },
      ),
    );
  }

      Future<void> normalDialogSneck(BuildContext context, String title, String message,
      {Widget? firstAction}) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: SizedBox(
            width: 80,
            height: 80,
            child: ShowImages(
              path: MyConstant.logo,
            ),
          ),
          title: ShowTitles(
            title: title,
            textStyle: MyConstant().h2Style(),
          ),
          subtitle: ShowTitles(
            title: message,
            textStyle: MyConstant().h3Style(),
          ),
        ),
        actions: [
          firstAction ?? const SizedBox(),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(firstAction == null ? 'ยืนยัน' : 'ยกเลิก')),
        ],
      ),
    );
  }
}
