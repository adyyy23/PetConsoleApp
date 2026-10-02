import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../theme/app_tokens.dart';
import '../../widgets/widgets.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onFinish;

  const OnboardingScreen({super.key, required this.onFinish});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isLast = _currentIndex == 2;

    return Scaffold(
      backgroundColor: PawlyColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Skip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: PawlyColors.black,
                          borderRadius: AppTokens.rSm,
                        ),
                        child: const Icon(Icons.pets, size: 16, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Pawly',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: PawlyColors.black,
                        ),
                      ),
                    ],
                  ),
                  if (!isLast)
                    TextButton(
                      onPressed: widget.onFinish,
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: PawlyColors.secondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Page View
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (idx) => setState(() => _currentIndex = idx),
                children: [
                  _buildStageOne(),
                  _buildStageTwo(),
                  _buildStageThree(),
                ],
              ),
            ),

            // Bottom Navigation and Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page Indicators
                  Row(
                    children: List.generate(
                      3,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 6),
                        width: i == _currentIndex ? 22 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: i == _currentIndex
                              ? PawlyColors.black
                              : PawlyColors.border,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),

                  PawlyButton(
                    text: isLast ? 'Get Started' : 'Continue',
                    isSmall: true,
                    onPressed: () {
                      if (isLast) {
                        widget.onFinish();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // STAGE 1: ONE PLACE FOR THEIR LIFE (Layered UI fragment preview)
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildStageOne() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          // Layered Graphic Area
          SizedBox(
            height: 250,
            width: double.infinity,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Base background frame
                Container(
                  width: double.infinity,
                  height: 230,
                  decoration: BoxDecoration(
                    color: PawlyColors.surface,
                    borderRadius: BorderRadius.circular(AppTokens.r24),
                    border: Border.all(color: PawlyColors.border),
                  ),
                ),

                // Center Pet Portrait
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppTokens.r18),
                  child: Container(
                    width: 170,
                    height: 190,
                    color: PawlyColors.surfaceWarm,
                    child: Image.network(
                      'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=600&q=80',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.pets, size: 48, color: PawlyColors.tertiary),
                      ),
                    ),
                  ),
                ),

                // Floating UI Preview 1: Today Care
                const Positioned(
                  top: 14,
                  left: 10,
                  child: _FloatingUiBadge(
                    icon: Icons.check_circle_outline_rounded,
                    label: 'Today',
                    value: '2 routines left',
                  ),
                ),

                // Floating UI Preview 2: Weight
                const Positioned(
                  bottom: 24,
                  left: 12,
                  child: _FloatingUiBadge(
                    icon: Icons.monitor_weight_outlined,
                    label: 'Weight',
                    value: '28.5 kg',
                  ),
                ),

                // Floating UI Preview 3: Next Visit
                const Positioned(
                  top: 36,
                  right: 10,
                  child: _FloatingUiBadge(
                    icon: Icons.calendar_today_outlined,
                    label: 'Next visit',
                    value: 'Oct 12',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const Text(
            'Everything about them,\nin one place.',
            style: PawlyTypography.display,
          ),
          const SizedBox(height: 12),
          const Text(
            'Care routines, health records, appointments,\nand memories — organized around each pet.',
            style: PawlyTypography.bodyLarge,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // STAGE 2: DAILY CARE (Editorial daily timeline)
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildStageTwo() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          // Editorial Timeline Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: PawlyColors.surface,
              borderRadius: BorderRadius.circular(AppTokens.r24),
              border: Border.all(color: PawlyColors.border),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('TODAY’S SCHEDULE', style: PawlyTypography.eyebrow),
                    _CareFlowPill(),
                  ],
                ),
                SizedBox(height: 16),
                _TimelineRow(
                  time: '08:00',
                  title: 'Morning care',
                  subtitle: 'Fresh water, breakfast & Apoquel',
                  isCompleted: true,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: SizedBox(height: 12, child: VerticalDivider(color: PawlyColors.border, thickness: 1)),
                ),
                _TimelineRow(
                  time: '12:00',
                  title: 'Meal',
                  subtitle: 'Nutritional kibble & wellness check',
                  isCompleted: false,
                  isCurrent: true,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: SizedBox(height: 12, child: VerticalDivider(color: PawlyColors.border, thickness: 1)),
                ),
                _TimelineRow(
                  time: '18:00',
                  title: 'Evening walk',
                  subtitle: '45-minute neighborhood stroll',
                  isCompleted: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const Text(
            'Their day,\nat a glance.',
            style: PawlyTypography.display,
          ),
          const SizedBox(height: 12),
          const Text(
            'Keep routines, meals, walks, medication,\nand everyday care organized.',
            style: PawlyTypography.bodyLarge,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // STAGE 3: THEIR STORY (Overlapping editorial composition)
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildStageThree() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          // Overlapping Editorial Story Composition
          SizedBox(
            height: 250,
            width: double.infinity,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Base white container
                Container(
                  width: double.infinity,
                  height: 240,
                  decoration: BoxDecoration(
                    color: PawlyColors.surface,
                    borderRadius: BorderRadius.circular(AppTokens.r24),
                    border: Border.all(color: PawlyColors.border),
                  ),
                ),

                // Large Memory Photo Fragment
                Positioned(
                  top: 18,
                  left: 18,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppTokens.r18),
                    child: Container(
                      width: 140,
                      height: 150,
                      color: PawlyColors.surfaceWarm,
                      child: Image.network(
                        'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=500&q=80',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.favorite, size: 36, color: PawlyColors.tertiary),
                        ),
                      ),
                    ),
                  ),
                ),

                // Pet portrait fragment
                Positioned(
                  top: 24,
                  right: 18,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppTokens.r18),
                    child: Container(
                      width: 120,
                      height: 110,
                      color: PawlyColors.surfaceWarm,
                      child: Image.network(
                        'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=500&q=80',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.pets, size: 32, color: PawlyColors.tertiary),
                        ),
                      ),
                    ),
                  ),
                ),

                // Health Record Preview Badge (Overlapping bottom)
                Positioned(
                  bottom: 20,
                  left: 24,
                  right: 24,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: PawlyColors.black,
                      borderRadius: BorderRadius.circular(AppTokens.r14),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.shield_outlined, color: Colors.white, size: 18),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Rabies Booster • Verified',
                                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                'Next exam: Nov 2026',
                                style: TextStyle(color: Colors.white70, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.check_circle_rounded, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const Text(
            'More than\na schedule.',
            style: PawlyTypography.display,
          ),
          const SizedBox(height: 12),
          const Text(
            'Keep health records, milestones, appointments,\nand the moments worth remembering.',
            style: PawlyTypography.bodyLarge,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _FloatingUiBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _FloatingUiBadge({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTokens.r10),
        border: Border.all(color: PawlyColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: PawlyColors.black),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label.toUpperCase(),
                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: PawlyColors.secondary),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: PawlyColors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final String time;
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isCurrent;

  const _TimelineRow({
    required this.time,
    required this.title,
    required this.subtitle,
    this.isCompleted = false,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            time,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: PawlyColors.black,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? PawlyColors.black
                : (isCurrent ? PawlyColors.surfaceWarm : Colors.transparent),
            border: Border.all(
              color: isCompleted ? PawlyColors.black : PawlyColors.border,
              width: 1.5,
            ),
          ),
          child: isCompleted
              ? const Icon(Icons.check, size: 13, color: Colors.white)
              : (isCurrent
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: PawlyColors.black,
                        ),
                      ),
                    )
                  : null),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isCompleted ? PawlyColors.secondary : PawlyColors.black,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: PawlyTypography.caption,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CareFlowPill extends StatelessWidget {
  const _CareFlowPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: PawlyColors.surfaceWarm,
        borderRadius: BorderRadius.circular(AppTokens.pill),
      ),
      child: const Text(
        'Care Flow',
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: PawlyColors.black),
      ),
    );
  }
}

