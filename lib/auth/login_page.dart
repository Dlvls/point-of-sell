import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:point_of_sell/data/bloc/auth/auth_bloc.dart';
import 'package:point_of_sell/resources/colors.dart';
import 'package:point_of_sell/resources/styles.dart';

import '../data/bloc/auth/auth_event.dart';
import '../data/bloc/auth/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isLoginSuccessful) {
            emailController.clear();
            passwordController.clear();
            Fluttertoast.showToast(msg: "Login Successful!");
            context.go('/home');
          } else if (state.isGoogleSignIn && state.userData != null) {
            emailController.clear();
            passwordController.clear();
            print("Email : ${state.userData?.email}");
            Fluttertoast.showToast(msg: "Google Sign-In Successful!");
            context.go('/home');
          } else if (state.errorMessage.isNotEmpty) {
            Fluttertoast.showToast(msg: state.errorMessage);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome Back",
                                style: Styles.appbarText.copyWith(fontSize: 24),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Sign in to continue",
                                style: Styles.title,
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Text(
                            "Email",
                            style: Styles.title,
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Enter your email',
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
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Password",
                            style: Styles.title,
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Enter your password',
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
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<AuthBloc>().add(AuthLogin(
                                    email: emailController.text,
                                    password: passwordController.text));
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: primaryColor,
                                minimumSize: const Size(double.infinity, 45),
                                elevation: 0,
                              ),
                              child: Text(
                                "Login",
                                style: Styles.buttonText,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                context
                                    .read<AuthBloc>()
                                    .add(const AuthSignInWithGoogle());
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: primaryColor,
                                backgroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 45),
                                side: const BorderSide(
                                    color: primaryColor, width: 2),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/google_logo.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Login with Google",
                                    style: Styles.buttonText
                                        .copyWith(color: primaryColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                context.go('/register');
                              },
                              child: Text(
                                "Don't have an account? Register",
                                style: Styles.description,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (state.isLoading)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
