import 'package:flutter/material.dart';
import '../theme/pawly_colors.dart';
import '../theme/app_tokens.dart';
import '../theme/pawly_typography.dart';
import '../models/pet.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 1. PawlyAppBar
// ─────────────────────────────────────────────────────────────────────────────
class PawlyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? action;
  final Widget? trailing; // backward-compat alias for action
  final bool showBack;
  final VoidCallback? onBack; // explicit back callback override
  final bool showBottomBorder; // visual option (no-op but accepted)

  const PawlyAppBar({
    super.key,
    required this.title,
    this.action,
    this.trailing,
    this.showBack = true,
    this.onBack,
    this.showBottomBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final actionWidget = action ?? trailing;
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              if (showBack && (Navigator.canPop(context) || onBack != null)) ...[
                IconButton(
                  onPressed: onBack ?? () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: PawlyColors.black, size: 22),
                  constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                  padding: EdgeInsets.zero,
                ),
              ] else
                const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: PawlyTypography.pageTitle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              if (actionWidget != null) actionWidget,
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. PawlyButton — supports both old (label:, variant:, isFullWidth:) and new
//    (text:, isSecondary:, isSmall:) APIs
// ─────────────────────────────────────────────────────────────────────────────

/// Old enum kept for backward compat
enum PawlyButtonVariant { primary, secondary, clay }

class PawlyButton extends StatelessWidget {
  // New API
  final String? text;
  final bool isSecondary;
  final bool isSmall;

  // Old API aliases
  final String? label;
  final PawlyButtonVariant? variant;
  final bool? isFullWidth;
  final VoidCallback onPressed;

  const PawlyButton({
    super.key,
    this.text,
    this.label,
    required this.onPressed,
    this.isSecondary = false,
    this.isSmall = false,
    this.variant,
    this.isFullWidth,
  });

  /// Alias constructor for old "clay" variant usage
  const PawlyButton.clay({
    super.key,
    required String this.label,
    required this.onPressed,
    this.text,
    this.isSecondary = true,
    this.isSmall = false,
    this.variant,
    this.isFullWidth,
  });

  String get _resolvedLabel => text ?? label ?? '';

  bool get _isSecondaryResolved {
    if (variant == PawlyButtonVariant.secondary || variant == PawlyButtonVariant.clay) return true;
    return isSecondary;
  }

  bool get _isFullWidth {
    if (isFullWidth != null) return isFullWidth!;
    return !isSmall;
  }

  @override
  Widget build(BuildContext context) {
    final useSecondary = _isSecondaryResolved;
    return SizedBox(
      width: _isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: useSecondary ? PawlyColors.surface : PawlyColors.black,
          foregroundColor: useSecondary ? PawlyColors.black : PawlyColors.surface,
          elevation: 0,
          padding: EdgeInsets.symmetric(
            vertical: isSmall ? 10 : 16,
            horizontal: isSmall ? 16 : 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.r14),
            side: useSecondary
                ? const BorderSide(color: PawlyColors.border)
                : BorderSide.none,
          ),
        ),
        child: Text(
          _resolvedLabel,
          style: TextStyle(
            fontSize: isSmall ? 13 : 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. PawlyCard — supports optional backgroundColor
// ─────────────────────────────────────────────────────────────────────────────
class PawlyCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final VoidCallback? onTap;

  const PawlyCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor,
    this.borderRadius,
    this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? PawlyColors.surface,
        borderRadius: borderRadius ?? BorderRadius.circular(AppTokens.r18),
        border: Border.all(color: borderColor ?? PawlyColors.border, width: 1),
      ),
      child: child,
    );
    return onTap != null ? GestureDetector(onTap: onTap, child: card) : card;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. PetAvatar — circle photo, selected ring
// ─────────────────────────────────────────────────────────────────────────────
class PetAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final bool isSelected;
  final VoidCallback? onTap;

  const PetAvatar({
    super.key,
    required this.imageUrl,
    this.radius = 24,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: isSelected
            ? Border.all(color: PawlyColors.black, width: 2)
            : Border.all(color: PawlyColors.border, width: 1),
      ),
      child: ClipOval(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: PawlyColors.surfaceWarm,
            child: const Icon(Icons.pets, color: PawlyColors.tertiary, size: 20),
          ),
        ),
      ),
    );
    return onTap != null
        ? GestureDetector(onTap: onTap, child: avatar)
        : avatar;
  }
}

/// Backward-compat alias — some screens call PawlyPetAvatar(imageUrl:, size:)
class PawlyPetAvatar extends StatelessWidget {
  final String imageUrl;
  final double size;
  final bool isSelected;

  const PawlyPetAvatar({
    super.key,
    required this.imageUrl,
    this.size = 40,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return PetAvatar(
      imageUrl: imageUrl,
      radius: size / 2,
      isSelected: isSelected,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 5. PetHeroImage — full-width hero with dark gradient overlay
// ─────────────────────────────────────────────────────────────────────────────
class PetHeroImage extends StatelessWidget {
  final String imageUrl;
  final Widget child;
  final double height;

  const PetHeroImage({
    super.key,
    required this.imageUrl,
    required this.child,
    this.height = 280,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppTokens.r24),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: PawlyColors.surfaceWarm),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xE6111111)],
                    stops: [0.3, 1.0],
                  ),
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 6. SectionHeader — eyebrow + bold title + optional action
// ─────────────────────────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String eyebrow;
  final Widget? action;

  const SectionHeader({
    super.key,
    required this.title,
    required this.eyebrow,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(eyebrow.toUpperCase(), style: PawlyTypography.eyebrow),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: PawlyTypography.sectionTitle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: 8),
            action!,
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 7. TagChip — pill-shaped label tag
// ─────────────────────────────────────────────────────────────────────────────
class TagChip extends StatelessWidget {
  final String label;

  const TagChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTokens.pill),
        border: Border.all(color: PawlyColors.border),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: PawlyColors.charcoal,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 8. StatusBadge — supports both old (variant:) and new (backgroundColor:) API
// ─────────────────────────────────────────────────────────────────────────────

/// Old enum, kept for backward compat
enum PawlyBadgeVariant { slate, alert, sage, honey }

class StatusBadge extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final PawlyBadgeVariant? variant;

  const StatusBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.variant,
  });

  Color get _bg {
    if (backgroundColor != null) return backgroundColor!;
    switch (variant) {
      case PawlyBadgeVariant.alert:
        return PawlyColors.alertLight;
      case PawlyBadgeVariant.sage:
        return const Color(0xFFDFEFE3);
      case PawlyBadgeVariant.honey:
        return const Color(0xFFFFF0D6);
      case PawlyBadgeVariant.slate:
      default:
        return PawlyColors.surfaceWarm;
    }
  }

  Color get _fg {
    if (textColor != null) return textColor!;
    switch (variant) {
      case PawlyBadgeVariant.alert:
        return PawlyColors.alert;
      case PawlyBadgeVariant.sage:
        return const Color(0xFF2E7D4F);
      case PawlyBadgeVariant.honey:
        return const Color(0xFF8A6200);
      case PawlyBadgeVariant.slate:
      default:
        return PawlyColors.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(AppTokens.pill),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _fg,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 9. EmptyStateView — supports both (icon required) and (icon optional) + old
//    (actionLabel/onAction) and new (buttonLabel/onButtonPressed) params
// ─────────────────────────────────────────────────────────────────────────────
class EmptyStateView extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String subtitle;

  // New API
  final String? buttonLabel;
  final VoidCallback? onButtonPressed;

  // Old API
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateView({
    super.key,
    this.icon,
    required this.title,
    required this.subtitle,
    this.buttonLabel,
    this.onButtonPressed,
    this.actionLabel,
    this.onAction,
  });

  String? get _ctaLabel => buttonLabel ?? actionLabel;
  VoidCallback? get _ctaAction => onButtonPressed ?? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.pets_outlined,
              size: 36,
              color: PawlyColors.tertiary,
            ),
            const SizedBox(height: 12),
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
            if (_ctaLabel != null && _ctaAction != null) ...[
              const SizedBox(height: 18),
              PawlyButton(
                text: _ctaLabel!,
                onPressed: _ctaAction!,
                isSmall: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 10. CareTimelineItem — supports subtitle:, isLast:, assignedTo: optionally
// ─────────────────────────────────────────────────────────────────────────────
class CareTimelineItem extends StatelessWidget {
  final String time;
  final String title;
  final String? subtitle;
  final bool isCompleted;
  final bool isLast;
  final String? assignedTo;
  final VoidCallback onToggle;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const CareTimelineItem({
    super.key,
    required this.time,
    required this.title,
    this.subtitle,
    required this.isCompleted,
    this.isLast = false,
    this.assignedTo,
    required this.onToggle,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time column
          SizedBox(
            width: 52,
            child: Text(
              time,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isCompleted ? PawlyColors.tertiary : PawlyColors.secondary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted ? PawlyColors.tertiary : PawlyColors.charcoal,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: PawlyTypography.caption,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
                if (assignedTo != null && assignedTo!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'By ${assignedTo!}',
                    style: PawlyTypography.caption,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Actions: Delete & Toggle
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, size: 18, color: PawlyColors.tertiary),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              onPressed: onDelete,
            ),
          // Toggle
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(top: 1),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted ? PawlyColors.black : PawlyColors.border,
                  width: 1.5,
                ),
                color: isCompleted ? PawlyColors.black : Colors.transparent,
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 13, color: Colors.white)
                  : null,
            ),
          ),
        ],
      ),
    );
    return onTap != null ? GestureDetector(onTap: onTap, child: content) : content;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 11. PetSwitcher — horizontal pet avatar row with add button
// ─────────────────────────────────────────────────────────────────────────────
class PetSwitcher extends StatelessWidget {
  final List<Pet> pets;
  final String selectedPetId;
  final ValueChanged<String>? onSelectPet;
  final ValueChanged<String>? onPetSelected; // backward-compat alias
  final VoidCallback? onAddPet;

  const PetSwitcher({
    super.key,
    required this.pets,
    required this.selectedPetId,
    this.onSelectPet,
    this.onPetSelected,
    this.onAddPet,
  });

  void _select(String id) {
    (onSelectPet ?? onPetSelected)?.call(id);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          ...pets.map((pet) {
            final isSelected = pet.id == selectedPetId;
            return Padding(
              padding: const EdgeInsets.only(right: 14),
              child: GestureDetector(
                onTap: () => _select(pet.id),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PetAvatar(
                      imageUrl: pet.imageUrl,
                      radius: 24,
                      isSelected: isSelected,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pet.name,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                        color: isSelected ? PawlyColors.black : PawlyColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          if (onAddPet != null)
            GestureDetector(
              onTap: onAddPet,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: PawlyColors.border, width: 1),
                      color: PawlyColors.surfaceWarm,
                    ),
                    child: const Icon(Icons.add, color: PawlyColors.secondary, size: 20),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 11,
                      color: PawlyColors.tertiary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 12. DateBubble — compact date block (used in appointments/calendar)
// ─────────────────────────────────────────────────────────────────────────────
class DateBubble extends StatelessWidget {
  final String month;
  final String day;
  final Color color;

  const DateBubble({
    super.key,
    required this.month,
    required this.day,
    this.color = PawlyColors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppTokens.r10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            month.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            day,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 13. MetricBubble — numeric metric tile (weight, vaccine count, etc.)
// ─────────────────────────────────────────────────────────────────────────────
class MetricBubble extends StatelessWidget {
  final String value;
  final String label;
  final IconData? icon;

  const MetricBubble({
    super.key,
    required this.value,
    required this.label,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: PawlyColors.secondary),
          const SizedBox(height: 4),
        ],
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: PawlyColors.black,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: PawlyTypography.caption),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 14. PhotoOverlayBubble — image with overlay text (memories/journal)
// ─────────────────────────────────────────────────────────────────────────────
class PhotoOverlayBubble extends StatelessWidget {
  final String imageUrl;
  final String? caption;
  final double height;

  const PhotoOverlayBubble({
    super.key,
    required this.imageUrl,
    this.caption,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppTokens.r18),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(color: PawlyColors.surfaceWarm),
            ),
            if (caption != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0xCC111111)],
                    ),
                  ),
                  child: Text(
                    caption!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
