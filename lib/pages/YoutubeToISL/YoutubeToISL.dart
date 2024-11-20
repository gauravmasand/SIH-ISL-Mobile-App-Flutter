import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeToISLPage extends StatefulWidget {
  const YouTubeToISLPage({Key? key}) : super(key: key);

  @override
  _YouTubeToISLPageState createState() => _YouTubeToISLPageState();
}

class _YouTubeToISLPageState extends State<YouTubeToISLPage> {
  final TextEditingController _urlController = TextEditingController();
  YoutubePlayerController? _controller;
  bool _isUrlValid = false;
  bool _showSubtitles = true;
  bool _isFullScreen = false;

  @override
  void dispose() {
    _urlController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  void _initializeYouTubePlayer(String url) {
    final videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId != null) {
      setState(() {
        _controller = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            enableCaption: true,
            captionLanguage: 'en',
          ),
        );
        _isUrlValid = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid YouTube URL')),
      );
    }
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isFullScreen
          ? null
          : AppBar(
        title: const Text('YouTube to ISL'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelpDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (!_isFullScreen) ...[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _urlController,
                            decoration: InputDecoration(
                              hintText: 'Enter YouTube URL',
                              prefixIcon: const Icon(Icons.link),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 100, // Fixed width for button
                          child: ElevatedButton(
                            onPressed: () => _initializeYouTubePlayer(_urlController.text),
                            child: const Text('Load'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () => _showYouTubePicker(),
                          icon: const Icon(Icons.video_library),
                          label: const Text('Choose from YouTube'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            if (_isUrlValid && _controller != null) ...[
              Stack(
                children: [
                  YoutubePlayer(
                    controller: _controller!,
                    showVideoProgressIndicator: true,
                    progressColors: const ProgressBarColors(
                      playedColor: Colors.red,
                      handleColor: Colors.redAccent,
                    ),
                    onReady: () {
                      print('Player is ready.');
                    },
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: IconButton(
                      icon: Icon(_isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
                      onPressed: _toggleFullScreen,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              if (!_isFullScreen) ...[
                const Divider(height: 32),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'ISL Translation',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.settings),
                              onPressed: _showSettingsDialog,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Stack(
                            children: [
                              const Center(
                                child: Text('ISL Avatar will appear here'),
                              ),
                              if (_showSubtitles)
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    color: Colors.black54,
                                    child: const Text(
                                      'Subtitles will appear here',
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ] else
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.ondemand_video_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Enter a YouTube URL to start',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Supports YouTube videos with closed captions',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to Use'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('1. Enter a YouTube URL or choose from YouTube'),
            Text('2. Make sure the video has closed captions'),
            Text('3. The ISL avatar will translate the captions in real-time'),
            Text('4. Toggle subtitles on/off as needed'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Show Subtitles'),
              value: _showSubtitles,
              onChanged: (value) {
                setState(() => _showSubtitles = value);
                Navigator.pop(context);
              },
            ),
            // Add more settings as needed
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showYouTubePicker() {
    // Implement YouTube video picker
    // This could open a webview with YouTube search or
    // use YouTube Data API to show a custom picker
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Feature Coming Soon'),
        content: const Text('YouTube video picker will be available soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
