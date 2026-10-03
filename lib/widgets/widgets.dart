import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/pawly_colors.dart';
import '../theme/app_tokens.dart';
import '../theme/pawly_typography.dart';
import '../models/pet.dart';

ImageProvider pawlyImageProvider(String path) =>
    path.startsWith('assets/') ? AssetImage(path) : NetworkImage(path);

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
              if (showBack &&
                  (Navigator.canPop(context) || onBack != null)) ...[
                IconButton(
                  tooltip: 'Back',
                  onPressed: onBack ?? () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back,
                      color: PawlyColors.resolve(context, PawlyColors.black),
                      size: 22),
                  constraints:
                      const BoxConstraints(minWidth: 44, minHeight: 44),
                  padding: EdgeInsets.zero,
                ),
              ] else
                const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: PawlyTypography.resolve(
                      context, PawlyTypography.pageTitle),
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

class PawlyButton extends StatefulWidget {
  // New API
  final String? text;
  final bool isSecondary;
  final bool isSmall;

  // Old API aliases
  final String? label;
  final PawlyButtonVariant? variant;
  final bool? isFullWidth;
  final FutureOr<void> Function() onPressed;

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

  @override
  State<PawlyButton> createState() => _PawlyButtonState();
}

class _PawlyButtonState extends State<PawlyButton> {
  bool _busy = false;
  Future<void> _run() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await widget.onPressed();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Could not save this change. Please try again.')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String get _resolvedLabel => widget.text ?? widget.label ?? '';

  bool get _isSecondaryResolved {
    if (widget.variant == PawlyButtonVariant.secondary ||
        widget.variant == PawlyButtonVariant.clay) return true;
    return widget.isSecondary;
  }

  bool get _isFullWidth {
    if (widget.isFullWidth != null) return widget.isFullWidth!;
    return !widget.isSmall;
  }

  @override
  Widget build(BuildContext context) {
    final useSecondary = _isSecondaryResolved;
    return SizedBox(
      width: _isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: _busy ? null : _run,
        style: ElevatedButton.styleFrom(
          backgroundColor: useSecondary
              ? Theme.of(context).colorScheme.surface
              : Theme.of(context).colorScheme.primary,
          foregroundColor: useSecondary
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onPrimary,
          elevation: 0,
          padding: EdgeInsets.symmetric(
            vertical: widget.isSmall ? 10 : 16,
            horizontal: widget.isSmall ? 16 : 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.r14),
            side: useSecondary
                ? BorderSide(
                    color: PawlyColors.resolve(context, PawlyColors.border))
                : BorderSide.none,
          ),
        ),
        child: Text(
          _busy ? 'Working…' : _resolvedLabel,
          style: TextStyle(
            fontSize: widget.isSmall ? 13 : 15,
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
        color: backgroundColor ??
            PawlyColors.resolve(context, PawlyColors.surface),
        borderRadius: borderRadius ?? BorderRadius.circular(AppTokens.r18),
        border: Border.all(
            color:
                borderColor ?? PawlyColors.resolve(context, PawlyColors.border),
            width: 1),
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
            ? Border.all(
                color: PawlyColors.resolve(context, PawlyColors.black),
                width: 2)
            : Border.all(
                color: PawlyColors.resolve(context, PawlyColors.border),
                width: 1),
      ),
      child: ClipOval(
        child: Image(
          image: pawlyImageProvider(imageUrl),
          fit: BoxFit.contain,
          loadingBuilder: (context, child, progress) => progress == null
              ? child
              : Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(Icons.pets,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      size: 24)),
          errorBuilder: (_, __, ___) => Container(
            color: PawlyColors.resolve(context, PawlyColors.surfaceWarm),
            child: Icon(Icons.pets,
                color: PawlyColors.resolve(context, PawlyColors.tertiary),
                size: 20),
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
            Image(
              image: pawlyImageProvider(imageUrl),
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Container(
                  color: PawlyColors.resolve(context, PawlyColors.surfaceWarm)),
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
                Text(eyebrow.toUpperCase(),
                    style: PawlyTypography.resolve(
                        context, PawlyTypography.eyebrow)),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: PawlyTypography.resolve(
                      context, PawlyTypography.sectionTitle),
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
        border:
            Border.all(color: PawlyColors.resolve(context, PawlyColors.border)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: PawlyColors.resolve(context, PawlyColors.charcoal),
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

  Color _bg(BuildContext context) {
    if (backgroundColor != null) return backgroundColor!;
    switch (variant) {
      case PawlyBadgeVariant.alert:
        return PawlyColors.resolve(context, PawlyColors.alertLight);
      case PawlyBadgeVariant.sage:
        return PawlyColors.resolve(context, PawlyColors.surfaceWarm);
      case PawlyBadgeVariant.honey:
        return PawlyColors.resolve(context, PawlyColors.surfaceWarm);
      case PawlyBadgeVariant.slate:
      default:
        return PawlyColors.resolve(context, PawlyColors.surfaceWarm);
    }
  }

  Color _fg(BuildContext context) {
    if (textColor != null) return textColor!;
    switch (variant) {
      case PawlyBadgeVariant.alert:
        return PawlyColors.resolve(context, PawlyColors.alert);
      case PawlyBadgeVariant.sage:
        return PawlyColors.resolve(context, PawlyColors.secondary);
      case PawlyBadgeVariant.honey:
        return PawlyColors.resolve(context, PawlyColors.secondary);
      case PawlyBadgeVariant.slate:
      default:
        return PawlyColors.resolve(context, PawlyColors.secondary);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _bg(context),
        borderRadius: BorderRadius.circular(AppTokens.pill),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _fg(context),
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
              color: PawlyColors.resolve(context, PawlyColors.tertiary),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style:
                  PawlyTypography.resolve(context, PawlyTypography.titleMedium),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style:
                  PawlyTypography.resolve(context, PawlyTypography.bodyMedium),
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
  final String? petImageUrl;
  final String? petName;
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
    this.petImageUrl,
    this.petName,
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
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (petImageUrl != null) ...[
                    Semantics(
                        label: 'Care for ${petName ?? "your pet"}',
                        image: true,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                                width: 44,
                                height: 44,
                                child: Image(
                                    image: pawlyImageProvider(petImageUrl!),
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => const Icon(
                                        Icons.pets_outlined,
                                        size: 24))))),
                    const SizedBox(height: 6),
                  ],
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isCompleted
                          ? PawlyColors.resolve(context, PawlyColors.tertiary)
                          : PawlyColors.resolve(context, PawlyColors.secondary),
                    ),
                  )
                ]),
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
                    color: isCompleted
                        ? PawlyColors.resolve(context, PawlyColors.tertiary)
                        : PawlyColors.resolve(context, PawlyColors.charcoal),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: PawlyTypography.resolve(
                        context, PawlyTypography.caption),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
                if (assignedTo != null && assignedTo!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'By ${assignedTo!}',
                    style: PawlyTypography.resolve(
                        context, PawlyTypography.caption),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Actions: Delete & Toggle
          if (onDelete != null)
            IconButton(
              icon: Icon(Icons.delete_outline_rounded,
                  size: 18,
                  color: PawlyColors.resolve(context, PawlyColors.tertiary)),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
              tooltip: 'Delete routine',
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                            title: Text('Remove $title?'),
                            content: const Text(
                                'This removes the routine from your care schedule.'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Keep routine')),
                              TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('Remove'))
                            ]));
                if (confirmed == true) onDelete!();
              },
            ),
          // A real checkbox gives screen readers checked state and a 48px target.
          Semantics(
              label: title,
              child:
                  Checkbox(value: isCompleted, onChanged: (_) => onToggle())),
        ],
      ),
    );
    return onTap != null
        ? GestureDetector(onTap: onTap, child: content)
        : content;
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
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w400,
                        color: isSelected
                            ? PawlyColors.black
                            : PawlyColors.resolve(
                                context, PawlyColors.secondary),
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
                      border: Border.all(
                          color:
                              PawlyColors.resolve(context, PawlyColors.border),
                          width: 1),
                      color:
                          PawlyColors.resolve(context, PawlyColors.surfaceWarm),
                    ),
                    child: Icon(Icons.add,
                        color:
                            PawlyColors.resolve(context, PawlyColors.secondary),
                        size: 20),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 11,
                      color: PawlyColors.resolve(context, PawlyColors.tertiary),
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
          Icon(icon,
              size: 18,
              color: PawlyColors.resolve(context, PawlyColors.secondary)),
          const SizedBox(height: 4),
        ],
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: PawlyColors.resolve(context, PawlyColors.black),
          ),
        ),
        const SizedBox(height: 2),
        Text(label,
            style: PawlyTypography.resolve(context, PawlyTypography.caption)),
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
            Image(
              image: pawlyImageProvider(imageUrl),
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Container(
                  color: PawlyColors.resolve(context, PawlyColors.surfaceWarm)),
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

/// A keyboard-safe, scrollable sheet used by Pawly forms.
class PawlySheet extends StatelessWidget {
  final Widget child;
  const PawlySheet({super.key, required this.child});
  @override
  Widget build(BuildContext context) => SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
            24, 8, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: child,
      ));
}
