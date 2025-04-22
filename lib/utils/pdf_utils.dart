import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfUtils {
  static Future<String> modifyPdf() async {
    try {
      // Charger le fichier PDF depuis les assets
      ByteData data = await rootBundle.load('assets/livre.pdf');
      Uint8List bytes = data.buffer.asUint8List();

      // Charger le document PDF
      PdfDocument document = PdfDocument(inputBytes: bytes);

      // Modifier chaque page pour ajuster le texte et la taille
      for (int i = 0; i < document.pages.count; i++) {
        PdfPage page = document.pages[i];

        // Exemple pour ajuster le texte
        PdfTextElement textElement = PdfTextElement(
          text: "Texte ajusté",
          font: PdfStandardFont(PdfFontFamily.helvetica, 40),
        );

        // Dessiner le texte sur la page en ajustant la position
        page.graphics.drawString(
          textElement.text,
          textElement.font,
          bounds: Rect.fromLTWH(
            10,
            10,
            page.size.width - 20,
            page.size.height - 20,
          ),
        );
      }

      // Sauvegarder le fichier PDF modifié
      final output = await getTemporaryDirectory();
      File file = File("${output.path}/livre_modifie.pdf");
      await file.writeAsBytes(await document.save());

      // Fermer le document
      document.dispose();

      print("📄 PDF modifié et sauvegardé ici : ${file.path}");
      return file.path; // Retourne le chemin du fichier
    } catch (e) {
      print("⚠️ Erreur lors de la modification du PDF : $e");
      return "";
    }
  }
}
