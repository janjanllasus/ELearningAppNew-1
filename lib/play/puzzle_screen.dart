import 'package:flutter/material.dart';

class PuzzleScreen extends StatelessWidget {
  final String role;
  const PuzzleScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Puzzle Game")),
      body: const Center(child: Text("Puzzle game here")),
    );
  }
}
