import 'package:flutter/material.dart';

enum PawlyNavDestination { home, pets, care, health, more }

class PawlyBottomNavBar extends StatelessWidget {
  final PawlyNavDestination currentDestination;
  final ValueChanged<PawlyNavDestination> onDestinationSelected;
  const PawlyBottomNavBar(
      {super.key,
      required this.currentDestination,
      required this.onDestinationSelected});
  @override
  Widget build(BuildContext context) => NavigationBar(
        selectedIndex: currentDestination.index,
        onDestinationSelected: (index) =>
            onDestinationSelected(PawlyNavDestination.values[index]),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.pets_outlined),
              selectedIcon: Icon(Icons.pets),
              label: 'Pets'),
          NavigationDestination(
              icon: Icon(Icons.check_circle_outline),
              selectedIcon: Icon(Icons.check_circle),
              label: 'Care'),
          NavigationDestination(
              icon: Icon(Icons.favorite_border),
              selectedIcon: Icon(Icons.favorite),
              label: 'Health'),
          NavigationDestination(icon: Icon(Icons.tune_rounded), label: 'More'),
        ],
      );
}
