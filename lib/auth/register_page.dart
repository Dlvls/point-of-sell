import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:point_of_sell/data/bloc/auth/auth_bloc.dart';
import 'package:point_of_sell/resources/colors.dart';
import 'package:point_of_sell/resources/styles.dart';

import '../data/bloc/auth/auth_event.dart';
import '../data/bloc/auth/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, left: 16, top: 64),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Create New Account",
                          style: Styles.appbarText.copyWith(fontSize: 24),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Let's get you signed up",
                          style: Styles.title,
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      "Name",
                      style: Styles.title,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter your name',
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
                      "Phone Number",
                      style: Styles.title,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Enter your phone number',
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
                    BlocListener<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state.isRegisterSuccessful) {
                          // Clear the text fields on successful registration
                          nameController.clear();
                          emailController.clear();
                          passwordController.clear();

                          Fluttertoast.showToast(
                              msg: "Registration Successful!");
                          context.go('/login'); // Navigate to login page
                        } else if (state.errorMessage.isNotEmpty) {
                          Fluttertoast.showToast(msg: state.errorMessage);
                        }
                      },
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final name = nameController.text;
                            final phoneNumber = phoneNumberController.text;
                            final email = emailController.text;
                            final password = passwordController.text;

                            if (email.isNotEmpty &&
                                name.isNotEmpty &&
                                password.isNotEmpty) {
                              context.read<AuthBloc>().add(
                                    AuthRegister(
                                        name: name,
                                        phoneNumber: phoneNumber,
                                        email: email,
                                        password: password),
                                  );
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                      "Please enter name, email, and password!");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: primaryColor,
                            minimumSize: const Size(double.infinity, 45),
                            elevation: 0,
                          ),
                          child: Text(
                            "Register",
                            style: Styles.buttonText,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          context.go('/login');
                        },
                        child: Text(
                          "Already have an account? Login",
                          style: Styles.description,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state.isLoading) {
                return Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
