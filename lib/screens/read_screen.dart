import 'package:flutter/material.dart';

class ReadScreen extends StatelessWidget {
  const ReadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Read")),
      body: const Center(child: Text("Reading materials here")),
    );
  }
}
