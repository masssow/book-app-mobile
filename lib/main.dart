import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/chapters.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const MuslimBookApp());
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MuslimBookApp());

  // 🔍 Test temporaire pour voir si la sauvegarde a été faite
  final prefs = await SharedPreferences.getInstance();
  final file = prefs.getString('last_read_file');
  final title = prefs.getString('last_read_title');
  final index = prefs.getInt('last_read_index');
  print('[TEST PREFS] $file / $title / $index');
}




class MuslimBookApp extends StatelessWidget {
  const MuslimBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Livre Musulman',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(13, 31, 28, 1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(185, 151, 91, 1),
          primary: const Color.fromRGBO(185, 151, 91, 1),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Color.fromRGBO(185, 151, 91, 1),
          elevation: 0,
          iconTheme: IconThemeData(color: Color.fromRGBO(185, 151, 91, 1)),
          titleTextStyle: TextStyle(
            color: Color.fromRGBO(185, 151, 91, 1),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(
            color: Color.fromRGBO(185, 151, 91, 1),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
