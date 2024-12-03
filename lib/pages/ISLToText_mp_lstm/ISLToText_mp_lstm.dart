import 'dart:async';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:isl/Services/AuthServices.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:image/image.dart' as img;

import 'dart:convert';

import '../../Services/ISlToTextServices.dart';
import '../../constants.dart';

class ISLToText_mp_lstm extends StatefulWidget {

  ISLToText_mp_lstm();

  @override
  _ISLToText_mp_lstmState createState() => _ISLToText_mp_lstmState();
}

class _ISLToText_mp_lstmState extends State<ISLToText_mp_lstm> {
  /// Working with good UI and UX
  final IslToTextService _service = IslToTextService();
  late CameraController _cameraController;
  late WebSocketChannel _channel;
  bool _isInitialized = false;
  bool _isConnected = false;
  String _prediction = "";
  DateTime? _lastFrameTime;
  List<CameraDescription> cameras = [];
  bool _isFrontCamera = true;
  static const int targetFps = 24;
  static const int frameInterval = 1000 ~/ targetFps;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

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
      _isInitialized = false;
      _isFrontCamera = !_isFrontCamera;
    });

    await _cameraController.dispose();
    await _initializeCamera();

    setState(() {
      _isInitialized = true;
    });
    _startStreaming();
  }

  Future<void> _initializeWebSocket() async {
    final clientId = await AuthService.getToken();
    print("The client token is $clientId");
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
  }

  void _startStreaming() {
    _cameraController.startImageStream(_processFrame);
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

  Widget _buildPredictionOverlay() {
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

  Widget _buildLoadingState() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Colors.teal,
            ),
            const SizedBox(height: 24),
            Text(
              _isConnected ? 'Initializing camera...' : 'Connecting to server...',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Connection lost',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _initializeServices,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraSwitchButton() {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: IconButton(
        icon: const Icon(Icons.flip_camera_ios),
        color: Colors.white,
        iconSize: 28,
        onPressed: _switchCamera,
        tooltip: 'Switch Camera',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: !_isInitialized
          ? _buildLoadingState()
          : !_isConnected
          ? _buildErrorState()
          : SafeArea(
            child: Column(
              children: [
              // Top Section (Camera/Avatar)
                Expanded(
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
                ),
                // Bottom Section
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        _buildPredictionOverlay(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.black,
  //     body: !_isInitialized
  //         ? _buildLoadingState()
  //         : !_isConnected
  //         ? _buildErrorState()
  //         : Stack(
  //       children: [
  //         // Camera Preview
  //         Positioned.fill(
  //           child: AspectRatio(
  //             aspectRatio: _cameraController.value.aspectRatio,
  //             child: CameraPreview(_cameraController),
  //           ),
  //         ),
  //         // Camera Switch Button
  //         Positioned(
  //           right: 16,
  //             top: 34,
  //             child: _buildCameraSwitchButton()
  //         ),
  //         // Prediction Overlay
  //         Positioned(
  //           left: 12,
  //           right: 12,
  //           bottom: 16,
  //           child: _buildPredictionOverlay(),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  void dispose() {
    _cameraController.dispose();
    _channel.sink.close();
    super.dispose();
  }

}
