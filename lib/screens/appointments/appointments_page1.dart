import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/contact.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Contact? _selectedContact;
  final ScrollController _scrollController = ScrollController();

  // Dummy data - in real app, this would come from your chat contacts
  final List<Contact> _contacts = [
    Contact(
      id: '1',
      name: 'Wajdi',
      lastMessage: 'Hey, are you available for a ride?',
      lastMessageTime: DateTime.now(),
      isOnline: true,
    ),
    Contact(
      id: '2',
      name: 'Mehdi',
      lastMessage: 'Thanks for the ride!',
      lastMessageTime: DateTime.now(),
    ),
    Contact(
      id: '3',
      name: 'Adam',
      lastMessage: 'See you tomorrow at 9 AM',
      lastMessageTime: DateTime.now(),
      isOnline: true,
    ),
    Contact(
      id: '4',
      name: 'Nathan',
      lastMessage: 'Perfect timing!',
      lastMessageTime: DateTime.now(),
    ),
  ];

  void _showRideProposalDialog(DateTime dateTime) {
    if (_selectedContact == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a contact first'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final TimeOfDay initialTime = TimeOfDay.now();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Propose Ride'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'To: ${_selectedContact!.name}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Date: ${dateTime.day}/${dateTime.month}/${dateTime.year}',
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Time: '),
                TextButton(
                  onPressed: () async {
                    final TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: initialTime,
                    );
                    if (time != null) {
                      // Handle time selection
                    }
                  },
                  child: Text(
                    '${initialTime.hour}:${initialTime.minute.toString().padLeft(2, '0')}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Add a message (optional)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle ride proposal
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ride proposal sent!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Send Proposal'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactBubbles() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          final contact = _contacts[index];
          final isSelected = contact.id == _selectedContact?.id;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedContact = isSelected ? null : contact;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[200],
                          child: Text(
                            contact.name[0],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      if (contact.isOnline)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    contact.name.split(' ')[0],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan a Ride'),
      ),
      body: Column(
        children: [
          _buildContactBubbles(),
          const Divider(),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: TableCalendar(
                    firstDay: DateTime.now(),
                    lastDay: DateTime.now().add(const Duration(days: 365)),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      if (_selectedContact != null) {
                        _showRideProposalDialog(selectedDay);
                      }
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    calendarStyle: const CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle plan ride
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Plan a Ride',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 