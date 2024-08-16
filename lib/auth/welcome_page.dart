import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:point_of_sell/resources/colors.dart';
import 'package:point_of_sell/resources/styles.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  right: 16, left: 16, top: 64, bottom: 16),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/img_welcome.png',
                            width: 200,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            "Welcome to Point of Sell",
                            style: Styles.appbarText.copyWith(color: softBlack),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "We're excited to have you with us! Please explore the app and take advantage of all the available features.",
                            style: Styles.description,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Bottom buttons
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.go('/login');
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: primaryColor, // Text color
                        minimumSize: const Size(double.infinity, 45),
                        elevation: 0,
                      ),
                      child: Text(
                        "Login",
                        style: Styles.buttonText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // Your onPressed logic here
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryColor,
                        backgroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 45),
                        side: const BorderSide(color: primaryColor, width: 2),
                        elevation: 0,
                      ),
                      child: Text(
                        "Register",
                        style: Styles.buttonText.copyWith(color: primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Positioned logo
            Positioned(
              top: 16,
              left: 16,
              child: Image.asset(
                'assets/images/logo.png',
                width: 150,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
