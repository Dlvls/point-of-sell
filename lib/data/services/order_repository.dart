import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/order_model.dart';

class OrderRepository {
  final FirebaseFirestore _firestore;

  OrderRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<OrderModel>> getOrders() async {
    try {
      print('Fetching orders from Firestore...');
      QuerySnapshot snapshot = await _firestore.collection('orders').get();
      print('Orders fetched: ${snapshot.docs.length}');
      return snapshot.docs
          .map((doc) => OrderModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Failed to load orders: $e');
      throw Exception('Failed to load orders: $e');
    }
  }

  Future<void> addOrder(OrderModel order) async {
    try {
      // Add the order without an ID, letting Firestore generate one
      DocumentReference docRef =
          await _firestore.collection('orders').add(order.toFirestore());

      // Once the document is created, retrieve the generated ID
      String generatedId = docRef.id;

      // Update the order document with the generated ID
      await _firestore
          .collection('orders')
          .doc(generatedId)
          .update({'id': generatedId});
    } catch (e) {
      throw Exception('Failed to add order: $e');
    }
  }

  Future<void> updateOrder(OrderModel order) async {
    try {
      // Ensure the document ID matches the order ID
      await _firestore
          .collection('orders')
          .doc(order.id)
          .update(order.toFirestore());
    } catch (e) {
      throw Exception('Failed to update order: $e');
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).delete();
    } catch (e) {
      throw Exception('Failed to delete order: $e');
    }
  }
}
