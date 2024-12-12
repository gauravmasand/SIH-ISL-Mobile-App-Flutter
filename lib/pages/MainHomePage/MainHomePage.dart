import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isl/pages/LearnISL/LearnISL.dart';
import 'package:isl/pages/TravelPage/TravelPage.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../main.dart';
import '../Announcement/AnnouncementBasePage.dart';
import '../GuideAndHelp/GuideAndHelp.dart';
import '../ISLExpertChatPage/ISLChatPage.dart';
import '../ISLToText_mp_lstm/ISLToText_mp_lstm.dart';
import '../SettingsPage/SettingsPage.dart';
import '../TextToISL/TextToISL.dart';
import '../YoutubeToISL/YoutubeToISL.dart';
import 'components/FeatureCard.dart';
import 'components/PrimaryActionCard.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ISL App",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Color(0xFF444444), // Subtle dark grey for text
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFF8F9FA), // Soft neutral background
        elevation: 0, // No elevation for a minimalist appearance
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFF444444)),
            onPressed: () {
              // Navigate to settings screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(12), // Rounded bottom corners
          ),
        ),
        toolbarHeight: 70, // Taller toolbar for better proportions
        shadowColor: Colors.grey.withOpacity(0.15), // Subtle shadow
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
        },
        backgroundColor: const Color(0xFF444444),
        child: const Icon(CupertinoIcons.chat_bubble, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Primary Actions Grid
              Row(
                children: [
                  Expanded(
                    child: PrimaryActionCard(
                      title: 'ISL to Text',
                      icon: Icons.sign_language,
                      color: Colors.blue,
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => ISLToText_mp_lstm()),
                        // );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ISLToText_mp_lstm()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PrimaryActionCard(
                      title: 'Text to ISL',
                      icon: Icons.text_fields,
                      color: Colors.green,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TextToISL()),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Travel Mode Card
              Container(
                height: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TravelPage()),
                      );
                      // Handle travel mode
                    },
                    child: Stack(
                      children: [
                        // Here you should add your travel image
                        // Recommended size: 160x160 for the illustration
                        Positioned(
                          right: -20,
                          top: -20,
                          child: Opacity(
                            opacity: 0.1,
                            child: Image.asset(
                              'assets/images/travel_illustration.png',
                              width: 160,
                              height: 160,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.purple.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.map,
                                  color: Colors.purple,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Travel Mode',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Quick switch between ISL and text with native language translation',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Feature Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  FeatureCard(
                    title: 'Make Announcement',
                    icon: Icons.campaign,
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AnnouncementBasePage()));
                    },
                  ),
                  FeatureCard(
                    title: 'YouTube to ISL',
                    icon: Icons.play_circle_filled,
                    color: Colors.red,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => YouTubeToISLPage()));
                    },
                  ),
                  // FeatureCard(
                  //   title: 'Chat to learn!',
                  //   icon: Icons.help_outline,
                  //   color: Colors.blue,
                  //   onTap: () {
                  //     Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
                  //   },
                  // ),
                  FeatureCard(
                    title: 'Learn ISL',
                    icon: Icons.school,
                    color: Colors.teal,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LearnISL()));
                    },
                  ),
                  FeatureCard(
                    title: 'Guide & Help',
                    icon: Icons.help_outline,
                    color: Colors.indigo,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HelpAndGuidePage()));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

