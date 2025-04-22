import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerPage extends StatefulWidget {
  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  final PdfViewerController _pdfController = PdfViewerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.black, // Fond noir pour supprimer les marges visuellement
      appBar: AppBar(
        title: Text('Lecture'),
        backgroundColor: Colors.green[900], // Vert foncé moderne
        actions: [
          IconButton(
            icon: Icon(Icons.zoom_in),
            onPressed: () {
              _pdfController.zoomLevel = _pdfController.zoomLevel += 0.5; // Zoom avant
            },
          ),
          IconButton(
            icon: Icon(Icons.zoom_out),
            onPressed: () {
              _pdfController.zoomLevel =
                  _pdfController.zoomLevel -= 0.5; // Zoom arrière
            },
          ),
        ],
      ),
      body: Center(
        child: SfPdfViewer.asset(
          'assets/mon_livre.pdf', // Assure-toi que ton PDF est bien dans assets/
          controller: _pdfController,
          enableDoubleTapZooming: true, // Permet de zoomer avec un double tap
          canShowScrollStatus: false, // Cache la barre de défilement
          canShowPaginationDialog: false, // Supprime le popup de pagination
          interactionMode:
              PdfInteractionMode.pan, // Désactive la sélection de texte
        ),
      ),
    );
  }
}
