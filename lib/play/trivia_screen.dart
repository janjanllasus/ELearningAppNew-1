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
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text("Trivia Finished"),
              content: Text("Your score: $score / ${triviaFacts.length}"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
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
              title: const Text("Edit Fact"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: questionController),
                  TextField(controller: answerController),
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
                  child: const Text("Save"),
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
      appBar: AppBar(
        title: const Text("Trivia Game"),
        actions: [
          if (widget.role == "teacher" || widget.role == "admin")
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => editFact(currentFactIndex),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              fact["question"]!,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => checkAnswer("True"),
              child: const Text("True"),
            ),
            ElevatedButton(
              onPressed: () => checkAnswer("False"),
              child: const Text("False"),
            ),
          ],
        ),
      ),
    );
  }
}
