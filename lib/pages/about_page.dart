// File: lib/pages/about_page.dart
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('À propos')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Présentation de l\'application',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(185, 151, 91, 1),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Cette application est une édition numérique du précieux ouvrage "Khouratoul Ayni",'
              'traduit du Wolofal par le Dahira Safinatoul Aman, une organisation d\'enseignants engagés de Kaolack, au Sénégal, œuvrant pour la vulgarisation des sciences islamiques.\n\n Développée par Massgrafik, cette application s\'inscrit dans un projet collaboratif de diffusion des œuvres de théologie musulmane — en particulier celles de l’érudit Cheikh Ahmadou Bamba Mbacké — et de promotion des valeurs spirituelles et juridiques islamiques. Elle vise à faciliter l’accès à cet ouvrage à travers une interface claire et immersive.\n\n Ce projet a vu le jour en collaboration avec le groupe de traduction Nouroul Houda                Éditions, œuvrant pour la transmission des sciences islamiques au sein de la communauté musulmane, à travers des langues telles que le français et l\'espagnol.',
              style: TextStyle(fontSize: 16, color: Color.fromARGB(221, 230, 230, 230), height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
