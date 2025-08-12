import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'play_screen.dart';
import 'watch_screen.dart';
import 'read_screen.dart';
import 'analytics_screen.dart';
import 'settings_screen.dart';

class RoleNavigation extends StatefulWidget {
  final String role;
  const RoleNavigation({super.key, required this.role});

  @override
  State<RoleNavigation> createState() => _RoleNavigationState();
}

class _RoleNavigationState extends State<RoleNavigation> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(role: widget.role),
      PlayScreen(role: widget.role), // ✅ Pass role here
      const WatchScreen(),
      const ReadScreen(),
      const AnalyticsScreen(),
      const SettingsScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.videogame_asset),
            label: "Play",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ondemand_video),
            label: "Watch",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Read"),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: "Analytics",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
