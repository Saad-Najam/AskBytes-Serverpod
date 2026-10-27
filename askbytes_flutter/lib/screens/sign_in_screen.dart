import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';
import '../state/auth_state.dart';
import '../theme.dart';
import '../widgets/brand.dart';

/// `/signin` — speakers sign in with email or Google.
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key, this.redirectTo});

  /// Where to go after signing in. Defaults to the dashboard.
  final String? redirectTo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/'),
        ),
        title: const BrandMark(size: 18),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Speaker sign in',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Create sessions, see live questions, get an AI recap.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 24),
                  SignInWidget(
                    client: client,
                    // Attendees never see this screen; they join anonymously.
                    disableAnonymousSignInWidget: true,
                    disableGoogleSignInWidget: !googleEnabled,
                    onAuthenticated: () {
                      if (context.mounted) {
                        context.go(redirectTo ?? '/dashboard');
                      }
                    },
                    onError: (error) {
                      if (context.mounted) {
                        showError(context, 'Sign in failed: $error');
                      }
                    },
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
