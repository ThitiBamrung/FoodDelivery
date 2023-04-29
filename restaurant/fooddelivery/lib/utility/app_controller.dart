// ignore_for_file: non_constant_identifier_names

import 'package:fooddelivery/models/category_model.dart';
import 'package:fooddelivery/models/customer_model.dart';
import 'package:fooddelivery/models/order_model.dart';
import 'package:fooddelivery/models/product_model.dart';
import 'package:fooddelivery/models/user_model.dart';
import 'package:fooddelivery/models/widraw_model.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  RxList<String> res_ids = <String>[].obs;
  RxList<CategoryModel> categoryModels = <CategoryModel>[].obs;
  RxList<CategoryModel> categoryModelForListProducts = <CategoryModel>[].obs;
  RxList<CategoryModel?> ChooseCategoryModels = <CategoryModel?>[null].obs;
  RxList<ProductModel> productModels = <ProductModel>[].obs;
  RxList<CustomerModel> custModelForListOrders = <CustomerModel>[].obs;
  RxList<CustomerModel> custModelForListNowOrdersDetail = <CustomerModel>[].obs;
  RxList<OrderModel> orderModels = <OrderModel>[].obs;
  RxList<OrderModel> orderNowModels = <OrderModel>[].obs;
  RxList<OrderModel> orderNowModels2 = <OrderModel>[].obs;
  RxList<CustomerModel> custModelForListNowOrders2 = <CustomerModel>[].obs;
  RxList<CustomerModel> custModels = <CustomerModel>[].obs;
  RxList<UserModel> currentUserModels = <UserModel>[].obs;
  RxList<WidrawModel> widrawModels = <WidrawModel>[].obs;

  RxList<CategoryModel> categoryModelsE = <CategoryModel>[].obs;
  RxList<CategoryModel?> ChooseCategoryModelsE = <CategoryModel?>[null].obs;

  RxList<CustomerModel> custModelForListOrdersH = <CustomerModel>[].obs;
  RxList<OrderModel> orderModelsH = <OrderModel>[].obs;
  
}
