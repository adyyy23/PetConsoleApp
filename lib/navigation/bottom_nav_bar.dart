import 'package:flutter/material.dart';
import '../theme/pawly_colors.dart';

enum PawlyNavDestination { home, pets, care, health, more }

class PawlyBottomNavBar extends StatelessWidget {
  final PawlyNavDestination currentDestination;
  final ValueChanged<PawlyNavDestination> onDestinationSelected;

  const PawlyBottomNavBar({
    super.key,
    required this.currentDestination,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: PawlyColors.border,
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_filled,
                label: 'Home',
                isSelected: currentDestination == PawlyNavDestination.home,
                onTap: () => onDestinationSelected(PawlyNavDestination.home),
              ),
              _NavItem(
                icon: Icons.pets_outlined,
                selectedIcon: Icons.pets,
                label: 'Pets',
                isSelected: currentDestination == PawlyNavDestination.pets,
                onTap: () => onDestinationSelected(PawlyNavDestination.pets),
              ),
              _NavItem(
                icon: Icons.check_circle_outline_rounded,
                selectedIcon: Icons.check_circle_rounded,
                label: 'Care',
                isSelected: currentDestination == PawlyNavDestination.care,
                onTap: () => onDestinationSelected(PawlyNavDestination.care),
              ),
              _NavItem(
                icon: Icons.favorite_border_rounded,
                selectedIcon: Icons.favorite_rounded,
                label: 'Health',
                isSelected: currentDestination == PawlyNavDestination.health,
                onTap: () => onDestinationSelected(PawlyNavDestination.health),
              ),
              _NavItem(
                icon: Icons.more_horiz_rounded,
                label: 'More',
                isSelected: currentDestination == PawlyNavDestination.more,
                onTap: () => onDestinationSelected(PawlyNavDestination.more),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData? selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? PawlyColors.black : PawlyColors.warmGrey;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 56,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 4),
            Icon(
              isSelected ? (selectedIcon ?? icon) : icon,
              size: 22,
              color: color,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                color: color,
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
