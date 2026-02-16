import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  AuthService._();

  static Future<AuthResponse> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<AuthResponse> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
    );
  }

  static Future<void> resetPasswordForEmail(String email) async {
    await Supabase.instance.client.auth.resetPasswordForEmail(email);
  }
}
