import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MuslimBookApp());
}

class MuslimBookApp extends StatelessWidget {
  const MuslimBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khouratoul Ayni',
      theme: AppTheme.theme,
      home: const HomePage(),
    );
  }
}
