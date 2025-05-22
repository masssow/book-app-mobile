import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

const String htmlContent = """
  <h2>Chapitre 1</h2>
  <p>Voici une belle image :</p>
  <img src="assets/images/photo_theme.png" width="300"/>
  <p>Fin du contenu.</p>
""";

class HtmlPage extends StatelessWidget {
  const HtmlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contenu HTML")),
      body: SingleChildScrollView(
        child: Html(
          data: htmlContent,
          extensions: [const AssetHtmlExtension()],
        ),
      ),
    );
  }
}
