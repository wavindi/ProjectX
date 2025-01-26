import 'package:flutter/material.dart';

class FindRidePage extends StatefulWidget {
  const FindRidePage({super.key});

  @override
  State<FindRidePage> createState() => _FindRidePageState();
}

class _FindRidePageState extends State<FindRidePage> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Ride'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _fromController,
              decoration: const InputDecoration(
                labelText: 'From',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _toController,
              decoration: const InputDecoration(
                labelText: 'To',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 90)),
                );
                if (date != null) {
                  setState(() => _selectedDate = date);
                }
              },
              icon: const Icon(Icons.calendar_today),
              label: Text(
                'Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Implement search functionality
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Search Rides'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 