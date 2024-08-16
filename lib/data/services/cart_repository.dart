import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/cart_model.dart';

class CartRepository {
  final FirebaseFirestore _firestore;

  CartRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<CartModel>> getCartItems() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('carts').get();
      return snapshot.docs
          .map((doc) => CartModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to load cart items: $e');
    }
  }

  Future<void> addCartItem(CartModel cartItem) async {
    try {
      await _firestore.collection('carts').add(cartItem.toFirestore());
    } catch (e) {
      throw Exception('Failed to add cart item: $e');
    }
  }

  Future<void> updateCartItem(CartModel cartItem) async {
    try {
      await _firestore
          .collection('carts')
          .doc(cartItem.id)
          .update(cartItem.toFirestore());
    } catch (e) {
      throw Exception('Failed to update cart item: $e');
    }
  }

  Future<void> removeCartItem(String cartItemId) async {
    try {
      await _firestore.collection('carts').doc(cartItemId).delete();
    } catch (e) {
      throw Exception('Failed to remove cart item: $e');
    }
  }

  Future<void> clearCart() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('carts').get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }
}
