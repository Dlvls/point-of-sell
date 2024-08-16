import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../model/products_model.dart';

@immutable
abstract class ProductsState extends Equatable {
  const ProductsState();
}

class ProductsLoadingState extends ProductsState {
  const ProductsLoadingState();

  @override
  List<Object?> get props => [];
}

class ProductsLoadedState extends ProductsState {
  final List<ProductsModel> products;

  const ProductsLoadedState(this.products);

  @override
  List<Object?> get props => [products];
}

class ProductsErrorState extends ProductsState {
  final String error;

  const ProductsErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
