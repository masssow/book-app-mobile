import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contactez-nous')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Nous sommes à votre écoute pour toute remarque, suggestion ou partenariat.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(221, 237, 229, 229),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '📧 Email :',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => _launchUrl('mailto:masssowcode@gmail.com'),
                child: const Text(
                  'masssowcode@gmail.com',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '📞 WhatsApp :',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text('+33 7 51 06 87 47'),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
