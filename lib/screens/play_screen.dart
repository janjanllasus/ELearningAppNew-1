import 'package:elearningapp_flutter/cms/game_cms.dart';
import 'package:flutter/material.dart';
import 'package:elearningapp_flutter/play/quizz_screen.dart';
import 'package:elearningapp_flutter/play/trivia_screen.dart';
import 'package:elearningapp_flutter/play/adventure_screen.dart';
import 'package:elearningapp_flutter/play/puzzle_screen.dart';

class PlayScreen extends StatelessWidget {
  final String role;
  const PlayScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Play"),
        actions: [
          // CMS access for Teacher, Parent, and Admin
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
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: [
          _gameButton(context, "Quiz", Icons.quiz, QuizScreen(role: role)),
          _gameButton(
            context,
            "Puzzle",
            Icons.extension,
            PuzzleScreen(role: role),
          ),
          _gameButton(
            context,
            "Adventure",
            Icons.map,
            AdventureScreen(role: role),
          ),
          _gameButton(
            context,
            "Trivia",
            Icons.lightbulb,
            TriviaScreen(role: role),
          ),
        ],
      ),
    );
  }

  Widget _gameButton(
    BuildContext context,
    String title,
    IconData icon,
    Widget screen,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Card(
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.blue),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
