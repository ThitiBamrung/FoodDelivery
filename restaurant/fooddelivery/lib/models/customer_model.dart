// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CustomerModel {
  final String cust_id;
  final String cust_firstname;
  final String cust_lastname;
  final String cust_phone;
  final String cust_email;
  final String password;
  final String profile_picture;
  final String address;
  final String lat;
  final String lng;
  final String? wallet;
  final String? payment;
  CustomerModel({
    required this.cust_id,
    required this.cust_firstname,
    required this.cust_lastname,
    required this.cust_phone,
    required this.cust_email,
    required this.password,
    required this.profile_picture,
    required this.address,
    required this.lat,
    required this.lng,
    this.wallet,
    this.payment,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cust_id': cust_id,
      'cust_firstname': cust_firstname,
      'cust_lastname': cust_lastname,
      'cust_phone': cust_phone,
      'cust_email': cust_email,
      'password': password,
      'profile_picture': profile_picture,
      'address': address,
      'lat': lat,
      'lng': lng,
      'wallet': wallet,
      'payment': payment,
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      cust_id: (map['cust_id'] ?? '') as String,
      cust_firstname: (map['cust_firstname'] ?? '') as String,
      cust_lastname: (map['cust_lastname'] ?? '') as String,
      cust_phone: (map['cust_phone'] ?? '') as String,
      cust_email: (map['cust_email'] ?? '') as String,
      password: (map['password'] ?? '') as String,
      profile_picture: (map['profile_picture'] ?? '') as String,
      address: (map['address'] ?? '') as String,
      lat: (map['lat'] ?? '') as String,
      lng: (map['lng'] ?? '') as String,
      wallet: map['wallet'] != null ? map['wallet'] as String : null,
      payment: map['payment'] != null ? map['payment'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerModel.fromJson(String source) => CustomerModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
