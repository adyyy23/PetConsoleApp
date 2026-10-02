import 'package:flutter/material.dart';
import '../theme/pawly_colors.dart';
import '../theme/pawly_typography.dart';
import '../models/pet.dart';

// --- BUTTONS ---
enum PawlyButtonVariant { primary, secondary, clay, subtle, danger }

class PawlyButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final PawlyButtonVariant variant;
  final bool isFullWidth;
  final bool isSmall;

  const PawlyButton({
    super.key,
    String? label,
    String? text,
    required this.onPressed,
    this.icon,
    PawlyButtonVariant? variant,
    bool? isSecondary,
    this.isFullWidth = false,
    this.isSmall = false,
  })  : label = label ?? text ?? '',
        variant = variant ?? (isSecondary == true ? PawlyButtonVariant.secondary : PawlyButtonVariant.primary);

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    BorderSide border = BorderSide.none;

    switch (variant) {
      case PawlyButtonVariant.primary:
        bg = PawlyColors.forest;
        fg = Colors.white;
        break;
      case PawlyButtonVariant.clay:
        bg = PawlyColors.clay;
        fg = Colors.white;
        break;
      case PawlyButtonVariant.secondary:
        bg = PawlyColors.surface;
        fg = PawlyColors.espresso;
        border = const BorderSide(color: PawlyColors.border, width: 1.2);
        break;
      case PawlyButtonVariant.subtle:
        bg = PawlyColors.surfaceWarm;
        fg = PawlyColors.charcoal;
        break;
      case PawlyButtonVariant.danger:
        bg = PawlyColors.roseLight;
        fg = PawlyColors.rose;
        border = const BorderSide(color: Color(0xFFF3C4C4), width: 1);
        break;
    }

    final content = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: isSmall ? 16 : 18, color: fg),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: TextStyle(
            fontSize: isSmall ? 13 : 15,
            fontWeight: FontWeight.w700,
            color: fg,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          shadowColor: Colors.transparent,
          side: border,
          padding: EdgeInsets.symmetric(
            horizontal: isSmall ? 14 : 22,
            vertical: isSmall ? 8 : 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isSmall ? 12 : 16),
          ),
        ),
        onPressed: onPressed,
        child: content,
      ),
    );
  }
}

// --- BADGE ---
enum PawlyBadgeVariant { sage, clay, honey, slate, subtle, alert }

class PawlyBadge extends StatelessWidget {
  final String label;
  final IconData? icon;
  final PawlyBadgeVariant variant;
  final Color? backgroundColor;
  final Color? textColor;

  const PawlyBadge({
    super.key,
    required this.label,
    this.icon,
    this.variant = PawlyBadgeVariant.subtle,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    Color border;

    switch (variant) {
      case PawlyBadgeVariant.sage:
        bg = PawlyColors.forestLight;
        fg = PawlyColors.forest;
        border = PawlyColors.forestBorder;
        break;
      case PawlyBadgeVariant.clay:
        bg = PawlyColors.clayLight;
        fg = PawlyColors.clay;
        border = PawlyColors.clayBorder;
        break;
      case PawlyBadgeVariant.honey:
        bg = PawlyColors.honeyLight;
        fg = PawlyColors.honey;
        border = PawlyColors.honeyBorder;
        break;
      case PawlyBadgeVariant.slate:
        bg = PawlyColors.slateLight;
        fg = PawlyColors.slate;
        border = const Color(0xFFC7DBE6);
        break;
      case PawlyBadgeVariant.alert:
        bg = PawlyColors.roseLight;
        fg = PawlyColors.rose;
        border = const Color(0xFFF7CECE);
        break;
      case PawlyBadgeVariant.subtle:
        bg = PawlyColors.surfaceWarm;
        fg = PawlyColors.charcoal;
        border = PawlyColors.border;
        break;
    }

    if (backgroundColor != null) bg = backgroundColor!;
    if (textColor != null) {
      fg = textColor!;
      border = Colors.transparent;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: fg,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

// --- PET AVATAR ---
class PawlyPetAvatar extends StatelessWidget {
  final String imageUrl;
  final double size;
  final bool hasBorder;
  final bool isSelected;

  const PawlyPetAvatar({
    super.key,
    required this.imageUrl,
    this.size = 48,
    this.hasBorder = true,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? PawlyColors.forest
              : (hasBorder ? PawlyColors.border : Colors.transparent),
          width: isSelected ? 2.5 : 1.2,
        ),
      ),
      child: ClipOval(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: PawlyColors.surfaceWarm,
            child: const Icon(Icons.pets, color: PawlyColors.forest),
          ),
        ),
      ),
    );
  }
}

// --- PET SWITCHER HEADER ROW ---
class PetSwitcher extends StatelessWidget {
  final List<Pet> pets;
  final String selectedPetId;
  final ValueChanged<String> onSelectPet;
  final VoidCallback? onAddPet;

  PetSwitcher({
    super.key,
    required this.pets,
    required this.selectedPetId,
    ValueChanged<String>? onSelectPet,
    ValueChanged<String>? onPetSelected,
    this.onAddPet,
  }) : onSelectPet = onSelectPet ?? onPetSelected ?? ((_) {});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: onAddPet != null ? pets.length + 1 : pets.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          if (index == pets.length && onAddPet != null) {
            // Add pet button
            return InkWell(
              onTap: onAddPet,
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: PawlyColors.border, width: 1.2),
                  color: PawlyColors.surface,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 16, color: PawlyColors.charcoal),
                    SizedBox(width: 4),
                    Text(
                      'Add',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: PawlyColors.charcoal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final pet = pets[index];
          final isSelected = pet.id == selectedPetId;

          return InkWell(
            onTap: () => onSelectPet(pet.id),
            borderRadius: BorderRadius.circular(24),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.fromLTRB(4, 4, 14, 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: isSelected ? PawlyColors.espresso : PawlyColors.surface,
                border: Border.all(
                  color: isSelected ? PawlyColors.espresso : PawlyColors.border,
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PawlyPetAvatar(
                    imageUrl: pet.imageUrl,
                    size: 30,
                    hasBorder: false,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    pet.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : PawlyColors.charcoal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// --- EMPTY STATE VIEW ---
class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? buttonLabel;
  final VoidCallback? onButtonPressed;

  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    String? buttonLabel,
    String? actionLabel,
    VoidCallback? onButtonPressed,
    VoidCallback? onAction,
  })  : buttonLabel = buttonLabel ?? actionLabel,
        onButtonPressed = onButtonPressed ?? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: PawlyColors.surfaceWarm,
                shape: BoxShape.circle,
                border: Border.all(color: PawlyColors.borderLight, width: 1.5),
              ),
              child: Icon(icon, size: 28, color: PawlyColors.warmGrey),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: PawlyTypography.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: PawlyTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (buttonLabel != null && onButtonPressed != null) ...[
              const SizedBox(height: 20),
              PawlyButton(
                label: buttonLabel!,
                onPressed: onButtonPressed,
                isSmall: true,
                variant: PawlyButtonVariant.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
