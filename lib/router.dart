import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:point_of_sell/add_product_page.dart';
import 'package:point_of_sell/auth/login_page.dart';
import 'package:point_of_sell/auth/register_page.dart';
import 'package:point_of_sell/auth/welcome_page.dart';
import 'package:point_of_sell/cart/check_out_page.dart';
import 'package:point_of_sell/cart/confirm_page.dart';
import 'package:point_of_sell/report_page.dart';
import 'package:point_of_sell/resources/update_product_page.dart';
import 'package:point_of_sell/status_page.dart';

import 'cart/cart_page.dart';
import 'detail_page.dart';
import 'home_page.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/welcome_page',
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/add_product',
        builder: (context, state) => const AddProductPage(),
      ),
      GoRoute(
        path: '/detail/:productId',
        builder: (context, state) {
          final String? productId = state.pathParameters['productId'];
          return DetailPage(productId: productId);
        },
      ),
      GoRoute(
        path: '/update_product/:productId',
        builder: (context, state) {
          final String productId = state.pathParameters['productId']!;
          return UpdateProductPage(productId: productId);
        },
      ),
      GoRoute(
        path: '/cart/:productId',
        builder: (context, state) {
          final String productId = state.pathParameters['productId']!;
          return CartPage(productId: productId);
        },
      ),
      GoRoute(
        path: '/check_out',
        pageBuilder: (context, state) {
          // Cast `state.extra` to a `Map<String, dynamic>` to extract both `checkedCartIds` and `totalPrice`.
          final extraData = state.extra as Map<String, dynamic>? ?? {};

          return MaterialPage(
            child: CheckOutPage(
              extraData: extraData,
            ),
          );
        },
      ),
      GoRoute(
        path: '/confirm',
        builder: (context, state) => ConfirmPage(),
      ),
      GoRoute(
        path: '/status',
        builder: (context, state) => StatusPage(),
      ),
      GoRoute(
        path: '/report',
        builder: (context, state) => ReportPage(),
      ),
    ],
  );
}
