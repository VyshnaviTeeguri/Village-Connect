import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyScreen extends StatelessWidget {
  final List<Map<String, String>> emergencyContacts = [
    {'label': 'Ambulance (108)', 'phone': '108'},
    {'label': 'Police Station', 'phone': '100'},
    {'label': 'Fire Station', 'phone': '101'},
    {'label': 'PHC Doctor', 'phone': '9876543220'},
    {'label': 'Electricity Dept', 'phone': '1912'},
    {'label': 'Water Supply Dept', 'phone': '9876543221'},
  ];

  void _call(String number) async {
    final Uri uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Emergency Contacts')),
      body: ListView.builder(
        itemCount: emergencyContacts.length,
        itemBuilder: (context, index) {
          final contact = emergencyContacts[index];
          return Card(
            child: ListTile(
              title: Text(contact['label']!),
              subtitle: Text(contact['phone']!),
              trailing: IconButton(
                icon: Icon(Icons.call, color: Colors.red),
                onPressed: () => _call(contact['phone']!),
              ),
            ),
          );
        },
      ),
    );
  }
}
