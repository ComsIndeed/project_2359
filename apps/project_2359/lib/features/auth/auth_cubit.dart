import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_2359/features/auth/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// States
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  final bool isUserAlreadyExists;

  AuthFailure({required this.message, this.isUserAlreadyExists = false});
}

// Cubit
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      await AuthService.signInWithEmailAndPassword(email, password);
      emit(AuthSuccess());
    } on AuthException catch (e) {
      emit(AuthFailure(message: e.message));
    } catch (e) {
      emit(AuthFailure(message: 'An unexpected error occurred'));
    }
  }

  Future<void> signUp(String email, String password) async {
    emit(AuthLoading());
    try {
      await AuthService.signUpWithEmailAndPassword(email, password);
      emit(AuthSuccess());
    } on AuthException catch (e) {
      // Check for "User already exists" error.
      // Supabase typically returns 400 or specific message for duplicates.
      // We'll check the message or status if available, but message is safest for now across varying API versions if code isn't precise.
      // Actually Supabase AuthException has a 'code'. 'user_already_exists' is common but let's check message too.
      // For now, let's look for keywords since specifics might vary.
      bool isExisting =
          e.message.toLowerCase().contains('already registered') ||
          e.message.toLowerCase().contains('already exists');

      emit(AuthFailure(message: e.message, isUserAlreadyExists: isExisting));
    } catch (e) {
      emit(AuthFailure(message: 'An unexpected error occurred'));
    }
  }

  Future<void> resetPassword(String email) async {
    // We don't change state to loading/success for this, just a side effect or separate status?
    // Actually simpler to just have UI call service for this one or have a separate state?
    // Let's keep it simple: The UI can just call this and handle the snackbar, OR we can have a specialized state.
    // The user wants "Forgot Password button".
    // Let's just catch errors and return them, or emit failure?
    // If we emit loading, it replaces the main UI.
    // Let's just make this return a Future<void> and throw if error, letting UI handle the "Email sent" snackbar.
    // But to be consistent with BLoC pattern, maybe better to have a `AuthPasswordResetSent` state?
    // BUT that would hide the login form.
    // Let's just handle it in the UI or use a separate Cubit?
    // No, keep it simple. Just return the Future.

    try {
      await AuthService.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }
}
