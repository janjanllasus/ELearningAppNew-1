import 'package:flutter/material.dart';

class WatchScreen extends StatelessWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Watch")),
      body: const Center(child: Text("Educational videos here")),
    );
  }
}
