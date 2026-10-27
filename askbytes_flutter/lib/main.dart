import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'client.dart';
import 'router.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Clean URLs like /join/ABC123 so QR codes work without a `#`.
  usePathUrlStrategy();
  await initializeClient();
  // Restore a previous sign-in before the first redirect runs.
  await client.auth.initialize();
  runApp(const AskBytesApp());
}

class AskBytesApp extends StatelessWidget {
  const AskBytesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AskBytes',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
