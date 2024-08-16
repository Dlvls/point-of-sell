import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point_of_sell/data/bloc/cart/cart_bloc.dart';
import 'package:point_of_sell/data/bloc/cart/cart_event.dart';
import 'package:point_of_sell/data/services/cart_repository.dart';
import 'package:point_of_sell/data/services/order_repository.dart';
import 'package:point_of_sell/data/services/products_repository.dart';
import 'package:point_of_sell/router.dart';

import 'data/bloc/auth/auth_bloc.dart';
import 'data/bloc/order/order_bloc.dart';
import 'data/bloc/products/products_bloc.dart';
import 'data/bloc/products/products_event.dart';
import 'firebase_options.dart';
import 'notification/notification_helper.dart';
import 'notification/push_notification_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationHelper.initLocalNotification();
  await PushNotificationHelper().initLocalNotifications();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => ProductRepository(),
        ),
        RepositoryProvider(
          create: (context) => CartRepository(),
        ),
        RepositoryProvider(
          create: (context) => OrderRepository(), // Add the OrderRepository
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(),
          ),
          BlocProvider(
            create: (context) {
              final productsBloc = ProductsBloc(
                RepositoryProvider.of<ProductRepository>(context),
              );
              productsBloc.add(const LoadProductsEvent());
              return productsBloc;
            },
          ),
          BlocProvider<CartBloc>(
            create: (context) =>
                CartBloc(RepositoryProvider.of<CartRepository>(context))
                  ..add(const LoadCartEvent()),
          ),
          BlocProvider<OrderBloc>(
            create: (context) => OrderBloc(
              RepositoryProvider.of<OrderRepository>(context),
            ), // Add the OrderBloc
          ),
        ],
        child: MaterialApp.router(
          routerConfig: createRouter(),
        ),
      ),
    );
  }
}
