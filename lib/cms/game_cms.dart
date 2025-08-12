import 'package:flutter/material.dart';

class GameCMS extends StatelessWidget {
  final String role;
  const GameCMS({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Game CMS")),
      body: Center(child: Text("CMS tools for $role")),
    );
  }
}
