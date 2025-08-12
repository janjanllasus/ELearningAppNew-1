import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  final String role; // "student", "teacher", or "admin"
  const QuizScreen({Key? key, required this.role}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "Which organ pumps blood through the body?",
      "options": ["Lungs", "Heart", "Brain", "Stomach"],
      "answer": "Heart",
    },
    {
      "question": "Which part of your body helps you breathe?",
      "options": ["Liver", "Lungs", "Heart", "Kidneys"],
      "answer": "Lungs",
    },
    {
      "question": "Which organ controls your thoughts and actions?",
      "options": ["Heart", "Brain", "Stomach", "Skin"],
      "answer": "Brain",
    },
    {
      "question": "Which part of the body helps you to see?",
      "options": ["Eyes", "Ears", "Nose", "Hands"],
      "answer": "Eyes",
    },
    {
      "question": "Which part of the body helps you to smell?",
      "options": ["Mouth", "Nose", "Hands", "Feet"],
      "answer": "Nose",
    },
  ];

  int currentQuestionIndex = 0;
  int score = 0;

  void checkAnswer(String selected) {
    if (selected == quizQuestions[currentQuestionIndex]["answer"]) {
      score++;
    }
    if (currentQuestionIndex < quizQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text("Quiz Finished"),
              content: Text("Your score: $score / ${quizQuestions.length}"),
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

  void editQuestion(int index) {
    if (widget.role == "teacher" || widget.role == "admin") {
      TextEditingController questionController = TextEditingController(
        text: quizQuestions[index]["question"],
      );
      TextEditingController answerController = TextEditingController(
        text: quizQuestions[index]["answer"],
      );

      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text("Edit Question"),
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
                      quizQuestions[index]["question"] =
                          questionController.text;
                      quizQuestions[index]["answer"] = answerController.text;
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
    var question = quizQuestions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz Game"),
        actions: [
          if (widget.role == "teacher" || widget.role == "admin")
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => editQuestion(currentQuestionIndex),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              question["question"],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...question["options"].map<Widget>((opt) {
              return ElevatedButton(
                onPressed: () => checkAnswer(opt),
                child: Text(opt),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
