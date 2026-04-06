import 'package:flutter/material.dart';
import 'directory_screen.dart';
import 'emergency_screen.dart';
import 'services_screen.dart';
import 'announcements_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userId; // pass logged-in user ID

  const HomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> features = [
      {
        'title': 'Village Directory',
        'icon': Icons.contacts,
        'screen': DirectoryScreen(),
      },
      {
        'title': 'Emergency Contacts',
        'icon': Icons.warning,
        'screen': EmergencyScreen(),
      },
      {
        'title': 'Local Services',
        'icon': Icons.build,
        'screen': ServicesScreen(),
      },
      {
        'title': 'Announcements',
        'icon': Icons.campaign,
        'screen': AnnouncementsScreen(),
      },
      {
        'title': 'Village Map',
        'icon': Icons.map,
        'route': '/map',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Nambur Connect')),
      body: ListView.builder(
        itemCount: features.length,
        itemBuilder: (context, index) {
          final feature = features[index];
          return Card(
            margin: const EdgeInsets.all(8.0), // Added margin for spacing
            child: ListTile(
              leading: Icon(feature['icon'], color: Colors.green),
              title: Text(feature['title']),
              onTap: () {
                if (feature.containsKey('screen')) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => feature['screen']),
                  );
                } else if (feature.containsKey('route')) {
                  Navigator.pushNamed(context, feature['route']);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
