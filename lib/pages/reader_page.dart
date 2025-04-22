import 'package:flutter/material.dart';
import '../models/section_model.dart';


class ReaderPage extends StatelessWidget {
  final SectionModel section;
  final int index;
  final List<SectionModel> sections;

  const ReaderPage({
    super.key,
    required this.section,
    required this.index,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    final total = sections.length;
    final progressText = 'Chapitre ${index + 1} / $total';

    return Scaffold(
      appBar: AppBar(title: Text(section.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(progressText, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  section.content,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: const Color.fromRGBO(185, 151, 91, 1),
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                  onPressed:
                      index > 0
                          ? () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ReaderPage(
                                      section: sections[index - 1],
                                      index: index - 1,
                                      sections: sections,
                                    ),
                              ),
                            );
                          }
                          : null,
                  child: const Text('Chapitre précédent'),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: const Color.fromRGBO(185, 151, 91, 1),
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                  onPressed:
                      index < sections.length - 1
                          ? () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ReaderPage(
                                      section: sections[index + 1],
                                      index: index + 1,
                                      sections: sections,
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
