import 'dart:convert';

import 'package:askbytes_client/askbytes_client.dart';
import 'package:flutter/material.dart';

import '../theme.dart';
import 'brand.dart';

/// Renders an AI recap: theme tags, ranked top questions, follow-ups and the
/// full markdown summary.
class RecapView extends StatelessWidget {
  const RecapView({super.key, required this.recap});

  final SessionRecap recap;

  List<({String text, int votes})> get _top {
    try {
      final raw = json.decode(recap.topQuestions) as List;
      return [
        for (final item in raw)
          (
            text: (item as Map)['text'] as String,
            votes: (item['votes'] as num).toInt(),
          ),
      ];
    } catch (_) {
      return const [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final top = _top;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (recap.keyThemes.isNotEmpty) ...[
          const _SectionTitle('Key themes'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final t in recap.keyThemes)
                Pill(t, color: AppColors.accentAlt),
            ],
          ),
          const SizedBox(height: 24),
        ],
        if (top.isNotEmpty) ...[
          const _SectionTitle('Top questions'),
          for (var i = 0; i < top.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Text(
                        '${i + 1}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(child: Text(top[i].text)),
                      const SizedBox(width: 10),
                      Pill(
                        '${top[i].votes}',
                        icon: Icons.arrow_upward_rounded,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 14),
        ],
        if (recap.unanswered.isNotEmpty) ...[
          const _SectionTitle('Needs follow-up'),
          for (final q in recap.unanswered)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.help_outline_rounded,
                    size: 18,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(q)),
                ],
              ),
            ),
          const SizedBox(height: 14),
        ],
        const _SectionTitle('Full recap'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: MarkdownText(recap.summaryMarkdown),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: AppColors.textMuted,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          fontSize: 12.5,
        ),
      ),
    );
  }
}

/// Minimal markdown renderer: headings, bullets, numbered lines, **bold**.
class MarkdownText extends StatelessWidget {
  const MarkdownText(this.source, {super.key});

  final String source;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (final raw in source.split('\n')) {
      final line = raw.trimRight();
      if (line.trim().isEmpty) {
        children.add(const SizedBox(height: 8));
        continue;
      }
      final heading = RegExp(r'^(#{1,6})\s+(.*)$').firstMatch(line);
      if (heading != null) {
        children.add(
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: Text(
              heading.group(2)!,
              style: TextStyle(
                fontSize: heading.group(1)!.length <= 2 ? 18 : 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        );
        continue;
      }
      final bullet = RegExp(r'^\s*[-*]\s+(.*)$').firstMatch(line);
      final numbered = RegExp(r'^\s*(\d+)\.\s+(.*)$').firstMatch(line);
      if (bullet != null || numbered != null) {
        final marker = bullet != null ? '•' : '${numbered!.group(1)}.';
        final body = bullet?.group(1) ?? numbered!.group(2)!;
        children.add(
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    marker,
                    style: const TextStyle(color: AppColors.accent),
                  ),
                ),
                Expanded(child: _inline(body)),
              ],
            ),
          ),
        );
        continue;
      }
      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: _inline(line),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _inline(String text) {
    final spans = <InlineSpan>[];
    final pattern = RegExp(r'\*\*(.+?)\*\*');
    var cursor = 0;
    for (final m in pattern.allMatches(text)) {
      if (m.start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, m.start)));
      }
      spans.add(
        TextSpan(
          text: m.group(1),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      );
      cursor = m.end;
    }
    if (cursor < text.length) spans.add(TextSpan(text: text.substring(cursor)));
    return Text.rich(
      TextSpan(children: spans),
      style: const TextStyle(height: 1.4),
    );
  }
}
