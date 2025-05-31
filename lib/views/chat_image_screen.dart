import 'dart:convert';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:skinai/appservices/image_picker_service.dart';
import 'package:skinai/constants/colors.dart';
import 'package:skinai/constants/size_config.dart';
import 'package:skinai/views/doctors_screen.dart';


class ChatWithImageScreen extends StatefulWidget {
  final String userImage;

  const ChatWithImageScreen({super.key, required this.userImage});

  @override
  State<ChatWithImageScreen> createState() => _ChatWithImageScreenState();
}

class _ChatWithImageScreenState extends State<ChatWithImageScreen> {
  final ChatUser _currentUser = ChatUser(id: '1', firstName: 'You');
  final ChatUser _aiUser = ChatUser(id: '2', firstName: 'Derm AI');

  List<ChatMessage> _messages = [];
  List<ChatUser> _typingUsers = [];
  final ImagePickerService _imagePickerService = ImagePickerService();
  bool _imageLoading = true;
  bool _showSuggestions = false;

  Future<void> _handleSend(ChatMessage message) async {
    setState(() {
      _messages.insert(0, message);
      _typingUsers.add(_aiUser);
      _showSuggestions = false; // hide suggestions while new request is processed
    });

    try {
      final result = await _imagePickerService.analyzeImageWithOpenAI(
        context,
        widget.userImage,
        prompt: message.text,
      );

      final responseData = jsonDecode(result);
      final String reply = responseData['data']['analysis'] ?? "No response";

      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            user: _aiUser,
            createdAt: DateTime.now(),
            text: reply,
          ),
        );
        _showSuggestions = true; // show buttons after AI response
      });


    } catch (e) {
      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            user: _aiUser,
            createdAt: DateTime.now(),
            text: "Error: ${e.toString()}",
          ),
        );
        _showSuggestions = false;
      });
    } finally {
      setState(() {
        _typingUsers.remove(_aiUser);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
          title: const Text("Face Analyzer")),

      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },

        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: SizeConfig.screenHeight * 0.30,
                    decoration: BoxDecoration(
                      border: Border.all(color: accentColor, width: 3),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Image.network(
                        widget.userImage,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: SizeConfig.screenHeight * 0.30,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            // Fix the setState error here
                            if (_imageLoading) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted) {
                                  setState(() => _imageLoading = false);
                                }
                              });
                            }
                            return child;
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(color: accentColor),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  if (_imageLoading)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  Positioned(
                    left: 12,
                    bottom: 12,
                    child: Text(
                      "Captured Result",
                      style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 2.2,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            offset: const Offset(1, 1),
                            blurRadius: 3,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
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
            if (_showSuggestions)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: successColor,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Product suggestions coming soon...")),
                        );
                      },
                      child: Text(
                        "Suggest Products",
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: SizeConfig.textMultiplier * 1.5,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: successColor,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AllDoctorsScreen()),
                        );
                      },
                      child: Text(
                        "Suggest Doctors",
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: SizeConfig.textMultiplier * 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
