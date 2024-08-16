import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthState extends Equatable {
  final User? userData;
  final bool isLoading;
  final String errorMessage;
  final bool isGoogleSignIn;
  final bool isLoginSuccessful;
  final bool isRegisterSuccessful;

  const AuthState({
    this.userData,
    this.isLoading = false,
    this.errorMessage = '',
    this.isGoogleSignIn = false,
    this.isLoginSuccessful = false,
    this.isRegisterSuccessful = false,
  });

  @override
  List<Object?> get props => [
        userData,
        isLoading,
        errorMessage,
        isGoogleSignIn,
        isLoginSuccessful,
        isRegisterSuccessful,
      ];

  AuthState copyWith({
    User? userData,
    bool? isLoading,
    String? errorMessage,
    bool? isGoogleSignIn,
    bool? isLoginSuccessful,
    bool? isRegisterSuccessful,
  }) {
    return AuthState(
      userData: userData ?? this.userData,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isGoogleSignIn: isGoogleSignIn ?? this.isGoogleSignIn,
      isLoginSuccessful: isLoginSuccessful ?? this.isLoginSuccessful,
      isRegisterSuccessful: isRegisterSuccessful ?? this.isRegisterSuccessful,
    );
  }
}
