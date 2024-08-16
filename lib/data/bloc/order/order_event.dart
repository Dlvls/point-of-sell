import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sell/data/model/order_model.dart';

@immutable
abstract class OrderEvent extends Equatable {
  const OrderEvent();
}

class LoadOrdersEvent extends OrderEvent {
  const LoadOrdersEvent();

  @override
  List<Object?> get props => [];
}

class AddOrderEvent extends OrderEvent {
  final OrderModel order;

  const AddOrderEvent(this.order);

  @override
  List<Object?> get props => [order];
}

class UpdateOrderEvent extends OrderEvent {
  final OrderModel order;

  const UpdateOrderEvent(this.order);

  @override
  List<Object?> get props => [order];
}

class DeleteOrderEvent extends OrderEvent {
  final String orderId;

  const DeleteOrderEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class FilterOrdersEvent extends OrderEvent {
  final String? product;
  final DateTimeRange? dateRange;
  final double? minPrice;
  final double? maxPrice;

  FilterOrdersEvent({
    this.product,
    this.dateRange,
    this.minPrice,
    this.maxPrice,
  });

  @override
  List<Object?> get props => [product, dateRange, minPrice, maxPrice];
}
