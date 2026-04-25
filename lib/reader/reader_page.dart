// File: lib/reader/reader_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';

import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class ReaderPage extends StatefulWidget {
  final String file;
  final String title;
  final List<Map<String, String>> chapters;
  final int index;

  const ReaderPage({
    super.key,
    required this.file,
    required this.title,
    required this.chapters,
    required this.index,
  });

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  String content = '';

  @override
  void initState() {
    super.initState();
    _loadHtml();

    // Sauvegarde position lecture
    StorageService.saveLastRead(
      file: widget.file,
      title: widget.title,
      index: widget.index,
    );
  }

  Future<void> _loadHtml() async {
    try {
      final data = await rootBundle.loadString(
        'assets/chapters/${widget.file}.html',
      );

      if (mounted) {
        setState(() => content = data);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          content = '<p><b>Erreur :</b> chapitre introuvable.</p>';
        });
      }
    }
  }

  Future<void> _addToLearning(String text) async {
    await StorageService.addLearning(text);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Ajouté à Mon Apprentissage 📖'),
        backgroundColor: AppTheme.accentGreen,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showLearningDialog(String text) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white.withValues(alpha: 0.95),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Ajouter à Mon Apprentissage ?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.background,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _addToLearning(text);
                    },
                    icon: const Icon(Icons.bookmark_add_outlined),
                    label: const Text('Ajouter à Mon Apprentissage'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.gold,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _navigateTo(int newIndex) {
    final chapter = widget.chapters[newIndex];

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (_) => ReaderPage(
              file: chapter['file']!,
              title: chapter['title']!,
              chapters: widget.chapters,
              index: newIndex,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontSize: 18)),
      ),
      body:
          content.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Chapitre ${widget.index + 1} / ${widget.chapters.length}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Html(
                          data: content,
                          extensions: [
                            TagExtension(
                              tagsToExtend: {'span'},
                              builder: (context) {
                                final id = context.attributes['id'];
                                final rawText =
                                    context.element?.text.trim() ?? '';

                                if (id != null && rawText.isNotEmpty) {
                                  return GestureDetector(
                                    onTap: () => _showLearningDialog(rawText),
                                    child: Text(
                                      rawText,
                                      style: const TextStyle(
                                        color: AppTheme.gold,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                          style: {
                            "h1": Style(
                              color: AppTheme.accentGreenLight,
                              fontSize: FontSize(24),
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.center,
                            ),
                            "h2": Style(
                              color: AppTheme.accentGreen,
                              fontSize: FontSize(20),
                              fontWeight: FontWeight.w600,
                            ),
                            "b": Style(
                              color: AppTheme.gold,
                              fontWeight: FontWeight.bold,
                              fontSize: FontSize(14),
                            ),
                            "b.rouge": Style(
                              color: Colors.red.shade900,
                              fontWeight: FontWeight.bold,
                              fontSize: FontSize(14),
                            ),
                            "p": Style(
                              color: AppTheme.textPrimary,
                              fontSize: FontSize(14),
                              lineHeight: LineHeight(1.5),
                            ),
                            "body": Style(
                              fontSize: FontSize(14),
                              color: AppTheme.textPrimary,
                            ),
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed:
                              widget.index > 0
                                  ? () => _navigateTo(widget.index - 1)
                                  : null,
                          child: const Text('Chapitre précédent'),
                        ),
                        TextButton(
                          onPressed:
                              widget.index < widget.chapters.length - 1
                                  ? () => _navigateTo(widget.index + 1)
                                  : null,
                          child: const Text('Chapitre suivant'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }
}
