import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class OrderModel {
  final String id;
  final String idCustomer;
  final String idShop;
  final String idRidder;
  final String dateTime;
  final String idProducts;
  final String names;
  final String prices;
  final String amounts;
  final String total;
  final String delivery;
  final String approveShop;
  final String approveRider;
  OrderModel({
    required this.id,
    required this.idCustomer,
    required this.idShop,
    required this.idRidder,
    required this.dateTime,
    required this.idProducts,
    required this.names,
    required this.prices,
    required this.amounts,
    required this.total,
    required this.delivery,
    required this.approveShop,
    required this.approveRider,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'idCustomer': idCustomer,
      'idShop': idShop,
      'idRidder': idRidder,
      'dateTime': dateTime,
      'idProducts': idProducts,
      'names': names,
      'prices': prices,
      'amounts': amounts,
      'total': total,
      'delivery': delivery,
      'approveShop': approveShop,
      'approveRider': approveRider,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: (map['id'] ?? '') as String,
      idCustomer: (map['idCustomer'] ?? '') as String,
      idShop: (map['idShop'] ?? '') as String,
      idRidder: (map['idRidder'] ?? '') as String,
      dateTime: (map['dateTime'] ?? '') as String,
      idProducts: (map['idProducts'] ?? '') as String,
      names: (map['names'] ?? '') as String,
      prices: (map['prices'] ?? '') as String,
      amounts: (map['amounts'] ?? '') as String,
      total: (map['total'] ?? '') as String,
      delivery: (map['delivery'] ?? '') as String,
      approveShop: (map['approveShop'] ?? '') as String,
      approveRider: (map['approveRider'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) => OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
