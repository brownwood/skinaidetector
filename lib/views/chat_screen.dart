import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import '../appservices/ai_service.dart';
import '../constants/colors.dart';

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
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                'images/robot.png',
                height: 35,
                width: 35,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              "DERM AI",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body:  Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DashChat(
            currentUser: _currentUser,

            onSend: _handleSend,
            messages: _messages,
            typingUsers: _typingUsers,
            inputOptions: InputOptions(
                sendButtonBuilder: (send) => IconButton(
                  icon: const Icon(Icons.send, color: successColor),
                  onPressed: send,
                ),
                cursorStyle: CursorStyle(
                    color: Colors.black
                ),
                inputDecoration: InputDecoration(
                  hintText: 'Type your message here...',
                  hintStyle: TextStyle(
                    color: Colors.grey,          // color of hint text
                    fontSize: 14,                // size of hint text
                    fontWeight: FontWeight.w400, // weight of hint text
                    fontStyle: FontStyle.normal, // optional italic style
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: successColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: successColor, width: 2),
                  ),
                )
            ),

            messageOptions: const MessageOptions(
              currentUserContainerColor: successColor,
              containerColor: Colors.black87,
              textColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
