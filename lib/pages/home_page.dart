// File: lib/pages/home_page.dart
import 'package:flutter/material.dart';

import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../reader/reader_page.dart';
import '../data/chapters.dart';
import 'chapter_list_page.dart';
import 'about_page.dart' as about;
import 'contact_page.dart' as contact;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? lastFile;
  String? lastTitle;
  int? lastIndex;

  @override
  void initState() {
    super.initState();
    _loadLastRead();
  }

  Future<void> _loadLastRead() async {
    final lastRead = await StorageService.getLastRead();

    if (lastRead != null && mounted) {
      setState(() {
        lastFile = lastRead.file;
        lastTitle = lastRead.title;
        lastIndex = lastRead.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(title: const Text('Mon Livre')),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.2,
            child: Image.asset('assets/images/bg_home.jpg', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  /// --- CONTENU HAUT (légèrement au-dessus du centre) ---
                  Expanded(
                    child: Align(
                      alignment: const Alignment(0, -0.2),
                      // -0.2 = légèrement au-dessus du centre
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'KHOURATOUL AYNI',
                            style: TextStyle(
                              color: AppTheme.gold,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Conseil à un ami',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Traité Soufi et de Jurisprudence\nPar Cheikh Abo Madyana Shouhaïbou Mbacke (1918 - 1991).',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'TRADUIT DU WOLOFAL PAR LA DAHIRA\nSAFÎNATOUL-AMAN DES ENSEIGNANTS DE KAOLACK',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// --- BOUTON BAS ---
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.gold,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      if (lastFile != null &&
                          lastTitle != null &&
                          lastIndex != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ReaderPage(
                                  file: lastFile!,
                                  title: lastTitle!,
                                  chapters: chapterList,
                                  index: lastIndex!,
                                ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ChapterListPage(),
                          ),
                        );
                      }
                    },
                    child: Text(
                      (lastFile != null &&
                              lastTitle != null &&
                              lastIndex != null)
                          ? 'Continuer la lecture'
                          : 'Commencer la lecture',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white.withValues(alpha: 0.94),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close_rounded, color: AppTheme.darkGold),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.transparent),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Menu',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkGold,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ExpansionTile(
                  leading: const Icon(
                    Icons.auto_stories_rounded,
                    color: AppTheme.darkGold,
                  ),
                  title: const Text(
                    'Chapitres',
                    style: TextStyle(
                      color: AppTheme.darkGold,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  iconColor: AppTheme.darkGold,
                  collapsedIconColor: AppTheme.darkGold,
                  children:
                      chapterList.asMap().entries.map((entry) {
                        final i = entry.key;
                        final chapter = entry.value;

                        return ListTile(
                          dense: true,
                          leading: const Icon(
                            Icons.bookmark_border_rounded,
                            color: AppTheme.darkGold,
                            size: 20,
                          ),
                          title: Text(
                            chapter['title']!,
                            style: const TextStyle(color: AppTheme.darkGold),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ReaderPage(
                                      file: chapter['file']!,
                                      title: chapter['title']!,
                                      chapters: chapterList,
                                      index: i,
                                    ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                ),
                const SizedBox(height: 24),
                ListTile(
                  leading: const Icon(
                    Icons.info_rounded,
                    color: AppTheme.darkGold,
                  ),
                  title: const Text(
                    "À propos",
                    style: TextStyle(color: AppTheme.darkGold),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppTheme.darkGold,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const about.AboutPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.alternate_email_rounded,
                    color: AppTheme.darkGold,
                  ),
                  title: const Text(
                    'Contact',
                    style: TextStyle(color: AppTheme.darkGold),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppTheme.darkGold,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const contact.ContactPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
