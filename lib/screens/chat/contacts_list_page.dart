import 'package:flutter/material.dart';
import '../../models/contact.dart';
import 'chat_page.dart';

class ContactsListPage extends StatefulWidget {
  const ContactsListPage({super.key});

  @override
  State<ContactsListPage> createState() => _ContactsListPageState();
}

class _ContactsListPageState extends State<ContactsListPage> {
  // Dummy data for demonstration
  final List<Contact> contacts = [
    Contact(
      id: '1',
      name: 'Adam',
      lastMessage: 'Hey, are you available for a ride?',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
      isOnline: true,
    ),
    Contact(
      id: '2',
      name: 'Adam Mehdi',
      lastMessage: 'Thanks for the ride!',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Contact(
      id: '3',
      name: 'Nathan FUmal',
      lastMessage: 'See you tomorrow at 9 AM',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
      isOnline: true,
    ),
  ];

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == now.year) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
    return '${time.day}/${time.month}/${time.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Implement more options
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey[300],
                  child: contact.photoUrl != null
                      ? null
                      : Text(
                          contact.name[0],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
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
            title: Text(
              contact.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              contact.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              _formatTime(contact.lastMessageTime),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(contact: contact),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement new chat functionality
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
} 