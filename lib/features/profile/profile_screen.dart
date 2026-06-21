import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/glass_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Hero Header ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.purple.withOpacity(0.3), Colors.transparent],
                  ),
                ),
                child: Column(children: [
                  Stack(alignment: Alignment.bottomRight, children: [
                    Container(
                      width: 86,
                      height: 86,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                            colors: [AppColors.purple, AppColors.cyan]),
                        border: Border.all(color: AppColors.surface, width: 3),
                      ),
                      child: const Center(
                        child: Text('ZL',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                          color: AppColors.green, shape: BoxShape.circle),
                      child: const Icon(Icons.check, size: 10, color: Colors.white),
                    ),
                  ]),
                  const SizedBox(height: 14),
                  const Text('Zack Lee',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('zack.lee@aiwave.io',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                  const SizedBox(height: 16),
                  // Plan badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.workspace_premium_rounded,
                          size: 14, color: Colors.white),
                      SizedBox(width: 6),
                      Text('Pro Plan · Active',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ]),
              ),

              // ── Usage Stats ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(children: [
                  const _ProfileStat('128', 'Total Chats'),
                  _Divider(),
                  const _ProfileStat('3,412', 'Searches'),
                  _Divider(),
                  const _ProfileStat('47', 'Saved'),
                ]),
              ),
              const SizedBox(height: 28),

              // ── Settings Sections ──
              const _SettingsSection(title: 'Account', items: [
                _SettingsTile(
                    icon: Icons.person_outline_rounded,
                    title: 'Edit Profile',
                    color: AppColors.purple),
                _SettingsTile(
                    icon: Icons.lock_outline_rounded,
                    title: 'Privacy & Security',
                    color: AppColors.cyan),
                _SettingsTile(
                    icon: Icons.subscriptions_outlined,
                    title: 'Subscription',
                    color: AppColors.orange),
              ]),
              const SizedBox(height: 16),
              const _SettingsSection(title: 'Preferences', items: [
                _SettingsTile(
                    icon: Icons.dark_mode_outlined,
                    title: 'Appearance',
                    color: AppColors.purple,
                    trailing: 'Dark'),
                _SettingsTile(
                    icon: Icons.language_rounded,
                    title: 'Language',
                    color: AppColors.green,
                    trailing: 'English'),
                _SettingsTile(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifications',
                    color: AppColors.pink),
              ]),
              const SizedBox(height: 16),
              const _SettingsSection(title: 'Support', items: [
                _SettingsTile(
                    icon: Icons.help_outline_rounded,
                    title: 'Help Center',
                    color: AppColors.cyan),
                _SettingsTile(
                    icon: Icons.star_outline_rounded,
                    title: 'Rate the App',
                    color: AppColors.orange),
                _SettingsTile(
                    icon: Icons.logout_rounded,
                    title: 'Sign Out',
                    color: AppColors.pink,
                    isDestructive: true),
              ]),
              const SizedBox(height: 28),
              const Text('AI Wave v2.0.0',
                  style: TextStyle(color: AppColors.textDisabled, fontSize: 12)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String value, label;
  const _ProfileStat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
      ]),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1, height: 32, color: Colors.white.withOpacity(0.08));
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> items;
  const _SettingsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(title,
              style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1)),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(children: items),
        ),
      ]),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final String? trailing;
  final bool isDestructive;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.color,
    this.trailing,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Colors.white.withOpacity(0.04))),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: isDestructive ? AppColors.pink : color),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(title,
              style: TextStyle(
                  color: isDestructive ? AppColors.pink : Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
        ),
        if (trailing != null)
          Text(trailing!,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
        const SizedBox(width: 6),
        Icon(Icons.chevron_right_rounded,
            size: 18,
            color: isDestructive
                ? AppColors.pink.withOpacity(0.5)
                : AppColors.textDisabled),
      ]),
    );
  }
}
