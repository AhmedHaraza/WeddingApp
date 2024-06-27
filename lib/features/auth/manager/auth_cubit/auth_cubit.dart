import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding/features/auth/manager/auth_cubit/auth_state.dart';

class AuthenticationCubit extends Cubit<AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthenticationCubit() : super(AuthenticationInitial()) {
    _firebaseAuth.authStateChanges().listen((user) {
      if (user != null) {
        if (user.emailVerified) {
          // User's email is verified
          emit(AuthenticationSuccess(user));
        } else {
          // User's email is not verified
          emit(AuthEmailNotVerified(user));
        }
      } else {
        emit(AuthenticationInitial());
      }
    });
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      emit(AuthenticationLoading());
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        // Check if the user's email is verified
        if (user.emailVerified) {
          await _checkUserTypeAndEmitState(user);
        } else {
          // User's email is not verified
          emit(AuthEmailNotVerified(user));
        }
      }
    } catch (e) {
      emit(AuthenticationFailure(error: e.toString()));
    }
  }

  Future<void> _checkUserTypeAndEmitState(User user) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> photographerSnapshot =
      await FirebaseFirestore.instance.collection('photographers').doc(user.uid).get();

      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (photographerSnapshot.exists) {
        // User is a photographer
        emit(AuthenticationSuccessPhotographer(user));
      } else if (userSnapshot.exists) {
        // User is a regular user
        emit(AuthenticationSuccessUser(user));
      } else {
        // User not found in either collection
        emit(AuthenticationFailure(error: 'User not found'));
      }
    } catch (e) {
      emit(AuthenticationFailure(error: e.toString()));
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        // Email verification sent successfully
      }
    } catch (e) {
      print('Error sending email verification: $e');
      // Handle error sending email verification
    }
  }

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      emit(AuthenticationLoading());
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        // Send email verification upon successful sign up
        await sendEmailVerification();
        emit(AuthenticationSuccess(user));
      }

      return user;
    } catch (e) {
      emit(AuthenticationFailure(error: e.toString()));
      return null;
    }
  }

  void signOut() async {
    try {
      await _firebaseAuth.signOut();
      emit(AuthenticationInitial());
    } catch (e) {
      emit(AuthenticationFailure(error: e.toString()));
    }
  }

  void resetPassword(String email) async {
    try {
      emit(AuthenticationLoading());
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      emit(AuthenticationSuccess(FirebaseAuth.instance.currentUser));
    } catch (e) {
      emit(AuthenticationFailure(error: e.toString()));
    }
  }
}
