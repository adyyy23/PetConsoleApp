import 'package:flutter/material.dart';
import '../theme/pawly_colors.dart';
import '../theme/pawly_typography.dart';
import '../theme/app_tokens.dart';
import '../models/pet.dart';

// ============================================================================
// 1. GLOBAL NAVIGATION APP BAR
// ============================================================================

/// Consistent editorial app bar for detail / secondary screens.
class PawlyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Widget? trailing;
  final bool showBottomBorder;

  const PawlyAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.actions,
    this.trailing,
    this.showBottomBorder = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: PawlyColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: PawlyColors.black),
        onPressed: onBack ?? () => Navigator.maybePop(context),
        splashRadius: 20,
      ),
      title: Text(
        title,
        style: PawlyTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
      ),
      actions: actions ??
          (trailing != null
              ? [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Center(child: trailing!),
                  ),
                ]
              : null),
      bottom: showBottomBorder
          ? const PreferredSize(
              preferredSize: Size.fromHeight(1.0),
              child: Divider(height: 1.0, color: PawlyColors.border),
            )
          : null,
    );
  }
}

// ============================================================================
// 2. BUTTONS (Normalized 6-8px radius, NO giant capsules)
// ============================================================================

enum PawlyButtonVariant { primary, secondary, subtle, danger, clay }

class PawlyButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final PawlyButtonVariant variant;
  final bool isFullWidth;
  final bool isSmall;
  final bool isLoading;

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
    this.isLoading = false,
  })  : label = label ?? text ?? '',
        variant = variant ?? (isSecondary == true ? PawlyButtonVariant.secondary : PawlyButtonVariant.primary);

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    BorderSide border = BorderSide.none;

    switch (variant) {
      case PawlyButtonVariant.primary:
      case PawlyButtonVariant.clay:
        bg = PawlyColors.black;
        fg = Colors.white;
        break;
      case PawlyButtonVariant.secondary:
        bg = Colors.white;
        fg = PawlyColors.black;
        border = const BorderSide(color: PawlyColors.border, width: 1.0);
        break;
      case PawlyButtonVariant.subtle:
        bg = PawlyColors.softGrey;
        fg = PawlyColors.black;
        break;
      case PawlyButtonVariant.danger:
        bg = PawlyColors.alertLight;
        fg = PawlyColors.alert;
        border = const BorderSide(color: PawlyColors.alert, width: 1.0);
        break;
    }

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: bg,
      foregroundColor: fg,
      disabledBackgroundColor: PawlyColors.lightGrey,
      disabledForegroundColor: PawlyColors.textMuted,
      elevation: 0,
      shadowColor: Colors.transparent,
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 12 : 20,
        vertical: isSmall ? 8 : 14,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: isSmall ? AppRadius.rSm : AppRadius.rMd,
        side: border,
      ),
      minimumSize: isSmall ? const Size(0, 36) : const Size(0, 48),
    );

    Widget content = isLoading
        ? SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(fg),
            ),
          )
        : Row(
            mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: isSmall ? 15 : 18, color: fg),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: isSmall ? 13 : 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.1,
                  color: fg,
                ),
              ),
            ],
          );

    return isFullWidth
        ? SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: buttonStyle,
              onPressed: isLoading ? null : onPressed,
              child: content,
            ),
          )
        : ElevatedButton(
            style: buttonStyle,
            onPressed: isLoading ? null : onPressed,
            child: content,
          );
  }
}

// ============================================================================
// 3. EDITORIAL CARDS & CONTAINERS (8px Standard Radius)
// ============================================================================

/// Clean, editorial card surface (strictly 8px radius, crisp 1px neutral border).
class PawlyCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const PawlyCard({
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
    final effectiveRadius = borderRadius ?? AppRadius.rMd;

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

/// Backwards compatibility alias
typedef PawlyBubble = PawlyCard;

// ============================================================================
// 4. METRIC & DATE CARDS (8px Radius)
// ============================================================================

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
    this.foregroundColor = PawlyColors.black,
    this.onTap,
  }) : backgroundColor = color ?? backgroundColor ?? Colors.white;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: AppRadius.rMd,
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
                  Icon(icon, size: 13, color: foregroundColor.withOpacity(0.6)),
                  const SizedBox(width: 4),
                ],
                Text(
                  label.toUpperCase(),
                  style: PawlyTypography.labelSmall.copyWith(
                    color: foregroundColor.withOpacity(0.6),
                    fontSize: 9,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: PawlyColors.black,
                    letterSpacing: -0.4,
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
        textColor = color ?? textColor ?? PawlyColors.black;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 48,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.rSm,
        border: Border.all(color: PawlyColors.border, width: 1.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            month.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: textColor.withOpacity(0.6),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            day,
            style: TextStyle(
              fontSize: 16,
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
// 5. EDITORIAL SECTION HEADER
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
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: PawlyTypography.titleMedium.copyWith(
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
                style: const TextStyle(
                  fontSize: 12,
                  color: PawlyColors.black,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================================
// 6. PET AVATAR & PET SWITCHER
// ============================================================================

class PawlyPetAvatar extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double size;
  final bool isSelected;
  final bool hasBorder;
  final VoidCallback? onTap;

  const PawlyPetAvatar({
    super.key,
    required this.imageUrl,
    this.name = '',
    this.size = 46.0,
    this.isSelected = false,
    this.hasBorder = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: AppRadius.rMd,
          border: hasBorder
              ? Border.all(
                  color: isSelected ? PawlyColors.black : PawlyColors.border,
                  width: isSelected ? 2.0 : 1.0,
                )
              : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: PawlyColors.softGrey,
            alignment: Alignment.center,
            child: Text(
              name.isNotEmpty ? name[0] : 'P',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: PawlyColors.black),
            ),
          ),
        ),
      ),
    );
  }
}

class PetSwitcher extends StatelessWidget {
  final List<Pet> pets;
  final String selectedPetId;
  final ValueChanged<String> onSelectPet;
  final VoidCallback? onAddPet;

  const PetSwitcher({
    super.key,
    required this.pets,
    required this.selectedPetId,
    ValueChanged<String>? onSelectPet,
    ValueChanged<String>? onPetSelected,
    this.onAddPet,
  }) : onSelectPet = onSelectPet ?? onPetSelected ?? _noopSelect;

  static void _noopSelect(String _) {}

  @override
  Widget build(BuildContext context) {
    final showAdd = onAddPet != null;
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: pets.length + (showAdd ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, idx) {
          if (showAdd && idx == pets.length) {
            return GestureDetector(
              onTap: onAddPet,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.rSm,
                  border: Border.all(color: PawlyColors.border, width: 1),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 16, color: PawlyColors.black),
                    SizedBox(width: 4),
                    Text(
                      'Add',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: PawlyColors.black),
                    ),
                  ],
                ),
              ),
            );
          }

          final pet = pets[idx];
          final isSelected = pet.id == selectedPetId;

          return GestureDetector(
            onTap: () => onSelectPet(pet.id),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? PawlyColors.black : Colors.white,
                borderRadius: AppRadius.rSm,
                border: Border.all(
                  color: isSelected ? PawlyColors.black : PawlyColors.border,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      pet.imageUrl,
                      width: 22,
                      height: 22,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 22,
                        height: 22,
                        color: isSelected ? Colors.white24 : PawlyColors.softGrey,
                        alignment: Alignment.center,
                        child: Text(
                          pet.name[0],
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: isSelected ? Colors.white : PawlyColors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    pet.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : PawlyColors.black,
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

// ============================================================================
// 7. PHOTO HERO CARD (High-contrast dark scrim, 8-10px radius)
// ============================================================================

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
    this.isDark = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: isDark ? Colors.black.withOpacity(0.75) : Colors.white.withOpacity(0.92),
        borderRadius: AppRadius.rSm,
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.18) : PawlyColors.border,
          width: 1.0,
        ),
      ),
      child: child ??
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: iconColor ?? (isDark ? Colors.white : PawlyColors.black)),
                const SizedBox(width: 6),
              ],
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: TextStyle(
                        color: isDark ? Colors.white : PawlyColors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 1),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        color: isDark ? Colors.white70 : PawlyColors.warmGrey,
                        fontSize: 10,
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

/// Backwards compatibility alias
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
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.borderRadius,
    this.backgroundColor = Colors.white,
    this.borderColor = PawlyColors.border,
    this.blurSigma = 0.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius ?? AppRadius.rSm,
          border: Border.all(color: borderColor, width: 1.0),
        ),
        child: child,
      ),
    );
  }
}

// ============================================================================
// 8. CARE TIMELINE ITEM (Daily Planner Style, 8px radius)
// ============================================================================

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
    this.categoryColor = PawlyColors.black,
    this.categoryIcon = Icons.check_circle_outline,
    this.assignedTo,
    required this.onToggle,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isCompleted ? PawlyColors.softGrey : Colors.white,
        borderRadius: AppRadius.rMd,
        border: Border.all(
          color: isCompleted ? Colors.transparent : PawlyColors.border,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          // Time badge
          SizedBox(
            width: 60,
            child: Text(
              time,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: isCompleted ? PawlyColors.textMuted : PawlyColors.black,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Content body
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted ? PawlyColors.textMuted : PawlyColors.black,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: PawlyColors.warmGrey,
                    ),
                  ),
                ],
                if (assignedTo != null && assignedTo!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Assigned: $assignedTo',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: PawlyColors.midGrey,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Check circle button
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? PawlyColors.black : Colors.transparent,
                border: Border.all(
                  color: isCompleted ? PawlyColors.black : PawlyColors.border,
                  width: 1.5,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 9. STATUS BADGES
// ============================================================================

enum PawlyBadgeVariant { sage, clay, honey, slate, alert }

class PawlyBadge extends StatelessWidget {
  final String label;
  final PawlyBadgeVariant variant;
  final Color? backgroundColor;
  final Color? textColor;

  const PawlyBadge({
    super.key,
    required this.label,
    this.variant = PawlyBadgeVariant.slate,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    Color bg = PawlyColors.softGrey;
    Color fg = PawlyColors.black;

    if (variant == PawlyBadgeVariant.alert) {
      bg = PawlyColors.alertLight;
      fg = PawlyColors.alert;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor ?? bg,
        borderRadius: AppRadius.rXs,
        border: Border.all(
          color: (backgroundColor ?? bg) == PawlyColors.alertLight ? PawlyColors.alert : PawlyColors.border,
          width: 0.8,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: textColor ?? fg,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// ============================================================================
// 10. EMPTY STATE VIEW (Minimal, Actionable)
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: PawlyColors.softGrey,
                borderRadius: AppRadius.rMd,
              ),
              child: Icon(icon, size: 28, color: PawlyColors.black),
            ),
            const SizedBox(height: 16),
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
                text: buttonLabel!,
                isSmall: true,
                onPressed: onButtonPressed!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
