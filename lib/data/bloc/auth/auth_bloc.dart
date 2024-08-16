import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthBloc() : super(const AuthState()) {
    // on<AuthRegister>((event, emit) async {
    //   emit(const AuthState(isLoading: true));
    //
    //   try {
    //     final res = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //       email: event.email,
    //       password: event.password,
    //     );
    //
    //     final user = res.user;
    //     if (user != null) {
    //       await FirebaseFirestore.instance
    //           .collection('users')
    //           .doc(user.uid)
    //           .set({
    //         'username': event.username,
    //         'email': event.email,
    //       });
    //       emit(AuthState(userData: user));
    //     } else {
    //       emit(const AuthState(errorMessage: "User registration failed"));
    //     }
    //     emit(AuthState(userData: res.user));
    //   } catch (e) {
    //     emit(AuthState(errorMessage: e.toString()));
    //   }
    // });

    on<AuthRegister>((event, emit) async {
      // Emit loading state
      emit(state.copyWith(isLoading: true));

      try {
        // Create the user
        final res = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        final user = res.user;
        if (user != null) {
          // Store additional user information in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'name': event.name,
            'phone': event.phoneNumber,
            'email': event.email,
          });

          // Emit success state with the user data and registration success
          emit(state.copyWith(
            userData: user,
            isLoading: false,
            isRegisterSuccessful: true,
          ));
        } else {
          // Emit error state if user registration fails
          emit(state.copyWith(
            isLoading: false,
            errorMessage: "User registration failed",
          ));
        }
      } catch (e) {
        // Emit error state with exception message
        emit(state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ));
      }
    });

    // on<AuthSignInWithGoogle>((event, emit) async {
    //   emit(const AuthState(isLoading: true, isGoogleSignIn: true));
    //
    //   try {
    //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    //     if (googleUser == null) {
    //       emit(const AuthState(errorMessage: 'Google sign in was cancelled'));
    //       return;
    //     }
    //     final GoogleSignInAuthentication googleAuth =
    //         await googleUser.authentication;
    //     final AuthCredential credential = GoogleAuthProvider.credential(
    //       accessToken: googleAuth.accessToken,
    //       idToken: googleAuth.idToken,
    //     );
    //     final UserCredential userCredential =
    //         await _auth.signInWithCredential(credential);
    //     final User? user = userCredential.user;
    //
    //     if (user != null) {
    //       emit(AuthState(userData: user));
    //     } else {
    //       emit(const AuthState(errorMessage: 'Sign in failed'));
    //     }
    //   } catch (e) {
    //     emit(AuthState(errorMessage: 'Sign in failed: $e'));
    //   }
    // });

    on<AuthSignInWithGoogle>((event, emit) async {
      emit(state.copyWith(isLoading: true, isGoogleSignIn: true));

      try {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          emit(state.copyWith(
              errorMessage: 'Google sign in was cancelled',
              isLoading: false,
              isGoogleSignIn: false));
          return;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          emit(state.copyWith(
              userData: user, isLoading: false, isGoogleSignIn: false));
        } else {
          emit(state.copyWith(
              errorMessage: 'Sign in failed',
              isLoading: false,
              isGoogleSignIn: false));
        }
      } catch (e) {
        emit(state.copyWith(
            errorMessage: 'Sign in failed: $e',
            isLoading: false,
            isGoogleSignIn: false));
      }
    });

    // on<AuthLogin>((event, emit) async {
    //   emit(const AuthState(isLoading: true));
    //
    //   try {
    //     final res = await FirebaseAuth.instance.signInWithEmailAndPassword(
    //       email: event.email,
    //       password: event.password,
    //     );
    //     emit(AuthState(userData: res.user));
    //   } catch (e) {
    //     emit(AuthState(errorMessage: e.toString()));
    //   }
    // });

    on<AuthLogin>((event, emit) async {
      emit(state.copyWith(isLoading: true, isLoginSuccessful: false));

      try {
        final res = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(state.copyWith(
          userData: res.user,
          isLoading: false,
          errorMessage: '',
          isLoginSuccessful: true,
        ));
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
          isLoginSuccessful: false,
        ));
      }
    });

    on<AuthUpdated>((event, emit) async {
      emit(AuthState(userData: event.userData));
    });

    // Monitor authentication state changes
    monitorAuthState();
  }

  void monitorAuthState() {
    _auth.authStateChanges().listen((user) {
      add(AuthUpdated(userData: user));
    });
  }
}
