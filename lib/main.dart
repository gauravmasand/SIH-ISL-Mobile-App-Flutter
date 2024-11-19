// main.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:isl/Services/AuthServices.dart';
import 'package:isl/pages/MainHomePage/MainHomePage.dart';
import 'package:isl/pages/Welcome/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

import 'constants.dart';

List<CameraDescription> cameras = [];

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   cameras = await availableCameras();
//   runApp(MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              foregroundColor: Colors.white,
              backgroundColor: kPrimaryColor,
              shape: const StadiumBorder(),
              maximumSize: const Size(double.infinity, 56),
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: kPrimaryLightColor,
            iconColor: kPrimaryColor,
            prefixIconColor: kPrimaryColor,
            contentPadding: EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide.none,
            ),
          )),
      home: FutureBuilder(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.data == true) {
              return MainHomePage(); // Replace with your home screen
            } else {
              return WelcomeScreen();
            }
          }
        },
      ),
    );
  }

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtToken');
    return token != null;
  }
}


class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  late Socket _socket;
  bool _isStreaming = false;
  String _serverMessage = "";

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _connectToServer();
  }

  void _initializeCamera() async {
    try {
      _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
      await _cameraController.initialize();
      setState(() {});
    } catch (e) {
      print("Failed to initialize camera: $e");
    }
  }

  void _connectToServer() async {
    try {

      // Retrieve the saved JWT token from shared preferences
      String? token = await AuthService.getToken();

      if (token == null) {
        print('Error: No JWT token found');
        return;
      }

      _socket = await Socket.connect('192.168.1.38', 12343);
      print('Connected to server at 192.168.31.133:12343');

      // Send the token as the first message to the server
      String authHeader = "Authorization: Bearer $token";
      _socket.write(authHeader);

      _receiveMessagesFromServer();
    } catch (e) {
      print('Failed to connect to server: $e');
    }
  }

  void _receiveMessagesFromServer() {
    _socket.listen(
          (Uint8List data) {
        final serverResponse = String.fromCharCodes(data);
        print('Server: $serverResponse');
      },
      onError: (error) {
        print('Error receiving data from server: $error');
        _socket.destroy();
      },
      onDone: () {
        print('Server connection closed');
        _socket.destroy();
      },
    );
  }

  void _startStreaming() async {
    if (!_cameraController.value.isInitialized) {
      print('Error: Camera is not initialized');
      return;
    }

    _isStreaming = true;
    while (_isStreaming) {
      try {
        XFile image = await _cameraController.takePicture();
        Uint8List imageBytes = await image.readAsBytes();
        String base64Image = base64Encode(imageBytes);
        String message = base64Image + '<END_OF_IMAGE>';

        if (_socket != null) {
          _socket.write(message);
        }
        // Ensure ~24 FPS by using appropriate delay.
        // await Future.delayed(Duration(milliseconds: 42));
      } catch (e) {
        print('Failed to send image: $e');
        break;
      }
    }
  }

  void _stopStreaming() {
    setState(() {
      _isStreaming = false;
    });
  }

  @override
  void dispose() {
    _isStreaming = false;
    _cameraController?.dispose();
    _socket?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(title: Text('Camera Streamer')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Camera Streamer')),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width*1.5,
            child: AspectRatio(
              aspectRatio: _cameraController.value.aspectRatio,
              child: CameraPreview(_cameraController),
            ),
          ),
          Container(
            color: Colors.amber,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: _isStreaming ? null : _startStreaming,
                    child: Text('Start'),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: _stopStreaming,
                    child: Text('Stop'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
