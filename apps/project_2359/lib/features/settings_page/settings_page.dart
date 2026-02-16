import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2359/app_theme.dart';
import 'package:project_2359/features/settings_page/auth_page.dart';
import 'package:project_2359/theme_notifier.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const List<Color> _accentColors = [
    Color(0xFF448AFF),
    Color(0xFF7C4DFF),
    Color(0xFFE040FB),
    Color(0xFFFF5252),
    Color(0xFFFF6D00),
    Color(0xFFFFAB40),
    Color(0xFF69F0AE),
    Color(0xFF00E5FF),
    Color(0xFF40C4FF),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListenableBuilder(
        listenable: themeNotifier,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            children: [
              // ── General ──
              _SectionTitle(title: 'General'),
              _SettingsCard(
                children: [
                  _InfoTile(
                    icon: FontAwesomeIcons.coins,
                    title: 'Credits',
                    trailing: Text(
                      '42',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  _divider(theme),
                  _SettingsTile(
                    icon: FontAwesomeIcons.cartShopping,
                    title: 'Buy Credits',
                    onTap: () {
                      // TODO: Implement credit purchase
                      _showSnackBar(context, 'Credit purchase coming soon');
                    },
                  ),
                ],
              ),

              // ── Account ──
              _SectionTitle(title: 'Account'),
              _SettingsCard(
                children: [
                  _SettingsTile(
                    icon: FontAwesomeIcons.rightToBracket,
                    title: 'Sign In',
                    subtitle: 'Log in to sync your data',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AuthPage()),
                    ),
                  ),
                ],
              ),

              // ── Appearance ──
              _SectionTitle(title: 'Appearance'),
              _SettingsCard(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Theme Mode', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: SegmentedButton<ThemeMode>(
                            segments: const [
                              ButtonSegment(
                                value: ThemeMode.dark,
                                label: Text('Dark'),
                                icon: FaIcon(FontAwesomeIcons.moon, size: 14),
                              ),
                              ButtonSegment(
                                value: ThemeMode.light,
                                label: Text('Light'),
                                icon: FaIcon(FontAwesomeIcons.sun, size: 14),
                              ),
                              ButtonSegment(
                                value: ThemeMode.system,
                                label: Text('Auto'),
                                icon: FaIcon(
                                  FontAwesomeIcons.circleHalfStroke,
                                  size: 14,
                                ),
                              ),
                            ],
                            selected: {themeNotifier.themeMode},
                            onSelectionChanged: (modes) =>
                                themeNotifier.setThemeMode(modes.first),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _divider(theme),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Accent Color',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _accentColors.map((color) {
                            final isSelected =
                                themeNotifier.accentColor.toARGB32() ==
                                color.toARGB32();
                            return GestureDetector(
                              onTap: () => themeNotifier.setAccentColor(color),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: isSelected
                                      ? Border.all(
                                          color: theme.colorScheme.onSurface,
                                          width: 2.5,
                                        )
                                      : null,
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: color.withValues(alpha: 0.4),
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                          ),
                                        ]
                                      : null,
                                ),
                                child: isSelected
                                    ? const Center(
                                        child: FaIcon(
                                          FontAwesomeIcons.check,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      )
                                    : null,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  _divider(theme),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Background Tone',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Dark mode only',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: BackgroundTone.values.map((tone) {
                            final isSelected =
                                themeNotifier.backgroundTone == tone;
                            return GestureDetector(
                              onTap: () =>
                                  themeNotifier.setBackgroundTone(tone),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: tone.background,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.onSurface
                                              .withValues(alpha: 0.12),
                                    width: isSelected ? 2.5 : 1,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: theme.colorScheme.primary
                                                .withValues(alpha: 0.3),
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    tone.label.split(' ').first,
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: isSelected ? 1 : 0.6,
                                      ),
                                      fontSize: 10,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // ── Storage ──
              _SectionTitle(title: 'Storage'),
              _SettingsCard(
                children: [
                  _SettingsTile(
                    icon: FontAwesomeIcons.eraser,
                    title: 'Clear Cache',
                    onTap: () {
                      // TODO: Implement cache clearing
                      _showSnackBar(context, 'Cache cleared');
                    },
                  ),
                  _divider(theme),
                  _SettingsTile(
                    icon: FontAwesomeIcons.hardDrive,
                    title: 'Manage Downloads',
                    onTap: () {
                      // TODO: Implement download management
                      _showSnackBar(context, 'Coming soon');
                    },
                  ),
                ],
              ),

              // ── Legal ──
              _SectionTitle(title: 'Legal'),
              _SettingsCard(
                children: [
                  _SettingsTile(
                    icon: FontAwesomeIcons.fileContract,
                    title: 'Terms of Service',
                    onTap: () => _showLegalSheet(
                      context,
                      'Terms of Service',
                      _placeholderToS,
                    ),
                  ),
                  _divider(theme),
                  _SettingsTile(
                    icon: FontAwesomeIcons.shieldHalved,
                    title: 'Privacy Policy',
                    onTap: () => _showLegalSheet(
                      context,
                      'Privacy Policy',
                      _placeholderPrivacy,
                    ),
                  ),
                  _divider(theme),
                  _SettingsTile(
                    icon: FontAwesomeIcons.scaleBalanced,
                    title: 'Licenses',
                    onTap: () => showLicensePage(
                      context: context,
                      applicationName: 'Project 2359',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
              Center(
                child: Text(
                  'Project 2359 • v0.1.0',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }

  static Widget _divider(ThemeData theme) {
    return Divider(
      height: 1,
      thickness: 1,
      color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
    );
  }

  static void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  static void _showLegalSheet(
    BuildContext context,
    String title,
    String content,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.2,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(title, style: theme.textTheme.displaySmall),
                  const SizedBox(height: 12),
                  // TODO: Replace placeholder legal content with actual content
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.warning.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.triangleExclamation,
                          size: 16,
                          color: AppTheme.warning,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Placeholder content — to be replaced',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppTheme.warning,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Text(
                        content,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.6,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ── Helper widgets ──

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 24, bottom: 10),
      child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.surface,
        shape: AppTheme.cardShape,
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            FaIcon(
              icon,
              size: 18,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.bodyLarge),
                  if (subtitle != null)
                    Text(subtitle!, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
            FaIcon(
              FontAwesomeIcons.chevronRight,
              size: 14,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          FaIcon(
            icon,
            size: 18,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 14),
          Text(title, style: theme.textTheme.bodyLarge),
          const Spacer(),
          trailing,
        ],
      ),
    );
  }
}

// ── Placeholder legal content ──
// TODO: Replace all placeholder legal content below with actual legal text

const _placeholderToS = '''
TERMS OF SERVICE

Last Updated: February 2026

1. ACCEPTANCE OF TERMS
By accessing and using Project 2359 ("the App"), you agree to be bound by these Terms of Service. If you do not agree to these terms, do not use the App.

2. DESCRIPTION OF SERVICE
Project 2359 is an AI-powered study assistant that helps users organize, generate, and study learning materials. The service includes document import, AI-generated study materials, and personalized study tools.

3. USER ACCOUNTS
You may be required to create an account to access certain features. You are responsible for maintaining the confidentiality of your account credentials and for all activities under your account.

4. ACCEPTABLE USE
You agree not to:
- Use the service for any unlawful purpose
- Upload content that infringes on intellectual property rights
- Attempt to reverse-engineer or compromise the service
- Share your account credentials with others

5. INTELLECTUAL PROPERTY
All content generated by the AI remains subject to the intellectual property of the original source materials. User-uploaded content remains the property of the user.

6. CREDITS AND PAYMENTS
The App uses a credit system for AI features. Credits are non-refundable and non-transferable. Pricing and availability of credits are subject to change.

7. LIMITATION OF LIABILITY
The App is provided "as is" without warranties of any kind. We are not liable for any damages arising from your use of the service.

8. CHANGES TO TERMS
We reserve the right to modify these terms at any time. Continued use of the App after changes constitutes acceptance of the new terms.

9. CONTACT
For questions about these terms, contact us at support@project2359.app.
''';

const _placeholderPrivacy = '''
PRIVACY POLICY

Last Updated: February 2026

1. INFORMATION WE COLLECT
We collect information you provide directly:
- Account information (email, name)
- Uploaded documents and study materials
- Usage data and study progress

We automatically collect:
- Device information and OS version
- App usage analytics
- Crash reports and performance data

2. HOW WE USE YOUR INFORMATION
We use collected information to:
- Provide and improve the service
- Generate personalized study materials
- Send important service updates
- Analyze usage patterns to improve features

3. DATA STORAGE
Your data is stored securely using industry-standard encryption. Documents are processed for AI features and stored in our secure cloud infrastructure.

4. DATA SHARING
We do not sell your personal information. We may share data with:
- AI service providers (for content generation, anonymized)
- Analytics services (aggregated, non-identifying)
- Law enforcement (when legally required)

5. YOUR RIGHTS
You have the right to:
- Access your personal data
- Request data deletion
- Export your data
- Opt out of non-essential data collection

6. COOKIES AND TRACKING
The App may use local storage for preferences and session management. We use minimal analytics tracking.

7. CHILDREN'S PRIVACY
The App is not intended for children under 13. We do not knowingly collect data from children.

8. CHANGES TO THIS POLICY
We may update this policy periodically. We will notify you of significant changes through the App.

9. CONTACT
For privacy inquiries, contact us at privacy@project2359.app.
''';
