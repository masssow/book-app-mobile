import 'dart:convert';
import 'package:flutter/services.dart';

class BookService {
  static Future<List<dynamic>> loadFilteredSections() async {
    String jsonString = await rootBundle.loadString('assets/mon_livre.json');
    List<dynamic> jsonData = json.decode(jsonString);
    return jsonData[0]['sections']
        .where(
          (section) =>
              section['id'] is String && section['id'].contains(RegExp(r'\D')),
        )
        .toList();
  }
}
