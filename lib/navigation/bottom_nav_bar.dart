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
        color: PawlyColors.surface,
        border: Border(
          top: BorderSide(color: PawlyColors.border, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isSelected: currentDestination == PawlyNavDestination.home,
                onTap: () => onDestinationSelected(PawlyNavDestination.home),
              ),
              _NavItem(
                icon: Icons.pets_rounded,
                label: 'Pets',
                isSelected: currentDestination == PawlyNavDestination.pets,
                onTap: () => onDestinationSelected(PawlyNavDestination.pets),
              ),
              _NavItem(
                icon: Icons.check_circle_outline_rounded,
                label: 'Care',
                isSelected: currentDestination == PawlyNavDestination.care,
                onTap: () => onDestinationSelected(PawlyNavDestination.care),
              ),
              _NavItem(
                icon: Icons.favorite_border_rounded,
                label: 'Health',
                isSelected: currentDestination == PawlyNavDestination.health,
                onTap: () => onDestinationSelected(PawlyNavDestination.health),
              ),
              _NavItem(
                icon: Icons.grid_view_rounded,
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
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? PawlyColors.forest : PawlyColors.mutedGrey;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 23, color: color),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: color,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
