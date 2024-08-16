import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:point_of_sell/data/model/cart_model.dart';

@immutable
abstract class CartEvent extends Equatable {
  const CartEvent();
}

class LoadCartEvent extends CartEvent {
  const LoadCartEvent();

  @override
  List<Object?> get props => [];
}

class AddToCartEvent extends CartEvent {
  final CartModel cartItem;

  const AddToCartEvent(this.cartItem);

  @override
  List<Object?> get props => [cartItem];
}

class UpdateCartItemEvent extends CartEvent {
  final CartModel cartItem;

  const UpdateCartItemEvent(this.cartItem);

  @override
  List<Object?> get props => [cartItem];
}

class RemoveFromCartEvent extends CartEvent {
  final String cartItemId;

  const RemoveFromCartEvent(this.cartItemId);

  @override
  List<Object?> get props => [cartItemId];
}
