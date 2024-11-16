import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TextToISL extends StatefulWidget {
  const TextToISL({Key? key}) : super(key: key);

  @override
  State<TextToISL> createState() => _TextToISLState();
}

class _TextToISLState extends State<TextToISL> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('http://192.168.31.133:55055/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text To ISL'),
        centerTitle: true,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}