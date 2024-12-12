import 'package:flutter/material.dart';

import '../models/PhraseModel.dart';

class LearnDailyPhrasesPage extends StatefulWidget {
  const LearnDailyPhrasesPage({super.key});

  @override
  State<LearnDailyPhrasesPage> createState() => _LearnDailyPhrasesPageState();
}

class _LearnDailyPhrasesPageState extends State<LearnDailyPhrasesPage> {
  final List<PhraseModel> phrases = [
    PhraseModel(
      phrase: 'Hello',
      imageUrl: 'assets/isl_phrases/hello.png',
      description: 'Learn how to sign "Hello"',
    ),
    PhraseModel(
      phrase: 'How are you?',
      imageUrl: 'assets/isl_phrases/how_are_you.png',
      description: 'Learn how to sign "How are you?"',
    ),
    PhraseModel(
      phrase: 'Thank you',
      imageUrl: 'assets/isl_phrases/thank_you.png',
      description: 'Learn how to sign "Thank you"',
    ),
    PhraseModel(
      phrase: 'Please',
      imageUrl: 'assets/isl_phrases/please.png',
      description: 'Learn how to sign "Please"',
    ),
    PhraseModel(
      phrase: 'Sorry',
      imageUrl: 'assets/isl_phrases/sorry.png',
      description: 'Learn how to sign "Sorry"',
    ),
    PhraseModel(
      phrase: 'Yes',
      imageUrl: 'assets/isl_phrases/yes.png',
      description: 'Learn how to sign "Yes"',
    ),
    PhraseModel(
      phrase: 'No',
      imageUrl: 'assets/isl_phrases/no.png',
      description: 'Learn how to sign "No"',
    ),
    PhraseModel(
      phrase: 'Good morning',
      imageUrl: 'assets/isl_phrases/good_morning.png',
      description: 'Learn how to sign "Good morning"',
    ),
    PhraseModel(
      phrase: 'Good evening',
      imageUrl: 'assets/isl_phrases/good_evening.png',
      description: 'Learn how to sign "Good evening"',
    ),
    PhraseModel(
      phrase: 'Good night',
      imageUrl: 'assets/isl_phrases/good_night.png',
      description: 'Learn how to sign "Good night"',
    ),
    PhraseModel(
      phrase: 'Excuse me',
      imageUrl: 'assets/isl_phrases/excuse_me.png',
      description: 'Learn how to sign "Excuse me"',
    ),
    PhraseModel(
      phrase: 'I don’t understand',
      imageUrl: 'assets/isl_phrases/i_dont_understand.png',
      description: 'Learn how to sign "I don’t understand"',
    ),
    PhraseModel(
      phrase: 'Can you help me?',
      imageUrl: 'assets/isl_phrases/can_you_help_me.png',
      description: 'Learn how to sign "Can you help me?"',
    ),
    PhraseModel(
      phrase: 'Where is the restroom?',
      imageUrl: 'assets/isl_phrases/where_is_restroom.png',
      description: 'Learn how to sign "Where is the restroom?"',
    ),
    PhraseModel(
      phrase: 'I’m hungry',
      imageUrl: 'assets/isl_phrases/im_hungry.png',
      description: 'Learn how to sign "I’m hungry"',
    ),
    PhraseModel(
      phrase: 'I’m thirsty',
      imageUrl: 'assets/isl_phrases/im_thirsty.png',
      description: 'Learn how to sign "I’m thirsty"',
    ),
    PhraseModel(
      phrase: 'What is your name?',
      imageUrl: 'assets/isl_phrases/what_is_your_name.png',
      description: 'Learn how to sign "What is your name?"',
    ),
    PhraseModel(
      phrase: 'My name is...',
      imageUrl: 'assets/isl_phrases/my_name_is.png',
      description: 'Learn how to sign "My name is..."',
    ),
    PhraseModel(
      phrase: 'How much is this?',
      imageUrl: 'assets/isl_phrases/how_much_is_this.png',
      description: 'Learn how to sign "How much is this?"',
    ),
    PhraseModel(
      phrase: 'I’m fine',
      imageUrl: 'assets/isl_phrases/im_fine.png',
      description: 'Learn how to sign "I’m fine"',
    ),
    PhraseModel(
      phrase: 'Please repeat',
      imageUrl: 'assets/isl_phrases/please_repeat.png',
      description: 'Learn how to sign "Please repeat"',
    ),
    PhraseModel(
      phrase: 'I love you',
      imageUrl: 'assets/isl_phrases/i_love_you.png',
      description: 'Learn how to sign "I love you"',
    ),
    PhraseModel(
      phrase: 'Goodbye',
      imageUrl: 'assets/isl_phrases/goodbye.png',
      description: 'Learn how to sign "Goodbye"',
    ),
    PhraseModel(
      phrase: 'See you later',
      imageUrl: 'assets/isl_phrases/see_you_later.png',
      description: 'Learn how to sign "See you later"',
    ),
    PhraseModel(
      phrase: 'Take care',
      imageUrl: 'assets/isl_phrases/take_care.png',
      description: 'Learn how to sign "Take care"',
    ),
  ];

  bool _showGrid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Learn Daily Phrases",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Color(0xFF444444),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF444444)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showGrid ? Icons.view_list : Icons.grid_view,
              color: Color(0xFF444444),
            ),
            onPressed: () {
              setState(() {
                _showGrid = !_showGrid;
              });
            },
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(12),
          ),
        ),
        toolbarHeight: 70,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search phrases...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
          ),
          Expanded(
            child: _showGrid ? _buildGridView() : _buildListView(),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: phrases.length,
      itemBuilder: (context, index) {
        return _buildPhraseCard(phrases[index]);
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: phrases.length,
      itemBuilder: (context, index) {
        return _buildPhraseListTile(phrases[index]);
      },
    );
  }

  Widget _buildPhraseCard(PhraseModel phrase) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _showPhraseDetail(phrase),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade50,
                Colors.blue.shade100,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    phrase.phrase,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF444444),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Tap to learn',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhraseListTile(PhraseModel phrase) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () => _showPhraseDetail(phrase),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.sign_language,
            color: Color(0xFF444444),
          ),
        ),
        title: Text(
          phrase.phrase,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(phrase.description),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  void _showPhraseDetail(PhraseModel phrase) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
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
                      phrase.phrase,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text('Sign Animation Here'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}