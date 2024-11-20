import 'package:flutter/material.dart';

class HelpAndGuidePage extends StatelessWidget {
  const HelpAndGuidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Guide'),
      ),
      body: ListView(
        children: [
          _buildWelcomeSection(),
          const Divider(),
          _buildFeatureGuides(),
          const Divider(),
          _buildFAQSection(context),
          const Divider(),
          _buildSupportSection(context),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome to ISL App',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your comprehensive tool for Indian Sign Language translation and learning.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGuides() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Features Guide',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildFeatureCard(
          icon: Icons.camera_alt,
          title: 'ISL to Text',
          content: [
            'Point camera at someone using sign language',
            'Hold steady for best results',
            'Real-time translation appears below',
            'Save translations for later reference',
          ],
        ),
        _buildFeatureCard(
          icon: Icons.text_fields,
          title: 'Text to ISL',
          content: [
            'Type or speak your text',
            'Watch avatar demonstrate signs',
            'Practice along with the avatar',
            'Use quick phrases for common expressions',
          ],
        ),
        _buildFeatureCard(
          icon: Icons.campaign,
          title: 'Announcements',
          content: [
            'Create flight/train announcements',
            'Fill required details in the form',
            'Preview ISL translation',
            'Save for future use',
          ],
        ),
        _buildFeatureCard(
          icon: Icons.play_circle,
          title: 'YouTube to ISL',
          content: [
            'Paste YouTube video URL',
            'Ensure video has closed captions',
            'Watch ISL translation alongside video',
            'Control playback as needed',
          ],
        ),
        _buildFeatureCard(
          icon: Icons.school,
          title: 'Learn ISL',
          content: [
            'Start with beginner lessons',
            'Progress through difficulty levels',
            'Practice with interactive exercises',
            'Track your learning progress',
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required List<String> content,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        leading: Icon(icon, size: 28),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var item in content)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle, size: 18, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(child: Text(item)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection(BuildContext context) {
    final List<Map<String, String>> faqs = [
      {
        'question': 'How accurate is the ISL translation?',
        'answer':
        'Our translation system uses advanced AI and is continuously improving. Accuracy typically ranges from 85-95% depending on factors like lighting and gesture clarity.',
      },
      {
        'question': 'Can I use this app offline?',
        'answer':
        'Basic features like saved translations work offline. Live translation and YouTube features require internet connection.',
      },
      {
        'question': 'How do I improve translation accuracy?',
        'answer':
        'Ensure good lighting, clear gestures, and steady camera positioning. Practice with the learning modules to improve sign recognition.',
      },
      {
        'question': 'Is my data secure?',
        'answer':
        'We prioritize user privacy. Translations are processed securely and no video data is stored without explicit permission.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        for (var faq in faqs)
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ExpansionTile(
              title: Text(
                faq['question']!,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(faq['answer']!),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Need More Help?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSupportOption(
            icon: Icons.email,
            title: 'Email Support',
            subtitle: 'Get help via email',
            onTap: () {
              // Handle email support
            },
          ),
          _buildSupportOption(
            icon: Icons.chat,
            title: 'Live Chat',
            subtitle: 'Chat with our support team',
            onTap: () {
              // Handle live chat
            },
          ),
          _buildSupportOption(
            icon: Icons.video_library,
            title: 'Video Tutorials',
            subtitle: 'Watch detailed guides',
            onTap: () {
              // Handle video tutorials
            },
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Text(
                  'App Version 1.0.0',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '© 2024 ISL App. All rights reserved.',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}