import 'package:flutter/material.dart';
import 'package:elearningapp_flutter/cms/game_cms.dart';
import 'package:elearningapp_flutter/play/quiz_screen.dart';
import 'package:elearningapp_flutter/play/trivia_screen.dart';
import 'package:elearningapp_flutter/play/adventure_screen.dart';
import 'package:elearningapp_flutter/play/puzzle_screen.dart';

class PlayScreen extends StatelessWidget {
  final String role;
  const PlayScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D102C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B4DFF),
        title: const Text(
          "PLAY",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (role == "teacher" || role == "parent" || role == "admin")
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameCMS(role: role)),
                );
              },
            ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Category buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _categoryButton(Icons.access_time, "Recent"),
                    _categoryButton(Icons.sports_basketball, "Sports"),
                    _categoryButton(Icons.music_note, "Music"),
                    _categoryButton(Icons.adjust, "Logic"),
                    _categoryButton(Icons.shopping_cart, "Shop"),
                  ],
                ),
              ),
            ),

            /// Feature Section Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Feature",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            /// Feature Banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  "lib/assets/spaceExplorer.jpg",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 60,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            /// Play Games Section Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                "Play Games",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            /// Game Cards Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _gameCard(
                  context,
                  "Quiz",
                  "lib/assets/quiz.jpg",
                  QuizScreen(role: role),
                ),
                _gameCard(
                  context,
                  "Puzzle",
                  "lib/assets/puzzle.jpg",
                  PuzzleScreen(role: role),
                ),
                _gameCard(
                  context,
                  "Adventure",
                  "lib/assets/spaceExplorer.jpg",
                  AdventureScreen(role: role),
                ),
                _gameCard(
                  context,
                  "Matching Game",
                  "lib/assets/trivia.jpg",
                  TriviaScreen(role: role),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Styled Category Button
  Widget _categoryButton(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1C1F3E),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {},
        icon: Icon(icon, size: 18),
        label: Text(title, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  /// Game Card with dark theme overlay
  Widget _gameCard(
    BuildContext context,
    String title,
    String imagePath,
    Widget screen,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
              Container(color: Colors.black.withOpacity(0.5)),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  color: Colors.black.withOpacity(0.6),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
