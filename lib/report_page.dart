import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:point_of_sell/data/bloc/order/order_event.dart';
import 'package:point_of_sell/data/model/order_model.dart';
import 'package:point_of_sell/resources/colors.dart';
import 'package:point_of_sell/resources/styles.dart';

import 'data/bloc/order/order_bloc.dart';
import 'data/bloc/order/order_state.dart';
import 'data/services/order_repository.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late OrderBloc _orderBloc;
  List<OrderModel> _orders = [];
  String? _selectedProduct;
  DateTimeRange? _dateRange;
  double? _minPrice = 0;
  double? _maxPrice = 1000;
  final TextEditingController _productController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _orderBloc = OrderBloc(OrderRepository());
    _orderBloc.add(const LoadOrdersEvent());
  }

  @override
  void dispose() {
    _productController.dispose();
    _orderBloc.close();
    super.dispose();
  }

  void _applyFilters() {
    _orderBloc.add(
      FilterOrdersEvent(
        product: _selectedProduct,
        dateRange: _dateRange,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedProduct = null;
      _dateRange = null;
      _minPrice = 0;
      _maxPrice = 1000;
      _productController.clear(); // Clear the text field
    });
    _orderBloc.add(const LoadOrdersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          'Report',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product ID Input
                    TextField(
                      controller: _productController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Enter product ID',
                        hintStyle: Styles.description,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: lightGray,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: lightGray,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _selectedProduct = value.isEmpty ? null : value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // Date Range Picker
                    Text('Date Range', style: Styles.title),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _dateRange == null
                                ? 'Select a date range'
                                : '${_dateRange?.start.toLocal().toString().split(' ')[0]} - ${_dateRange?.end.toLocal().toString().split(' ')[0]}',
                            style: Styles.description,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final pickedDateRange = await showDateRangePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            setState(() {
                              _dateRange = pickedDateRange;
                            });
                          },
                          child: const Text('Select Date Range'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Price Range Slider
                    Text('Price Range', style: Styles.title),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            min: 0,
                            max: 1000,
                            divisions: 100,
                            value: _minPrice!,
                            activeColor: primaryColor,
                            inactiveColor: lightGray,
                            onChanged: (value) {
                              setState(() {
                                _minPrice = value;
                              });
                            },
                            label: _minPrice?.toStringAsFixed(2),
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            min: 0,
                            max: 1000,
                            divisions: 100,
                            value: _maxPrice!,
                            activeColor: primaryColor,
                            inactiveColor: lightGray,
                            onChanged: (value) {
                              setState(() {
                                _maxPrice = value;
                              });
                            },
                            label: _maxPrice?.toStringAsFixed(2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Apply Filters and Clear Filters Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _applyFilters,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: primaryColor,
                              minimumSize: const Size.fromHeight(50),
                            ),
                            child: const Text(
                              'Apply Filters',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _clearFilters,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: primaryColor,
                              backgroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(50),
                              side: const BorderSide(
                                color: primaryColor,
                              ),
                            ),
                            child: const Text(
                              'Clear Filters',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // BlocConsumer to display the filtered orders
              BlocProvider(
                create: (context) => _orderBloc,
                child: BlocConsumer<OrderBloc, OrderState>(
                  listener: (context, state) {
                    if (state is OrderLoadedState) {
                      setState(() {
                        _orders = state.orders;
                      });
                    }
                  },
                  builder: (context, state) {
                    if (state is OrderLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is OrderErrorState) {
                      return Center(child: Text('Error: ${state.error}'));
                    } else if (state is OrderLoadedState) {
                      final orders = state.orders;

                      if (orders.isEmpty) {
                        return const Center(child: Text('No orders found.'));
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return Card(
                            elevation: 0,
                            color: backgroundColor,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Product ID: ${order.items.map((item) => item.productId).join(', ')}',
                                          style: Styles.title.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          order.items
                                              .map((item) => item.productName)
                                              .join(', '),
                                          style: Styles.title.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Quantity: ${order.items.map((item) => item.quantity).join(', ')}',
                                          style: Styles.title,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Total Price: \$${order.totalPrice.toStringAsFixed(2)}',
                                          style: Styles.title,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Payment Method: ${order.paymentMethod}',
                                          style: Styles.title,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Order Time: ${order.orderTime}',
                                          style: Styles.title.copyWith(
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          order.paymentMethod == 'Cash'
                                              ? 'Cash Payment'
                                              : 'Credit Card Payment',
                                          style: Styles.title.copyWith(
                                            fontSize: 12,
                                          ),
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
                    return const Center(child: Text('Something went wrong.'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
