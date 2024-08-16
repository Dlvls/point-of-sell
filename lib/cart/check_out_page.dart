import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:point_of_sell/data/bloc/cart/cart_bloc.dart';
import 'package:point_of_sell/data/bloc/cart/cart_state.dart';
import 'package:point_of_sell/data/bloc/order/order_bloc.dart';
import 'package:point_of_sell/data/bloc/order/order_event.dart';
import 'package:point_of_sell/data/bloc/order/order_state.dart';
import 'package:point_of_sell/data/bloc/products/products_bloc.dart';
import 'package:point_of_sell/data/bloc/products/products_state.dart';
import 'package:point_of_sell/data/model/order_model.dart';
import 'package:point_of_sell/data/model/products_model.dart';

import '../resources/colors.dart';
import '../resources/styles.dart';

class ProductDetails {
  final String productId;
  final String cartId;
  final String productName;
  final int quantity;

  ProductDetails({
    required this.productId,
    required this.cartId,
    required this.productName,
    required this.quantity,
  });
}

class CheckOutPage extends StatefulWidget {
  final Map<String, dynamic> extraData;

  const CheckOutPage({super.key, required this.extraData});

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  String? paymentMethod;
  late final List<String> checkedCartIds;
  late final double totalPrice;
  List<ProductDetails> matchedProductDetails = [];

  @override
  void initState() {
    super.initState();
    checkedCartIds = widget.extraData['checkedCartIds'] as List<String>;
    totalPrice = widget.extraData['totalPrice'] as double;
    _fetchData();
  }

  void _fetchData() {
    final cartBloc = context.read<CartBloc>();
    final productsBloc = context.read<ProductsBloc>();

    if (cartBloc.state is CartLoadedState &&
        productsBloc.state is ProductsLoadedState) {
      final cartState = cartBloc.state as CartLoadedState;
      final productsState = productsBloc.state as ProductsLoadedState;

      for (var cartItem in cartState.cartItems) {
        if (checkedCartIds.contains(cartItem.id)) {
          final product = productsState.products.firstWhere(
            (product) => product.id == cartItem.productId,
            orElse: () => _createEmptyProduct(),
          );

          setState(() {
            matchedProductDetails.add(ProductDetails(
              productId: product.id,
              cartId: cartItem.id,
              productName: product.productName,
              quantity: cartItem.quantity,
            ));
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          'Checkout',
          style: Styles.appbarText,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: softBlack),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<CartBloc, CartState>(
              listener: (context, cartState) {
                if (cartState is CartLoadedState) {
                  _fetchData();
                }
              },
            ),
            BlocListener<ProductsBloc, ProductsState>(
              listener: (context, productsState) {
                if (productsState is ProductsLoadedState) {
                  _fetchData();
                }
              },
            ),
            BlocListener<OrderBloc, OrderState>(
              listener: (context, orderState) {
                if (orderState is OrderLoadedState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order placed successfully!'),
                    ),
                  );
                  context.go('/confirm');
                } else if (orderState is OrderErrorState) {
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Failed to place order: ${orderState.error}'),
                    ),
                  );
                }
              },
            ),
          ],
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Payment Method Selection
                Text(
                  'E-Wallet',
                  style: Styles.title.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _buildPaymentOption(
                  imageProvider: const AssetImage('assets/images/dana.png'),
                  text: 'Dana',
                  value: 'DANA',
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Divider(color: lightGray),
                ),
                _buildPaymentOption(
                  imageProvider: const AssetImage('assets/images/gopay.png'),
                  text: 'Gopay',
                  value: 'GOPAY',
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Divider(color: lightGray),
                ),
                _buildPaymentOption(
                  imageProvider: const AssetImage('assets/images/ovo.jpg'),
                  text: 'OVO',
                  value: 'OVO',
                ),
                const SizedBox(height: 32),
                Text(
                  'M-Banking',
                  style: Styles.title.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _buildPaymentOption(
                  imageProvider: const AssetImage('assets/images/bca.png'),
                  text: 'Bank Central Asia (BCA)',
                  value: 'BCA',
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Divider(color: lightGray),
                ),
                _buildPaymentOption(
                  imageProvider: const AssetImage('assets/images/bni.png'),
                  text: 'Bank Negara Indonesia (BNI)',
                  value: 'BNI',
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Divider(color: lightGray),
                ),
                _buildPaymentOption(
                  imageProvider: const AssetImage('assets/images/bri.png'),
                  text: 'Bank Republik Indonesia (BRI)',
                  value: 'BRI',
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (matchedProductDetails.isNotEmpty &&
                              paymentMethod != null) {
                            print('Selected Payment Method: $paymentMethod');
                            final orderItems =
                                matchedProductDetails.map((details) {
                              return OrderItem(
                                productId: details.productId,
                                cartId: details.cartId,
                                productName: details.productName,
                                quantity: details.quantity,
                              );
                            }).toList();

                            final orderModel = OrderModel(
                              id: '',
                              items: orderItems,
                              totalPrice: totalPrice,
                              paymentMethod: paymentMethod!,
                              orderTime: DateTime.now(),
                            );

                            context
                                .read<OrderBloc>()
                                .add(AddOrderEvent(orderModel));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please select a payment method and ensure product details are available'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          minimumSize: const Size(double.infinity, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Order',
                          style: Styles.title.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ProductsModel _createEmptyProduct() {
    return ProductsModel(
      id: '',
      productName: 'No Name',
      description: 'No Description',
      price: 0.0,
      stock: 0,
      category: 'Unknown',
      imageUrl: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: 'unknown',
    );
  }

  Widget _buildPaymentOption({
    IconData? icon,
    ImageProvider? imageProvider,
    required String text,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          imageProvider != null
              ? Image(
                  image: imageProvider,
                  height: 24,
                  width: 24,
                )
              : Icon(
                  icon,
                  size: 24,
                ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: Styles.title.copyWith(fontSize: 14),
            ),
          ),
          Radio<String>(
            value: value,
            groupValue: paymentMethod,
            onChanged: (value) {
              setState(() {
                paymentMethod = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
