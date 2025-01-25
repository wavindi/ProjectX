import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart'; // Ensure this file is generated using FlutterFire CLI
import 'screens/home/home_page.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/welcome_screen.dart';

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
      // Checking if the user is logged in
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          } else if (snapshot.hasData) {
            // If the user is logged in, navigate to HomePage
            return const HomePage();
          } else {
            // If the user is not logged in, navigate to WelcomeScreen (Login/Signup)
            return const WelcomeScreen();
          }
        },
      ),
      routes: {
        '/home': (context) => const HomePage(),
        '/welcome': (context) => const WelcomeScreen(),
      },
    );
  }
}
