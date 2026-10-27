import 'package:askbytes_client/askbytes_client.dart';
import 'package:flutter/material.dart';

import '../theme.dart';
import 'brand.dart';

/// Animated vote counter button.
class VoteButton extends StatelessWidget {
  const VoteButton({
    super.key,
    required this.count,
    required this.voted,
    required this.onPressed,
  });

  final int count;
  final bool voted;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final color = voted ? AppColors.accent : AppColors.textMuted;
    return Semantics(
      button: true,
      label: 'Upvote, $count votes',
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 56,
          height: 64,
          decoration: BoxDecoration(
            color: voted
                ? AppColors.accent.withValues(alpha: 0.14)
                : AppColors.surfaceHigh,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: voted ? AppColors.accent : AppColors.outline,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_upward_rounded, color: color, size: 22),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, anim) => ScaleTransition(
                  scale: anim,
                  child: FadeTransition(opacity: anim, child: child),
                ),
                child: Text(
                  '$count',
                  key: ValueKey(count),
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A single question in the attendee and speaker lists.
class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.question,
    required this.rank,
    this.voted = false,
    this.onVote,
    this.onPin,
    this.highlight = false,
  });

  final Question question;
  final int rank;
  final bool voted;
  final VoidCallback? onVote;
  final VoidCallback? onPin;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: question.pinned
              ? AppColors.warning
              : highlight
              ? AppColors.accent.withValues(alpha: 0.6)
              : AppColors.outline,
          width: question.pinned || highlight ? 1.5 : 1,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VoteButton(
            count: question.voteCount,
            voted: voted,
            onPressed: onVote,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.text,
                  style: const TextStyle(fontSize: 16.5, height: 1.35),
                ),
                if (question.pinned || question.mergeNote != null) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (question.pinned)
                        const Pill(
                          'Pinned',
                          color: AppColors.warning,
                          icon: Icons.push_pin_rounded,
                        ),
                      if (question.mergeNote != null)
                        Pill(
                          question.mergeNote!,
                          color: AppColors.accentAlt,
                          icon: Icons.merge_type_rounded,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (onPin != null)
            IconButton(
              tooltip: question.pinned ? 'Unpin' : 'Pin',
              onPressed: onPin,
              icon: Icon(
                question.pinned
                    ? Icons.push_pin_rounded
                    : Icons.push_pin_outlined,
                color: question.pinned
                    ? AppColors.warning
                    : AppColors.textMuted,
              ),
            ),
        ],
      ),
    );
  }
}
