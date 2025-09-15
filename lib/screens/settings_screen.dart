import 'package:flutter/material.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A), // Dark owl theme background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B263B),
        elevation: 0,
        title: const Text("Settings", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 10),

          // Account Section
          const Text(
            "Account",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF778DA9),
            ),
          ),
          const SizedBox(height: 10),
          _buildSettingsTile(
            icon: Icons.person,
            title: "Edit Profile",
            subtitle: "Update your name, age, gender",
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.lock,
            title: "Change Password",
            subtitle: "Update your account password",
            onTap: () {},
          ),

          const SizedBox(height: 20),

          // Preferences Section
          const Text(
            "Preferences",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF778DA9),
            ),
          ),
          const SizedBox(height: 10),
          _buildSettingsTile(
            icon: Icons.palette,
            title: "Theme",
            subtitle: "Light / Dark mode",
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.notifications,
            title: "Notifications",
            subtitle: "Manage notification settings",
            onTap: () {},
          ),

          const SizedBox(height: 20),

          // Logout
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false, // clears all previous routes
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE63946),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text(
              "Logout",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xFF1B263B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF778DA9)),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        subtitle:
            subtitle != null
                ? Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                )
                : null,
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.white54,
        ),
        onTap: onTap,
      ),
    );
  }
}
