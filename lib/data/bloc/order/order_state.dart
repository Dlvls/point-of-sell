import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../model/order_model.dart';

@immutable
abstract class OrderState extends Equatable {
  const OrderState();
}

class OrderLoadingState extends OrderState {
  const OrderLoadingState();

  @override
  List<Object?> get props => [];
}

class OrderLoadedState extends OrderState {
  final List<OrderModel> orders;

  const OrderLoadedState(this.orders);

  @override
  List<Object?> get props => [orders];
}

class OrderErrorState extends OrderState {
  final String error;

  const OrderErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
