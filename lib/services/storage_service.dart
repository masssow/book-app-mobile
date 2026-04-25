import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _lastFileKey = 'last_read_file';
  static const _lastTitleKey = 'last_read_title';
  static const _lastIndexKey = 'last_read_index';
  static const _learningKey = 'learning';

  // -------- Last Read --------

  static Future<void> saveLastRead({
    required String file,
    required String title,
    required int index,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastFileKey, file);
    await prefs.setString(_lastTitleKey, title);
    await prefs.setInt(_lastIndexKey, index);
  }

  static Future<LastRead?> getLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    final file = prefs.getString(_lastFileKey);
    final title = prefs.getString(_lastTitleKey);
    final index = prefs.getInt(_lastIndexKey);

    if (file == null || title == null || index == null) return null;

    return LastRead(file: file, title: title, index: index);
  }

  // -------- Learning --------

  static Future<List<String>> getLearning() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_learningKey) ?? [];
    return List<String>.from(list); // copie propre
  }

  static Future<void> addLearning(String text) async {
    if (text.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_learningKey) ?? [];

    if (!current.contains(text)) {
      current.add(text);
      await prefs.setStringList(_learningKey, current);
    }
  }

  static Future<void> removeLearning(String text) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_learningKey) ?? [];

    current.remove(text);
    await prefs.setStringList(_learningKey, current);
  }
}

class LastRead {
  final String file;
  final String title;
  final int index;

  const LastRead({
    required this.file,
    required this.title,
    required this.index,
  });
}
