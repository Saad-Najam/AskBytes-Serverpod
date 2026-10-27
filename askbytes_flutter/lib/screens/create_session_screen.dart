import 'package:askbytes_client/askbytes_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../client.dart';
import '../state/live_session.dart';
import '../theme.dart';
import '../widgets/brand.dart';

String joinUrl(String code) => '${Uri.base.origin}/join/$code';

/// `/session/create` — create a session, then show its QR code and link.
class CreateSessionScreen extends StatefulWidget {
  const CreateSessionScreen({super.key});

  @override
  State<CreateSessionScreen> createState() => _CreateSessionScreenState();
}

class _CreateSessionScreenState extends State<CreateSessionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _speaker = TextEditingController();
  final _description = TextEditingController();
  int _duration = 45;
  bool _autoEnd = false;
  bool _saving = false;
  TalkSession? _created;

  @override
  void dispose() {
    _title.dispose();
    _speaker.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final talk = await client.session.createSession(
        title: _title.text,
        speakerName: _speaker.text,
        description: _description.text,
        durationMinutes: _duration,
        autoEnd: _autoEnd,
      );
      if (mounted) {
        setState(() => _created = talk);
        if (_autoEnd && !talk.autoEndScheduled) {
          showInfo(
            context,
            'Auto-end is not available on this server plan. '
            'End the session manually when you finish.',
          );
        }
      }
    } catch (e) {
      if (mounted) showError(context, errorMessage(e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final created = _created;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/dashboard'),
        ),
        title: Text(created == null ? 'New session' : 'Session ready'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: PageBody(
            maxWidth: 560,
            child: created == null ? _form() : _ready(created),
          ),
        ),
      ),
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Talk title'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _speaker,
            decoration: const InputDecoration(labelText: 'Speaker name'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _description,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Description (optional)',
            ),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<int>(
            initialValue: _duration,
            decoration: const InputDecoration(labelText: 'Duration'),
            items: [
              for (final m in const [15, 30, 45, 60, 90])
                DropdownMenuItem(value: m, child: Text('$m minutes')),
            ],
            onChanged: (v) => setState(() => _duration = v ?? 45),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _autoEnd,
            onChanged: (v) => setState(() => _autoEnd = v),
            title: const Text('Auto-end when time is up'),
            subtitle: const Text(
              'Closes questions and generates the AI recap automatically.',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saving ? null : _submit,
            child: _saving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  )
                : const Text('Create session'),
          ),
        ],
      ),
    );
  }

  Widget _ready(TalkSession talk) {
    final url = joinUrl(talk.joinCode);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          talk.title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 20),
        Center(
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: QrImageView(
              data: url,
              size: 240,
              backgroundColor: Colors.white,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.circle,
                color: AppColors.background,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.circle,
                color: AppColors.background,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Center(
          child: Text(
            talk.joinCode,
            style: const TextStyle(
              fontSize: 36,
              letterSpacing: 8,
              fontWeight: FontWeight.w900,
              color: AppColors.accent,
            ),
          ),
        ),
        const SizedBox(height: 6),
        SelectableText(
          url,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textMuted),
        ),
        const SizedBox(height: 22),
        OutlinedButton.icon(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: url));
            if (mounted) showInfo(context, 'Join link copied');
          },
          icon: const Icon(Icons.copy_rounded),
          label: const Text('Copy join link'),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () => context.go('/present/${talk.id}'),
          icon: const Icon(Icons.tv_rounded),
          label: const Text('Open big screen'),
        ),
        const SizedBox(height: 10),
        FilledButton.icon(
          onPressed: () => context.go('/manage/${talk.id}'),
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text('Manage live session'),
        ),
      ],
    );
  }
}
