// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:go_router/go_router.dart';
//
// import '../data/bloc/cart/cart_bloc.dart';
// import '../data/bloc/cart/cart_event.dart';
// import '../data/bloc/cart/cart_state.dart';
// import '../data/bloc/products/products_bloc.dart';
// import '../data/bloc/products/products_state.dart';
// import '../data/model/cart_model.dart';
// import '../data/model/products_model.dart';
// import '../resources/colors.dart';
// import '../resources/styles.dart';
// import 'cart/check_box_page.dart';
// import 'cart/counter_page.dart';
//
// class TryPage extends StatefulWidget {
//   final String productId;
//
//   const TryPage({super.key, required this.productId});
//
//   @override
//   _TryPageState createState() => _TryPageState();
// }
//
// class _TryPageState extends State<TryPage> {
//   late String productId;
//   final Map<String, bool> _checkedItems = {};
//   double _totalPrice = 0.0;
//
//   @override
//   void initState() {
//     super.initState();
//     productId = widget.productId;
//     context.read<CartBloc>().add(const LoadCartEvent());
//   }
//
//   void _addToCart(BuildContext context, ProductsModel product) {
//     final cartItem = CartModel(
//       id: '',
//       productId: product.id,
//       name: product.productName,
//       category: product.category,
//       price: product.price,
//       imageUrl: product.imageUrl,
//       quantity: 1,
//     );
//
//     BlocProvider.of<CartBloc>(context).add(AddToCartEvent(cartItem));
//     _showToast('Product added to cart: ${product.productName}');
//   }
//
//   void _showToast(String message) {
//     Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       backgroundColor: Colors.black54,
//       textColor: Colors.white,
//       fontSize: 16.0,
//     );
//   }
//
//   void _updateTotalPrice(double priceChange) {
//     setState(() {
//       _totalPrice += priceChange;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.white,
//         title: Text(
//           'Add Product',
//           style: Styles.appbarText,
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_rounded, color: softBlack),
//           onPressed: () {
//             GoRouter.of(context).pop();
//           },
//         ),
//       ),
//       body: BlocBuilder<ProductsBloc, ProductsState>(
//         builder: (context, productsState) {
//           if (productsState is ProductsLoadingState) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (productsState is ProductsLoadedState) {
//             final products = productsState.products;
//
//             return BlocBuilder<CartBloc, CartState>(
//               builder: (context, cartState) {
//                 if (cartState is CartLoadingState) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (cartState is CartLoadedState) {
//                   final product = products.firstWhere(
//                     (product) => product.id == productId,
//                     orElse: () => ProductsModel(
//                       id: 'N/A',
//                       productName: 'Unknown',
//                       description: 'No description available',
//                       price: 0.0,
//                       stock: 0,
//                       category: 'Uncategorized',
//                       imageUrl: 'https://via.placeholder.com/150',
//                       createdAt: DateTime.now(),
//                       updatedAt: DateTime.now(),
//                       status: 'Unknown',
//                     ),
//                   );
//
//                   final cartItemExists = cartState.cartItems.any(
//                     (cart) => cart.productId == productId,
//                   );
//
//                   if (!cartItemExists) {
//                     _addToCart(context, product);
//                   }
//
//                   return Column(
//                     children: [
//                       Expanded(
//                         child: ListView.builder(
//                           itemCount: cartState.cartItems.length,
//                           itemBuilder: (context, index) {
//                             final cartItem = cartState.cartItems[index];
//                             final product = products.firstWhere(
//                               (product) => product.id == cartItem.productId,
//                               orElse: () => ProductsModel(
//                                 id: 'N/A',
//                                 productName: 'Unknown',
//                                 description: 'No description available',
//                                 price: 0.0,
//                                 stock: 0,
//                                 category: 'Uncategorized',
//                                 imageUrl: 'https://via.placeholder.com/150',
//                                 createdAt: DateTime.now(),
//                                 updatedAt: DateTime.now(),
//                                 status: 'Unknown',
//                               ),
//                             );
//
//                             return ListTile(
//                               title: DefaultTextStyle(
//                                 style: Styles.title.copyWith(color: softBlack),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     CheckboxApp(
//                                       onChanged: (isChecked) {
//                                         setState(() {
//                                           _checkedItems[cartItem.productId] =
//                                               isChecked;
//                                         });
//                                       },
//                                       cartItem: cartItem,
//                                       onTotalPriceChanged: _updateTotalPrice,
//                                     ),
//                                     const SizedBox(width: 8),
//                                     Container(
//                                       width: 100,
//                                       height: 100,
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius:
//                                             BorderRadius.circular(10.0),
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(8),
//                                         child: Image.network(
//                                           product.imageUrl,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(width: 16),
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             product.productName,
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.w600),
//                                           ),
//                                           const SizedBox(height: 8),
//                                           Text(
//                                             product.category,
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.w400),
//                                           ),
//                                           const SizedBox(height: 16),
//                                           Row(
//                                             children: [
//                                               Text(
//                                                 '\$${cartItem.totalPrice.toStringAsFixed(2)}',
//                                                 style: const TextStyle(
//                                                     color: primaryColor,
//                                                     fontWeight:
//                                                         FontWeight.w700),
//                                               ),
//                                               const Spacer(),
//                                               Counter(
//                                                 initialQuantity:
//                                                     cartItem.quantity,
//                                                 onQuantityChanged:
//                                                     (newQuantity) {
//                                                   // Handle quantity change if needed
//                                                 },
//                                                 productId: cartItem.productId,
//                                                 cartItem:
//                                                     cartItem, // Pass the cart item
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               onTap: () {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text(
//                                         'Product clicked: ${product.productName}'),
//                                     duration: const Duration(seconds: 2),
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Total Price',
//                                   style: Styles.title.copyWith(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500,
//                                     color: lightGray,
//                                   ),
//                                 ),
//                                 Text(
//                                   '\$${_totalPrice.toStringAsFixed(2)}',
//                                   style: Styles.title.copyWith(
//                                       color: primaryColor,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               width: 16,
//                             ),
//                             Expanded(
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   // context.push('/checkout', extra: _totalPrice);
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: primaryColor,
//                                   minimumSize: const Size(double.infinity, 45),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                                 child: Text(
//                                   'Checkout',
//                                   style: Styles.title
//                                       .copyWith(color: Colors.white),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   );
//                 } else {
//                   return const Center(child: Text('No cart items found.'));
//                 }
//               },
//             );
//           } else {
//             return const Center(child: Text('No products found.'));
//           }
//         },
//       ),
//     );
//   }
// }
