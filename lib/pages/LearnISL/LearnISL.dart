import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isl/pages/LearnISL/LearningPages/LearnEmotionsPage.dart';

import '../ISLExpertChatPage/ISLChatPage.dart';
import 'LearningPages/LearnColors.dart';
import 'LearningPages/LearnDailyPhrasesPage.dart';
import 'LearningPages/LearnFamilyMembers.dart';
import 'LearningPages/LearnISLAlphabetsPage.dart';
import 'LearningPages/LearnISLNumbersPage.dart';
import 'components/CategoryCard.dart';
import 'models/CategoryModel.dart';

class LearnISL extends StatefulWidget {
  const LearnISL({super.key});

  @override
  State<LearnISL> createState() => _LearnISLState();
}

class _LearnISLState extends State<LearnISL> {
  final List<CategoryModel> categories = [
    CategoryModel(
      title: 'Alphabets',
      icon: Icons.abc,
      color: Colors.blue,
      description: 'Learn ISL alphabet signs step by step',
      detailedPage: LearnISLAlphabetsPage(),
    ),
    CategoryModel(
      title: 'Numbers',
      icon: Icons.numbers,
      color: Colors.green,
      description: 'Master numerical hand signs',
      detailedPage: LearnISLNumbersPage(),
    ),
    CategoryModel(
      title: 'Daily Phrases',
      icon: Icons.chat_bubble_outline,
      color: Colors.orange,
      description: 'Common conversational signs',
      detailedPage: LearnDailyPhrasesPage(),
    ),
    CategoryModel(
      title: 'Emotions',
      icon: Icons.sentiment_satisfied_alt,
      color: Colors.purple,
      description: 'Express feelings through signs',
      detailedPage: LearnEmotionsPage(),
    ),
    CategoryModel(
      title: 'Family',
      icon: Icons.family_restroom,
      color: Colors.teal,
      description: 'Signs for family members',
      detailedPage: LearnFamilyPage(),
    ),
    CategoryModel(
      title: 'Colors',
      icon: Icons.palette,
      color: Colors.pink,
      description: 'Learn color representation signs',
      detailedPage: LearnColorsPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Learn ISL",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Color(0xFF444444),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Color(0xFF444444)),
            onPressed: _showHelpDialog,
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(12),
          ),
        ),
        toolbarHeight: 70,
        shadowColor: Colors.grey.withOpacity(0.15),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,  // Soft light grey background
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300.withOpacity(0.5),
                      blurRadius: 6,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                child: TextField(
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search sign categories...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade600,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              // Category Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CategoryCard(category: categories[index]);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
        },
        backgroundColor: const Color(0xFF444444),
        child: const Icon(CupertinoIcons.chat_bubble, color: Colors.white),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Learn ISL'),
        content: const Text(
          'Explore various categories of Indian Sign Language. '
              'Learn alphabets, numbers, emotions, and more through interactive lessons.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

