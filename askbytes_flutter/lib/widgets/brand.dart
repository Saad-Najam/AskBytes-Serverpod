import 'package:flutter/material.dart';

import '../theme.dart';

/// The AskBytes wordmark.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 22});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size * 1.5,
          height: size * 1.5,
          decoration: BoxDecoration(
            gradient: AppColors.gradient,
            borderRadius: BorderRadius.circular(size * 0.45),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.forum_rounded,
            size: size,
            color: AppColors.background,
          ),
        ),
        SizedBox(width: size * 0.5),
        Text(
          'AskBytes',
          style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

/// Centers content and caps its width, with a 16px side gutter.
class PageBody extends StatelessWidget {
  const PageBody({super.key, required this.child, this.maxWidth = 760});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: child,
        ),
      ),
    );
  }
}

/// Small pill used for status and themes.
class Pill extends StatelessWidget {
  const Pill(this.label, {super.key, this.color = AppColors.accent, this.icon});

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 5),
          ],
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Live connection indicator.
class LiveDot extends StatelessWidget {
  const LiveDot({super.key, required this.connected});

  final bool connected;

  @override
  Widget build(BuildContext context) {
    return Pill(
      connected ? 'LIVE' : 'RECONNECTING',
      color: connected ? AppColors.success : AppColors.warning,
      icon: Icons.circle,
    );
  }
}

void _toast(BuildContext context, String message, Color color) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        // Keeps the toast clear of the sticky question composer.
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 92),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
}

void showError(BuildContext context, String message) =>
    _toast(context, message, AppColors.danger);

void showInfo(BuildContext context, String message) =>
    _toast(context, message, const Color(0xFF3B4A80));
