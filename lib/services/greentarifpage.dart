import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: camel_case_types
class greentarifpage extends StatelessWidget {
  const greentarifpage({super.key});

  // Function to launch the link
  Future<void> _launchURL() async {
    const url = 'https://webportal.tgsouthernpower.org/greentariff/login';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply for Green Tariff'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Text
            const Text(
              'APPLY FOR GREEN TARIFF',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Description Text
            const Text(
              'Click the link below to apply for Green Tariff:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),

            // Link Button
            GestureDetector(
              onTap: _launchURL,
              child: Text(
                'https://webportal.tgsouthernpower.org/greentariff/login',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
