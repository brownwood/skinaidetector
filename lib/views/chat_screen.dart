import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final ChatUser _currentUser = ChatUser(id: '1', firstName: 'You', lastName: '');
  final ChatUser _gptUser = ChatUser(id: '2', firstName: 'Google', lastName: 'Gemini');

  List<ChatMessage> _messages = <ChatMessage>[];
  List<ChatUser> typingUser = <ChatUser>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Chatbot"),
      ),
      body: DashChat(
        typingUsers: typingUser,
        currentUser: _currentUser,
        onSend: (ChatMessage message){
          gptChatResponse(message);
        },
        messages: _messages,
        messageOptions: const MessageOptions(
            currentUserContainerColor: Colors.black, //Current User Container Color
            containerColor: Colors.green, //Other User Container Color
            textColor: Colors.white

        ),
      ),
    );
  }

  Future<void> gptChatResponse(ChatMessage message) async {
    setState(() {
      _messages.insert(0, message);
      typingUser.add(_gptUser);
    });

    final String userMessage = message.text;

    try {
      dynamic gemini = Gemini.instance;
      final response = await gemini.prompt(parts: [
        Part.text(userMessage),
      ]);

        setState(() {
          _messages.insert(
            0,
            ChatMessage(
              user: _gptUser,
              createdAt: DateTime.now(),
              text: response.content!.parts.first.text,
            ),
          );
        });

    } catch (e) {
      print('Gemini API error: $e');
      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            user: _gptUser,
            createdAt: DateTime.now(),
            text: "$e",
          ),
        );
      });
    } finally {
      setState(() {
        typingUser.remove(_gptUser);
      });
    }
  }

}

