import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// KamraiCard — glass card, optionally highlighted (selected = green tint)
// ─────────────────────────────────────────────────────────────────────────────
class KamraiCard extends StatelessWidget {
  const KamraiCard({
    super.key,
    required this.child,
    this.selected = false,
    this.padding = const EdgeInsets.all(20),
    this.onTap,
  });

  final Widget child;
  final bool selected;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFE8F5EE) // green-tinted when selected
              : const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? const Color(0xFF006A30)
                : const Color(0xFFDFE3E6),
            width: selected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0x0A000000),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// KamraiGlassCard — frosted-glass variant (used for ambient backgrounds)
// ─────────────────────────────────────────────────────────────────────────────
class KamraiGlassCard extends StatelessWidget {
  const KamraiGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 16.0,
    this.blurSigma = 20.0,
  });

  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;
  /// Backdrop blur radius. Default 20 matches the Kamrai glassmorphism spec.
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xA6FFFFFF),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: const Color(0x66FFFFFF)),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// KamraiButton — 4 variants: primary / secondary / danger / ghost
// ─────────────────────────────────────────────────────────────────────────────
enum KamraiButtonVariant { primary, secondary, danger, ghost }

class KamraiButton extends StatefulWidget {
  const KamraiButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.variant = KamraiButtonVariant.primary,
    this.width,
    this.height = 44,
    this.loading = false,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final KamraiButtonVariant variant;
  final double? width;
  final double height;
  final bool loading;

  @override
  State<KamraiButton> createState() => _KamraiButtonState();
}

class _KamraiButtonState extends State<KamraiButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null && !widget.loading;

    return MouseRegion(
      cursor: disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.loading ? null : widget.onPressed,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: disabled ? 0.45 : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: widget.width,
            height: widget.height,
            transform: Matrix4.translationValues(
                0, _hovered && !disabled ? -1 : 0, 0),
            decoration: _decoration(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisSize: widget.width == null
                  ? MainAxisSize.min
                  : MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.loading)
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: _foreground(),
                    ),
                  )
                else if (widget.icon != null) ...[
                  Icon(widget.icon, size: 18, color: _foreground()),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.label,
                  style: GoogleFonts.prompt(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _foreground(),
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _decoration() {
    switch (widget.variant) {
      case KamraiButtonVariant.primary:
        return BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(10),
          boxShadow: _hovered
              ? [
                  const BoxShadow(
                    color: Color(0x40006A30),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  )
                ]
              : [],
        );
      case KamraiButtonVariant.secondary:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary, width: 1.5),
        );
      case KamraiButtonVariant.danger:
        return BoxDecoration(
          color: _hovered
              ? const Color(0xFFCC0000)
              : const Color(0xFFE53935),
          borderRadius: BorderRadius.circular(10),
        );
      case KamraiButtonVariant.ghost:
        return BoxDecoration(
          color: _hovered
              ? const Color(0x0F006A30)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        );
    }
  }

  Color _foreground() {
    switch (widget.variant) {
      case KamraiButtonVariant.primary:
        return Colors.white;
      case KamraiButtonVariant.secondary:
        return AppColors.primary;
      case KamraiButtonVariant.danger:
        return Colors.white;
      case KamraiButtonVariant.ghost:
        return AppColors.primary;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// KamraiSectionLabel — uppercase label with green left bar
// ─────────────────────────────────────────────────────────────────────────────
class KamraiSectionLabel extends StatelessWidget {
  const KamraiSectionLabel(this.label, {super.key, this.bottom = 12});
  final String label;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.prompt(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// KamraiTextField — labelled text input with green focus border
// ─────────────────────────────────────────────────────────────────────────────
class KamraiTextField extends StatelessWidget {
  const KamraiTextField({
    super.key,
    required this.label,
    this.hint = '',
    this.controller,
    this.keyboardType,
    this.suffix,
    this.enabled = true,
    this.onChanged,
  });

  final String label;
  final String hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Widget? suffix;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.prompt(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          enabled: enabled,
          onChanged: onChanged,
          style: GoogleFonts.prompt(
            fontSize: 14,
            color: AppColors.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.prompt(
              fontSize: 14,
              color: AppColors.outlineVariant,
            ),
            suffixIcon: suffix,
            filled: true,
            fillColor: enabled
                ? const Color(0xFFFAFAFA)
                : const Color(0xFFF0F0F0),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFDFE3E6)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFDFE3E6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFEEF1F3)),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// KamraiSegmentedOption — data model for segmented control items
// ─────────────────────────────────────────────────────────────────────────────
class KamraiSegmentedOption<T> {
  const KamraiSegmentedOption({
    required this.value,
    required this.label,
    this.icon,
    this.sublabel,
  });

  final T value;
  final String label;
  final IconData? icon;
  final String? sublabel;
}

// ─────────────────────────────────────────────────────────────────────────────
// KamraiSegmented — segmented control with icon+label+sublabel support
// ─────────────────────────────────────────────────────────────────────────────
class KamraiSegmented<T> extends StatelessWidget {
  const KamraiSegmented({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.compact = false,
  });

  final List<KamraiSegmentedOption<T>> options;
  final T selected;
  final ValueChanged<T> onChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDFE3E6)),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: options.map((opt) {
          final isSelected = opt.value == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(opt.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 8 : 12,
                  vertical: compact ? 8 : 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isSelected
                      ? [
                          const BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          )
                        ]
                      : [],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (opt.icon != null) ...[
                      Icon(
                        opt.icon,
                        size: compact ? 16 : 20,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.onSurfaceVariant,
                      ),
                      const SizedBox(height: 4),
                    ],
                    Text(
                      opt.label,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.prompt(
                        fontSize: compact ? 12 : 13,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.onSurfaceVariant,
                      ),
                    ),
                    if (opt.sublabel != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        opt.sublabel!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.prompt(
                          fontSize: 10,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.outlineVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// KamraiSwitch — labelled toggle switch
// ─────────────────────────────────────────────────────────────────────────────
class KamraiSwitch extends StatelessWidget {
  const KamraiSwitch({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.sublabel,
  });

  final String label;
  final String? sublabel;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.prompt(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurface,
                ),
              ),
              if (sublabel != null)
                Text(
                  sublabel!,
                  style: GoogleFonts.prompt(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.primary,
          activeTrackColor: const Color(0xFF3AE97A),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// KamraiStatPill — coloured count + label pill (used in table status bars)
// ─────────────────────────────────────────────────────────────────────────────
class KamraiStatPill extends StatelessWidget {
  const KamraiStatPill({
    super.key,
    required this.count,
    required this.label,
    required this.color,
  });

  final int count;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 5),
          Text(
            '$count $label',
            style: GoogleFonts.prompt(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// KamraiPulseDot — animated pulsing status dot
//   Consolidates _PulseDot (home_screen) and _PulsingDot (tables_screen)
// ─────────────────────────────────────────────────────────────────────────────
class KamraiPulseDot extends StatefulWidget {
  const KamraiPulseDot({
    super.key,
    required this.color,
    this.size = 8.0,
    this.pulse = true,
  });

  final Color color;
  final double size;
  /// When false the dot is rendered statically (no animation controller overhead).
  final bool pulse;

  @override
  State<KamraiPulseDot> createState() => _KamraiPulseDotState();
}

class _KamraiPulseDotState extends State<KamraiPulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.25, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dot = Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color),
    );
    if (!widget.pulse) return dot;
    return FadeTransition(opacity: _anim, child: dot);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// KamraiNavIconButton — 44×44 touch target wrapping a visual icon container
// ─────────────────────────────────────────────────────────────────────────────
class KamraiNavIconButton extends StatelessWidget {
  const KamraiNavIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.visualSize = 36.0,
  });

  final IconData icon;
  final VoidCallback onTap;
  /// The visible container size. Touch target is always 44×44.
  final double visualSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 44,
        height: 44,
        child: Center(
          child: Container(
            width: visualSize,
            height: visualSize,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.onSurface),
          ),
        ),
      ),
    );
  }
}
