import 'package:flutter/material.dart';

class PartnersScreen extends StatelessWidget {
  const PartnersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Partners'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SectionHeader(title: 'Our Partners'),
            const SizedBox(height: 8),
            const PartnersSection(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }
}

class PartnersSection extends StatelessWidget {
  const PartnersSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          5, // Replace with actual data from your database
          (index) => const PartnerCard(
            logo:
                'assets/images/justinjob1.jpg', // Replace with actual logo path
            name: 'Partner Name',
            phone: '+251 123 456 789',
            email: 'partner@example.com',
            website: 'www.partner.com',
          ),
        ),
      ),
    );
  }
}

class PartnerCard extends StatelessWidget {
  final String logo;
  final String name;
  final String phone;
  final String email;
  final String website;

  const PartnerCard({
    required this.logo,
    required this.name,
    required this.phone,
    required this.email,
    required this.website,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(logo, height: 50),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(phone),
            Text(email),
            Text(website),
          ],
        ),
      ),
    );
  }
}
