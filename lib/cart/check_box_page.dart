import 'package:flutter/material.dart';
import 'package:point_of_sell/resources/colors.dart';

import '../data/model/cart_model.dart'; // Ensure you import the CartModel

class CheckboxApp extends StatefulWidget {
  final Function(bool, String)
      onChanged; // Pass cart ID along with checked state
  final CartModel cartItem;
  final ValueChanged<double> onTotalPriceChanged;

  const CheckboxApp({
    super.key,
    required this.onChanged,
    required this.cartItem,
    required this.onTotalPriceChanged,
  });

  @override
  _CheckboxAppState createState() => _CheckboxAppState();
}

class _CheckboxAppState extends State<CheckboxApp> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: isChecked,
      onChanged: (value) {
        setState(() {
          isChecked = value ?? false;
          widget.onChanged(isChecked, widget.cartItem.id); // Notify CartPage

          // Update total price
          if (isChecked) {
            widget.onTotalPriceChanged(widget.cartItem.totalPrice);
          } else {
            widget.onTotalPriceChanged(-widget.cartItem.totalPrice);
          }
        });
      },
      activeColor: primaryColor,
    );
  }
}
