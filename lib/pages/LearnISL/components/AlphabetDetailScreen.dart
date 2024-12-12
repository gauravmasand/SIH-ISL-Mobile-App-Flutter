import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../models/AlphabetModel.dart';

class AlphabetDetailScreen extends StatefulWidget {
  final AlphabetModel alphabet;

  AlphabetDetailScreen({required this.alphabet});

  @override
  _AlphabetDetailScreenState createState() => _AlphabetDetailScreenState();
}

class _AlphabetDetailScreenState extends State<AlphabetDetailScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.alphabet.videoPath)
      ..setLooping(true) // Loop the video
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose(); // Dispose the controller when screen is disposed
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    'Letter ${widget.alphabet.letter}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Video player container
                  _controller.value.isInitialized
                      ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                      : const Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 24, right: 24),
            child: ElevatedButton(
              onPressed: () {
                // Implement practice functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF444444),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Complete'),
            ),
          ),
          SizedBox(height: 100,)
        ],
      ),
    );
  }
}