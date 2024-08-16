import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/products_repository.dart';
import 'products_event.dart';
import 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductRepository productsRepository;

  ProductsBloc(this.productsRepository) : super(const ProductsLoadingState()) {
    on<LoadProductsEvent>((event, emit) async {
      emit(const ProductsLoadingState());
      try {
        final products = await productsRepository.getProducts();
        emit(ProductsLoadedState(products));
      } catch (e) {
        emit(ProductsErrorState(e.toString()));
      }
    });

    on<AddProductEvent>((event, emit) async {
      emit(const ProductsLoadingState());
      try {
        await productsRepository.addProduct(event.product, event.imageFile);
        final products = await productsRepository.getProducts();
        emit(ProductsLoadedState(products));
      } catch (e) {
        emit(ProductsErrorState(e.toString()));
      }
    });

    on<DeleteProductEvent>((event, emit) async {
      emit(const ProductsLoadingState());
      try {
        await productsRepository.deleteProduct(event.productId);
        final products = await productsRepository.getProducts();
        emit(ProductsLoadedState(products));
      } catch (e) {
        emit(ProductsErrorState(e.toString()));
      }
    });

    on<UpdateProductEvent>((event, emit) async {
      emit(const ProductsLoadingState());
      try {
        await productsRepository.updateProduct(event.product, event.imageFile);
        final products = await productsRepository.getProducts();
        emit(ProductsLoadedState(products));
      } catch (e) {
        emit(ProductsErrorState(e.toString()));
      }
    });
  }
}

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:point_of_sell/data/bloc/products/products_event.dart';
// import 'package:point_of_sell/data/bloc/products/products_state.dart';
//
// import '../../services/products_repository.dart';
//
// class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
//   final ProductRepository _productRepository;
//
//   ProductsBloc(this._productRepository) : super(const ProductsLoadingState()) {
//     on<LoadProductsEvent>(_onLoadProducts);
//     on<AddProductEvent>(_onAddProduct);
//     on<UpdateProductEvent>(_onUpdateProduct);
//     on<DeleteProductEvent>(_onDeleteProduct);
//   }
//
//   Future<void> _onLoadProducts(
//       LoadProductsEvent event, Emitter<ProductsState> emit) async {
//     emit(const ProductsLoadingState());
//     try {
//       final products = await _productRepository.getProducts();
//       emit(ProductsLoadedState(products));
//     } catch (e) {
//       emit(ProductsErrorState(e.toString()));
//     }
//   }
//
//   Future<void> _onAddProduct(
//       AddProductEvent event, Emitter<ProductsState> emit) async {
//     try {
//       await _productRepository.addProduct(event.product, event.imageFile);
//       final products = await _productRepository.getProducts();
//       emit(ProductsLoadedState(products));
//     } catch (e) {
//       emit(ProductsErrorState(e.toString()));
//     }
//   }
//
//   Future<void> _onUpdateProduct(
//       UpdateProductEvent event, Emitter<ProductsState> emit) async {
//     try {
//       await _productRepository.updateProduct(event.product, event.imageFile);
//       final products = await _productRepository.getProducts();
//       emit(ProductsLoadedState(products));
//     } catch (e) {
//       emit(ProductsErrorState(e.toString()));
//     }
//   }
//
//   Future<void> _onDeleteProduct(
//       DeleteProductEvent event, Emitter<ProductsState> emit) async {
//     try {
//       await _productRepository.deleteProduct(event.productId);
//       final products = await _productRepository.getProducts();
//       emit(ProductsLoadedState(products));
//     } catch (e) {
//       emit(ProductsErrorState(e.toString()));
//     }
//   }
// }
