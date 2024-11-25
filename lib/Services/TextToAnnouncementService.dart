import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TextToAnnouncementService extends StatefulWidget {
  String text;
  TextToAnnouncementService({super.key, required this.text});

  @override
  State<TextToAnnouncementService> createState() => _TextToAnnouncementServiceState();
}

class _TextToAnnouncementServiceState extends State<TextToAnnouncementService> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the WebView and load the initial URL
    initWebView(widget.text);
  }

  // Custom encode function to ensure spaces are encoded as %20
  String customUrlEncode(String text) {
    return text.replaceAll(' ', '%20');
  }

  void printFutureValue(Future<String?> futureValue) {
    futureValue.then((result) {
      if (result != null) {
        print("This is log of future: $result");
      } else {
        print("URL is null");
      }
    }).catchError((error) {
      print("Error fetching current URL: $error");
    });
  }

  void initWebView(String inputText) async {
    final String baseUrl = 'http://64.227.148.189:55055';
    final String text = inputText.isNotEmpty ? customUrlEncode(inputText) : '';
    final String encodedUrl = '$baseUrl/text-from-url?text=$text';

    print("Encoded URL: $encodedUrl");

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(encodedUrl));

    Future.delayed(Duration(seconds: 1), () {
      printFutureValue(_controller.currentUrl());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text to Announcement Service'),
        backgroundColor: Colors.teal,
      ),
      body: _buildAvatarView(),
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
}
