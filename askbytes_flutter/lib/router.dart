import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/create_session_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/join_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/manage_screen.dart';
import 'screens/present_screen.dart';
import 'screens/recap_screen.dart';
import 'screens/sign_in_screen.dart';
import 'state/auth_state.dart';

/// Routes that only a signed-in speaker may open.
bool _needsSpeaker(String path) =>
    path == '/dashboard' ||
    path.startsWith('/session/') ||
    path.startsWith('/manage/');

final router = GoRouter(
  refreshListenable: authState,
  redirect: (context, state) async {
    final path = state.uri.path;
    if (_needsSpeaker(path) && !await authState.isSpeaker()) {
      return '/signin';
    }
    return null;
  },
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Page not found'),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => context.go('/'),
            child: const Text('Go home'),
          ),
        ],
      ),
    ),
  ),
  routes: [
    GoRoute(path: '/', builder: (_, _) => const LandingScreen()),
    GoRoute(path: '/signin', builder: (_, _) => const SignInScreen()),
    GoRoute(path: '/dashboard', builder: (_, _) => const DashboardScreen()),
    GoRoute(
      path: '/session/create',
      builder: (_, _) => const CreateSessionScreen(),
    ),
    GoRoute(
      path: '/join/:code',
      builder: (_, state) => JoinScreen(code: state.pathParameters['code']!),
    ),
    GoRoute(
      path: '/manage/:sessionId',
      builder: (_, state) => ManageScreen(
        sessionId: int.parse(state.pathParameters['sessionId']!),
      ),
    ),
    GoRoute(
      path: '/present/:sessionId',
      builder: (_, state) => PresentScreen(
        sessionId: int.parse(state.pathParameters['sessionId']!),
      ),
    ),
    GoRoute(
      path: '/recap/:sessionId',
      builder: (_, state) => RecapScreen(
        sessionId: int.parse(state.pathParameters['sessionId']!),
      ),
    ),
  ],
);
