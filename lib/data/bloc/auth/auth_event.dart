import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthRegister extends AuthEvent {
  final String name;
  final String phoneNumber;
  final String email;
  final String password;

  const AuthRegister({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.password,
  });
}

class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  const AuthLogin({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class AuthSignInWithGoogle extends AuthEvent {
  const AuthSignInWithGoogle();
}

class AuthUpdated extends AuthEvent {
  final User? userData;

  const AuthUpdated({
    required this.userData,
  });

  @override
  List<Object?> get props => [userData];
}
