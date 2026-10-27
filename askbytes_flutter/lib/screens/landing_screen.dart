import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../state/auth_state.dart';
import '../theme.dart';
import '../widgets/brand.dart';

/// `/` — first impression: sign in as a speaker, or jump in with a code.
class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final _code = TextEditingController();
  bool? _speaker;

  @override
  void initState() {
    super.initState();
    authState.isSpeaker().then((v) {
      if (mounted) setState(() => _speaker = v);
    });
  }

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  void _join() {
    final code = _code.text.trim().toUpperCase();
    if (code.isEmpty) return;
    context.go('/join/$code');
  }

  @override
  Widget build(BuildContext context) {
    final speaker = _speaker == true;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(child: BrandMark(size: 30)),
                  const SizedBox(height: 40),
                  ShaderMask(
                    shaderCallback: (r) => AppColors.gradient.createShader(r),
                    child: const Text(
                      'Every question,\nheard.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 46,
                        height: 1.05,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Live, AI-moderated Q&A for conference talks. Attendees '
                    'scan a QR code, ask, upvote. Duplicates merge themselves.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 16.5,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 36),
                  FilledButton.icon(
                    onPressed: () =>
                        context.go(speaker ? '/dashboard' : '/signin'),
                    icon: Icon(
                      speaker ? Icons.dashboard_rounded : Icons.mic_rounded,
                    ),
                    label: Text(
                      speaker ? 'Open my dashboard' : 'Sign in as Speaker',
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.outline)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'Got a QR code?',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      ),
                      Expanded(child: Divider(color: AppColors.outline)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _code,
                          textCapitalization: TextCapitalization.characters,
                          textInputAction: TextInputAction.go,
                          maxLength: 6,
                          onSubmitted: (_) => _join(),
                          style: const TextStyle(
                            letterSpacing: 4,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'ABC123',
                            counterText: '',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      FilledButton(
                        onPressed: _join,
                        child: const Text('Join'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
