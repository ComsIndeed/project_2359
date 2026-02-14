import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/app_theme.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLogin = true;
  bool _obscurePassword = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Sign In' : 'Create Account'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            FaIcon(
              FontAwesomeIcons.userLarge,
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              _isLogin ? 'Welcome Back' : 'Get Started',
              style: theme.textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _isLogin
                  ? 'Sign in to sync your data'
                  : 'Create an account to get started',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Email field
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 12, right: 8),
                  child: FaIcon(FontAwesomeIcons.envelope, size: 18),
                ),
                prefixIconConstraints: BoxConstraints(minWidth: 0),
              ),
            ),
            const SizedBox(height: 16),

            // Password field
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 12, right: 8),
                  child: FaIcon(FontAwesomeIcons.lock, size: 18),
                ),
                prefixIconConstraints: const BoxConstraints(minWidth: 0),
                suffixIcon: IconButton(
                  icon: FaIcon(
                    _obscurePassword
                        ? FontAwesomeIcons.eye
                        : FontAwesomeIcons.eyeSlash,
                    size: 18,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Submit button
            ElevatedButton(
              onPressed: () {
                // TODO: Implement auth
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Not yet implemented')),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: AppTheme.buttonShape as OutlinedBorder,
              ),
              child: Text(
                _isLogin ? 'Sign In' : 'Create Account',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Divider
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.12),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('or', style: theme.textTheme.bodyMedium),
                ),
                Expanded(
                  child: Divider(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Google Sign In
            OutlinedButton.icon(
              onPressed: () {
                // TODO: Implement Google Sign-In
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Not yet implemented')),
                );
              },
              icon: const FaIcon(FontAwesomeIcons.google, size: 18),
              label: const Text('Continue with Google'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: AppTheme.buttonShape as OutlinedBorder,
              ),
            ),
            const SizedBox(height: 24),

            // Toggle mode
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isLogin
                      ? "Don't have an account?"
                      : 'Already have an account?',
                  style: theme.textTheme.bodyMedium,
                ),
                TextButton(
                  onPressed: () => setState(() => _isLogin = !_isLogin),
                  child: Text(_isLogin ? 'Create Account' : 'Sign In'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
