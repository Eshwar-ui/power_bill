import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  // Function to open links
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Phone Number
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('1912'),
              onTap: () => _launchURL('tel:1912'),
            ),

            // Email
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email: customerservice@tgsouthernpower.com'),
              onTap: () =>
                  _launchURL('mailto:customerservice@tgsouthernpower.com'),
            ),

            // Website
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Website: https://tgsouthernpower.org/'),
              onTap: () => _launchURL('https://tgsouthernpower.org/'),
            ),

            // Facebook
            ListTile(
              leading: const Icon(Icons.facebook),
              title: const Text('Facebook: @example'),
              onTap: () =>
                  _launchURL('https://www.facebook.com/tspdcl'), // Replace
            ),

            // Twitter
          ],
        ),
      ),
    );
  }
}
