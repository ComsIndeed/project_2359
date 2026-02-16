import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/app_theme.dart';
import 'package:project_2359/core/widgets/slide_fade_text.dart';
import 'package:project_2359/features/auth/auth_cubit.dart';

class AuthPage extends StatefulWidget {
  final bool initialIsLogin;
  const AuthPage({super.key, this.initialIsLogin = true});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late bool _isLogin;
  bool _obscurePassword = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Visual State
  bool _isSuccess = false;
  bool _isError = false;

  // Validation vars
  String? _emailError;
  double _passwordStrength = 0.0;
  bool _hasMinChars = false;
  bool _hasUpperCase = false;
  bool _hasLowerCase = false;
  bool _hasNumber = false;
  bool _hasSpecial = false;

  @override
  void initState() {
    super.initState();
    _isLogin = widget.initialIsLogin;
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
  }

  void _validateEmail() {
    final email = _emailController.text;
    if (email.isEmpty) {
      if (_emailError != null) setState(() => _emailError = null);
      return;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email) && email.length > 5) {
      setState(() => _emailError = 'Please enter a valid email');
    } else {
      setState(() => _emailError = null);
    }
  }

  void _validatePassword() {
    final password = _passwordController.text;
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
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            setState(() {
              _isSuccess = true;
              _isError = false;
            });
            Future.delayed(const Duration(milliseconds: 1500), () {
              if (mounted) Navigator.of(context).pop();
            });
          } else if (state is AuthFailure) {
            setState(() {
              _isError = true;
              _isSuccess = false;
            });

            // Reset error state visuals after a delay to allow for soft fade-out
            Future.delayed(const Duration(seconds: 5), () {
              if (mounted) setState(() => _isError = false);
            });

            if (state.isUserAlreadyExists) {
              ScaffoldMessenger.of(context).clearMaterialBanners();
              ScaffoldMessenger.of(context).showMaterialBanner(
                MaterialBanner(
                  content: const Text(
                    'An account with this email already exists.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(
                          context,
                        ).hideCurrentMaterialBanner();
                        setState(() => _isLogin = true);
                      },
                      child: const Text('SIGN IN'),
                    ),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(
                          context,
                        ).hideCurrentMaterialBanner();
                      },
                      child: const Text('DISMISS'),
                    ),
                  ],
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  contentTextStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          }
        },
        builder: (context, state) {
          final theme = Theme.of(context);
          final isLoading = state is AuthLoading;

          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: Stack(
              children: [
                // Animated Background Gradient
                Positioned.fill(
                  child: IgnorePointer(
                    child: _BackgroundGradient(
                      isSuccess: _isSuccess,
                      isError: _isError,
                    ),
                  ),
                ),

                LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 32,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(
                                height: 80,
                              ), // Keep some top space for back button
                              // Optional: Add a Spacer or flexible to push everything down
                              // But in SingleChildScrollView, MainAxisAlignment.end works with ConstrainedBox

                              // Header
                              Center(child: _AuthIcon(isLogin: _isLogin)),
                              const SizedBox(height: 24),

                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                transitionBuilder: (child, animation) =>
                                    FadeTransition(
                                      opacity: animation,
                                      child: SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(0, 0.1),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: child,
                                      ),
                                    ),
                                child: Column(
                                  key: ValueKey(_isLogin),
                                  children: [
                                    Text(
                                      _isLogin ? 'Welcome Back' : 'Get Started',
                                      style: theme.textTheme.displaySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Sign in to use all features',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),

                              AutofillGroup(
                                child: Column(
                                  children: [
                                    _EmailField(
                                      controller: _emailController,
                                      errorText: _emailError,
                                      enabled: !isLoading && !_isSuccess,
                                    ),
                                    const SizedBox(height: 16),
                                    _PasswordField(
                                      controller: _passwordController,
                                      obscureText: _obscurePassword,
                                      onToggleObscure: () => setState(
                                        () => _obscurePassword =
                                            !_obscurePassword,
                                      ),
                                      enabled: !isLoading && !_isSuccess,
                                      onSubmitted: (_) {
                                        if (_emailController.text.isNotEmpty &&
                                            _passwordController
                                                .text
                                                .isNotEmpty) {
                                          _handleAuth(context);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              if (_isLogin)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: isLoading
                                        ? null
                                        : () {
                                            if (_emailController.text.isEmpty) {
                                              setState(
                                                () => _emailError =
                                                    "Enter email to reset password",
                                              );
                                              return;
                                            }
                                            context
                                                .read<AuthCubit>()
                                                .resetPassword(
                                                  _emailController.text,
                                                )
                                                .then(
                                                  (_) =>
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                            'Password reset email sent',
                                                          ),
                                                        ),
                                                      ),
                                                )
                                                .catchError(
                                                  (e) =>
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            'Error: ${e.toString()}',
                                                          ),
                                                        ),
                                                      ),
                                                );
                                          },
                                    child: Text(
                                      'Forgot Password?',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme.colorScheme.primary,
                                          ),
                                    ),
                                  ),
                                ),

                              _PasswordStrengthBar(
                                isVisible:
                                    !_isLogin &&
                                    _passwordController.text.isNotEmpty,
                                strength: _passwordStrength,
                                hasMinChars: _hasMinChars,
                                hasUpperCase: _hasUpperCase,
                                hasLowerCase: _hasLowerCase,
                                hasNumber: _hasNumber,
                                hasSpecial: _hasSpecial,
                              ),
                              const SizedBox(height: 32),

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
                                  final isDisabled =
                                      isEmpty || isLoading || _isSuccess;

                                  return AnimatedOpacity(
                                    duration: const Duration(milliseconds: 300),
                                    opacity: isEmpty ? 0.5 : 1.0,
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      curve: Curves.easeOutCubic,
                                      width: double.infinity,
                                      height: 56,
                                      child: ElevatedButton(
                                        onPressed: isDisabled
                                            ? null
                                            : () => _handleAuth(context),
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          shape:
                                              AppTheme.buttonShape
                                                  as OutlinedBorder,
                                          backgroundColor: _isSuccess
                                              ? Colors.green
                                              : (_isError
                                                    ? theme.colorScheme.error
                                                    : null),
                                          foregroundColor:
                                              (_isSuccess || _isError)
                                              ? Colors.white
                                              : null,
                                        ),
                                        child: AnimatedSwitcher(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          child: _buildButtonChild(isLoading),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 24),

                              Row(
                                children: [
                                  const Expanded(child: Divider()),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Text(
                                      'or',
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ),
                                  const Expanded(child: Divider()),
                                ],
                              ),
                              const SizedBox(height: 24),

                              _SocialButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Not yet implemented'),
                                    ),
                                  );
                                },
                                icon: const FaIcon(
                                  FontAwesomeIcons.google,
                                  size: 18,
                                  color: Color(0xFFDB4437),
                                ),
                                label: 'Continue with Google',
                              ),
                              const SizedBox(height: 12),
                              _SocialButton(
                                onPressed: () {},
                                icon: const FaIcon(
                                  FontAwesomeIcons.facebook,
                                  size: 20,
                                  color: Color(0xFF1877F2),
                                ),
                                label: 'Continue with Facebook',
                              ),
                              const SizedBox(height: 32),

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
                                    onPressed: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).hideCurrentMaterialBanner();
                                      setState(() => _isLogin = !_isLogin);
                                    },
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                    ),
                                    child: Text(
                                      _isLogin ? 'Create Account' : 'Sign In',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // Custom back button
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 16,
                  child: IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                      Navigator.of(context).pop();
                    },
                    icon: const FaIcon(FontAwesomeIcons.chevronLeft, size: 24),
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildButtonChild(bool isLoading) {
    if (_isSuccess) {
      return const FaIcon(
        FontAwesomeIcons.check,
        color: Colors.white,
        key: ValueKey('success'),
      );
    }
    if (isLoading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      );
    }
    return SlideFadeText(
      key: ValueKey(_isLogin),
      text: _isLogin ? 'Sign In' : 'Create Account',
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  void _handleAuth(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    if (_isLogin) {
      cubit.signIn(_emailController.text, _passwordController.text);
    } else {
      cubit.signUp(_emailController.text, _passwordController.text);
    }
  }
}

class _AuthIcon extends StatelessWidget {
  final bool isLogin;

  const _AuthIcon({required this.isLogin});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Hero(
      tag: 'app_icon',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.2,
          ),
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
  final bool enabled;

  const _EmailField({
    required this.controller,
    this.errorText,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      enabled: enabled,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
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
  final bool enabled;
  final ValueChanged<String>? onSubmitted;

  const _PasswordField({
    required this.controller,
    required this.obscureText,
    required this.onToggleObscure,
    this.enabled = true,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.password],
      onSubmitted: onSubmitted,
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

class _BackgroundGradient extends StatelessWidget {
  final bool isSuccess;
  final bool isError;

  const _BackgroundGradient({required this.isSuccess, required this.isError});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = isSuccess
        ? Colors.green
        : (isError ? theme.colorScheme.error : Colors.transparent);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 1500),
      opacity: (isSuccess || isError) ? 1.0 : 0.0,
      curve: Curves.easeInOutQuart,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: const [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.501, 1.0],
            colors: [
              baseColor.withValues(alpha: 0.75),
              baseColor.withValues(alpha: 0.6),
              baseColor.withValues(alpha: 0.4),
              baseColor.withValues(alpha: 0.2),
              baseColor.withValues(alpha: 0.05),
              baseColor.withValues(alpha: 0.0),
              Colors.transparent,
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
