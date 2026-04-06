// lib/widgets/service_card.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceCard extends StatelessWidget {
  final String serviceName;
  final String providerName;
  final String phoneNumber;
  final Widget? trailing;

  const ServiceCard({
    Key? key,
    required this.serviceName,
    required this.providerName,
    required this.phoneNumber,
    this.trailing,
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
        leading: const Icon(Icons.home_repair_service),
        title: Text(serviceName),
        subtitle: Text(providerName),
        trailing: trailing ?? IconButton(
          icon: const Icon(Icons.call),
          onPressed: () => _launchCaller(phoneNumber),
        ),
      ),
    );
  }
}
