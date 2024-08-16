import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:point_of_sell/data/model/products_model.dart';

@immutable
abstract class ProductsEvent extends Equatable {
  const ProductsEvent();
}

class LoadProductsEvent extends ProductsEvent {
  const LoadProductsEvent();

  @override
  List<Object?> get props => [];
}

class AddProductEvent extends ProductsEvent {
  final ProductsModel product;
  final File? imageFile;

  const AddProductEvent(this.product, {this.imageFile});

  @override
  List<Object?> get props => [product, imageFile];
}

class UpdateProductEvent extends ProductsEvent {
  final ProductsModel product;
  final File? imageFile;

  const UpdateProductEvent(this.product, {this.imageFile});

  @override
  List<Object?> get props => [product, imageFile];
}

class DeleteProductEvent extends ProductsEvent {
  final String productId;

  const DeleteProductEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}
