// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String driver_id;
  final String driver_firstname;
  final String driver_lastname;
  final String address;
  final String driver_telephone;
  final String email_address;
  final String profile_image;
  final String latitude;
  final String longitude;
  final String password;
  final String wallet;
  final String open_close;
  final String driver_status;
  UserModel({
    required this.driver_id,
    required this.driver_firstname,
    required this.driver_lastname,
    required this.address,
    required this.driver_telephone,
    required this.email_address,
    required this.profile_image,
    required this.latitude,
    required this.longitude,
    required this.password,
    required this.wallet,
    required this.open_close,
    required this.driver_status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'driver_id': driver_id,
      'driver_firstname': driver_firstname,
      'driver_lastname': driver_lastname,
      'address': address,
      'driver_telephone': driver_telephone,
      'email_address': email_address,
      'profile_image': profile_image,
      'latitude': latitude,
      'longitude': longitude,
      'password': password,
      'wallet': wallet,
      'open_close': open_close,
      'driver_status': driver_status,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      driver_id: (map['driver_id'] ?? '') as String,
      driver_firstname: (map['driver_firstname'] ?? '') as String,
      driver_lastname: (map['driver_lastname'] ?? '') as String,
      address: (map['address'] ?? '') as String,
      driver_telephone: (map['driver_telephone'] ?? '') as String,
      email_address: (map['email_address'] ?? '') as String,
      profile_image: (map['profile_image'] ?? '') as String,
      latitude: (map['latitude'] ?? '') as String,
      longitude: (map['longitude'] ?? '') as String,
      password: (map['password'] ?? '') as String,
      wallet: (map['wallet'] ?? '') as String,
      open_close: (map['open_close'] ?? '') as String,
      driver_status: (map['driver_status'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
