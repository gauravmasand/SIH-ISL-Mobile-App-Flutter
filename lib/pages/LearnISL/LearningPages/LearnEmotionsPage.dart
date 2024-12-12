import 'package:flutter/material.dart';

import '../models/PhraseModel.dart';

class LearnEmotionsPage extends StatefulWidget {
  const LearnEmotionsPage({super.key});

  @override
  State<LearnEmotionsPage> createState() => _LearnEmotionsPageState();
}

class _LearnEmotionsPageState extends State<LearnEmotionsPage> {
  final List<PhraseModel> emotions = [
    PhraseModel(
      phrase: 'Happy',
      imageUrl: 'assets/isl_emotions/happy.png',
      description: 'Learn how to sign "Happy"',
    ),
    PhraseModel(
      phrase: 'Sad',
      imageUrl: 'assets/isl_emotions/sad.png',
      description: 'Learn how to sign "Sad"',
    ),
    PhraseModel(
      phrase: 'Angry',
      imageUrl: 'assets/isl_emotions/angry.png',
      description: 'Learn how to sign "Angry"',
    ),
    PhraseModel(
      phrase: 'Surprised',
      imageUrl: 'assets/isl_emotions/surprised.png',
      description: 'Learn how to sign "Surprised"',
    ),
    PhraseModel(
      phrase: 'Scared',
      imageUrl: 'assets/isl_emotions/scared.png',
      description: 'Learn how to sign "Scared"',
    ),
    PhraseModel(
      phrase: 'Confused',
      imageUrl: 'assets/isl_emotions/confused.png',
      description: 'Learn how to sign "Confused"',
    ),
    PhraseModel(
      phrase: 'Excited',
      imageUrl: 'assets/isl_emotions/excited.png',
      description: 'Learn how to sign "Excited"',
    ),
    PhraseModel(
      phrase: 'Tired',
      imageUrl: 'assets/isl_emotions/tired.png',
      description: 'Learn how to sign "Tired"',
    ),
    PhraseModel(
      phrase: 'Bored',
      imageUrl: 'assets/isl_emotions/bored.png',
      description: 'Learn how to sign "Bored"',
    ),
    PhraseModel(
      phrase: 'Nervous',
      imageUrl: 'assets/isl_emotions/nervous.png',
      description: 'Learn how to sign "Nervous"',
    ),
    PhraseModel(
      phrase: 'Relaxed',
      imageUrl: 'assets/isl_emotions/relaxed.png',
      description: 'Learn how to sign "Relaxed"',
    ),
    PhraseModel(
      phrase: 'Proud',
      imageUrl: 'assets/isl_emotions/proud.png',
      description: 'Learn how to sign "Proud"',
    ),
    PhraseModel(
      phrase: 'Shy',
      imageUrl: 'assets/isl_emotions/shy.png',
      description: 'Learn how to sign "Shy"',
    ),
    PhraseModel(
      phrase: 'Frustrated',
      imageUrl: 'assets/isl_emotions/frustrated.png',
      description: 'Learn how to sign "Frustrated"',
    ),
    PhraseModel(
      phrase: 'In love',
      imageUrl: 'assets/isl_emotions/in_love.png',
      description: 'Learn how to sign "In love"',
    ),
    PhraseModel(
      phrase: 'Lonely',
      imageUrl: 'assets/isl_emotions/lonely.png',
      description: 'Learn how to sign "Lonely"',
    ),
    PhraseModel(
      phrase: 'Grateful',
      imageUrl: 'assets/isl_emotions/grateful.png',
      description: 'Learn how to sign "Grateful"',
    ),
    PhraseModel(
      phrase: 'Hopeful',
      imageUrl: 'assets/isl_emotions/hopeful.png',
      description: 'Learn how to sign "Hopeful"',
    ),
    PhraseModel(
      phrase: 'Embarrassed',
      imageUrl: 'assets/isl_emotions/embarrassed.png',
      description: 'Learn how to sign "Embarrassed"',
    ),
  ];

  bool _showGrid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Learn Daily emotions",
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
                hintText: 'Search emotions...',
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
      itemCount: emotions.length,
      itemBuilder: (context, index) {
        return _buildPhraseCard(emotions[index]);
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: emotions.length,
      itemBuilder: (context, index) {
        return _buildPhraseListTile(emotions[index]);
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