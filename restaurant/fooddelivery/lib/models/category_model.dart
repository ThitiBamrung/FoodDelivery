// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CategoryModel {
  final String cate_id;
  final String cate_name;
  final String res_id; 
  CategoryModel({
    required this.cate_id,
    required this.cate_name,
    required this.res_id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cate_id': cate_id,
      'cate_name': cate_name,
      'res_id': res_id,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      cate_id: map['cate_id'] as String,
      cate_name: map['cate_name'] as String,
      res_id: map['res_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) => CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
