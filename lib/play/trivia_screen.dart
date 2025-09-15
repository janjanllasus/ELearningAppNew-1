import 'package:flutter/material.dart';

class TriviaScreen extends StatefulWidget {
  final String role;
  const TriviaScreen({Key? key, required this.role}) : super(key: key);

  @override
  State<TriviaScreen> createState() => _TriviaScreenState();
}

class _TriviaScreenState extends State<TriviaScreen> {
  List<Map<String, String>> triviaFacts = [
    {
      "question": "True or False: Your heart is about the size of your fist.",
      "answer": "True",
    },
    {
      "question": "True or False: The brain has no pain receptors.",
      "answer": "True",
    },
    {
      "question": "True or False: Humans have 300 bones at birth.",
      "answer": "True",
    },
    {
      "question":
          "True or False: The smallest bone in the human body is in the ear.",
      "answer": "True",
    },
    {
      "question":
          "True or False: The lungs are the heaviest organ in the human body.",
      "answer": "False",
    },
  ];

  int currentFactIndex = 0;
  int score = 0;

  void checkAnswer(String selected) {
    if (selected == triviaFacts[currentFactIndex]["answer"]) {
      score++;
    }

    if (currentFactIndex < triviaFacts.length - 1) {
      setState(() {
        currentFactIndex++;
      });
    } else {
      // End of quiz
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              backgroundColor: const Color(0xFF1C1F3E),
              title: const Text(
                "Trivia Finished",
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                "Your score: $score / ${triviaFacts.length}",
                style: const TextStyle(color: Colors.white70),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
      );
    }
  }

  void editFact(int index) {
    if (widget.role == "teacher" || widget.role == "admin") {
      TextEditingController questionController = TextEditingController(
        text: triviaFacts[index]["question"],
      );
      TextEditingController answerController = TextEditingController(
        text: triviaFacts[index]["answer"],
      );

      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              backgroundColor: const Color(0xFF1C1F3E),
              title: const Text(
                "Edit Fact",
                style: TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: questionController,
                    style: const TextStyle(color: Colors.white),
                  ),
                  TextField(
                    controller: answerController,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      triviaFacts[index]["question"] = questionController.text;
                      triviaFacts[index]["answer"] = answerController.text;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var fact = triviaFacts[currentFactIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF0D102C), // Achievement dark theme
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B4DFF), // Purple theme
        title: const Text("Trivia Game", style: TextStyle(color: Colors.white)),
        actions: [
          if (widget.role == "teacher" || widget.role == "admin")
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () => editFact(currentFactIndex),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🦉 Science Owl Mascot
            SizedBox(height: 120, child: Image.asset("lib/assets/owl.png")),
            const SizedBox(height: 20),

            // Trivia Question Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1F3E),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Text(
                fact["question"]!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // True Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B4DFF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 32,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => checkAnswer("True"),
              child: const Text("True", style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),

            // False Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 32,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => checkAnswer("False"),
              child: const Text("False", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
