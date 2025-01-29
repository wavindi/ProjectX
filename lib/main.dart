import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart'; // Ensure this file is generated using FlutterFire CLI
import 'screens/home/home_page.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/welcome_screen.dart';
import 'screens/language.dart';
import 'screens/auth/verify1.dart';
import 'screens/auth/verify2.dart';
import 'screens/auth/verify3.dart';
import 'screens/auth/verify4.dart';
import 'screens/auth/verify5.dart';
import 'screens/auth/verify6.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LUXPOOL',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const HomePage(),
        '/welcome': (context) => const WelcomeScreen(),
      },
    );
  }
}
