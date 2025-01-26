import 'package:flutter/material.dart';
import 'final_details_screen.dart';

class GenderSelectionScreen extends StatelessWidget {
  const GenderSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red, Colors.white, Colors.blue],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Select Your Gender',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildGenderButton(
                    context,
                    'Male',
                    Icons.male,
                    Colors.blue,
                  ),
                  _buildGenderButton(
                    context,
                    'Female',
                    Icons.female,
                    Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderButton(
    BuildContext context,
    String gender,
    IconData icon,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FinalDetailsScreen(),
          ),
        );
      },
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: color),
            const SizedBox(height: 10),
            Text(
              gender,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 