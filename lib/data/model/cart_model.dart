class CartModel {
  final String id;
  final String productId;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  int quantity;
  double totalPrice;

  CartModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  }) : totalPrice = price * quantity;

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'category': category,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }

  static CartModel fromFirestore(Map<String, dynamic> data, String id) {
    return CartModel(
      id: id,
      productId: data['productId'],
      name: data['name'],
      category: data['category'],
      price: data['price'],
      imageUrl: data['imageUrl'],
      quantity: data['quantity'],
    );
  }

  CartModel copyWith({
    String? id,
    String? productId,
    String? name,
    String? category,
    double? price,
    String? imageUrl,
    int? quantity,
    double? totalPrice,
  }) {
    return CartModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
    );
  }

  void incrementQuantity() {
    quantity += 1;
    totalPrice = price * quantity;
  }

  void decrementQuantity() {
    if (quantity > 1) {
      quantity -= 1;
      totalPrice = price * quantity;
    }
  }
}
