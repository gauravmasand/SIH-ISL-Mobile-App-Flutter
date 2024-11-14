import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/AuthServices.dart';
import '../main.dart';
import 'Welcome/welcome_screen.dart';


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
        title: Text("ISL App"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CameraScreen()),
                  );
                },
                icon: Icon(Icons.sign_language, size: 24),
                label: Text("ISL to Text"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.text_fields, size: 24),
                label: Text("Text to ISL"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.card_travel, size: 24),
                label: Text("Travel Mode"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.campaign, size: 24),
                label: Text("Make Announcement Video"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.play_circle_filled, size: 24),
                label: Text("YouTube video to ISL"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.school, size: 24),
                label: Text("Learn ISL"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.help_outline, size: 24),
                label: Text("About & How to use Guide"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  Future<void> logout(BuildContext context) async {
                    AuthService authService = AuthService();
                    authService.logout();

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                          (Route<dynamic> route) => false,
                    );
                  }
                  await logout(context);
                },
                icon: Icon(Icons.help_outline, size: 24),
                label: Text("Logout"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

