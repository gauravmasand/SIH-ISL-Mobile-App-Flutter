import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:image/image.dart' as img;

import 'dart:convert';
import 'dart:isolate';

List<CameraDescription> cameras = [];

class WebSocketClient extends StatefulWidget {

  WebSocketClient();

  @override
  _WebSocketClientState createState() => _WebSocketClientState();
}

class _WebSocketClientState extends State<WebSocketClient> {
  /// Working code with better optimization
  late CameraController _cameraController;
  late WebSocketChannel _channel;
  bool _isStreaming = false;
  DateTime? _lastFrameTime;
  String _prediction = "";
  static const int targetFps = 24;
  static const int frameInterval = 1000 ~/ targetFps; // milliseconds between frames

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    final clientId = "123123";
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.10.3:8000/ws/${clientId}'),
    );
    _channel.stream.listen(_handleMessage);  // Add this line
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    // Find the front camera
    final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first, // Fallback to first camera if front camera is not available
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await _cameraController.initialize();

    await _cameraController.lockCaptureOrientation(DeviceOrientation.portraitUp);

    _cameraController.startImageStream(_processFrame);
  }

  // Future<void> _initializeCamera() async {
  //   final cameras = await availableCameras();
  //   final firstCamera = cameras.first;
  //
  //   _cameraController = CameraController(
  //     firstCamera,
  //     ResolutionPreset.medium,
  //     enableAudio: false,
  //     imageFormatGroup: ImageFormatGroup.yuv420,
  //   );
  //
  //   await _cameraController.initialize();
  //
  //   await _cameraController.lockCaptureOrientation(DeviceOrientation.portraitUp);
  //
  //   _cameraController.startImageStream(_processFrame);
  // }


  void _handleMessage(dynamic message) {
    try {
      final data = jsonDecode(message);
      if (data['prediction'] != null) {
        setState(() {
          _prediction = _prediction + " " + data['prediction'];
          print("This is log  of prediction" + _prediction);
        });
      }
    } catch (e) {
      print("Error parsing message: $e");
    }
  }



  void _processFrame(CameraImage image) {
    if (!_isStreaming) return;

    final now = DateTime.now();
    if (_lastFrameTime != null) {
      final elapsed = now.difference(_lastFrameTime!).inMilliseconds;
      if (elapsed < frameInterval) return;
    }
    _lastFrameTime = now;

    try {
      final img.Image frame = _convertYUV420ToImage(image);

      // Rotate the frame from landscape to portrait
      final img.Image rotatedFrame = img.copyRotate(frame, angle: 90); // Rotate 90 degrees clockwise

      final List<int> jpgData = img.encodeJpg(rotatedFrame, quality: 65);
      final String base64Image = base64Encode(jpgData);
      _channel.sink.add(base64Image);
    } catch (e) {
      print("Error processing frame: $e");
    }
  }

  img.Image _convertYUV420ToImage(CameraImage inputImage) {
      final img.Image outputImage = img.Image(
        width: inputImage.width,
        height: inputImage.height,
      );

      final yRowStride = inputImage.planes[0].bytesPerRow;
      final uvRowStride = inputImage.planes[1].bytesPerRow;
      final uvPixelStride = inputImage.planes[1].bytesPerPixel ?? 1;

      // More accurate YUV -> RGB conversion coefficients
      const double ry = 1.0;
      const double gy = 1.0;
      const double by = 1.0;
      const double ru = 0.0;
      const double gu = -0.344136;
      const double bu = 1.772;
      const double rv = 1.402;
      const double gv = -0.714136;
      const double bv = 0.0;

      for (int y = 0; y < inputImage.height; y++) {
        for (int x = 0; x < inputImage.width; x++) {
          final int yIndex = y * yRowStride + x;

          // Proper UV index calculation with pixel stride
          final int uvRow = y ~/ 2;
          final int uvCol = x ~/ 2;
          final int uvIndex = uvRow * uvRowStride + uvCol * uvPixelStride;

          // Extract YUV values
          final int yValue = inputImage.planes[0].bytes[yIndex];
          final int uValue = inputImage.planes[1].bytes[uvIndex];
          final int vValue = inputImage.planes[2].bytes[uvIndex];

          // Adjusted YUV -> RGB conversion
          final double yNormalized = (yValue - 16) * 1.164;
          final double uDiff = uValue - 128;
          final double vDiff = vValue - 128;

          final int r = (yNormalized + rv * vDiff).round().clamp(0, 255);
          final int g = (yNormalized + gu * uDiff + gv * vDiff).round().clamp(0, 255);
          final int b = (yNormalized + bu * uDiff).round().clamp(0, 255);

          outputImage.setPixelRgb(x, y, r, g, b);
        }
      }

      return outputImage;
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video Stream")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isStreaming = !_isStreaming;
              });
            },
            child: Text(_isStreaming ? "Stop Streaming" : "Start Streaming"),
          ),
          if (_isStreaming)
            SizedBox(
              width: 320, // Fixed size preview
              height: 240,
              child: CameraPreview(_cameraController),
            ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _prediction,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class ISLToText_mp_lstm extends StatefulWidget {
//   @override
//   _ISLToText_mp_lstmState createState() => _ISLToText_mp_lstmState();
// }
//
// class _ISLToText_mp_lstmState extends State<ISLToText_mp_lstm> {
//   late CameraController _cameraController;
//   late WebSocketChannel _channel;
//
//   void initCamera() async {
//     cameras = await availableCameras();
//   }
//
//   @override
//   void initState() {
//     initCamera();
//     super.initState();
//     _initializeCamera();
//     _initializeWebSocket();
//   }
//
//   // Initialize camera
//   void _initializeCamera() async {
//     setState(() async {
//       _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
//       await _cameraController.initialize();
//     });
//     _startStreaming();
//   }
//
//   // Initialize WebSocket connection
//   void _initializeWebSocket() {
//     _channel = WebSocketChannel.connect(Uri.parse('ws://172.20.10.7/ws'));
//   }
//
//   // Start streaming video frames
//   void _startStreaming() {
//     _cameraController.startImageStream((image) async {
//       try {
//         // Convert the camera frame to an image
//         img.Image? imgFrame = img.decodeImage(Uint8List.fromList(image.planes[0].bytes));
//
//         if (imgFrame != null) {
//           // Encode the image as a JPEG (you can also use WebP for better compression)
//           List<int> jpegBytes = img.encodeJpg(imgFrame, quality: 80);
//
//           // Send the image bytes to the WebSocket server
//           _channel.sink.add(jpegBytes);
//         }
//       } catch (e) {
//         print('Error streaming image: $e');
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _cameraController.dispose();
//     _channel.sink.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Live Video Streaming')),
//       body: Center(
//         child: _cameraController.value.isInitialized
//             ? CameraPreview(_cameraController)
//             : CircularProgressIndicator(),
//       ),
//     );
//   }
// }