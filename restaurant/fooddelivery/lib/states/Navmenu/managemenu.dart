import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fooddelivery/states/FoodMangeTabs/addon.dart';
import 'package:fooddelivery/states/FoodMangeTabs/food.dart';
import 'package:fooddelivery/states/FoodMangeTabs/category.dart';
import 'package:fooddelivery/utility/my_constant.dart';
import 'package:fooddelivery/widgets/show_signout.dart';
import 'package:fooddelivery/widgets/show_titles.dart';

class ManageMenu extends StatefulWidget {
  @override
  State<ManageMenu> createState() => _ManageMenuState();
}

class _ManageMenuState extends State<ManageMenu> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
         appBar: AppBar(
        title: ShowTitles(
          title: 'จัดการเมนู',
          textStyle: TextStyle(fontFamily: 'MN MINI Bold',fontSize: 36,color: Colors.black87),
        ),
      ),
        backgroundColor: Colors.white,
        body: Column(
          children: const [
            TabBar(
              labelColor: Color(0xffFF8126),
              indicatorColor: Color(0xffFF8126),
              unselectedLabelColor: Colors.black,
              tabs: [
                Tab(
                  child: Text(
                    'หมวดหมู่',
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    style: TextStyle(
                        fontFamily: 'MN MINI',
                        fontSize: 16),
                  ),
                ),
                Tab(
                  child: Text(
                    'รายการอาหาร',
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    style: TextStyle(
                        fontFamily: 'MN MINI',
                        fontSize: 16),
                  ),
                ),
              ],
            ),
            Expanded(
                child: TabBarView(
              children: [
                CategoryFood(),
                Food(),
                //Addon(),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
