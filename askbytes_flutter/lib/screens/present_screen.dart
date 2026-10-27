import 'dart:async';

import 'package:askbytes_client/askbytes_client.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../state/live_session.dart';
import '../theme.dart';
import '../widgets/brand.dart';

/// `/present/:sessionId` — projector mode. Giant top question, cycling through
/// the top three every 15 seconds.
class PresentScreen extends StatefulWidget {
  const PresentScreen({super.key, required this.sessionId});

  final int sessionId;

  @override
  State<PresentScreen> createState() => _PresentScreenState();
}

class _PresentScreenState extends State<PresentScreen> {
  static const _cycle = Duration(seconds: 15);

  late final LiveSessionController _live;
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _live = LiveSessionController(sessionId: widget.sessionId)..start();
    _timer = Timer.periodic(_cycle, (_) {
      final count = _live.questions.take(3).length;
      if (count > 1) setState(() => _index = (_index + 1) % count);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _live.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _live,
      builder: (context, _) {
        final session = _live.session;
        final top = _live.questions.take(3).toList();
        final i = top.isEmpty ? 0 : _index % top.length;
        final Question? current = top.isEmpty ? null : top[i];

        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 32, 40, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const BrandMark(size: 22),
                          const Spacer(),
                          if (top.isNotEmpty)
                            Text(
                              '#${i + 1} of ${top.length}',
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                        ],
                      ),
                      Expanded(
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 600),
                            switchInCurve: Curves.easeOutCubic,
                            transitionBuilder: (child, anim) => FadeTransition(
                              opacity: anim,
                              child: SlideTransition(
                                position: Tween(
                                  begin: const Offset(0, 0.06),
                                  end: Offset.zero,
                                ).animate(anim),
                                child: child,
                              ),
                            ),
                            child: current == null
                                ? const Text(
                                    'Scan the QR code and ask\nyour question',
                                    key: ValueKey('empty'),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 44,
                                      color: AppColors.textMuted,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )
                                : _BigQuestion(
                                    key: ValueKey(current.id),
                                    question: current,
                                  ),
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  session?.title ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  session?.speakerName ?? '',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (session != null && !_live.isEnded)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.outline),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                'Join: ${session.joinCode}',
                                style: const TextStyle(
                                  fontSize: 26,
                                  letterSpacing: 4,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.accent,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 4,
                  left: 4,
                  child: IconButton(
                    tooltip: 'Back',
                    color: AppColors.outline,
                    onPressed: () => context.go('/manage/${widget.sessionId}'),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BigQuestion extends StatelessWidget {
  const _BigQuestion({super.key, required this.question});

  final Question question;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Text(
                question.text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 64,
                  height: 1.15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.arrow_upward_rounded,
              size: 40,
              color: AppColors.accent,
            ),
            const SizedBox(width: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                '${question.voteCount}',
                key: ValueKey(question.voteCount),
                style: const TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  color: AppColors.accent,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
