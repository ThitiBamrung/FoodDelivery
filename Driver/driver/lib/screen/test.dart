// Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Container(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'เลขคำสั่งซื้อ',
//                                   style: TextStyle(
//                                       fontFamily: 'MN MINI Bold',
//                                       fontSize: 20,
//                                       color: Colors.black87),
//                                 ),
//                                 Text(
//                                   'LMF-670600${widget.orderModel.id}',
//                                   style: TextStyle(
//                                       fontFamily: 'MN MINI Bold',
//                                       fontSize: 20,
//                                       color: Colors.black87),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 16, top: 2, right: 16),
//                     child: Container(
//                       child: Row(
//                         children: [
//                           Text(
//                             appController.custModelForListNowOrdersDetailS1.last
//                                 .cust_firstname,
//                             style: TextStyle(
//                               fontFamily: 'MN MINI Bold',
//                               fontSize: 27,
//                               color: Colors.black87,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 2,
//                           ),
//                           SizedBox(width: 10),
//                           Text(
//                             appController.custModelForListNowOrdersDetailS1.last
//                                 .cust_lastname,
//                             style: TextStyle(
//                               fontFamily: 'MN MINI Bold',
//                               fontSize: 27,
//                               color: Colors.black87,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 2,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 16, right: 16),
//                     child: Container(
//                       child: Row(
//                         children: [
//                           Text(
//                             'วันที่ ${DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.parse(widget.orderModel.dateTime))} ',
//                             style: TextStyle(
//                                 fontFamily: 'MN MINI',
//                                 fontSize: 18,
//                                 color: Color(0xffA8A5A5)),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child: Column(
//                           children: [
//                             Text(
//                               'จำนวน',
//                               style: TextStyle(
//                                   fontFamily: 'MN MINI Bold',
//                                   fontSize: 18,
//                                   color: Colors.black87),
//                             ),
//                             Text(
//                               widget.orderModel.amounts
//                                   .replaceAll('[', '')
//                                   .replaceAll(']', '')
//                                   .replaceAll(', ', '\n'),
//                               style: TextStyle(
//                                   fontFamily: 'MN MINI',
//                                   fontSize: 18,
//                                   color: Colors.black87),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Expanded(
//                         flex: 2,
//                         child: Column(
//                           children: [
//                             Text(
//                               'รายการ',
//                               style: TextStyle(
//                                   fontFamily: 'MN MINI Bold',
//                                   fontSize: 18,
//                                   color: Colors.black87),
//                             ),
//                             Text(
//                               widget.orderModel.names
//                                   .replaceAll('[', '')
//                                   .replaceAll(']', '')
//                                   .replaceAll(', ', '\n'),
//                               style: TextStyle(
//                                   fontFamily: 'MN MINI',
//                                   fontSize: 18,
//                                   color: Colors.black87),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Expanded(
//                         flex: 2,
//                         child: Column(
//                           children: [
//                             Text(
//                               'ราคา',
//                               style: TextStyle(
//                                   fontFamily: 'MN MINI Bold',
//                                   fontSize: 18,
//                                   color: Colors.black87),
//                             ),
//                             for (var name in widget.orderModel.prices
//                                 .replaceAll('[', '')
//                                 .replaceAll(']', '')
//                                 .split(','))
//                               Text(
//                                 name,
//                                 style: TextStyle(
//                                     fontFamily: 'MN MINI',
//                                     fontSize: 18,
//                                     color: Colors.black87),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   buildLine(size),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 16, top: 2, right: 16),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         ShowTitles(
//                             title: 'ค่าอาหาร',
//                             textStyle: TextStyle(
//                                 fontFamily: 'MN MINI Bold',
//                                 fontSize: 20,
//                                 color: Colors.black87)),
//                         ShowTitles(
//                             title: '${widget.orderModel.total} บาท',
//                             textStyle: TextStyle(
//                                 fontFamily: 'MN MINI Bold',
//                                 fontSize: 20,
//                                 color: Colors.black87)),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding:
//                         const EdgeInsets.only(left: 16, right: 16, bottom: 15),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         ShowTitles(
//                             title: 'ค่าส่ง',
//                             textStyle: TextStyle(
//                                 fontFamily: 'MN MINI Bold',
//                                 fontSize: 20,
//                                 color: Colors.black87)),
//                         ShowTitles(
//                             title: '${widget.orderModel.delivery} บาท',
//                             textStyle: TextStyle(
//                                 fontFamily: 'MN MINI Bold',
//                                 fontSize: 20,
//                                 color: Colors.black87)),
//                       ],
//                     ),
//                   ),