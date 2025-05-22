import 'package:flutter/material.dart';
import '../data/chapters.dart';
import '../reader/reader_page.dart';

class ChapterListPage extends StatelessWidget {
  const ChapterListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chapitres')),
      body: ListView.separated(
        itemCount: chapterList.length,
        separatorBuilder:
            (_, __) => const Divider(height: 1, color: Colors.white12),
        itemBuilder:
            (context, index) => ListTile(
              title: Text(
                chapterList[index]['title']!,
                style: const TextStyle(color: Colors.white),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Color.fromRGBO(185, 151, 91, 1),
              ),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ReaderPage(
                            fileName: chapterList[index]['file']!,
                            title: chapterList[index]['title']!,
                            chapters: chapterList,
                            index: index,
                          ),
                    ),
                  ),
            ),
      ),
    );
  }
}
