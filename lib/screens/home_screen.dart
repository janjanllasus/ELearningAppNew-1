import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String role;
  const HomeScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D102C), // Dark background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF7B4DFF), // Purple theme
        leading: const Icon(Icons.menu, color: Colors.white),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.book, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "HOME",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: const [
          Icon(Icons.person_outline, color: Colors.white),
          SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome $role!",
              style: const TextStyle(
                color: Colors.white, // White text for dark bg
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Header Banner
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1C1F3E), // Dark card
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Welcome to Science E-Learning App",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Play Games\nWatch Videos\nRead and more!",
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  Image.asset("lib/assets/owl.png", height: 120, width: 120),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Activities Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Activities",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text("View all", style: TextStyle(color: Colors.white70)),
              ],
            ),
            const SizedBox(height: 12),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _activityCard(
                    title: "PLAY",
                    subtitle: "Play games & learn",
                    color: Colors.deepPurple,
                    imagePath: "lib/assets/play.png",
                    onTap: () {},
                  ),
                  const SizedBox(width: 12),
                  _activityCard(
                    title: "WATCH",
                    subtitle: "Watch videos",
                    color: Colors.teal,
                    imagePath: "lib/assets/video.png",
                    onTap: () {},
                  ),
                  const SizedBox(width: 12),
                  _activityCard(
                    title: "READ",
                    subtitle: "Read articles",
                    color: Colors.orange,
                    imagePath: "lib/assets/popularRead.png",
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Popular Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Popular",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text("View all", style: TextStyle(color: Colors.white70)),
              ],
            ),
            const SizedBox(height: 12),

            _popularItem(
              title: "Play Games - Puzzle, Trivia, Quizzes and more",
              tag: "GAMES",
              color: Colors.deepPurple,
              imagePath: "lib/assets/popularPlay.png",
            ),
            _popularItem(
              title: "Watch Science Video - Earth, Space and Life",
              tag: "VIDEOS",
              color: Colors.teal,
              imagePath: "lib/assets/video.png",
            ),
            _popularItem(
              title: "Read Science Books - Understanding life through Science",
              tag: "READ",
              color: Colors.orange,
              imagePath: "lib/assets/popularRead.png",
            ),
          ],
        ),
      ),
    );
  }

  // Activity Card
  static Widget _activityCard({
    required String title,
    required String subtitle,
    required Color color,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        height: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagePath,
                    height: 40,
                    width: 40,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Popular Item
  static Widget _popularItem({
    required String title,
    required String tag,
    required Color color,
    required String imagePath,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.9), color.withOpacity(0.7)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          // Left Image
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
          ),

          // Middle Text
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Right Tag + Play Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Text(
                  tag,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.play_arrow, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
