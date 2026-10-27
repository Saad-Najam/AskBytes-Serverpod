import 'package:askbytes_client/askbytes_client.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../client.dart';
import '../state/auth_state.dart';
import '../state/live_session.dart';
import '../theme.dart';
import '../widgets/brand.dart';

/// `/dashboard` — the speaker's sessions, past and active.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<TalkSession>> _sessions = client.session
      .getSpeakerSessions();

  void _reload() {
    setState(() => _sessions = client.session.getSpeakerSessions());
  }

  String _date(DateTime d) {
    final l = d.toLocal();
    const m = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${m[l.month - 1]} ${l.day}, ${l.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BrandMark(size: 18),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _reload,
            icon: const Icon(Icons.refresh_rounded),
          ),
          TextButton.icon(
            onPressed: () async {
              await authState.signOut();
              if (context.mounted) context.go('/');
            },
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: const Text('Sign out'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/session/create'),
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.background,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Create New Session',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: PageBody(
        child: FutureBuilder<List<TalkSession>>(
          future: _sessions,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(errorMessage(snap.error!)),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: _reload,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            final sessions = snap.data!;
            if (sessions.isEmpty) {
              return const Center(
                child: Text(
                  'No sessions yet.\nCreate one and share the QR code.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textMuted, height: 1.5),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.only(top: 16, bottom: 110),
              itemCount: sessions.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final s = sessions[i];
                final live = s.status == 'active';
                return Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => context.go('/manage/${s.id}'),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.title,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${_date(s.createdAt)} · '
                                  '${s.questionCount} question'
                                  '${s.questionCount == 1 ? '' : 's'} · '
                                  'code ${s.joinCode}',
                                  style: const TextStyle(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Pill(
                            live ? 'LIVE' : 'ENDED',
                            color: live
                                ? AppColors.success
                                : AppColors.textMuted,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
