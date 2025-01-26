import 'package:flutter/material.dart';

class FinalDetailsScreen extends StatefulWidget {
  const FinalDetailsScreen({super.key});

  @override
  State<FinalDetailsScreen> createState() => _FinalDetailsScreenState();
}

class _FinalDetailsScreenState extends State<FinalDetailsScreen> {
  final _phoneController = TextEditingController();
  final _companyIdController = TextEditingController();
  bool _isLoading = false;

  void _handleSubmit() async {
    setState(() => _isLoading = true);

    // Simulate loading
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (route) => false,
      );
    }
  }

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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Final Steps',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _companyIdController,
                  decoration: const InputDecoration(
                    labelText: 'Company ID',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            "Let's Go!",
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 