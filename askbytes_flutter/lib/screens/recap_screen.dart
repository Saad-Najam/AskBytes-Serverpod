import 'dart:async';

import 'package:askbytes_client/askbytes_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../client.dart';
import '../state/live_session.dart';
import '../theme.dart';
import '../widgets/brand.dart';
import '../widgets/recap_view.dart';

/// `/recap/:sessionId` — public, shareable AI recap.
class RecapScreen extends StatefulWidget {
  const RecapScreen({super.key, required this.sessionId});

  final int sessionId;

  @override
  State<RecapScreen> createState() => _RecapScreenState();
}

class _RecapScreenState extends State<RecapScreen> {
  SessionSnapshot? _snapshot;
  SessionRecap? _recap;
  SessionStats? _stats;
  String? _error;
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final snapshot = await client.session.getSessionById(widget.sessionId);
      if (!mounted) return;
      setState(() {
        _snapshot = snapshot;
        _recap = snapshot.recap;
      });
      client.session
          .getStats(widget.sessionId)
          .then((stats) {
            if (mounted) setState(() => _stats = stats);
          })
          .catchError((_) {});
      // The speaker may land here while the AI is still writing.
      if (_recap == null) {
        _poll = Timer.periodic(const Duration(seconds: 3), (t) async {
          final r = await client.recap.getRecap(widget.sessionId);
          if (r != null && mounted) {
            t.cancel();
            setState(() => _recap = r);
          }
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = errorMessage(e));
    }
  }

  String _date(DateTime d) {
    final l = d.toLocal();
    const m = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${m[l.month - 1]} ${l.day}, ${l.year}';
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = _snapshot;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home_rounded),
          onPressed: () => context.go('/'),
        ),
        title: const BrandMark(size: 18),
        actions: [
          if (_recap != null)
            TextButton.icon(
              onPressed: () async {
                await Clipboard.setData(
                  ClipboardData(
                    text: '${Uri.base.origin}/recap/${widget.sessionId}',
                  ),
                );
                if (context.mounted) showInfo(context, 'Recap link copied');
              },
              icon: const Icon(Icons.ios_share_rounded, size: 18),
              label: const Text('Share'),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: _error != null
            ? Center(child: Text(_error!))
            : snapshot == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: PageBody(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.session.title,
                        style: const TextStyle(
                          fontSize: 30,
                          height: 1.15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${snapshot.session.speakerName} · '
                        '${_date(snapshot.session.createdAt)}',
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 15.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_stats != null) _StatsRow(stats: _stats!),
                      const SizedBox(height: 24),
                      if (_recap == null)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Column(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text(
                                  'The recap isn\'t ready yet…',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        RecapView(recap: _recap!),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats});

  final SessionStats stats;

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.help_outline_rounded, '${stats.totalQuestions}', 'questions'),
      (Icons.arrow_upward_rounded, '${stats.totalVotes}', 'votes'),
      (Icons.merge_type_rounded, '${stats.mergedDuplicates}', 'merged'),
      (Icons.people_alt_rounded, '${stats.participants}', 'people'),
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final (icon, value, label) in items)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.outline),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: AppColors.accent),
                const SizedBox(width: 8),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  label,
                  style: const TextStyle(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
