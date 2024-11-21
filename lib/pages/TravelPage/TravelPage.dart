import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class TravelPage extends StatefulWidget {
  const TravelPage({Key? key}) : super(key: key);

  @override
  _TravelPageState createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> {
  bool isISLToText = true;
  bool isListening = false;
  late CameraController _cameraController;
  bool _isCameraInitialized = false;


  // for audio
  final TextEditingController _textController = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _speechText = "";

  final List<Map<String, List<String>>> quickPhrases = [
    {
      'Transport': [
        'Where is the bus stop?',
        'How much is the fare?',
        'Where is the station?',
        'Call a taxi'
      ]
    },
    {
      'Emergency': [
        'I need help',
        'Call ambulance',
        'Call police',
        'Medical emergency'
      ]
    },
    {
      'General': [
        'How much does it cost?',
        'Thank you',
        'Good morning',
        'Nice to meet you'
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _speech = stt.SpeechToText();

    // Listen to the status updates and handle when the session ends automatically
    _speech.statusListener = (status) {
      if (status == "notListening") {
        setState(() {
          _isListening = false;
        });
      }
    };
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    await _cameraController.initialize();
    setState(() => _isCameraInitialized = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(  // Changed from Stack to Column
          children: [
            // Top Section (Camera/Avatar)
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black,
                    child: isISLToText
                        ? _buildCameraView()
                        : _buildAvatarView(),
                  ),
                  Positioned(
                    top: 40,
                    right: 16,
                    child: FloatingActionButton(
                      heroTag: 'switch',
                      onPressed: () => setState(() => isISLToText = !isISLToText),
                      child: Icon(isISLToText ? Icons.text_fields : Icons.sign_language),
                      mini: true,
                    ),
                  ),
                ],
              ),
            ),
            // Bottom Section
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    if (isISLToText)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: _buildDetectedTextArea(),
                        ),
                      )
                    else ...[
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: _buildInputArea(),
                      ),
                      Expanded(child: _buildQuickPhrases()),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraView() {
    if (!_isCameraInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return CameraPreview(_cameraController);
  }

  Widget _buildAvatarView() {
    return Container(
      height: MediaQuery.of(context).size.width*1.3,
      color: Colors.white,
      child: Center(
        child: Text("Avatar will get diaplayed here"),
      ),
    );
  }

  Widget _buildDetectedTextArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ISL to Text',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          const Expanded(
            child: Text(
              'Real-time detected text will appear here...',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print("Speech status: $status"),
      onError: (error) => print("Speech error: $error"),
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _textController.text = result.recognizedWords;
          });
        },
      );
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  Widget _buildInputArea() {
    return Container(
      height: 56,
      padding: const EdgeInsets.only(left: 8, right: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _isListening ? _stopListening : _startListening,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isListening ? Colors.red[100] : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isListening ? Icons.mic : Icons.mic_none_rounded,
                color: _isListening ? Colors.red : Colors.grey[700],
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _textController,
              maxLines: 1,
              textInputAction: TextInputAction.send,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                fillColor: Colors.grey[50],
              ),
              onSubmitted: (value) {
                // Handle submit on keyboard enter
                print("Message sent: $value");
                _textController.clear();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickPhrases() {
    return Container(
      height: 290,
      margin:  const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: quickPhrases.map((category) {
                String categoryName = category.keys.first;
                List<String> phrases = category.values.first;
                return Container(
                  width: 260,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _getCategoryIcon(categoryName),
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              categoryName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          physics: const BouncingScrollPhysics(),
                          itemCount: phrases.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                // Handle phrase selection
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        phrases[index],
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14,
                                      color: Colors.grey[400],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'transport':
        return Icons.directions_bus;
      case 'emergency':
        return Icons.emergency;
      case 'general':
        return Icons.chat_bubble;
      default:
        return Icons.category;
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }
}