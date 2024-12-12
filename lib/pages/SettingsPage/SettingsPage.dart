import 'package:flutter/material.dart';
import 'package:isl/pages/Welcome/welcome_screen.dart';

import '../../Services/AuthServices.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Profile Section
          const ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            subtitle: Text('Manage your profile'),
            trailing: Icon(Icons.chevron_right),
          ),

          // Notification Settings
          SwitchListTile(
            title: const Text('Notifications'),
            subtitle: const Text('Receive app notifications'),
            value: true, // You can make this dynamic
            onChanged: (bool value) {
              // Implement notification toggle logic
            },
            secondary: const Icon(Icons.notifications),
          ),

          // Theme Settings
          ListTile(
            leading: const Icon(Icons.brightness_4),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: false, // You can implement theme provider
              onChanged: (bool value) {
                // Implement theme switching logic
              },
            ),
          ),

          // Logout Tile
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
                'Logout',
                style: TextStyle(color: Colors.red)
            ),
            onTap: () => _showLogoutConfirmation(context),
          ),

          // Divider
          const Divider(),

          // Additional Settings
          const ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('Help & Support'),
            trailing: Icon(Icons.chevron_right),
          ),

          const ListTile(
            leading: Icon(Icons.privacy_tip_outlined),
            title: Text('Privacy Policy'),
            trailing: Icon(Icons.chevron_right),
          ),

          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About App'),
            trailing: Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  // Logout Confirmation Dialog
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Logout'),
              onPressed: () {
                // Perform logout
                _performLogout(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Logout Method
  void _performLogout(BuildContext context) async {
    try {
      // Call logout method from AuthService
      await AuthService().logout();

      // Navigate to Login Screen and remove all previous routes
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              (Route<dynamic> route) => false
      );
    } catch (e) {
      // Show error if logout fails
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          )
      );
    }
  }
}