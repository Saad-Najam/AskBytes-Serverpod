import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../client.dart';
import '../state/live_session.dart';
import '../theme.dart';
import '../widgets/brand.dart';
import '../widgets/question_card.dart';
import '../widgets/ranked_list.dart';
import 'create_session_screen.dart' show joinUrl;

/// `/manage/:sessionId` — the speaker's live control room.
class ManageScreen extends StatefulWidget {
  const ManageScreen({super.key, required this.sessionId});

  final int sessionId;

  @override
  State<ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  late final LiveSessionController _live;
  bool _ending = false;

  @override
  void initState() {
    super.initState();
    _live = LiveSessionController(sessionId: widget.sessionId)..start();
  }

  @override
  void dispose() {
    _live.dispose();
    super.dispose();
  }

  Future<void> _end() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End this session?'),
        content: const Text(
          'Attendees can no longer post or vote, and the AI recap is '
          'generated and sent to everyone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('End session'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _ending = true);
    try {
      await client.session.endSession(widget.sessionId);
      if (mounted) context.go('/recap/${widget.sessionId}');
    } catch (e) {
      if (mounted) {
        showError(context, errorMessage(e));
        setState(() => _ending = false);
      }
    }
  }

  Future<void> _pin(int id) async {
    try {
      _live.applyLocal(await client.question.togglePin(id));
    } catch (e) {
      if (mounted) showError(context, errorMessage(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _live,
      builder: (context, _) {
        final session = _live.session;
        final questions = _live.questions;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => context.go('/dashboard'),
            ),
            title: Text(
              session?.title ?? 'Session',
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              if (session != null)
                IconButton(
                  tooltip: 'Open big screen',
                  onPressed: () => context.go('/present/${session.id}'),
                  icon: const Icon(Icons.tv_rounded),
                ),
              if (session != null && !_live.isEnded)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: LiveDot(connected: _live.connected),
                ),
            ],
          ),
          body: SafeArea(
            child: session == null
                ? Center(
                    child: _live.error == null
                        ? const CircularProgressIndicator()
                        : Text(_live.error!),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: PageBody(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _header(session.joinCode),
                          const SizedBox(height: 16),
                          if (_live.isEnded)
                            OutlinedButton.icon(
                              onPressed: () =>
                                  context.go('/recap/${session.id}'),
                              icon: const Icon(Icons.article_rounded),
                              label: const Text('View recap'),
                            )
                          else
                            FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.danger,
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(56),
                              ),
                              onPressed: _ending ? null : _end,
                              icon: _ending
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.stop_circle_rounded),
                              label: Text(
                                _ending ? 'Generating recap…' : 'End Session',
                              ),
                            ),
                          const SizedBox(height: 20),
                          Text(
                            '${questions.length} QUESTION'
                            '${questions.length == 1 ? '' : 'S'}',
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              fontSize: 12.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (questions.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 50),
                              child: Text(
                                'Waiting for the first question…',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: AppColors.textMuted),
                              ),
                            )
                          else
                            RankedList(
                              children: [
                                for (var i = 0; i < questions.length; i++)
                                  QuestionCard(
                                    key: ValueKey(questions[i].id),
                                    question: questions[i],
                                    rank: i + 1,
                                    highlight: i < 3,
                                    onPin: _live.isEnded
                                        ? null
                                        : () => _pin(questions[i].id!),
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _header(String code) {
    final url = joinUrl(code);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'JOIN CODE',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    code,
                    style: const TextStyle(
                      fontSize: 30,
                      letterSpacing: 6,
                      fontWeight: FontWeight.w900,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),
            IconButton.outlined(
              tooltip: 'Copy join link',
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: url));
                if (mounted) showInfo(context, 'Join link copied');
              },
              icon: const Icon(Icons.copy_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
