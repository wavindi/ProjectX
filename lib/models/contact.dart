class Contact {
  final String id;
  final String name;
  final String? photoUrl;
  final String lastMessage;
  final DateTime lastMessageTime;
  final bool isOnline;

  Contact({
    required this.id,
    required this.name,
    this.photoUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    this.isOnline = false,
  });
} 