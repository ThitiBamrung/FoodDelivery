import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fooddelivery/models/category_model.dart';
import 'package:fooddelivery/models/customer_model.dart';
import 'package:fooddelivery/models/order_model.dart';
import 'package:fooddelivery/models/product_model.dart';
import 'package:fooddelivery/models/user_model.dart';
import 'package:fooddelivery/models/widraw_model.dart';
import 'package:fooddelivery/utility/app_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppService {
  AppController appController = Get.put(AppController());

  Future<void> readProduct() async {
    if (appController.productModels.isNotEmpty) {
      appController.productModels.clear();
      appController.categoryModelForListProducts.clear();
    }
    String urlAPi =
        'https://www.androidthai.in.th/edumall/getProductWhereUser.php?isAdd=true&res_id=${appController.res_ids.last}';
    await Dio().get(urlAPi).then((value) async {
      if (value.toString() != 'null') {
        for (var element in jsonDecode(value.data)) {
          ProductModel productModel = ProductModel.fromMap(element);
          appController.productModels.add(productModel);

          String url =
              'https://www.androidthai.in.th/edumall/getCatWhereId.php?isAdd=true&cate_id=${productModel.cate_id}';
          await Dio().get(url).then((value) {
            for (var element in jsonDecode(value.data)) {
              CategoryModel categoryModel = CategoryModel.fromMap(element);
              appController.categoryModelForListProducts.add(categoryModel);
            }
          });
        }
      }
    });
  }

  Future<void> readRestaurantWhereResId() async {
    if (appController.currentUserModels.isNotEmpty) {
      appController.currentUserModels.clear();
    }

    String path =
        'https://www.androidthai.in.th/edumall/Restaurant_getUser.php';
    await Dio().get(path).then((value) {
      for (var element in json.decode(value.data)) {
        UserModel userModel = UserModel.fromMap(element);
        if (appController.res_ids.last == userModel.res_id) {
          appController.currentUserModels.add(userModel);
        }
      }
    });
  }

  Future<void> resdCategoryWhereResId() async {
    if (appController.categoryModels.isNotEmpty) {
      appController.categoryModels.clear();
      appController.ChooseCategoryModels.clear();
      appController.ChooseCategoryModels.add(null);
    }

    String path = 'https://www.androidthai.in.th/edumall/getCategory.php';
    await Dio().get(path).then((value) {
      for (var element in json.decode(value.data)) {
        CategoryModel categoryModel = CategoryModel.fromMap(element);
        if (appController.res_ids.last == categoryModel.res_id) {
          appController.categoryModels.add(categoryModel);
        }
      }
    });
  }

    Future<void> resdCategoryWhereResIdEdit() async {
    if (appController.categoryModelsE.isNotEmpty) {
      appController.categoryModelsE.clear();
      appController.ChooseCategoryModelsE.clear();
      appController.ChooseCategoryModelsE.add(null);
    }

    String path = 'https://www.androidthai.in.th/edumall/getCategory.php';
    await Dio().get(path).then((value) {
      for (var element in json.decode(value.data)) {
        CategoryModel categoryModel = CategoryModel.fromMap(element);
        if (appController.res_ids.last == categoryModel.res_id) {
          appController.categoryModelsE.add(categoryModel);
        }
      }
    });
  }

  Future<void> readOrderWhereResId() async {
    if (appController.orderNowModels2.isNotEmpty) {
      appController.orderNowModels2.clear();
      appController.custModelForListNowOrders2.clear();
    }

    String urlAPi =
        'https://www.androidthai.in.th/edumall/getOrderWhereResId.php?isAdd=true&idShop=${appController.res_ids.last}';
    await Dio().get(urlAPi).then((value) async {
      if (value.toString() != 'null') {
        for (var element in jsonDecode(value.data)) {
          OrderModel orderModel = OrderModel.fromMap(element);
          appController.orderNowModels2.add(orderModel);
          print('URLAPI = ${orderModel.toMap()}');

          String url =
              'https://www.androidthai.in.th/edumall/getCustometWhereCusId.php?isAdd=true&cust_id=${orderModel.idCustomer}';
          await Dio().get(url).then((value) {
            for (var element in jsonDecode(value.data)) {
              CustomerModel customerModel = CustomerModel.fromMap(element);
              appController.custModelForListNowOrders2.add(customerModel);
            }
          });
        }
      }
    });
  }

  Future<void> readHistoryOrderWhereResId() async {
    if (appController.orderModelsH.isNotEmpty) {
      appController.orderModelsH.clear();
      appController.custModelForListOrdersH.clear();
    }

    String urlAPi =
        'https://www.androidthai.in.th/edumall/Restaurant_getHistoryOrderWhereResId.php?isAdd=true&idShop=${appController.res_ids.last}';
    await Dio().get(urlAPi).then((value) async {
      if (value.toString() != 'null') {
        for (var element in jsonDecode(value.data)) {
          OrderModel orderModel = OrderModel.fromMap(element);
          appController.orderModelsH.add(orderModel);
          print('URLAPI = ${orderModel.toMap()}');

          String url =
              'https://www.androidthai.in.th/edumall/getCustometWhereCusId.php?isAdd=true&cust_id=${orderModel.idCustomer}';
          await Dio().get(url).then((value) {
           if (value.toString() != 'null') {
              for (var element in jsonDecode(value.data)) {
              CustomerModel customerModel = CustomerModel.fromMap(element);
              appController.custModelForListOrdersH.add(customerModel);
            }
           }
          });
        }
      }
    });
  }

  Future<void> findCurrentUsermodel() async {
    if (appController.currentUserModels.isNotEmpty) {
      appController.currentUserModels.clear();
    }
    String url =
        'https://www.androidthai.in.th/edumall/Restaurant_getUserWhereResId.php?isAdd=true&res_id=${appController.res_ids.last}';
    await Dio().get(url).then((value) {
      for (var element in json.decode(value.data)) {
        UserModel userModel = UserModel.fromMap(element);
        appController.currentUserModels.add(userModel);
      }
    });
  }

  Future<void> readNowOrderDetailWhereOrderId(
      {required String id, required String cust_id}) async {
    if (appController.orderNowModels.isNotEmpty) {
      appController.orderNowModels.clear();
      appController.custModelForListNowOrdersDetail.clear();
    }

    String url =
        'https://www.androidthai.in.th/edumall/Restaurant_getUserWhereResId.php?isAdd=true&res_id=$id';
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

  Future<void> readWidrawWhereResId() async {
    if (appController.widrawModels.isNotEmpty) {
      appController.widrawModels.clear();
    }

    String urlAPi =
        'https://www.androidthai.in.th/edumall/Restaurant_getWidrawWhereResId.php?isAdd=true&res_id=${appController.res_ids.last}';
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
