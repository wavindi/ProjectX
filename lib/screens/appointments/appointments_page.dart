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
          Container(
  width: 375,
  height: 812,
  clipBehavior: Clip.antiAlias,
  decoration: BoxDecoration(color: Color(0xFF020611)),
  child: Stack(
    children: [
      Positioned(
        left: -188,
        top: -184,
        child: Container(
          width: 752,
          height: 382,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.00, -1.00),
              end: Alignment(0, 1),
              colors: [Colors.white.withOpacity(0), Colors.white],
            ),
          ),
        ),
      ),
      Positioned(
        left: 0,
        top: 198,
        child: Container(
          width: 375,
          height: 614,
          padding: const EdgeInsets.symmetric(vertical: 16),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 414,
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Color(0xFF0F1728),
                          fontSize: 28,
                          fontFamily: 'Satoshi Variable',
                          fontWeight: FontWeight.w700,
                          height: 1.29,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 54,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                                    decoration: ShapeDecoration(
                                      color: Color(0xFFF2F3F6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'First Name',
                                          style: TextStyle(
                                            color: Color(0xFF667084),
                                            fontSize: 13,
                                            fontFamily: 'Public Sans',
                                            fontWeight: FontWeight.w400,
                                            height: 1.38,
                                            letterSpacing: -0.08,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    height: 54,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                                    decoration: ShapeDecoration(
                                      color: Color(0xFFF2F3F6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Last Name',
                                          style: TextStyle(
                                            color: Color(0xFF667084),
                                            fontSize: 13,
                                            fontFamily: 'Public Sans',
                                            fontWeight: FontWeight.w400,
                                            height: 1.38,
                                            letterSpacing: -0.08,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
  decoration: InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
    filled: true,
    fillColor: Color(0xFFF2F3F6),
    hintText: 'Email address',
    hintStyle: TextStyle(
      color: Color(0xFF667084),
      fontSize: 13,
      fontFamily: 'Public Sans',
      fontWeight: FontWeight.w400,
      height: 1.38,
      letterSpacing: -0.08,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none, // Removes border lines
    ),
  ),
  style: TextStyle(
    fontSize: 13,
    fontFamily: 'Public Sans',
    fontWeight: FontWeight.w400,
    height: 1.38,
    letterSpacing: -0.08,
  ),
),

                          const SizedBox(height: 8),
                          Container(
                            width: 343,
                            height: 54,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                            decoration: ShapeDecoration(
                              color: Color(0xFFF2F3F6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Password ',
                                  style: TextStyle(
                                    color: Color(0xFF667084),
                                    fontSize: 13,
                                    fontFamily: 'Public Sans',
                                    fontWeight: FontWeight.w400,
                                    height: 1.38,
                                    letterSpacing: -0.08,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  width: 24,
                                  height: 24,
                                  child: FlutterLogo(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 343,
                            height: 54,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                            decoration: ShapeDecoration(
                              color: Color(0xFFF2F3F6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Confirm Password',
                                  style: TextStyle(
                                    color: Color(0xFF667084),
                                    fontSize: 13,
                                    fontFamily: 'Public Sans',
                                    fontWeight: FontWeight.w400,
                                    height: 1.38,
                                    letterSpacing: -0.08,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  width: 24,
                                  height: 24,
                                  child: FlutterLogo(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 32,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'By registering, you accept our',
                                    style: TextStyle(
                                      color: Color(0xFF6B7280),
                                      fontSize: 11,
                                      fontFamily: 'SF Pro Text',
                                      fontWeight: FontWeight.w400,
                                      height: 1.18,
                                      letterSpacing: 0.07,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ',
                                    style: TextStyle(
                                      color: Color(0xFF6B7280),
                                      fontSize: 11,
                                      fontFamily: 'SF Pro Text',
                                      fontWeight: FontWeight.w700,
                                      height: 1.18,
                                      letterSpacing: 0.07,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Terms & Conditions',
                                    style: TextStyle(
                                      color: Color(0xFF4BBDD8),
                                      fontSize: 11,
                                      fontFamily: 'SF Pro Text',
                                      fontWeight: FontWeight.w700,
                                      height: 1.18,
                                      letterSpacing: 0.07,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ',
                                    style: TextStyle(
                                      color: Color(0xFF4BBDD8),
                                      fontSize: 11,
                                      fontFamily: 'SF Pro Text',
                                      fontWeight: FontWeight.w400,
                                      height: 1.18,
                                      letterSpacing: 0.07,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'and',
                                    style: TextStyle(
                                      color: Color(0xFF6B7280),
                                      fontSize: 11,
                                      fontFamily: 'SF Pro Text',
                                      fontWeight: FontWeight.w400,
                                      height: 1.18,
                                      letterSpacing: 0.07,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ',
                                    style: TextStyle(
                                      color: Color(0xFF4BBDD8),
                                      fontSize: 11,
                                      fontFamily: 'SF Pro Text',
                                      fontWeight: FontWeight.w400,
                                      height: 1.18,
                                      letterSpacing: 0.07,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                      color: Color(0xFF4BBDD8),
                                      fontSize: 11,
                                      fontFamily: 'SF Pro Text',
                                      fontWeight: FontWeight.w700,
                                      height: 1.18,
                                      letterSpacing: 0.07,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '. Your data will be securely encrypted with TLS. 🔒',
                                    style: TextStyle(
                                      color: Color(0xFF6B7280),
                                      fontSize: 11,
                                      fontFamily: 'SF Pro Text',
                                      fontWeight: FontWeight.w400,
                                      height: 1.18,
                                      letterSpacing: 0.07,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 343,
                            height: 44,
                            padding: const EdgeInsets.all(12),
                            decoration: ShapeDecoration(
                              color: Color(0xFF4BBDD8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Sign Up',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Public Sans',
                                    fontWeight: FontWeight.w500,
                                    height: 1.50,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Already have an account?',
                                  style: TextStyle(
                                    color: Color(0xFF667084),
                                    fontSize: 12,
                                    fontFamily: 'Public Sans',
                                    fontWeight: FontWeight.w500,
                                    height: 1.50,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Color(0xFF4BBDD8),
                                    fontSize: 12,
                                    fontFamily: 'Public Sans',
                                    fontWeight: FontWeight.w500,
                                    height: 1.50,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 8),
                    Text(
                      'OR',
                      style: TextStyle(
                        color: Color(0xFF667084),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 343,
                height: 54,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Color(0xFFF2F3F6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      child: FlutterLogo(),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Sign up with Linkedin',
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 14,
                        fontFamily: 'Public Sans',
                        fontWeight: FontWeight.w500,
                        height: 1.43,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 343,
                height: 54,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Color(0xFFF2F3F6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(),
                      child: FlutterLogo(),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Sign up with Google',
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 14,
                        fontFamily: 'Public Sans',
                        fontWeight: FontWeight.w500,
                        height: 1.43,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        left: 0,
        top: 0,
        child: Container(
          width: 375,
          height: 44,
          padding: const EdgeInsets.only(
            top: 14,
            left: 30,
            right: 21.75,
            bottom: 14,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '9:41',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 1,
                ),
              ),
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 18,
                      height: 10,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage("https://via.placeholder.com/18x10"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: 15.27,
                      height: 10.97,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage("https://via.placeholder.com/15x11"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: 26.98,
                      height: 13,
                      child: Stack(),
                    ),
                  ],
                ),
              ),
            ],
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