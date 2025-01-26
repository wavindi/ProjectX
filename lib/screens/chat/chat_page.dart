import 'package:flutter/material.dart';
import '../../models/contact.dart';

class ChatMessage {
  final String text;
  final bool isSentByMe;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isSentByMe,
    required this.timestamp,
  });
}

class ChatPage extends StatefulWidget {
  final Contact contact;
  
  const ChatPage({
    super.key,
    required this.contact,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isSentByMe: true,
          timestamp: DateTime.now(),
        ),
      );
    });
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[300],
              child: widget.contact.photoUrl != null
                  ? null
                  : Text(
                      widget.contact.name[0],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.contact.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.contact.isOnline)
                    const Text(
                      'Online',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              // Implement video call
            },
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              // Implement voice call
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
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
              ),
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                padding: const EdgeInsets.all(8.0),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessage(message);
                },
              ),
            ),
          ),
          const Divider(height: 1.0),
          _buildTextComposer(),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment:
            message.isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: message.isSentByMe
                  ? Colors.lightBlue[100]
                  : Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  message.text,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: () {
                // Implement file attachment
              },
            ),
            Expanded(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: const InputDecoration(
                  hintText: 'Type a message',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16.0),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  _handleSubmitted(_textController.text);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
} 