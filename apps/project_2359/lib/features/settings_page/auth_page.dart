import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/app_theme.dart';
import 'package:project_2359/core/widgets/slide_fade_text.dart';

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

  // TODO: BACKEND IMPLEMENTATION OF THIS SHIT ABOUT PASSWORD VALIDATION

  // Validation vars
  String? _emailError;
  double _passwordStrength = 0.0;

  // Password recommendations
  bool _hasMinChars = false;
  bool _hasUpperCase = false;
  bool _hasLowerCase = false;
  bool _hasNumber = false;
  bool _hasSpecial = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
  }

  void _validateEmail() {
    final email = _emailController.text;

    // Illegal char check
    final illegalChars = RegExp(r'[<>()\[\]\\,;:\s]');
    if (illegalChars.hasMatch(email) && !email.contains('@')) {
      // Only show if really weird stuff, standard email check handles most
    }

    if (email.isEmpty) {
      if (_emailError != null) setState(() => _emailError = null);
      return;
    }

    // Basic regex for email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final valid = emailRegex.hasMatch(email);

    // Check for illegal characters that shouldn't be in an email at all (beyond structure)
    // Actually the regex above is quite strict. Let's strict it to printable.

    if (!valid && email.length > 5) {
      // Only error after some typing
      setState(() => _emailError = 'Please enter a valid email');
    } else {
      setState(() => _emailError = null);
    }
  }

  void _validatePassword() {
    final password = _passwordController.text;

    // Illegal characters check (simple example)
    // allowing most symbols, maybe just block control chars?

    // Strength Calculation
    if (password.isEmpty) {
      setState(() {
        _passwordStrength = 0.0;
        _hasMinChars = false;
        _hasUpperCase = false;
        _hasLowerCase = false;
        _hasNumber = false;
        _hasSpecial = false;
      });
      return;
    }

    final hasMinChars = password.length >= 8;
    final hasUpperCase = password.contains(RegExp(r'[A-Z]'));
    final hasLowerCase = password.contains(RegExp(r'[a-z]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));
    final hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    int score = 0;
    if (hasMinChars) score++;
    if (hasUpperCase) score++;
    if (hasLowerCase) score++;
    if (hasNumber) score++;
    if (hasSpecial) score++;

    setState(() {
      _passwordStrength = score / 5.0;
      _hasMinChars = hasMinChars;
      _hasUpperCase = hasUpperCase;
      _hasLowerCase = hasLowerCase;
      _hasNumber = hasNumber;
      _hasSpecial = hasSpecial;
    });
  }

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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Center(child: _AuthIcon(isLogin: _isLogin)),
                const SizedBox(height: 16),
                SlideFadeText(
                  text: _isLogin ? 'Welcome Back' : 'Get Started',
                  style: theme.textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to use all features',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Email field
                _EmailField(
                  controller: _emailController,
                  errorText: _emailError,
                ),
                const SizedBox(height: 16),

                // Password field
                _PasswordField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  onToggleObscure: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),

                // Password Strength
                _PasswordStrengthBar(
                  isVisible: !_isLogin && _passwordController.text.isNotEmpty,
                  strength: _passwordStrength,
                  hasMinChars: _hasMinChars,
                  hasUpperCase: _hasUpperCase,
                  hasLowerCase: _hasLowerCase,
                  hasNumber: _hasNumber,
                  hasSpecial: _hasSpecial,
                ),
                const SizedBox(height: 24),

                // Submit button
                ListenableBuilder(
                  listenable: Listenable.merge([
                    _emailController,
                    _passwordController,
                  ]),
                  builder: (context, _) {
                    final isEmpty =
                        _emailController.text.isEmpty ||
                        _passwordController.text.isEmpty;
                    return AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: isEmpty ? 0.5 : 1.0,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: SizedBox(
                          key: ValueKey(_isLogin),
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isEmpty
                                ? null
                                : () {
                                    // TODO: Implement auth
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Not yet implemented'),
                                      ),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: AppTheme.buttonShape as OutlinedBorder,
                            ),
                            child: SlideFadeText(
                              text: _isLogin ? 'Sign In' : 'Create Account',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('or', style: theme.textTheme.bodyMedium),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),

                // Social Sign In
                Column(
                  children: [
                    _SocialButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Not yet implemented')),
                        );
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.google,
                        size: 18,
                        color: Color(0xFFDB4437),
                      ), // Google Red
                      label: 'Continue with Google',
                    ),
                    const SizedBox(height: 12),
                    _SocialButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Not yet implemented')),
                        );
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.facebook,
                        size: 20,
                        color: Color(0xFF1877F2),
                      ), // Facebook Blue
                      label: 'Continue with Facebook',
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Toggle mode
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SlideFadeText(
                      text: _isLogin
                          ? "Don't have an account?"
                          : 'Already have an account?',
                      style: theme.textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () => setState(() => _isLogin = !_isLogin),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      child: SlideFadeText(
                        text: _isLogin ? 'Create Account' : 'Sign In',
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Custom back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const FaIcon(FontAwesomeIcons.chevronLeft, size: 24),
              padding: const EdgeInsets.all(8),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthIcon extends StatelessWidget {
  final bool isLogin;

  const _AuthIcon({required this.isLogin});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Image.asset(
        isDark
            ? 'assets/images/app_icon_light_nobg.png'
            : 'assets/images/app_icon_nobg.png',
        height: 64,
        errorBuilder: (context, error, stackTrace) => FaIcon(
          FontAwesomeIcons.layerGroup,
          size: 48,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 12),
              Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;

  const _EmailField({required this.controller, this.errorText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        errorText: errorText,
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 12, right: 8),
          child: FaIcon(FontAwesomeIcons.envelope, size: 18),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onToggleObscure;

  const _PasswordField({
    required this.controller,
    required this.obscureText,
    required this.onToggleObscure,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 12, right: 8),
          child: FaIcon(FontAwesomeIcons.lock, size: 18),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0),
        suffixIcon: IconButton(
          icon: FaIcon(
            obscureText ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
            size: 18,
          ),
          onPressed: onToggleObscure,
        ),
      ),
    );
  }
}

class _PasswordStrengthBar extends StatelessWidget {
  final bool isVisible;
  final double strength;
  final bool hasMinChars;
  final bool hasUpperCase;
  final bool hasLowerCase;
  final bool hasNumber;
  final bool hasSpecial;

  const _PasswordStrengthBar({
    required this.isVisible,
    required this.strength,
    required this.hasMinChars,
    required this.hasUpperCase,
    required this.hasLowerCase,
    required this.hasNumber,
    required this.hasSpecial,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRect(
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        alignment: Alignment.topCenter,
        heightFactor: isVisible ? 1.0 : 0.0,
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Password strength: ${_getStrengthText()}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: _getStrengthColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: strength,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  color: _getStrengthColor(),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 16),
              _PasswordReqItem(text: '8+ characters', isMet: hasMinChars),
              _PasswordReqItem(text: 'Uppercase letter', isMet: hasUpperCase),
              _PasswordReqItem(text: 'Lowercase letter', isMet: hasLowerCase),
              _PasswordReqItem(text: 'Contains a number', isMet: hasNumber),
              _PasswordReqItem(text: 'Special character', isMet: hasSpecial),
            ],
          ),
        ),
      ),
    );
  }

  String _getStrengthText() {
    if (strength < 0.3) return 'Weak';
    if (strength < 0.7) return 'Fair';
    if (strength < 1.0) return 'Good';
    return 'Strong';
  }

  Color _getStrengthColor() {
    if (strength < 0.3) return Colors.red;
    if (strength < 0.7) return Colors.orange;
    if (strength < 1.0) return Colors.blue;
    return Colors.green;
  }
}

class _PasswordReqItem extends StatelessWidget {
  final String text;
  final bool isMet;

  const _PasswordReqItem({required this.text, required this.isMet});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isMet
        ? Colors.green
        : theme.colorScheme.onSurface.withValues(alpha: 0.3);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          FaIcon(
            isMet ? FontAwesomeIcons.circleCheck : FontAwesomeIcons.circle,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isMet
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurface.withValues(alpha: 0.5),
              fontWeight: isMet ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
