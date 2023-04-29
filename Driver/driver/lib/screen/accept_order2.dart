import 'package:flutter/material.dart';
import '../utility/my_constant.dart';

class ACPT_order2 extends StatefulWidget {
  const ACPT_order2({super.key});

  @override
  State<ACPT_order2> createState() => _ACPT_order2State();
}

class _ACPT_order2State extends State<ACPT_order2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'กระเป๋าเงิน',
          style: MyConstant().h2Style(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Center(
            child: ListView(
              children: [],
            ),
          )),
    );
  }
}
