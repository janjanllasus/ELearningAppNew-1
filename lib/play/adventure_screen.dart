import 'package:flutter/material.dart';

class AdventureScreen extends StatelessWidget {
  final String role;
  const AdventureScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Adventure Game")),
      body: const Center(child: Text("Adventure game here")),
    );
  }
}
