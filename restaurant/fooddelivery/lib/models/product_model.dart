// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProductModel {
  final String food_id;
  final String res_id;
  final String food_name;
  final String food_price;
  final String food_image;
  final String description;
  final String cate_id;
  final String option_id;
  final String food_status;
  ProductModel({
    required this.food_id,
    required this.res_id,
    required this.food_name,
    required this.food_price,
    required this.food_image,
    required this.description,
    required this.cate_id,
    required this.option_id,
    required this.food_status,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'food_id': food_id,
      'res_id': res_id,
      'food_name': food_name,
      'food_price': food_price,
      'food_image': food_image,
      'description': description,
      'cate_id': cate_id,
      'option_id': option_id,
      'food_status': food_status,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      food_id: (map['food_id'] ?? '') as String,
      res_id: (map['res_id'] ?? '') as String,
      food_name: (map['food_name'] ?? '') as String,
      food_price: (map['food_price'] ?? '') as String,
      food_image: (map['food_image'] ?? '') as String,
      description: (map['description'] ?? '') as String,
      cate_id: (map['cate_id'] ?? '') as String,
      option_id: (map['option_id'] ?? '') as String,
      food_status: (map['food_status'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
