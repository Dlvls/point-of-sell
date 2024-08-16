import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:point_of_sell/data/bloc/order/order_event.dart';
import 'package:point_of_sell/data/model/order_model.dart';
import 'package:point_of_sell/resources/colors.dart';
import 'package:point_of_sell/resources/styles.dart';
import 'package:printing/printing.dart';

import 'data/bloc/order/order_bloc.dart';
import 'data/bloc/order/order_state.dart';
import 'data/services/order_repository.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  late OrderBloc _orderBloc;
  List<OrderModel> _orders = [];

  @override
  void initState() {
    super.initState();
    _orderBloc = OrderBloc(OrderRepository());
    _orderBloc.add(LoadOrdersEvent());
  }

  @override
  void dispose() {
    _orderBloc.close();
    super.dispose();
  }

  Future<void> _createPDF(List<OrderModel> orders) async {
    if (orders.isEmpty) {
      print('No orders found.');
      return; // Added return to avoid unnecessary processing
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return pw.Container(
                padding: const pw.EdgeInsets.all(10),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Products: ${order.items.map((item) => item.productName).join(', ')}',
                      style: pw.TextStyle(fontSize: 16),
                    ),
                    pw.Text(
                      'Quantity: ${order.items.map((item) => item.quantity).join(', ')}',
                      style: pw.TextStyle(fontSize: 14),
                    ),
                    pw.Text(
                      'Total Price: \$${order.totalPrice.toStringAsFixed(2)}',
                      style: pw.TextStyle(fontSize: 14),
                    ),
                    pw.Text(
                      'Payment Method: ${order.paymentMethod}',
                      style: pw.TextStyle(fontSize: 14),
                    ),
                    pw.Text(
                      'Order Time: ${order.orderTime}',
                      style: pw.TextStyle(fontSize: 14),
                    ),
                    pw.Text(
                      order.paymentMethod != null &&
                              order.paymentMethod.isNotEmpty
                          ? 'Purchase Status: Delivered'
                          : 'Purchase Status: Canceled',
                      style: pw.TextStyle(
                        fontSize: 14,
                        color: order.paymentMethod != null &&
                                order.paymentMethod.isNotEmpty
                            ? PdfColor.fromHex('#008000') // Green
                            : PdfColor.fromHex('#FF0000'), // Red
                      ),
                    ),
                    pw.Divider(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          'Delivered Status',
          style: Styles.appbarText,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: softBlack),
          onPressed: () {
            context.push('home');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocProvider(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order.items
                                        .map((item) => item.productName)
                                        .join(', '),
                                    style: Styles.title.copyWith(
                                      fontSize: 16,
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
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Order Time: ${order.orderTime}',
                                    style: Styles.title.copyWith(
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    order.paymentMethod != null &&
                                            order.paymentMethod.isNotEmpty
                                        ? 'Purchase Status: Delivered'
                                        : 'Purchase Status: Canceled',
                                    style: Styles.title.copyWith(
                                      color: order.paymentMethod != null &&
                                              order.paymentMethod.isNotEmpty
                                          ? Colors.green
                                          : Colors.red,
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
              return Container(); // Shouldn't reach here.
            },
          ),
        ),
      ),
      floatingActionButton: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          final bool hasOrders = _orders.isNotEmpty;

          return FloatingActionButton(
            onPressed: hasOrders
                ? () {
                    _createPDF(_orders);
                  }
                : null,
            backgroundColor: hasOrders ? primaryColor : Colors.grey,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.picture_as_pdf_rounded,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
