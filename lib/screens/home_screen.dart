import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String role;
  const HomeScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFAFAFA),
        leading: const Icon(Icons.menu, color: Colors.black),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.book, color: Color(0xFF66BB6A)),
            SizedBox(width: 8),
            Text(
              "HOME",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: const [
          Icon(Icons.person_outline, color: Colors.black),
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
                color: Color(0xFF66BB6A),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF66BB6A),
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
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Play Games\nWatch Videos\nRead and more!",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Image.asset("lib/assets/owl.png", height: 150, width: 150),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Activities",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text("View all", style: TextStyle(color: Colors.blue)),
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
                    color: Colors.orange,
                    imagePath: "lib/assets/play.png",
                    onTap: () {
                      // Navigate to PLAY page
                    },
                  ),
                  const SizedBox(width: 12),
                  _activityCard(
                    title: "WATCH",
                    subtitle: "Watch videos",
                    color: Colors.blue,
                    imagePath: "lib/assets/video.png",
                    onTap: () {
                      // Navigate to WATCH page
                    },
                  ),
                  const SizedBox(width: 12),
                  _activityCard(
                    title: "READ",
                    subtitle: "Read articles",
                    color: Colors.pink,
                    imagePath: "lib/assets/owl.png",
                    onTap: () {
                      // Navigate to READ page
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Popular",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text("View all", style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 12),

            _popularItem(
              "Play Games - Puzzle, Trivia, Quizzes and more",
              "GAMES",
              Colors.orange,
              Icons.extension,
            ),
            const SizedBox(height: 8),
            _popularItem(
              "Watch Science Video - Earth, Space and Life",
              "VIDEOS",
              Colors.blue,
              Icons.video_library,
            ),
            const SizedBox(height: 8),
            _popularItem(
              "Read Science Books - Understanding life through Science",
              "READ",
              Colors.pink,
              Icons.menu_book,
            ),
          ],
        ),
      ),
    );
  }

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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _popularItem(
    String title,
    String tag,
    Color color,
    IconData icon,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.4), color.withOpacity(0.2)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          const Icon(Icons.play_arrow, color: Colors.white),
        ],
      ),
    );
  }
}
