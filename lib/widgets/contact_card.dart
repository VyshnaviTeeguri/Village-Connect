// lib/widgets/contact_card.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactCard extends StatelessWidget {
  final String name;
  final String role;
  final String phoneNumber;

  const ContactCard({
    Key? key,
    required this.name,
    required this.role,
    required this.phoneNumber,
  }) : super(key: key);

  void _launchCaller(String number) async {
    final Uri url = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: ListTile(
        leading: const Icon(Icons.person),
        title: Text(name),
        subtitle: Text(role),
        trailing: IconButton(
          icon: const Icon(Icons.call),
          onPressed: () => _launchCaller(phoneNumber),
        ),
      ),
    );
  }
}
