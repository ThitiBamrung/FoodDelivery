import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:driver/models/customer_model.dart';
import 'package:driver/models/order_model.dart';
import 'package:driver/models/reataurant_model.dart';
import 'package:driver/models/user_model.dart';
import 'package:driver/models/widraw_model.dart';
import 'package:driver/utility/app_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppService {
  AppController appController = Get.put(AppController());

  Future<void> findCurrentUsermodel() async {
    if (appController.currentUserModels.isNotEmpty) {
      appController.currentUserModels.clear();
    }
    String url =
        'https://www.androidthai.in.th/edumall/Driver_getUserWhereDriverId.php?isAdd=true&driver_id=${appController.rider_ids.last}';
    await Dio().get(url).then((value) {
      for (var element in json.decode(value.data)) {
        UserModel userModel = UserModel.fromMap(element);
        appController.currentUserModels.add(userModel);
      }
    });
  }

  Future<void> findUserForMapmodel() async {
    if (appController.UserForMapModels.isNotEmpty) {
      appController.UserForMapModels.clear();
    }
    String url =
        'https://www.androidthai.in.th/edumall/Driver_getUserWhereDriverId.php?isAdd=true&driver_id=${appController.rider_ids.last}';
    await Dio().get(url).then((value) {
      for (var element in json.decode(value.data)) {
        UserModel userModel = UserModel.fromMap(element);
        appController.UserForMapModels.add(userModel);
      }
    });
  }

  Future<void> readDriverWhereDriverId() async {
    if (appController.currentUserModels.isNotEmpty) {
      appController.currentUserModels.clear();
    }

    String path = 'https://www.androidthai.in.th/edumall/Driver_getUser.php';
    await Dio().get(path).then((value) async {
      if (appController.rider_ids.isNotEmpty) {
        for (var element in json.decode(value.data)) {
          UserModel userModel = UserModel.fromMap(element);
          if (appController.rider_ids.last == userModel.driver_id) {
            appController.currentUserModels.add(userModel);
          }
        }
      }
    });
  }

  Future<void> readNowDateOrderWhereDriverId() async {
    if (appController.orderModels.isNotEmpty) {
      appController.orderModels.clear();
      appController.resModelForListOrders.clear();
    }

    String urlAPi =
        'https://www.androidthai.in.th/edumall/Driver_OrderWhereNowDate.php?isAdd=true';
    await Dio().get(urlAPi).then((value) async {
      if (value.toString() != 'null') {
        for (var element in jsonDecode(value.data)) {
          OrderModel orderModel = OrderModel.fromMap(element);
          appController.orderModels.add(orderModel);
          print('URLAPI = ${orderModel.toMap()}');

          String url =
              'https://www.androidthai.in.th/edumall/customer_getRestaurnatWhereResid.php?isAdd=true&res_id=${orderModel.idShop}';
          await Dio().get(url).then((value) {
            for (var element in jsonDecode(value.data)) {
              RestaurantModel restaurantModel =
                  RestaurantModel.fromMap(element);
              appController.resModelForListOrders.add(restaurantModel);
            }
          });
        }
      }
    });
  }
  //--------------his order----------------------------------

  Future<void> readNowOrderDetailWhereOrderId(
      {required String id, required String cust_id}) async {
    if (appController.orderNowModels.isNotEmpty) {
      appController.orderNowModels.clear();
      appController.custModelForListNowOrdersDetail.clear();
    }

    String url =
        'https://www.androidthai.in.th/edumall/Driver_getOrderWhereId.php?isAdd=true&id=$id';
    await Dio().get(url).then((value) async {
      if (value.toString() != 'null') {
        for (var element in json.decode(value.data)) {
          OrderModel orderNowModels = OrderModel.fromMap(element);
          appController.orderNowModels.add(orderNowModels);

          String url2 =
              'https://www.androidthai.in.th/edumall/getCustometWhereCusId.php?isAdd=true&cust_id=$cust_id';
          await Dio().get(url2).then((value) {
            for (var element in jsonDecode(value.data)) {
              CustomerModel customerModel = CustomerModel.fromMap(element);
              appController.custModelForListNowOrdersDetail.add(customerModel);
            }
          });
        }
      }
    });
  }

  //-----------------------Accept Order------------------
  Future<void> readNowOrderDetailWhereOrderIdA1(
      {required String id, required String cust_id}) async {
    if (appController.orderNowModelsA1.isNotEmpty) {
      appController.orderNowModelsA1.clear();
      appController.custModelForListNowOrdersDetailA1.clear();
    }

    String url =
        'https://www.androidthai.in.th/edumall/Driver_getOrderWhereId.php?isAdd=true&id=$id';
    await Dio().get(url).then((value) async {
      if (value.toString() != 'null') {
        for (var element in json.decode(value.data)) {
          OrderModel orderNowModelsA1 = OrderModel.fromMap(element);
          appController.orderNowModelsA1.add(orderNowModelsA1);

          String url2 =
              'https://www.androidthai.in.th/edumall/getCustometWhereCusId.php?isAdd=true&cust_id=$cust_id';
          await Dio().get(url2).then((value) {
            for (var element in jsonDecode(value.data)) {
              CustomerModel customerModel = CustomerModel.fromMap(element);
              appController.custModelForListNowOrdersDetailA1.add(customerModel);
            }
          });
        }
      }
    });
  }

  //S1
  Future<void> readNowOrderDetailWhereOrderIdS1(
      {required String id, required String cust_id, required String res_id}) async {
    if (appController.orderNowModelsS1.isNotEmpty) {
      appController.orderNowModelsS1.clear();
      appController.custModelForListNowOrdersDetailS1.clear();
      appController.resModelForListNowOrdersDetailS1.clear();
    }
    String url =
        'https://www.androidthai.in.th/edumall/Driver_getOrderWhereId.php?isAdd=true&id=$id';
    await Dio().get(url).then((value) async {
      if (value.toString() != 'null') {
        for (var element in json.decode(value.data)) {
          OrderModel orderNowModelsS1 = OrderModel.fromMap(element);
          appController.orderNowModelsS1.add(orderNowModelsS1);

          String url2 =
              'https://www.androidthai.in.th/edumall/getCustometWhereCusId.php?isAdd=true&cust_id=$cust_id';
          await Dio().get(url2).then((value) {
            for (var element in jsonDecode(value.data)) {
              CustomerModel customerModel = CustomerModel.fromMap(element);
              appController.custModelForListNowOrdersDetailS1
                  .add(customerModel);
            }
          });
          String url3 =
              'https://www.androidthai.in.th/edumall/Restaurant_getUserWhereResId.php?isAdd=true&res_id=$res_id';
          await Dio().get(url3).then((value) {
            for (var element in jsonDecode(value.data)) {
              RestaurantModel restaurantModel = RestaurantModel.fromMap(element);
              appController.resModelForListNowOrdersDetailS1
                  .add(restaurantModel);
            }
          });
        }
      }
    });
  }

  //S2
  Future<void> readNowOrderDetailWhereOrderIdS2(
      {required String id, required String cust_id, required String res_id} ) async {
    if (appController.orderNowModelsS2.isNotEmpty) {
      appController.orderNowModelsS2.clear();
      appController.custModelForListNowOrdersDetailS2.clear();
      appController.resModelForListNowOrdersDetailS2.clear();
    }

    String url =
        'https://www.androidthai.in.th/edumall/Driver_getOrderWhereId.php?isAdd=true&id=$id';
    await Dio().get(url).then((value) async {
      if (value.toString() != 'null') {
        for (var element in json.decode(value.data)) {
          OrderModel orderNowModelsS2 = OrderModel.fromMap(element);
          appController.orderNowModelsS2.add(orderNowModelsS2);

          String url2 =
              'https://www.androidthai.in.th/edumall/getCustometWhereCusId.php?isAdd=true&cust_id=$cust_id';
          await Dio().get(url2).then((value) {
            for (var element in jsonDecode(value.data)) {
              CustomerModel customerModel = CustomerModel.fromMap(element);
              appController.custModelForListNowOrdersDetailS2
                  .add(customerModel);
            }
          });
          String url3 =
              'https://www.androidthai.in.th/edumall/Restaurant_getUserWhereResId.php?isAdd=true&res_id=$res_id';
          await Dio().get(url3).then((value) {
            for (var element in jsonDecode(value.data)) {
              RestaurantModel restaurantModel = RestaurantModel.fromMap(element);
              appController.resModelForListNowOrdersDetailS2
                  .add(restaurantModel);
            }
          });
        }
      }
    });
  }

  //S3
  Future<void> readNowOrderDetailWhereOrderIdS3(
      {required String id, required String cust_id, required String res_id}) async {
    if (appController.orderNowModelsS3.isNotEmpty) {
      appController.orderNowModelsS3.clear();
      appController.custModelForListNowOrdersDetailS3.clear();
      appController.resModelForListNowOrdersDetailS3.clear();
    }

    String url =
        'https://www.androidthai.in.th/edumall/Driver_getOrderWhereId.php?isAdd=true&id=$id';
    await Dio().get(url).then((value) async {
      if (value.toString() != 'null') {
        for (var element in json.decode(value.data)) {
          OrderModel orderNowModelsS3 = OrderModel.fromMap(element);
          appController.orderNowModelsS3.add(orderNowModelsS3);

          String url2 =
              'https://www.androidthai.in.th/edumall/getCustometWhereCusId.php?isAdd=true&cust_id=$cust_id';
          await Dio().get(url2).then((value) {
            for (var element in jsonDecode(value.data)) {
              CustomerModel customerModel = CustomerModel.fromMap(element);
              appController.custModelForListNowOrdersDetailS3
                  .add(customerModel);
            }
          });
          String url3 =
              'https://www.androidthai.in.th/edumall/Restaurant_getUserWhereResId.php?isAdd=true&res_id=$res_id';
          await Dio().get(url3).then((value) {
            for (var element in jsonDecode(value.data)) {
              RestaurantModel restaurantModel = RestaurantModel.fromMap(element);
              appController.resModelForListNowOrdersDetailS3
                  .add(restaurantModel);
            }
          });
        }
      }
    });
  }

//-----------------------------------------------------------------------------------

  Future<void> readHistoryOrderWhereDriverId() async {
    if (appController.orderModelsH.isNotEmpty) {
      appController.orderModelsH.clear();
      appController.custModelForListOrdersHistory.clear();
    }

    String urlAPi =
        'https://www.androidthai.in.th/edumall/Driver_getHistoryOrderWhereDriverId.php?isAdd=true&idRidder=${appController.rider_ids.last}';
    await Dio().get(urlAPi).then((value) async {
      if (value.toString() != 'null') {
        for (var element in jsonDecode(value.data)) {
          OrderModel orderModel = OrderModel.fromMap(element);
          appController.orderModelsH.add(orderModel);
          print('URLAPI = ${orderModel.toMap()}');

          String url =
              'https://www.androidthai.in.th/edumall/getCustometWhereCusId.php?isAdd=true&cust_id=${orderModel.idCustomer}';
          await Dio().get(url).then((value) {
            for (var element in jsonDecode(value.data)) {
              CustomerModel customerModel = CustomerModel.fromMap(element);
              appController.custModelForListOrdersHistory.add(customerModel);
            }
          });
        }
      }
    });
  }

  //-------------------Wallter------------------------
  Future<void> readWidrawWhereDriverId() async {
    if (appController.widrawModels.isNotEmpty) {
      appController.widrawModels.clear();
    }

    String urlAPi =
        'https://www.androidthai.in.th/edumall/Driver_getWidrawWhereDriverId.php?isAdd=true&driver_id=${appController.rider_ids.last}';
    await Dio().get(urlAPi).then((value) async {
      if (value.toString() != 'null') {
        for (var element in jsonDecode(value.data)) {
          WidrawModel widrawModel = WidrawModel.fromMap(element);
          appController.widrawModels.add(widrawModel);
          print('URLAPI = ${widrawModel.toMap()}');
        }
      }
    });
  }
}
