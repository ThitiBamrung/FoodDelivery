// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String res_id;
  final String res_name;
  final String complete_address;
  final String email_address;
  final String owner_name;
  final String company_logo;
  final String res_telephone;
  final String latitude;
  final String longitude;
  final String password;
  final String wallet;
  final String res_status;
  UserModel({
    required this.res_id,
    required this.res_name,
    required this.complete_address,
    required this.email_address,
    required this.owner_name,
    required this.company_logo,
    required this.res_telephone,
    required this.latitude,
    required this.longitude,
    required this.password,
    required this.wallet,
    required this.res_status,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'res_id': res_id,
      'res_name': res_name,
      'complete_address': complete_address,
      'email_address': email_address,
      'owner_name': owner_name,
      'company_logo': company_logo,
      'res_telephone': res_telephone,
      'latitude': latitude,
      'longitude': longitude,
      'password': password,
      'wallet': wallet,
      'res_status': res_status,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      res_id: (map['res_id'] ?? '') as String,
      res_name: (map['res_name'] ?? '') as String,
      complete_address: (map['complete_address'] ?? '') as String,
      email_address: (map['email_address'] ?? '') as String,
      owner_name: (map['owner_name'] ?? '') as String,
      company_logo: (map['company_logo'] ?? '') as String,
      res_telephone: (map['res_telephone'] ?? '') as String,
      latitude: (map['latitude'] ?? '') as String,
      longitude: (map['longitude'] ?? '') as String,
      password: (map['password'] ?? '') as String,
      wallet: (map['wallet'] ?? '') as String,
      res_status: (map['res_status'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
