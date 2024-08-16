import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../model/cart_model.dart';

@immutable
abstract class CartState extends Equatable {
  const CartState();
}

class CartLoadingState extends CartState {
  const CartLoadingState();

  @override
  List<Object?> get props => [];
}

class CartLoadedState extends CartState {
  final List<CartModel> cartItems;

  const CartLoadedState(this.cartItems);

  @override
  List<Object?> get props => [cartItems];
}

class CartErrorState extends CartState {
  final String error;

  const CartErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class CartEmptyState extends CartState {
  const CartEmptyState();

  @override
  List<Object?> get props => [];
}

class CartUpdatedState extends CartState {
  final CartModel updatedCartItem;

  const CartUpdatedState(this.updatedCartItem);

  @override
  List<Object?> get props => [updatedCartItem];
}
