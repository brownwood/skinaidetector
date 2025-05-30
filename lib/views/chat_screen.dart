import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import '../appservices/ai_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatUser _currentUser = ChatUser(id: '1', firstName: 'You');
  final ChatUser _aiUser = ChatUser(id: '2', firstName: 'Derm AI');

  List<ChatMessage> _messages = [];
  List<ChatUser> _typingUsers = [];

  Future<void> _handleSend(ChatMessage message) async {
    setState(() {
      _messages.insert(0, message);
      _typingUsers.add(_aiUser);
    });

    try {
      final reply = await AIService.getAIResponse(message.text);

      final responseMessage = ChatMessage(
        user: _aiUser,
        createdAt: DateTime.now(),
        text: reply,
      );

      setState(() {
        _messages.insert(0, responseMessage);
      });
    } catch (e) {
      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            user: _aiUser,
            createdAt: DateTime.now(),
            text: 'Error: ${e.toString()}',
          ),
        );
      });
    } finally {
      setState(() {
        _typingUsers.remove(_aiUser);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Dermatology Assistant"),
      ),
      body: DashChat(
        currentUser: _currentUser,
        onSend: _handleSend,
        messages: _messages,
        typingUsers: _typingUsers,
        messageOptions: const MessageOptions(
          currentUserContainerColor: Colors.black,
          containerColor: Colors.green,
          textColor: Colors.white,
        ),
      ),
    );
  }
}
