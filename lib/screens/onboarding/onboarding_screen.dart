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

  final List<_OnboardingPageData> _pages = const [
    _OnboardingPageData(
      title: 'Their whole world,\nright here.',
      subtitle:
          'A quiet, loving companion app dedicated to your pets — keeping routines, health, and memories together.',
      imageUrl:
          'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=1000&q=80',
      badge: 'Personal Pet Companion',
    ),
    _OnboardingPageData(
      title: 'Never miss\ntheir care.',
      subtitle:
          'Smart routines for feeding, walks, and medications with gentle reminders that keep every tail wagging.',
      imageUrl:
          'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=1000&q=80',
      badge: 'Daily Care Flow',
    ),
    _OnboardingPageData(
      title: 'Clinical history\nin your pocket.',
      subtitle:
          'Weight tracking, vaccine passports, and pre-visit vet prep checklists ready whenever you need them.',
      imageUrl:
          'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=1000&q=80',
      badge: 'Lifelong Health Passport',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isLast = _currentIndex == _pages.length - 1;

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
                          borderRadius: AppRadius.rSm,
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
                          color: PawlyColors.warmGrey,
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
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (idx) => setState(() => _currentIndex = idx),
                itemBuilder: (context, index) {
                  final item = _pages[index];
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        // Big Visual Image Card (8-10px radius)
                        AspectRatio(
                          aspectRatio: 16 / 11,
                          child: ClipRRect(
                            borderRadius: AppRadius.rLg,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  item.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: PawlyColors.softGrey,
                                    child: const Icon(Icons.pets, size: 54, color: PawlyColors.black),
                                  ),
                                ),
                                Positioned(
                                  top: 14,
                                  left: 14,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.75),
                                      borderRadius: AppRadius.rSm,
                                      border: Border.all(color: Colors.white24, width: 0.8),
                                    ),
                                    child: Text(
                                      item.badge,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(item.title, style: PawlyTypography.displayMedium),
                        const SizedBox(height: 10),
                        Text(item.subtitle, style: PawlyTypography.bodyLarge),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
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
                      _pages.length,
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

                  // Continue / Get Started Button (6-8px radius)
                  PawlyButton(
                    label: isLast ? 'Get Started' : 'Continue',
                    icon: Icons.arrow_forward_rounded,
                    variant: PawlyButtonVariant.primary,
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
}

class _OnboardingPageData {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String badge;

  const _OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.badge,
  });
}
