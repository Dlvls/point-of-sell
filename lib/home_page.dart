import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:point_of_sell/data/bloc/products/products_bloc.dart';
import 'package:point_of_sell/data/bloc/products/products_event.dart';
import 'package:point_of_sell/data/bloc/products/products_state.dart';
import 'package:point_of_sell/resources/colors.dart';
import 'package:point_of_sell/resources/styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductsBloc>(context).add(const LoadProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        surfaceTintColor: backgroundColor,
        title: Text(
          'Home',
          style: Styles.appbarText,
        ),
        centerTitle: true,
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
                PopupMenuButton<String>(
                  color: Colors.white,
                  icon: const CircleAvatar(
                    radius: 17.0,
                    backgroundImage: AssetImage(
                      'assets/images/profile_image.jpg',
                    ),
                  ),
                  onSelected: (String value) {
                    switch (value) {
                      case 'Profile':
                        context.push('/profile');
                        break;
                      case 'Add Product':
                        context.push('/add_product');
                        break;
                      case 'Report':
                        context.push('/report');
                        break;
                      case 'Status':
                        context.push('/status');
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem<String>(
                        value: 'Profile',
                        child: Text(
                          'Profile',
                          style: Styles.title,
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'Add Product',
                        child: Text(
                          'Add Product',
                          style: Styles.title,
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'Report',
                        child: Text(
                          'Report',
                          style: Styles.title,
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'Status',
                        child: Text(
                          'Status',
                          style: Styles.title,
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: Styles.title.copyWith(color: lightGray),
                            border: InputBorder.none,
                            suffixIcon: const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.search,
                                color: lightGray,
                                size: 20.0,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                            ),
                          ),
                          style: const TextStyle(color: backgroundColor),
                          onChanged: (value) {
                            // Perform search here
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Container(
                      width: 50,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.compare_arrows_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // New Arrival Banner
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF2C3E50).withOpacity(0.6),
                      primaryColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "New Arrival",
                          style: Styles.title.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          "Product Name",
                          style: Styles.description.copyWith(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Image.asset(
                      "assets/images/product_example.png",
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 16),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       "All",
              //       style: Styles.title.copyWith(
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //     Container(
              //       height: 35,
              //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(10.0),
              //       ),
              //       child: DropdownButtonHideUnderline(
              //         child: DropdownButton<String>(
              //           dropdownColor: Colors.white,
              //           borderRadius: BorderRadius.circular(10),
              //           value: "All",
              //           icon: const Icon(
              //             Icons.keyboard_arrow_down_rounded,
              //             color: lightGray,
              //             size: 16.0,
              //           ),
              //           elevation: 0,
              //           style: Styles.description.copyWith(color: lightGray),
              //           onChanged: (String? newValue) {},
              //           items: <String>[
              //             "All",
              //             "Option 1",
              //             "Option 2",
              //             "Option 3"
              //           ].map<DropdownMenuItem<String>>((String value) {
              //             return DropdownMenuItem<String>(
              //               value: value,
              //               child: Text(value),
              //             );
              //           }).toList(),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 16),
              BlocBuilder<ProductsBloc, ProductsState>(
                builder: (context, state) {
                  if (state is ProductsLoadingState) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: primaryColor,
                    ));
                  }
                  if (state is ProductsErrorState) {
                    return Center(child: Text('Error: ${state.error}'));
                  }
                  if (state is ProductsLoadedState) {
                    final products = state.products;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 3 / 4,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        final productName = product.productName;
                        final price = product.price.toString();
                        final imageUrl = product.imageUrl;

                        return GestureDetector(
                          onTap: () {
                            context.push('/detail/${product.id}');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: imageUrl.isNotEmpty
                                            ? Image.network(imageUrl,
                                                fit: BoxFit.cover)
                                            : const Icon(Icons.image, size: 50),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                productName,
                                                style: Styles.title.copyWith(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                '\$$price',
                                                style: Styles.description
                                                    .copyWith(color: softBlack),
                                              ),
                                            ],
                                          ),
                                          FloatingActionButton(
                                            heroTag: null,
                                            onPressed: () {
                                              context
                                                  .push('/cart/${product.id}');
                                            },
                                            backgroundColor: primaryColor,
                                            mini: true,
                                            child: const Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                  ],
                                ),
                                Positioned(
                                  right: 8.0,
                                  top: 8.0,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () {
                                          context.push(
                                              '/update_product/${product.id}');
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: primaryColor),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                backgroundColor: Colors.white,
                                                title: Text(
                                                  'Confirm Deletion',
                                                  style: Styles.title.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                content: Text(
                                                  'Are you sure you want to delete this product?',
                                                  style: Styles.title,
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // Close the dialog
                                                    },
                                                    child: Text(
                                                      'Cancel',
                                                      style:
                                                          Styles.title.copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      BlocProvider.of<
                                                                  ProductsBloc>(
                                                              context)
                                                          .add(
                                                              DeleteProductEvent(
                                                                  product.id));
                                                      context.pop();
                                                    },
                                                    child: Text(
                                                      'Delete',
                                                      style: Styles.title
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  primaryColor),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return const Center(child: Text('No products available'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
