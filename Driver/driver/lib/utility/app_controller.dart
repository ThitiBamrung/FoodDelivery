// ignore_for_file: non_constant_identifier_names

import 'package:driver/models/customer_model.dart';
import 'package:driver/models/order_model.dart';
import 'package:driver/models/reataurant_model.dart';
import 'package:driver/models/user_model.dart';
import 'package:driver/models/widraw_model.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  RxList<String> rider_ids = <String>[].obs;
  RxList<UserModel> currentUserModels = <UserModel>[].obs;
  RxList<UserModel> UserForMapModels = <UserModel>[].obs;
  //----------------ออเดอร์ที่เข้ามา----------------------------
  RxList<RestaurantModel> resModelForListOrders = <RestaurantModel>[].obs;
  RxList<OrderModel> orderModels = <OrderModel>[].obs;
  //--------------------------------------------------------
  RxList<OrderModel> orderNowModels = <OrderModel>[].obs;
  RxList<CustomerModel> custModelForListNowOrdersDetail = <CustomerModel>[].obs;
  //---------------------A1---------------------------------
  RxList<OrderModel> orderNowModelsA1 = <OrderModel>[].obs;
  RxList<CustomerModel> custModelForListNowOrdersDetailA1 =
      <CustomerModel>[].obs;
  //---------------------S1---------------------------------
  RxList<OrderModel> orderNowModelsS1 = <OrderModel>[].obs;
  RxList<CustomerModel> custModelForListNowOrdersDetailS1 =
      <CustomerModel>[].obs;
  RxList<RestaurantModel> resModelForListNowOrdersDetailS1 =
      <RestaurantModel>[].obs;
  //---------------------S2---------------------------------
  RxList<OrderModel> orderNowModelsS2 = <OrderModel>[].obs;
  RxList<CustomerModel> custModelForListNowOrdersDetailS2 =
      <CustomerModel>[].obs;
  RxList<RestaurantModel> resModelForListNowOrdersDetailS2 =
      <RestaurantModel>[].obs;
  //---------------------S3---------------------------------
  RxList<OrderModel> orderNowModelsS3 = <OrderModel>[].obs;
  RxList<CustomerModel> custModelForListNowOrdersDetailS3 =
      <CustomerModel>[].obs;
  RxList<RestaurantModel> resModelForListNowOrdersDetailS3 =
      <RestaurantModel>[].obs;
  //----------------ออเดอร์เก่า-------------------------------
  RxList<OrderModel> orderModelsH = <OrderModel>[].obs;
  RxList<CustomerModel> custModelForListOrdersHistory = <CustomerModel>[].obs;
  //----------------วอเล็ต-----------------------------------
  RxList<WidrawModel> widrawModels = <WidrawModel>[].obs;
}
