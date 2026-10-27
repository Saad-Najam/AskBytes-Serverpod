import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';
import '../state/auth_state.dart';
import '../state/live_session.dart';
import '../theme.dart';
import '../widgets/brand.dart';
import '../widgets/question_card.dart';
import '../widgets/ranked_list.dart';
import '../widgets/recap_view.dart';

/// `/join/:code` — the attendee's phone view.
class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key, required this.code});

  final String code;

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  late final LiveSessionController _live;
  final _input = TextEditingController();
  final _voted = <int>{};

  bool _joining = true;
  String? _joinError;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _live = LiveSessionController(joinCode: widget.code.toUpperCase());
    _join();
  }

  Future<void> _join() async {
    setState(() {
      _joining = true;
      _joinError = null;
    });
    try {
      await authState.ensureAttendee();
      if (!client.auth.isAuthenticated) {
        throw StateError('Could not start an anonymous session.');
      }
      await _live.start();
      // Background: must not hold the loading spinner.
      unawaited(_restoreVotes());
    } catch (e) {
      _joinError = errorMessage(e);
    }
    if (mounted) setState(() => _joining = false);
  }

  /// Re-lights the vote buttons for questions this attendee already voted on.
  Future<void> _restoreVotes() async {
    // The session id is only known once the first snapshot arrives.
    for (var i = 0; i < 40 && _live.session == null; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
    }
    final id = _live.session?.id;
    if (id == null) return;
    try {
      final ids = await client.question.getMyVotes(id);
      if (mounted) setState(() => _voted.addAll(ids));
    } catch (_) {
      // Non-critical: the server still rejects duplicate votes.
    }
  }

  @override
  void dispose() {
    _live.dispose();
    _input.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _input.text.trim();
    final id = _live.session?.id;
    if (text.isEmpty || id == null || _sending) return;
    setState(() => _sending = true);
    try {
      final result = await client.question.postQuestion(id, text);
      _live.applyLocal(result.question);
      _input.clear();
      if (!mounted) return;
      if (result.merged) {
        showInfo(context, result.message);
      }
    } catch (e) {
      if (mounted) showError(context, errorMessage(e));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _vote(int questionId) async {
    if (_voted.contains(questionId)) return;
    setState(() => _voted.add(questionId));
    try {
      final updated = await client.question.upvoteQuestion(questionId);
      _live.applyLocal(updated);
    } catch (e) {
      final msg = errorMessage(e);
      // "already voted" keeps the button lit; anything else rolls back.
      if (!msg.toLowerCase().contains('already')) {
        if (mounted) setState(() => _voted.remove(questionId));
      }
      if (mounted) showError(context, msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _live,
      builder: (context, _) {
        final error = _joinError ?? _live.error;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => context.go('/'),
            ),
            title: _live.session == null
                ? const BrandMark(size: 18)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _live.session!.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        _live.session!.speakerName,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
            actions: [
              if (_live.session != null && !_live.isEnded)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: LiveDot(connected: _live.connected),
                ),
            ],
          ),
          body: SafeArea(child: _body(error)),
        );
      },
    );
  }

  Widget _body(String? error) {
    if (_joining || (error == null && !_live.isLoaded)) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null && !_live.isLoaded) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, size: 40),
              const SizedBox(height: 12),
              Text(error, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              OutlinedButton(onPressed: _join, child: const Text('Try again')),
            ],
          ),
        ),
      );
    }

    final questions = _live.questions;
    final recap = _live.recap;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: PageBody(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_live.isEnded) ...[
                    const _EndedBanner(),
                    const SizedBox(height: 16),
                    if (recap != null) ...[
                      const Text(
                        '📝 Session Recap',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 14),
                      RecapView(recap: recap),
                      const SizedBox(height: 14),
                      OutlinedButton.icon(
                        onPressed: () =>
                            context.go('/recap/${_live.session!.id}'),
                        icon: const Icon(Icons.open_in_new_rounded),
                        label: const Text('Open shareable recap'),
                      ),
                    ] else
                      const _RecapPending(),
                  ] else if (questions.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Text(
                        'No questions yet.\nBe the first to ask!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 16,
                          height: 1.5,
                        ),
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
                            voted: _voted.contains(questions[i].id),
                            onVote: () => _vote(questions[i].id!),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
        if (!_live.isEnded) _composer(),
      ],
    );
  }

  Widget _composer() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.outline)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: PageBody(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _input,
                maxLength: 500,
                minLines: 1,
                maxLines: 3,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _submit(),
                decoration: const InputDecoration(
                  hintText: 'Ask a question…',
                  counterText: '',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 52,
              width: 52,
              child: FilledButton(
                onPressed: _sending ? null : _submit,
                style: FilledButton.styleFrom(padding: EdgeInsets.zero),
                child: _sending
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      )
                    : const Icon(Icons.send_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EndedBanner extends StatelessWidget {
  const _EndedBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
      ),
      child: const Row(
        children: [
          Icon(Icons.lock_clock_rounded, color: AppColors.warning),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Session ended. Questions are closed.',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecapPending extends StatelessWidget {
  const _RecapPending();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'AI is writing the recap…',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
