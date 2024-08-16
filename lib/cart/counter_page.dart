import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point_of_sell/data/bloc/cart/cart_bloc.dart';
import 'package:point_of_sell/data/bloc/cart/cart_event.dart';
import 'package:point_of_sell/data/bloc/cart/cart_state.dart'; // Ensure you import CartState
import 'package:point_of_sell/resources/styles.dart';

import '../../resources/colors.dart';
import '../data/model/cart_model.dart';

class Counter extends StatefulWidget {
  final int initialQuantity;
  final ValueChanged<int> onQuantityChanged;
  final String productId;
  final CartModel cartItem;

  const Counter({
    Key? key,
    required this.initialQuantity,
    required this.onQuantityChanged,
    required this.productId,
    required this.cartItem,
  }) : super(key: key);

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
  }

  Future<void> _confirmDelete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Prevents dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Product'),
          content: Text(
              'Are you sure you want to remove this product from the cart?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                context
                    .read<CartBloc>()
                    .add(RemoveFromCartEvent(widget.cartItem.id));
              },
            ),
          ],
        );
      },
    );
  }

  void _increment() {
    setState(() {
      _quantity++;
      widget.onQuantityChanged(_quantity);
    });

    final updatedCartItem = widget.cartItem.copyWith(quantity: _quantity);
    context.read<CartBloc>().add(UpdateCartItemEvent(updatedCartItem));
  }

  void _decrement() async {
    if (_quantity > 0) {
      setState(() {
        _quantity--;
        widget.onQuantityChanged(_quantity);
      });

      final updatedCartItem = widget.cartItem.copyWith(quantity: _quantity);
      context.read<CartBloc>().add(UpdateCartItemEvent(updatedCartItem));
    }

    if (_quantity == 0) {
      await _confirmDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoadingState) {
          return const Row(
            children: [
              IconButton(
                onPressed: null,
                icon: Icon(Icons.remove, color: primaryColor),
              ),
              SizedBox(width: 8),
              CircularProgressIndicator(),
              SizedBox(width: 8),
              IconButton(
                onPressed: null,
                icon: Icon(Icons.add, color: primaryColor),
              ),
            ],
          );
        }

        return Row(
          children: [
            IconButton(
              onPressed: _decrement,
              icon: const Icon(Icons.remove, color: primaryColor),
            ),
            Text(
              '$_quantity',
              style: Styles.description.copyWith(color: softBlack),
            ),
            IconButton(
              onPressed: _increment,
              icon: const Icon(Icons.add, color: primaryColor),
            ),
          ],
        );
      },
    );
  }
}
