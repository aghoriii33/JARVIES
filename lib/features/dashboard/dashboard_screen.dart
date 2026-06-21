import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/glass_card.dart';
import '../voice/voice_screen.dart';
import '../image_search/image_search_screen.dart';
import '../chat/chat_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Bar ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _IconBox(icon: Icons.menu_rounded),
                  Row(children: [
                    const _NotifBadge(),
                    const SizedBox(width: 10),
                    const _IconBox(icon: Icons.hexagon_outlined),
                  ]),
                ],
              ).animate().fadeIn(duration: 300.ms),
              const SizedBox(height: 28),

              // ── Greeting ──
              const Text('Hi Zack Lee,',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 15))
                  .animate().fadeIn(delay: 100.ms, duration: 300.ms),
              const SizedBox(height: 4),
              const Text("Let's see what I can do\nfor you today?",
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.3))
                  .animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: 28),

              // ── Prompt Search Bar ──
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ChatScreen()),
                  );
                },
                child: const _PromptBar(),
              ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: 28),

              // ── Feature Cards ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const VoiceScreen()),
                      ),
                      child: const _VoiceCard(),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    flex: 4,
                    child: Column(children: [
                      _SmallCard(
                        title: 'Start New Chat',
                        icon: Icons.chat_bubble_outline_rounded,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ChatScreen()),
                        ),
                      ),
                      const SizedBox(height: 14),
                      _SmallCard(
                        title: 'Search by Image',
                        icon: Icons.image_search_rounded,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ImageSearchScreen()),
                        ),
                      ),
                    ]),
                  ),
                ],
              ).animate().fadeIn(delay: 450.ms, duration: 500.ms).slideY(begin: 0.08, end: 0),
              const SizedBox(height: 32),

              // ── Stats Row ──
              const _StatsRow().animate().fadeIn(delay: 550.ms, duration: 400.ms),
              const SizedBox(height: 32),

              // ── Recent Searches ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recently Searched',
                      style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  Text('See all',
                      style: TextStyle(color: AppColors.purple, fontSize: 13)),
                ],
              ).animate().fadeIn(delay: 600.ms),
              const SizedBox(height: 14),
              const Column(children: [
                _RecentTile('Look for 5 potential headlines for websites with fintech themes'),
                SizedBox(height: 8),
                _RecentTile('find the python code to create a 10-fold branch'),
                SizedBox(height: 8),
                _RecentTile('5 copywriting for the benefits and features section on the SaaS website'),
                SizedBox(height: 8),
                _RecentTile('Summarize the key differences between REST and GraphQL APIs'),
              ]).animate().fadeIn(delay: 700.ms, duration: 500.ms).slideY(begin: 0.05, end: 0),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  const _IconBox({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
      ),
      child: Icon(icon, size: 20, color: AppColors.textSecondary),
    );
  }
}

class _NotifBadge extends StatelessWidget {
  const _NotifBadge();

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
        ),
        child: const Icon(Icons.notifications_none_rounded,
            size: 20, color: AppColors.textSecondary),
      ),
      Positioned(
        top: 6,
        right: 6,
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
              color: AppColors.pink, shape: BoxShape.circle),
        ),
      ),
    ]);
  }
}

class _PromptBar extends StatelessWidget {
  const _PromptBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [
        const Icon(Icons.auto_awesome, size: 18, color: AppColors.purple),
        const SizedBox(width: 10),
        const Expanded(
          child: Text('Ask me anything…',
              style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
        ),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
              color: AppColors.purple, shape: BoxShape.circle),
          child: const Icon(Icons.arrow_upward_rounded,
              size: 14, color: Colors.white),
        ),
      ]),
    );
  }
}

class _VoiceCard extends StatelessWidget {
  const _VoiceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: AppColors.voiceGradient,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Voice helper',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                  color: Colors.white24, shape: BoxShape.circle),
              child: const Icon(Icons.mic, size: 16, color: Colors.white),
            ),
          ]),
          const Text("Let's find new things using voice recording",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600)),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 11),
            decoration: AppDecorations.whiteRound(),
            child: const Center(
              child: Text('Start Recording',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _SmallCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      radius: 22,
      child: SizedBox(
        height: 68, // matching 98 total height with margins
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 18, color: AppColors.purple),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(
                child: Text(title,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  size: 12, color: AppColors.textDisabled),
            ]),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(children: [
      _StatChip(label: 'Chats', value: '128', color: AppColors.purple),
      SizedBox(width: 10),
      _StatChip(label: 'Searches', value: '3.4K', color: AppColors.cyan),
      SizedBox(width: 10),
      _StatChip(label: 'Saved', value: '47', color: AppColors.green),
    ]);
  }
}

class _StatChip extends StatelessWidget {
  final String label, value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        ]),
      ),
    );
  }
}

class _RecentTile extends StatelessWidget {
  final String text;
  const _RecentTile(this.text);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      radius: 16,
      child: Row(children: [
        const Icon(Icons.history_rounded, size: 16, color: AppColors.textMuted),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ),
        const Icon(Icons.north_east_rounded, size: 14, color: AppColors.textDisabled),
      ]),
    );
  }
}
