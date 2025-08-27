import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreen createState() => _ContactUsScreen();
}

class _ContactUsScreen extends State<ContactUsScreen> {
  void _launchURL(String url) async {
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
        title: const Text('Contact Us'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Address: Addis Ababa, Nifas Silk kefle k. Woreda 9',
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                'Email: justin@jijethiopia.com',
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                'Telephone: +251(0)945999997',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.facebook, color: Colors.blue),
                    onPressed: () => _launchURL(
                        'https://www.facebook.com/jijethiopia?mibextid=ZbWKwL&_rdc=1&_rdr#'),
                  ),
                  IconButton(
                    icon: Icon(Icons.telegram, color: Colors.blueAccent),
                    onPressed: () => _launchURL('https://t.me/jijethio'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
