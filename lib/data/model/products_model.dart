import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsModel {
  final String id;
  final String productName;
  final String description;
  final double price;
  final int stock;
  final String category;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status;

  ProductsModel({
    required this.id,
    required this.productName,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  factory ProductsModel.fromFirestore(Map<String, dynamic> json, String id) {
    return ProductsModel(
      id: id,
      productName: json['productName'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] ?? 0,
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      status: json['status'] ?? 'available',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'productName': productName,
      'description': description,
      'price': price,
      'stock': stock,
      'category': category,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'status': status,
    };
  }

  ProductsModel copyWith({
    String? id,
    String? productName,
    String? description,
    double? price,
    int? stock,
    String? category,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? status,
  }) {
    return ProductsModel(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
    );
  }
}
