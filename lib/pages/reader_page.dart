// File: lib/pages/reader_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/chapters.dart';

class ReaderPage extends StatefulWidget {
  final String fileName;
  final String title;
  final List<Map<String, String>> chapters;
  final int index;

  const ReaderPage({
    super.key,
    required this.fileName,
    required this.title,
    required this.chapters,
    required this.index,
  });

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  String content = '';
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<String> learningItems = [];

  @override
  void initState() {
    super.initState();
    loadHtml();
    loadLearningItems();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> loadHtml() async {
    try {
      final data = await rootBundle.loadString(
        'lib/chapters/${widget.fileName}.html',
      );
      setState(() => content = data);
    } catch (e) {
      setState(() => content = '<p><b>Erreur :</b> chapitre introuvable.</p>');
    }
  }

  Future<void> loadLearningItems() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      learningItems = prefs.getStringList('learning') ?? [];
    });
  }

  Future<void> addToLearning(String text) async {
    final prefs = await SharedPreferences.getInstance();
    learningItems.add(text);
    await prefs.setStringList('learning', learningItems);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Ajouté à Mon Apprentissage 📖'),
        backgroundColor: Colors.green.shade700,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> playAudio(String id) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setAsset('lib/audio/$id.mp3');
      await _audioPlayer.play();
    } catch (e) {
      debugPrint('Erreur lecture audio : $e');
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Audio non disponible'),
              content: Text('Erreur: $e'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    }
  }

  void showLearningDialog(String text, String id) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white.withOpacity(0.95),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Que souhaitez-vous faire ?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromRGBO(13, 31, 28, 1),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      addToLearning(text);
                    },
                    icon: const Icon(Icons.bookmark_add_outlined),
                    label: const Text('Ajouter à Mon Apprentissage'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(185, 151, 91, 1),
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      playAudio(id);
                    },
                    icon: const Icon(Icons.play_circle_fill_outlined),
                    label: const Text('Écouter l\'invocation'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 18), // taille réduite pour AppBar
        ),
      ),
      body:
          content.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
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
                                final rawText = context.element?.text ?? '';
                                if (id != null) {
                                  return GestureDetector(
                                    onTap:
                                        () => showLearningDialog(rawText, id),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 2,
                                      ),
                                      child: Text(
                                        rawText,
                                        style: const TextStyle(
                                          color: Color.fromRGBO(
                                            185,
                                            151,
                                            91,
                                            1,
                                          ),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14, // même que <p>
                                        ),
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
                              color: Colors.greenAccent,
                              fontSize: FontSize(24),
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.center,
                            ),
                            "h2": Style(
                              color: Colors.green,
                              fontSize: FontSize(20),
                              fontWeight: FontWeight.w600,
                            ),
                            "b": Style(
                              color: const Color.fromRGBO(185, 151, 91, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: FontSize(14), // même que <p>
                            ),
                            "p": Style(
                              color: Colors.white,
                              fontSize: FontSize(14), // réduite
                              lineHeight: LineHeight(1.5),
                            ),
                            "body": Style(
                              fontSize: FontSize(14),
                              color: Colors.white,
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
                                  ? () {
                                    final prev =
                                        widget.chapters[widget.index - 1];
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => ReaderPage(
                                              fileName: prev['file']!,
                                              title: prev['title']!,
                                              chapters: widget.chapters,
                                              index: widget.index - 1,
                                            ),
                                      ),
                                    );
                                  }
                                  : null,
                          child: const Text('Chapitre précédent'),
                        ),
                        TextButton(
                          onPressed:
                              widget.index < widget.chapters.length - 1
                                  ? () {
                                    final next =
                                        widget.chapters[widget.index + 1];
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => ReaderPage(
                                              fileName: next['file']!,
                                              title: next['title']!,
                                              chapters: widget.chapters,
                                              index: widget.index + 1,
                                            ),
                                      ),
                                    );
                                  }
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
