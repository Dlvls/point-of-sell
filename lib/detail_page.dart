import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../data/bloc/products/products_bloc.dart';
import '../../data/bloc/products/products_state.dart';
import '../../data/model/products_model.dart';
import '../../resources/colors.dart';
import '../../resources/styles.dart';

class DetailPage extends StatelessWidget {
  final String? productId;

  const DetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoadingState) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is ProductsErrorState) {
          return Scaffold(
            body: Center(child: Text('Error: ${state.error}')),
          );
        }

        final product = state is ProductsLoadedState
            ? state.products.firstWhere(
                (prod) => prod.id == productId,
                orElse: () => _createEmptyProduct(),
              )
            : _createEmptyProduct();

        // Check if the stock is low
        if (product.stock < 10) {
          _showLowStockAlert(context);
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: Text(
              'Home',
              style: Styles.appbarText,
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, color: softBlack),
              onPressed: () {
                context.pop();
              },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_bag_rounded,
                        color: lightGray,
                        size: 20.0,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    const CircleAvatar(
                      radius: 17.0,
                      backgroundImage: AssetImage(
                        'assets/images/profile_image.jpg',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 250.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Image.network(
                    product.imageUrl.isNotEmpty
                        ? product.imageUrl
                        : 'https://via.placeholder.com/150', // Placeholder image URL
                    width: double.infinity,
                    height: 200.0,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 32),
                Text(product.productName, style: Styles.appbarText),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Row(
                    children: [
                      Text(
                        product.category,
                        style: Styles.title,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        '|',
                        style: Styles.title,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        'Stock: ${product.stock}',
                        style: Styles.title,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  product.description,
                  style: Styles.title
                      .copyWith(fontWeight: FontWeight.w500, color: lightGray),
                ),
                const SizedBox(height: 32),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: Styles.appbarText.copyWith(
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to checkout
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          minimumSize: const Size(double.infinity, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Buy',
                          style: Styles.title.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
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

  void _showLowStockAlert(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Low Stock Alert',
              style: Styles.title.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            content: Text(
              'The stock for this product is low. Please consider restocking.',
              style: Styles.title,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: Text(
                  'OK',
                  style: Styles.title.copyWith(color: primaryColor),
                ),
              ),
            ],
          );
        },
      );
    });
  }
}
