import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point_of_sell/data/bloc/cart/cart_event.dart';
import 'package:point_of_sell/data/bloc/cart/cart_state.dart';

import '../../services/cart_repository.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;

  CartBloc(this._cartRepository) : super(const CartLoadingState()) {
    on<LoadCartEvent>((event, emit) async {
      emit(const CartLoadingState());
      try {
        final cartItems = await _cartRepository.getCartItems();
        if (cartItems.isEmpty) {
          emit(const CartEmptyState());
        } else {
          emit(CartLoadedState(cartItems));
        }
      } catch (e) {
        emit(CartErrorState(e.toString()));
      }
    });

    on<AddToCartEvent>((event, emit) async {
      emit(const CartLoadingState());
      try {
        await _cartRepository.addCartItem(event.cartItem);
        final cartItems = await _cartRepository.getCartItems();
        emit(CartLoadedState(cartItems));
      } catch (e) {
        emit(CartErrorState(e.toString()));
      }
    });

    on<UpdateCartItemEvent>((event, emit) async {
      emit(const CartLoadingState());
      try {
        await _cartRepository.updateCartItem(event.cartItem);
        final cartItems = await _cartRepository.getCartItems();
        emit(CartLoadedState(cartItems));
      } catch (e) {
        emit(CartErrorState(e.toString()));
      }
    });

    on<RemoveFromCartEvent>((event, emit) async {
      emit(const CartLoadingState());
      try {
        await _cartRepository.removeCartItem(event.cartItemId);
        final cartItems = await _cartRepository.getCartItems();
        if (cartItems.isEmpty) {
          emit(const CartEmptyState());
        } else {
          emit(CartLoadedState(cartItems));
        }
      } catch (e) {
        emit(CartErrorState(e.toString()));
      }
    });
  }
}

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:point_of_sell/data/bloc/cart/cart_event.dart';
// import 'package:point_of_sell/data/bloc/cart/cart_state.dart';
//
// import '../../services/cart_repository.dart';
//
// class CartBloc extends Bloc<CartEvent, CartState> {
//   final CartRepository _cartRepository;
//
//   CartBloc(this._cartRepository) : super(const CartLoadingState()) {
//     on<LoadCartEvent>(_onLoadCart);
//     on<AddToCartEvent>(_onAddToCart);
//     on<UpdateCartItemEvent>(_onUpdateCartItem);
//     on<RemoveFromCartEvent>(_onRemoveFromCart);
//   }
//
//   Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
//     emit(const CartLoadingState());
//     try {
//       final cartItems = await _cartRepository.getCartItems();
//       if (cartItems.isEmpty) {
//         emit(const CartEmptyState());
//       } else {
//         emit(CartLoadedState(cartItems));
//       }
//     } catch (e) {
//       emit(CartErrorState(e.toString()));
//     }
//   }
//
//   Future<void> _onAddToCart(
//       AddToCartEvent event, Emitter<CartState> emit) async {
//     try {
//       await _cartRepository.addCartItem(event.cartItem);
//       final cartItems = await _cartRepository.getCartItems();
//       emit(CartLoadedState(cartItems));
//     } catch (e) {
//       emit(CartErrorState(e.toString()));
//     }
//   }
//
//   Future<void> _onUpdateCartItem(
//       UpdateCartItemEvent event, Emitter<CartState> emit) async {
//     try {
//       await _cartRepository.updateCartItem(event.cartItem);
//       final cartItems = await _cartRepository.getCartItems();
//       emit(CartLoadedState(cartItems)); // Emit updated cart items
//     } catch (e) {
//       emit(CartErrorState(e.toString()));
//     }
//   }
//
//   Future<void> _onRemoveFromCart(
//       RemoveFromCartEvent event, Emitter<CartState> emit) async {
//     try {
//       await _cartRepository.removeCartItem(event.cartItemId);
//       final cartItems = await _cartRepository.getCartItems();
//       if (cartItems.isEmpty) {
//         emit(const CartEmptyState());
//       } else {
//         emit(CartLoadedState(cartItems));
//       }
//     } catch (e) {
//       emit(CartErrorState(e.toString()));
//     }
//   }
// }
