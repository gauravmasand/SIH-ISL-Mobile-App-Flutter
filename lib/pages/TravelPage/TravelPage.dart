import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:image/image.dart' as img;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../Services/AuthServices.dart';
import '../../Services/ISlToTextServices.dart';
import '../../constants.dart';

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
  late final WebViewController _controller;
  final IslToTextService _service = IslToTextService();
  /// Working with good UI and UX
  late WebSocketChannel _channel;
  bool _isInitialized = false;
  bool _isConnected = false;
  String _prediction = "";
  DateTime? _lastFrameTime;
  List<CameraDescription> cameras = [];
  bool _isFrontCamera = true;  // Track current camera
  static const int targetFps = 24;
  static const int frameInterval = 1000 ~/ targetFps;

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

  /// ISL to Text Functions
  Future<void> _initializeServices() async {
    try {
      // Get available cameras first
      cameras = await availableCameras();
      await _initializeCamera();
      await _initializeWebSocket();
      setState(() {
        _isInitialized = true;
        _isConnected = true;
      });
      _startStreaming();
    } catch (e) {
      print("Initialization error: $e");
      setState(() {
        _isInitialized = true;
        _isConnected = false;
      });
    }
  }

  Future<void> _switchCamera() async {
    setState(() {
      _isCameraInitialized = false;
      _isInitialized = false;
      _isFrontCamera = !_isFrontCamera;
    });

    await _cameraController.dispose();
    await _initializeCamera();

    setState(() {
      _isCameraInitialized = true;
      _isInitialized = true;
    });
    _startStreaming();
  }

  Future<void> _initializeWebSocket() async {
    final clientId = await AuthService.getToken();
    _channel = WebSocketChannel.connect(
      Uri.parse('$islToTextBaseURl/ws/${clientId}'),
    );
    _channel.stream.listen(_handleMessage, onError: (error) {
      setState(() => _isConnected = false);
    });
  }

  Future<void> _initializeCamera() async {
    final selectedCamera = cameras.firstWhere(
          (camera) => _isFrontCamera
          ? camera.lensDirection == CameraLensDirection.front
          : camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      selectedCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await _cameraController.initialize();
    await _cameraController.lockCaptureOrientation(DeviceOrientation.portraitUp);

    setState(() {
      _isCameraInitialized = true;
    });
  }

  Future<void> _startStreaming() async {
    if (!_isInitialized) {
      await _initializeCamera();
    }
    await _cameraController.startImageStream(_processFrame);
    setState(() {
      _isInitialized = true;
    });
  }

  void _handleMessage(dynamic message) {
    try {
      final data = jsonDecode(message);
      if (data['prediction'] != null) {
        setState(() {
          _prediction = _prediction.isEmpty
              ? data['prediction']
              : "$_prediction ${data['prediction']}";
        });
      }
    } catch (e) {
      print("Error parsing message: $e");
    }
  }

  void _processFrame(CameraImage image) {
    if (!_isConnected) return;

    final now = DateTime.now();
    if (_lastFrameTime != null) {
      final elapsed = now.difference(_lastFrameTime!).inMilliseconds;
      if (elapsed < frameInterval) return;
    }
    _lastFrameTime = now;

    try {
      final img.Image frame = _service.convertYUV420ToImage(image);

      // Fix rotation based on camera direction
      final img.Image rotatedFrame = _isFrontCamera
          ? img.copyRotate(frame, angle: -90)  // Rotate counterclockwise for front camera
          : img.copyRotate(frame, angle: 90);  // Rotate clockwise for back camera

      final List<int> jpgData = img.encodeJpg(rotatedFrame, quality: 65);
      final String base64Image = base64Encode(jpgData);
      _channel.sink.add(base64Image);
    } catch (e) {
      print("Error processing frame: $e");
    }
  }
  /// ISL to Text Functions

  // Custom encode function to ensure spaces are encoded as %20
  String customUrlEncode(String text) {
    return text.replaceAll(' ', '%20');
  }

  void printFutureValue(Future<String?> futureValue) {
    futureValue.then((result) {
      if (result != null) {
        print("This is log of future " + result);
      } else {
        print("URL is null");
      }
    }).catchError((error) {
      print("Error fetching current URL: $error");
    });
  }

  void initWebView(String inputText) async {
    // final String baseUrl = 'http://64.227.148.189:55055';
    final String text = inputText.isNotEmpty ? customUrlEncode(inputText) : '';
    final String encodedUrl = '$textToISLBaseURl/text-from-url?text=$text';

    print(encodedUrl);

    // If already initialized, simply load the new URL
    await _controller.setJavaScriptMode(JavaScriptMode.unrestricted).then((_) {
      print("New URL loaded: $encodedUrl");
    }).catchError((error) {
      print("Error loading URL: $error");
    });
    // If already initialized, simply load the new URL
    await _controller.loadRequest(Uri.parse(encodedUrl)).then((_) {
      print("New URL loaded: $encodedUrl");
    }).catchError((error) {
      print("Error loading URL: $error");
    });

    Future.delayed(Duration(seconds: 1), () {
      printFutureValue(_controller.currentUrl());
    });

    print("check pass 3");

    // Clear the TextField after submission
    _textController.clear();
  }

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _speech = stt.SpeechToText();

    // Listen to the status updates and handle when the session ends automatically
    _speech.statusListener = (status) {
      if (status == "notListening") {
        setState(() {
          _isListening = false;
        });
      }
    };

    _controller = WebViewController();

    initWebView("");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Section (Camera/Avatar)
            Expanded(
              flex: 6,
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
                      onPressed: () {
                        setState(() {
                          isISLToText = !isISLToText;
                          if (isISLToText) {
                            _startStreaming();
                          } else {
                            _stopStreaming();
                          }
                        });
                      },
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
                      Padding(
                        padding: EdgeInsets.only(left: 24, right: 24),
                        child: ElevatedButton(onPressed: () => _showQuickPhrasesDialog(context), child: Text("Quick Conversation")),
                      ),
                      // Expanded(child: _buildQuickPhrases()),
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
    return Expanded(
      flex: 6,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Positioned.fill(
          child: AspectRatio(
            aspectRatio: _cameraController.value.aspectRatio,
            child: CameraPreview(_cameraController),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarView() {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Center(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }

  Widget _buildDetectedTextArea() {
    final words = _prediction.split(' ');
    final lastWord = words.isNotEmpty ? words.last : '';
    final previousWords = words.length > 1 ? words.sublist(0, words.length - 1).join(' ') : '';

    return Container(
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ISL to Text',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.flip_camera_ios_outlined, color: Colors.black87,),
                color: Colors.white,
                iconSize: 28,
                onPressed: _switchCamera,
                tooltip: 'Switch Camera',
              )
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: previousWords + ' ',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    WidgetSpan(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          lastWord,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
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

  // New method to handle text submission
  void _submitText(String text) {
    if (text.isNotEmpty) {
      print("Submitting text: $text");
      // Call your existing initWebView method to handle submission
      initWebView(text);

      // Optionally clear the text field after submission
      _textController.clear();
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();

    // Automatically submit the text in the _textController when audio stops
    _submitText(_textController.text);
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
              onSubmitted: (value) async {
                // Handle submit on keyboard enter
                print("Message sent: $value");
                // Handle submit on keyboard enter
                if (value.isNotEmpty) {
                  print("Message sent after not null: $value");
                  // Reinitialize the WebView with the new URL
                  initWebView(value);
                  _controller.reload();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showQuickPhrasesDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Handle indicator
                  Container(
                    width: 50,
                    height: 6,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Quick Phrases',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: quickPhrases.map((categoryMap) {
                        String category = categoryMap.keys.first;
                        List<String> phrases = categoryMap[category]!;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: phrases.map((phrase) {
                                  return GestureDetector(
                                    onTap: () {
                                      _textController.text = phrase;
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.deepPurple.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.deepPurple.withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        phrase,
                                        style: TextStyle(
                                          color: Colors.deepPurple[800],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
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
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _channel.sink.close();
    super.dispose();
  }

  Future<void> _stopStreaming() async {
    setState(() {
      _isInitialized = false;
    });
    await _cameraController.stopImageStream();
  }
}