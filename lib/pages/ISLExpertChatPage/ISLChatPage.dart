import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  late GenerativeModel _model;
  late ChatSession _chatSession;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeGeminiModel();
  }

  void _initializeGeminiModel() {
    const apiKey = 'AIzaSyBFelb6GgFsmWGt5Y4_439t7l6B-R21hGs';

    _model = GenerativeModel(
      model: 'gemini-2.0-flash-exp',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 1.0,
        topP: 0.95,
        topK: 40,
        maxOutputTokens: 8192,
      ),
      systemInstruction: Content.text(
          "Mudra Chatbot: Refinement and Enhanced Features\n\nWelcome Message:\n\nGreeting: When a user says \"Hi\" or \"Hello,\" the chatbot should respond with a warm, welcoming tone:\nResponse: \"Namaste! Welcome to Mudra. How can I assist you today? I’m Mudra, your virtual assistant, here to help you understand more about our features and make communication easier for everyone. Please feel free to ask me anything!\"\nChatbot Features & Interaction Prompts:\n\nISL to Text Conversion:\n\nUser Query: \"How does the ISL to text feature work?\"\nResponse: \"Our ISL to Text feature allows you to record sign language gestures through the camera. These gestures are then converted into text in real-time. This helps both deaf and mute individuals communicate with those who do not know sign language. Just capture the sign, and I’ll show you the corresponding text translation.\"\nText to ISL Conversion:\n\nUser Query: \"What’s the Text to ISL feature?\"\nResponse: \"This feature helps those who don’t know sign language communicate with the deaf and mute community. You can type text, such as 'How are you?', and I will show you an avatar that performs the sign language equivalent. You can also control the speed of the avatar, and we have five different avatars to choose from: Marc, Luna, Siggi, Anna, and Francoise.\"\nTravel Mode:\n\nUser Query: \"What is Travel Mode?\"\nResponse: \"Travel Mode is a special feature that allows quick ISL-to-text and text-to-ISL conversion with just a single click. It's designed to help deaf and mute individuals while traveling. You can also ask travel-related questions like 'Where is the bus?', 'Where is the railway station?', or even use your voice for real-time ISL translation.\"\nMake Announcement:\n\nUser Query: \"How do I create an airport or railway announcement?\"\nResponse: \"In the 'Make Announcement' feature, we offer two sections: 'Airport Announcements' and 'Railway Announcements.' For airport announcements, you can select from options like flight boarding, arrival, departure, gate changes, and more. For example, to make a flight departure announcement, simply fill in details like the airline name, flight number, gate number, and boarding time. Once you submit, an avatar will announce the details for you.\"\nYouTube to ISL:\n\nUser Query: \"Tell me about the YouTube to ISL feature.\"\nResponse: \"The YouTube to ISL feature allows you to watch YouTube videos with real-time sign language translations. You can paste the URL of a YouTube video, and an avatar will appear, signing the dialogues from the video. The avatar's visibility can be adjusted so it doesn't disrupt the viewing experience.\"\nLearn ISL:\n\nUser Query: \"What does the Learn ISL section include?\"\nResponse: \"The 'Learn ISL' section is a great way to understand and learn Indian Sign Language. It includes:\nAlphabets: Learn all 26 letters of the alphabet in sign language.\nNumbers: Learn how to sign numbers from 0 to 9.\nDaily Phrases: Phrases used daily, such as greetings and common expressions.\nEmotions: Learn how to express emotions like happiness, sadness, and anger in sign language.\nFamily: Learn family-related terms like 'mom', 'dad', 'brother', and 'sister'.\nColors: Learn how to sign different colors.\"\nGuide & Help:\n\nUser Query: \"Where can I find help?\"\nResponse: \"In the 'Guide & Help' section, you’ll find FAQs and helpful tips on how to use the app. If you ever get stuck or need assistance, feel free to ask. I’m here to guide you.\"\nAdditional Features and Enhancements:\n\nAvatar Control Mechanism:\n\nAllow users to control avatar speed and customize its style to match their preferences. The avatars (Marc, Luna, Siggi, Anna, Francoise) each bring a unique personality, and users can switch between them as they wish.\nMultilingual Support:\n\nAs you expand the app, consider adding multilingual support so that users from different regions can understand the instructions and interact with the avatars in their local language, making the app more accessible.\nUser Feedback Mechanism:\n\nAsk for user feedback after completing tasks, like:\nResponse: \"Did this feature help you? Let us know if you need more assistance or if you have suggestions to improve Mudra.\"\nVoice-to-Text Integration:\n\nUsers can also use their voice to convert text into ISL, adding another layer of convenience and accessibility.\nHelp Section (Expanded):\n\nProvide step-by-step tutorials or videos explaining how to use each feature, especially for newcomers.\nTraining Prompts for the Chatbot:\n\nGreeting & Conversation Initiation:\n\n\"Namaste! How can I assist you today?\"\n\"Welcome to Mudra! How can I help you?\"\n\"Hello! What can I do for you today?\"\nFeature Query:\n\n\"Do you need help with ISL-to-Text conversion?\"\n\"Are you looking for an avatar announcement or help with YouTube to ISL?\"\nUser Interaction:\n\n\"Which avatar would you like to use for sign language conversion?\"\n\"Would you like to customize the speed of the avatar?\"\nEnding the Conversation:\n\n\"Thank you for using Mudra. Have a great day!\"\n\"Feel free to return anytime if you need assistance. Goodbye for now!\""
      ),
    );

    _chatSession = _model.startChat();
  }

  void _sendMessage() async {
    String messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: messageText,
        isUserMessage: true,
        timestamp: DateTime.now(),
      ));
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      final response = await _chatSession.sendMessage(Content.text(messageText));

      setState(() {
        _messages.add(ChatMessage(
          text: response.text ?? 'No response',
          isUserMessage: false,
          timestamp: DateTime.now(),
        ));
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: 'Oops! Something went wrong.',
          isUserMessage: false,
          timestamp: DateTime.now(),
        ));
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Icon(Icons.sign_language, color: Colors.blue.shade700),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mudra Assistant',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Sign Language Helper',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.black),
            onPressed: () => _showAboutDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          _buildMessageInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUserMessage
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isUserMessage
              ? Colors.blue.shade50
              : Colors.grey.shade100,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: message.isUserMessage
                ? Radius.circular(16)
                : Radius.circular(0),
            bottomRight: message.isUserMessage
                ? Radius.circular(0)
                : Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isUserMessage
                    ? Colors.blue.shade900
                    : Colors.black87,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              DateFormat('hh:mm a').format(message.timestamp),
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInputArea() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
                maxLines: null,
              ),
            ),
            SizedBox(width: 12),
            CircleAvatar(
              backgroundColor: Colors.blue.shade600,
              radius: 25,
              child: IconButton(
                icon: Icon(Icons.send, color: Colors.white),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Mudra Chat Assistant'),
        content: Text(
          'This AI assistant helps you communicate using Indian Sign Language. '
              'Ask questions about sign language, get translations, and learn more!',
          style: TextStyle(color: Colors.grey.shade700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close', style: TextStyle(color: Colors.blue)),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUserMessage;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUserMessage,
    required this.timestamp,
  });
}