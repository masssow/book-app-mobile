import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/section_model.dart';
import 'reader_page.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<SectionModel> sections = [];

  @override
  void initState() {
    super.initState();
    loadSections();
  }

  Future<void> loadSections() async {
    final data = await rootBundle.loadString('assets/mon_livre.json');
    final jsonData = json.decode(data);
    final loadedSections =
        (jsonData['sections'] as List)
            .map((e) => SectionModel.fromJson(e))
            .toList();

    setState(() => sections = loadedSections);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white.withOpacity(0.9),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.transparent),
              child: Text(
                'Menu',
                style: TextStyle(
                  fontSize: 24,
                  color: Color.fromRGBO(185, 151, 91, 1),
                ),
              ),
            ),
            ExpansionTile(
              title: const Text(
                'Les pratiques',
                style: TextStyle(color: Color.fromRGBO(185, 151, 91, 1)),
              ),
              children:
                  sections
                      .map(
                        (s) => ListTile(
                          title: Text(
                            s.title,
                            style: const TextStyle(color: Colors.black),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ReaderPage(
                                      section: s,
                                      index: sections.indexOf(s),
                                      sections: sections,
                                    ),
                              ),
                            );
                          },
                        ),
                      )
                      .toList(),
            ),
            const ListTile(
              title: Text(
                'Contact',
                style: TextStyle(color: Color.fromRGBO(185, 151, 91, 1)),
              ),
            ),
            const ListTile(
              title: Text(
                'Paramètres',
                style: TextStyle(color: Color.fromRGBO(185, 151, 91, 1)),
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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'MON LIVRE',
                    style: TextStyle(
                      color: Color.fromRGBO(185, 151, 91, 1),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
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
                    'Traité Soufi et de Jurisprudence écrit par :\nCheikh Chouhaybou MBACKE',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

