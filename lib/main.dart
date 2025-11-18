import 'package:flutter/material.dart';

import 'screens/analysis_result_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/history_screen.dart';
import 'screens/login_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/upload_audio_screen.dart';
import 'theme/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const SequetricsApp());
}

class SequetricsApp extends StatelessWidget {
  const SequetricsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sequetrics Conversation',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: '/',
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final name = settings.name ?? '/';

    if (name.startsWith('/analysis/')) {
      final segments = name.split('/');
      final id = segments.length > 2 && segments[2].isNotEmpty
          ? segments[2]
          : 'unknown';
      return MaterialPageRoute(
        settings: RouteSettings(name: name),
        builder: (_) => AnalysisResultScreen(analysisId: id),
      );
    }

    switch (name) {
      case '/':
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/'),
          builder: (_) => const LoginScreen(),
        );
      case '/dashboard':
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/dashboard'),
          builder: (_) => const DashboardScreen(),
        );
      case '/upload':
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/upload'),
          builder: (_) => const UploadAudioScreen(),
        );
      case '/history':
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/history'),
          builder: (_) => const HistoryScreen(),
        );
      case '/settings':
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/settings'),
          builder: (_) => const SettingsScreen(),
        );
      default:
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/'),
          builder: (_) => const LoginScreen(),
        );
    }
  }
}



