import 'package:flutter/material.dart';
import 'package:nambur_connect/widgets/service_card.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  List<Map<String, String>> services = [
    {
      'serviceName': 'Electrician',
      'providerName': 'Naresh Kumar',
      'phoneNumber': '9876543210',
    },
    {
      'serviceName': 'Plumber',
      'providerName': 'Ravi Sharma',
      'phoneNumber': '9123456780',
    },
    {
      'serviceName': 'Carpenter',
      'providerName': 'Sunil Verma',
      'phoneNumber': '9012345678',
    },
    {
      'serviceName': 'Auto Rickshaw',
      'providerName': 'Kiran',
      'phoneNumber': '9988776655',
    },
    {
      'serviceName': 'Water Supply',
      'providerName': 'Village Water Dept',
      'phoneNumber': '1234567890',
    },
  ];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _providerNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    final prefs = await SharedPreferences.getInstance();
    final String? servicesJson = prefs.getString('services');
    if (servicesJson != null) {
      final List<dynamic> decoded = jsonDecode(servicesJson);
      setState(() {
        services = decoded.map((e) => Map<String, String>.from(e)).toList();
      });
    }
  }

  Future<void> _saveServices() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('services', jsonEncode(services));
  }

  void _showAddServiceDialog() {
    // Clear controllers before showing dialog
    _serviceNameController.clear();
    _providerNameController.clear();
    _phoneNumberController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Service'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _serviceNameController,
                  decoration: const InputDecoration(labelText: 'Service Name'),
                  validator: (value) => value == null || value.isEmpty ? 'Enter service name' : null,
                ),
                TextFormField(
                  controller: _providerNameController,
                  decoration: const InputDecoration(labelText: 'Provider Name'),
                  validator: (value) => value == null || value.isEmpty ? 'Enter provider name' : null,
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) => value == null || value.isEmpty ? 'Enter phone number' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    services.add({
                      'serviceName': _serviceNameController.text,
                      'providerName': _providerNameController.text,
                      'phoneNumber': _phoneNumberController.text,
                    });
                  });
                  await _saveServices();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _serviceNameController.dispose();
    _providerNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Services'),
      ),
      body: ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return ServiceCard(
            serviceName: service['serviceName']!,
            providerName: service['providerName']!,
            phoneNumber: service['phoneNumber']!,
            trailing: SizedBox(
              width: 100,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.call),
                    onPressed: () async {
                      final Uri url = Uri(scheme: 'tel', path: service['phoneNumber']!);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Delete',
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Contact'),
                          content: const Text('Are you sure you want to delete this contact?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Delete', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        setState(() {
                          services.removeAt(index);
                        });
                        await _saveServices();
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddServiceDialog,
        child: const Icon(Icons.add),
        tooltip: 'Add Service',
      ),
    );
  }
}
