import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/animated_chip.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _activeCategory = 0;

  final List<String> _categories = [
    'All',
    'Code',
    'Design',
    'Writing',
    'Science',
    'Business'
  ];

  final List<Map<String, dynamic>> _prompts = [
    {
      'title': 'Generate a REST API in Python',
      'desc': 'FastAPI boilerplate with auth',
      'icon': Icons.code_rounded,
      'color': AppColors.purple,
      'tag': 'Code'
    },
    {
      'title': 'UI Color Palette Creator',
      'desc': 'Generate harmonious color schemes',
      'icon': Icons.palette_outlined,
      'color': AppColors.pink,
      'tag': 'Design'
    },
    {
      'title': 'Blog Post Outline Generator',
      'desc': 'SEO-optimised structure in seconds',
      'icon': Icons.edit_note_rounded,
      'color': AppColors.cyan,
      'tag': 'Writing'
    },
    {
      'title': 'Explain Quantum Computing',
      'desc': 'Simple analogies for complex topics',
      'icon': Icons.science_outlined,
      'color': AppColors.green,
      'tag': 'Science'
    },
    {
      'title': 'Business Plan Framework',
      'desc': 'From idea to investor-ready pitch',
      'icon': Icons.trending_up_rounded,
      'color': AppColors.orange,
      'tag': 'Business'
    },
    {
      'title': 'SQL Query Optimiser',
      'desc': 'Rewrite slow queries, add indexes',
      'icon': Icons.storage_rounded,
      'color': AppColors.purple,
      'tag': 'Code'
    },
    {
      'title': 'Landing Page Copywriting',
      'desc': 'Conversion-focused hero sections',
      'icon': Icons.web_rounded,
      'color': AppColors.pink,
      'tag': 'Writing'
    },
    {
      'title': 'React Component Library',
      'desc': 'Accessible, reusable components',
      'icon': Icons.widgets_outlined,
      'color': AppColors.cyan,
      'tag': 'Code'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _activeCategory == 0
        ? _prompts
        : _prompts
            .where((p) => p['tag'] == _categories[_activeCategory])
            .toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Explore',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Discover AI capabilities',
                      style: TextStyle(
                          color: AppColors.textMuted, fontSize: 14)),
                  const SizedBox(height: 20),
                  // Search bar
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 13),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Row(children: [
                      Icon(Icons.search_rounded,
                          color: AppColors.textMuted, size: 18),
                      const SizedBox(width: 10),
                      Text('Search prompts…',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 14)),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  // Category chips
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        final active = i == _activeCategory;
                        return AnimatedChip(
                          label: _categories[i],
                          isActive: active,
                          onTap: () => setState(() => _activeCategory = i),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            // Prompt Cards Grid with staggered entry animation
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.88),
                itemCount: filtered.length,
                itemBuilder: (_, i) => _ExploreCard(data: filtered[i])
                    .animate()
                    .fadeIn(delay: (i * 60).ms, duration: 350.ms)
                    .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExploreCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _ExploreCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final Color col = data['color'] as Color;
    return GlassCard(
      padding: const EdgeInsets.all(16),
      radius: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: col.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14)),
            child: Icon(data['icon'] as IconData, color: col, size: 22),
          ),
          const Spacer(),
          Text(data['title'] as String,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
              maxLines: 2),
          const SizedBox(height: 4),
          Text(data['desc'] as String,
              style: const TextStyle(
                  color: AppColors.textMuted, fontSize: 11),
              maxLines: 2),
          const SizedBox(height: 10),
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: col.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8)),
              child: Text(data['tag'] as String,
                  style: TextStyle(
                      color: col, fontSize: 10, fontWeight: FontWeight.w500)),
            ),
            const Spacer(),
            const Icon(Icons.north_east_rounded,
                size: 14, color: AppColors.textMuted),
          ]),
        ],
      ),
    );
  }
}
