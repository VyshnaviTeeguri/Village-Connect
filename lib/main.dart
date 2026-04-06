import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'screens/home_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/map_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(NamburConnectApp());
}

class NamburConnectApp extends StatelessWidget {
  const NamburConnectApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Village Connect',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/', // Show WelcomeScreen first
      routes: {
        '/': (context) => const WelcomeScreen(),
        // Pass userId when creating HomeScreen
        '/home': (context) => const HomeScreen(userId: 'test_user'),
        '/map': (context) => const MapScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
