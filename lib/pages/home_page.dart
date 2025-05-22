// File: lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chapter_list_page.dart';
import '../reader/reader_page.dart';
import '../data/chapters.dart';
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
    loadLastRead();
  }

  Future<void> loadLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      lastFile = prefs.getString('last_read_file');
      lastTitle = prefs.getString('last_read_title');
      lastIndex = prefs.getInt('last_read_index');
      print('[LOAD] $lastFile / $lastTitle / $lastIndex');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white.withOpacity(0.9),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.transparent),
              child: Text(
                'Menu',
                style: TextStyle(
                  fontSize: 24,
                  color: Color.fromRGBO(31, 30, 29, 1),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ExpansionTile(
                    leading: const Icon(
                      Icons.menu_book_outlined,
                      color: Color.fromRGBO(31, 30, 29, 1),
                    ),
                    title: const Text(
                      'Chapitres',
                      style: TextStyle(color: Color.fromRGBO(31, 30, 29, 1)),
                    ),
                    iconColor: const Color.fromRGBO(31, 30, 29, 1),
                    collapsedIconColor: const Color.fromRGBO(31, 30, 29, 1),
                    initiallyExpanded: false,
                    children:
                        chapterList.asMap().entries.map((entry) {
                          final i = entry.key;
                          final chapter = entry.value;
                          return ListTile(
                            title: Text(chapter['title']!),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => ReaderPage(
                                        fileName: chapter['file']!,
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
                      Icons.info_outline,
                      color: Color.fromRGBO(31, 30, 29, 1),
                    ),
                    title: const Text(
                      "À propos",
                      style: TextStyle(color: Color.fromRGBO(31, 30, 29, 1)),
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
                      Icons.contact_mail_outlined,
                      color: Color.fromRGBO(31, 30, 29, 1),
                    ),
                    title: const Text(
                      'Contact',
                      style: TextStyle(color: Color.fromRGBO(31, 30, 29, 1)),
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
            const Padding(
              padding: EdgeInsets.only(left: 12.0, bottom: 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Text(
                    'V1.0.0',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(title: const Text('Mon Livre')),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.2,
            child: Image.asset('assets/bg_home.jpg', fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 170),
                    const Text(
                      'KHOURATOUL AYNI',
                      style: TextStyle(
                        color: Color.fromRGBO(185, 151, 91, 1),
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 1),
                    const Text(
                      'Conseil à un ami',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Traité Soufi et de Jurisprudence par Cheikh Chouhaybou MBACKÉ',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'TRADUIT DU WOLOFAL PAR LE DAHIRA SAFÎNATOUL-AMAN DES ENSEIGNANTS DE KAOLACK',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Column(
                  children: [
                    if (lastFile != null &&
                        lastTitle != null &&
                        lastIndex != null)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(
                            185,
                            151,
                            91,
                            1,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ReaderPage(
                                    fileName: lastFile!,
                                    title: lastTitle!,
                                    index: lastIndex!,
                                    chapters: chapterList,
                                  ),
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          child: Text(
                            'Continuer la lecture',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      )
                    else
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(
                            185,
                            151,
                            91,
                            1,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ChapterListPage(),
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          child: Text(
                            'Commencer la lecture',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Image.asset('assets/fullLogoMass.png', width: 34),
                            const SizedBox(height: 4),
                            const Text(
                              'Conçue par : Massgrafik',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 32),
                        Column(
                          children: [
                            Image.asset(
                              'assets/nouroulHoudaLogo.png',
                              width: 34,
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Nouroul Houda Éditions',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
