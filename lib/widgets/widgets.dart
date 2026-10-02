import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/pawly_colors.dart';
import '../theme/pawly_typography.dart';
import '../models/pet.dart';

// ============================================================================
// 1. FROSTED & TRANSLUCENT BUBBLES (Selective Layering over Photography / Sheets)
// ============================================================================

/// Reusable frosted translucent bubble with subtle backdrop blur and high text contrast.
class FrostedBubble extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final Color backgroundColor;
  final Color borderColor;
  final double blurSigma;
  final VoidCallback? onTap;

  const FrostedBubble({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    this.borderRadius,
    this.backgroundColor = PawlyColors.frostedWhite,
    this.borderColor = PawlyColors.frostedBorder,
    this.blurSigma = 12.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(20);

    Widget bubble = ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: radius,
            border: Border.all(color: borderColor, width: 1.0),
            boxShadow: [
              BoxShadow(
                color: PawlyColors.deepEspresso.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      bubble = GestureDetector(onTap: onTap, child: bubble);
    }

    return bubble;
  }
}

/// Floating translucent bubble specifically designed to float over Pet Photography.
class PhotoOverlayBubble extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? child;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  final bool isDark;
  final EdgeInsetsGeometry padding;

  const PhotoOverlayBubble({
    super.key,
    this.title,
    this.subtitle,
    this.child,
    this.icon,
    this.iconColor,
    this.onTap,
    this.isDark = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return FrostedBubble(
      onTap: onTap,
      backgroundColor: isDark ? PawlyColors.frostedEspresso : PawlyColors.frostedWhite,
      borderColor: isDark ? Colors.white.withOpacity(0.18) : PawlyColors.frostedBorder,
      padding: padding,
      borderRadius: BorderRadius.circular(18),
      child: child ??
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: iconColor ?? (isDark ? Colors.white : PawlyColors.forest)),
                const SizedBox(width: 8),
              ],
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: PawlyTypography.labelLarge.copyWith(
                        color: isDark ? Colors.white : PawlyColors.deepEspresso,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 1),
                    Text(
                      subtitle!,
                      style: PawlyTypography.bodySmall.copyWith(
                        color: isDark ? Colors.white.withOpacity(0.75) : PawlyColors.warmGrey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
    );
  }
}

// ============================================================================
// 2. SOFT BUBBLE CONTAINER & METRIC BUBBLE
// ============================================================================

/// Organic, tactile soft bubble surface (reducing rigid box cards).
class PawlyBubble extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const PawlyBubble({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.backgroundColor = PawlyColors.surface,
    this.borderColor,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? BorderRadius.circular(22);

    Widget container = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: effectiveRadius,
        border: Border.all(
          color: borderColor ?? PawlyColors.border,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: PawlyColors.deepEspresso.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      container = InkWell(
        onTap: onTap,
        borderRadius: effectiveRadius,
        child: container,
      );
    }

    return container;
  }
}

/// Compact metric bubble showing large distinct figure and unit label.
class MetricBubble extends StatelessWidget {
  final String value;
  final String label;
  final String? unit;
  final IconData? icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback? onTap;

  const MetricBubble({
    super.key,
    required this.value,
    required this.label,
    this.unit,
    this.icon,
    Color? color,
    Color? backgroundColor,
    this.foregroundColor = PawlyColors.deepEspresso,
    this.onTap,
  }) : backgroundColor = color ?? backgroundColor ?? PawlyColors.surfaceWarm;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: PawlyColors.border, width: 1.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 14, color: foregroundColor.withOpacity(0.7)),
                  const SizedBox(width: 4),
                ],
                Text(
                  label.toUpperCase(),
                  style: PawlyTypography.labelSmall.copyWith(
                    color: foregroundColor.withOpacity(0.65),
                    fontSize: 10,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: PawlyTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: foregroundColor,
                    letterSpacing: -0.3,
                  ),
                ),
                if (unit != null) ...[
                  const SizedBox(width: 3),
                  Text(
                    unit!,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: foregroundColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Circular or rounded date block with month in small uppercase and day in bold large number.
class DateBubble extends StatelessWidget {
  final String month;
  final String day;
  final Color backgroundColor;
  final Color textColor;

  const DateBubble({
    super.key,
    required this.month,
    required this.day,
    Color? color,
    Color? backgroundColor,
    Color? textColor,
  })  : backgroundColor = backgroundColor ?? PawlyColors.surfaceWarm,
        textColor = color ?? textColor ?? PawlyColors.deepEspresso;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 54,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PawlyColors.border, width: 1.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            month.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: textColor.withOpacity(0.6),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            day,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: textColor,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 3. EDITORIAL SECTION HEADER
// ============================================================================

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    String? actionLabel,
    String? actionText,
    this.onAction,
  }) : actionLabel = actionLabel ?? actionText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: PawlyTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: PawlyTypography.bodySmall.copyWith(color: PawlyColors.warmGrey),
                ),
              ],
            ],
          ),
          if (actionLabel != null && onAction != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel!,
                style: PawlyTypography.labelMedium.copyWith(
                  color: PawlyColors.forest,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================================
// 4. BUTTONS & BADGES
// ============================================================================

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
            borderRadius: BorderRadius.circular(isSmall ? 14 : 18),
          ),
        ),
        onPressed: onPressed,
        child: content,
      ),
    );
  }
}

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

// ============================================================================
// 5. PET AVATAR & CIRCULAR PET SWITCHER
// ============================================================================

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

/// Circular pet portrait switcher (Mochi) (Luna) (Milo) (+) - editorial bubble design.
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
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: onAddPet != null ? pets.length + 1 : pets.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          if (index == pets.length && onAddPet != null) {
            // Add pet circular bubble
            return GestureDetector(
              onTap: onAddPet,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: PawlyColors.surface,
                      border: Border.all(color: PawlyColors.border, width: 1.5),
                    ),
                    child: const Icon(Icons.add_rounded, size: 20, color: PawlyColors.charcoal),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: PawlyColors.warmGrey,
                    ),
                  ),
                ],
              ),
            );
          }

          final pet = pets[index];
          final isSelected = pet.id == selectedPetId;

          return GestureDetector(
            onTap: () => onSelectPet(pet.id),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? PawlyColors.forest : Colors.transparent,
                      width: 2.2,
                    ),
                  ),
                  child: PawlyPetAvatar(
                    imageUrl: pet.imageUrl,
                    size: 42,
                    hasBorder: !isSelected,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  pet.name,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    color: isSelected ? PawlyColors.forest : PawlyColors.charcoal,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ============================================================================
// 6. VISUAL TIMELINE ITEMS (Tactile, uncontained timeline rows)
// ============================================================================

/// Tactile care timeline row (e.g. 8 AM ●──── Apoquel \n Medication).
class CareTimelineItem extends StatelessWidget {
  final String time;
  final String title;
  final String subtitle;
  final bool isCompleted;
  final Color categoryColor;
  final IconData categoryIcon;
  final String? assignedTo;
  final VoidCallback onToggle;
  final bool isLast;

  const CareTimelineItem({
    super.key,
    required this.time,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    this.categoryColor = PawlyColors.forest,
    this.categoryIcon = Icons.check_circle_outline,
    this.assignedTo,
    required this.onToggle,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time column
          SizedBox(
            width: 58,
            child: Text(
              time,
              style: PawlyTypography.labelSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: isCompleted ? PawlyColors.mutedGrey : PawlyColors.deepEspresso,
                fontSize: 12,
              ),
            ),
          ),

          // Vertical timeline track with check circle
          Column(
            children: [
              GestureDetector(
                onTap: onToggle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? PawlyColors.forest : PawlyColors.surface,
                    border: Border.all(
                      color: isCompleted ? PawlyColors.forest : PawlyColors.border,
                      width: 2,
                    ),
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                      : null,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: PawlyColors.borderLight,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),

          // Content body
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 22),
              child: GestureDetector(
                onTap: onToggle,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isCompleted ? PawlyColors.surfaceWarm.withOpacity(0.5) : PawlyColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isCompleted ? Colors.transparent : PawlyColors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: categoryColor.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(categoryIcon, size: 16, color: categoryColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: PawlyTypography.titleSmall.copyWith(
                                fontWeight: FontWeight.w700,
                                decoration: isCompleted ? TextDecoration.lineThrough : null,
                                color: isCompleted ? PawlyColors.mutedGrey : PawlyColors.deepEspresso,
                              ),
                            ),
                            if (subtitle.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                subtitle,
                                style: PawlyTypography.bodySmall.copyWith(
                                  color: PawlyColors.warmGrey,
                                ),
                              ),
                            ],
                            if (assignedTo != null && assignedTo!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: PawlyColors.surfaceWarm,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Assigned to: $assignedTo',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: PawlyColors.forest,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 7. EMPTY STATE VIEW (Warm, pet-specific copy)
// ============================================================================

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
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: PawlyColors.surfaceWarm,
                shape: BoxShape.circle,
                border: Border.all(color: PawlyColors.borderLight, width: 1.5),
              ),
              child: Icon(icon, size: 30, color: PawlyColors.warmGrey),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: PawlyTypography.titleMedium.copyWith(fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: PawlyTypography.bodyMedium.copyWith(color: PawlyColors.warmGrey),
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
