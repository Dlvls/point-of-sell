import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final List<OrderItem> items;
  final double totalPrice;
  final String paymentMethod;
  final DateTime orderTime;

  OrderModel({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.paymentMethod,
    required this.orderTime,
  });

  factory OrderModel.fromFirestore(Map<String, dynamic> json, String id) {
    final orderTimeField = json['orderTime'];
    DateTime orderTime;

    if (orderTimeField is Timestamp) {
      orderTime = orderTimeField.toDate();
    } else if (orderTimeField is String) {
      orderTime = DateTime.parse(orderTimeField);
    } else {
      throw Exception("Unexpected format for orderTime field");
    }

    return OrderModel(
      id: json['id'] ?? '',
      items: (json['items'] as List<dynamic>)
          .map((item) => OrderItem.fromFirestore(item))
          .toList(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] ?? '',
      orderTime: orderTime,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'items': items.map((item) => item.toFirestore()).toList(),
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod,
      'orderTime': Timestamp.fromDate(orderTime),
    };
  }

  OrderModel copyWith({
    String? id,
    List<OrderItem>? items,
    double? totalPrice,
    String? paymentMethod,
    DateTime? orderTime,
  }) {
    return OrderModel(
      id: id ?? this.id,
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      orderTime: orderTime ?? this.orderTime,
    );
  }
}

class OrderItem {
  final String productId;
  final String cartId;
  final String productName;
  final int quantity;

  OrderItem({
    required this.productId,
    required this.cartId,
    required this.productName,
    required this.quantity,
  });

  factory OrderItem.fromFirestore(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] ?? '',
      cartId: json['cartId'] ?? '',
      productName: json['productName'] ?? '',
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'productId': productId,
      'cartId': cartId,
      'productName': productName,
      'quantity': quantity,
    };
  }
}
