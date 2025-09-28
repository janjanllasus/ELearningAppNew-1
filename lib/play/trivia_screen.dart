import 'package:flutter/material.dart';
import 'dart:math';

class TriviaScreen extends StatefulWidget {
  final String role;
  const TriviaScreen({super.key, required this.role});

  @override
  State<TriviaScreen> createState() => _TriviaScreenState();
}

class _TriviaScreenState extends State<TriviaScreen> {
  // Maximum 10 levels
  int currentLevel = 1;
  int score = 0;
  int? firstIndex;

  // Cards data for each level
  final List<List<Map<String, String>>> levels = [
    // Level 1
    [
      {"term": "Photosynthesis", "definition": "Process by which plants make food"},
      {"term": "Evaporation", "definition": "Liquid turning into gas"}
    ],
    // Level 2
    [
      {"term": "Oxygen", "definition": "Gas humans need to breathe"},
      {"term": "Gravity", "definition": "Force that pulls objects down"}
    ],
    // Level 3
    [
      {"term": "Magnetism", "definition": "Force that attracts metals"},
      {"term": "Condensation", "definition": "Gas turning into liquid"}
    ],
    // Level 4
    [
      {"term": "Solar System", "definition": "Planets orbiting the Sun"},
      {"term": "Evaporation", "definition": "Liquid turning into gas"}
    ],
    // Level 5
    [
      {"term": "Plant Cell", "definition": "Cell of a plant"},
      {"term": "Animal Cell", "definition": "Cell of an animal"}
    ],
    // Level 6
    [
      {"term": "Inertia", "definition": "Object stays at rest or motion"},
      {"term": "Friction", "definition": "Resistance when surfaces move"}
    ],
    // Level 7
    [
      {"term": "Photosynthesis", "definition": "Process by which plants make food"},
      {"term": "Respiration", "definition": "Process of releasing energy"}
    ],
    // Level 8
    [
      {"term": "Acid", "definition": "Substance with pH<7"},
      {"term": "Base", "definition": "Substance with pH>7"}
    ],
    // Level 9
    [
      {"term": "Evaporation", "definition": "Liquid turning into gas"},
      {"term": "Precipitation", "definition": "Water falling from clouds"}
    ],
    // Level 10
    [
      {"term": "Force", "definition": "Push or pull on an object"},
      {"term": "Energy", "definition": "Ability to do work"}
    ],
  ];

  List<String> _cards = [];
  List<bool> _flipped = [];

  @override
  void initState() {
    super.initState();
    _prepareCards();
  }

  void _prepareCards() {
    final pairs = levels[currentLevel - 1];
    _cards = [];
    for (var pair in pairs) {
      _cards.add(pair['term']!);
      _cards.add(pair['definition']!);
    }
    _cards.shuffle(Random());
    _flipped = List<bool>.filled(_cards.length, false);
    firstIndex = null;
  }

  void _flipCard(int index) {
    setState(() {
      _flipped[index] = true;
    });

    if (firstIndex == null) {
      firstIndex = index;
    } else {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (_isMatch(firstIndex!, index)) {
          score += 10;
          _showMessage("✅ Match found! +10 points", Colors.green);
        } else {
          _flipped[firstIndex!] = false;
          _flipped[index] = false;
          _showMessage("❌ Not a match", Colors.redAccent);
        }
        firstIndex = null;

        // Check if level completed
        if (_flipped.every((f) => f)) {
          if (currentLevel < 10) {
            currentLevel++;
            _showMessage("🎉 Level $currentLevel!", Colors.blueAccent);
            _prepareCards();
          } else {
            _showMessage("🏆 You completed all levels!", Colors.purpleAccent);
          }
        }

        setState(() {});
      });
    }
  }

  bool _isMatch(int a, int b) {
    String cardA = _cards[a];
    String cardB = _cards[b];

    for (var pair in levels[currentLevel - 1]) {
      if ((pair['term'] == cardA && pair['definition'] == cardB) ||
          (pair['term'] == cardB && pair['definition'] == cardA)) {
        return true;
      }
    }
    return false;
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: color,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1F3E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B4DFF),
        title: Text("Matching Game - ${widget.role}",
            style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            "Level: $currentLevel / 10 | Score: $score",
            style: const TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _cards.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: _flipped[index] ? null : () => _flipCard(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    decoration: BoxDecoration(
                      color: _flipped[index]
                          ? Colors.greenAccent
                          : const Color(0xFF2C2F5E),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white24, width: 2),
                      boxShadow: _flipped[index]
                          ? [
                              const BoxShadow(
                                  color: Colors.white24,
                                  blurRadius: 6,
                                  offset: Offset(2, 2))
                            ]
                          : [],
                    ),
                    alignment: Alignment.center,
                    child: _flipped[index]
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _cards[index],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : const Icon(Icons.help_outline,
                            color: Colors.white, size: 40),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                score = 0;
                currentLevel = 1;
                _prepareCards();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purpleAccent,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text("Restart Game",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
