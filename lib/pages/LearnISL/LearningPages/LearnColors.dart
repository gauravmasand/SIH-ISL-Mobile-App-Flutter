import 'package:flutter/material.dart';

import '../models/PhraseModel.dart';

class LearnColorsPage extends StatefulWidget {
  const LearnColorsPage({super.key});

  @override
  State<LearnColorsPage> createState() => _LearnColorsPageState();
}

class _LearnColorsPageState extends State<LearnColorsPage> {
  final List<PhraseModel> colors = [
    PhraseModel(
      phrase: 'Red',
      imageUrl: 'assets/isl_colors/red.png',
      description: 'Learn how to sign "Red"',
    ),
    PhraseModel(
      phrase: 'Green',
      imageUrl: 'assets/isl_colors/green.png',
      description: 'Learn how to sign "Green"',
    ),
    PhraseModel(
      phrase: 'Blue',
      imageUrl: 'assets/isl_colors/blue.png',
      description: 'Learn how to sign "Blue"',
    ),
    PhraseModel(
      phrase: 'Yellow',
      imageUrl: 'assets/isl_colors/yellow.png',
      description: 'Learn how to sign "Yellow"',
    ),
    PhraseModel(
      phrase: 'Black',
      imageUrl: 'assets/isl_colors/black.png',
      description: 'Learn how to sign "Black"',
    ),
    PhraseModel(
      phrase: 'White',
      imageUrl: 'assets/isl_colors/white.png',
      description: 'Learn how to sign "White"',
    ),
    PhraseModel(
      phrase: 'Orange',
      imageUrl: 'assets/isl_colors/orange.png',
      description: 'Learn how to sign "Orange"',
    ),
    PhraseModel(
      phrase: 'Pink',
      imageUrl: 'assets/isl_colors/pink.png',
      description: 'Learn how to sign "Pink"',
    ),
    PhraseModel(
      phrase: 'Purple',
      imageUrl: 'assets/isl_colors/purple.png',
      description: 'Learn how to sign "Purple"',
    ),
    PhraseModel(
      phrase: 'Brown',
      imageUrl: 'assets/isl_colors/brown.png',
      description: 'Learn how to sign "Brown"',
    ),
    PhraseModel(
      phrase: 'Grey',
      imageUrl: 'assets/isl_colors/grey.png',
      description: 'Learn how to sign "Grey"',
    ),
    PhraseModel(
      phrase: 'Violet',
      imageUrl: 'assets/isl_colors/violet.png',
      description: 'Learn how to sign "Violet"',
    ),
    PhraseModel(
      phrase: 'Cyan',
      imageUrl: 'assets/isl_colors/cyan.png',
      description: 'Learn how to sign "Cyan"',
    ),
    PhraseModel(
      phrase: 'Magenta',
      imageUrl: 'assets/isl_colors/magenta.png',
      description: 'Learn how to sign "Magenta"',
    ),
    PhraseModel(
      phrase: 'Gold',
      imageUrl: 'assets/isl_colors/gold.png',
      description: 'Learn how to sign "Gold"',
    ),
    PhraseModel(
      phrase: 'Silver',
      imageUrl: 'assets/isl_colors/silver.png',
      description: 'Learn how to sign "Silver"',
    ),
  ];

  bool _showGrid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Learn Colors",
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
      itemCount: colors.length,
      itemBuilder: (context, index) {
        return _buildPhraseCard(colors[index]);
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: colors.length,
      itemBuilder: (context, index) {
        return _buildPhraseListTile(colors[index]);
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