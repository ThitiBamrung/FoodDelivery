import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class WidrawModel {
  final String widraw_id;
  final String res_id;
  final String widraw_amount;
  final String dateTime;
  WidrawModel({
    required this.widraw_id,
    required this.res_id,
    required this.widraw_amount,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'widraw_id': widraw_id,
      'res_id': res_id,
      'widraw_amount': widraw_amount,
      'dateTime': dateTime,
    };
  }

  factory WidrawModel.fromMap(Map<String, dynamic> map) {
    return WidrawModel(
      widraw_id: (map['widraw_id'] ?? '') as String,
      res_id: (map['res_id'] ?? '') as String,
      widraw_amount: (map['widraw_amount'] ?? '') as String,
      dateTime: (map['dateTime'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory WidrawModel.fromJson(String source) => WidrawModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
