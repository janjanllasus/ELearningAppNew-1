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
              backgroundColor: const Color(0xFF1C1F3E),
              title: const Text(
                "Quiz Finished 🎉",
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                "Your score: $score / ${quizQuestions.length}",
                style: const TextStyle(fontSize: 18, color: Colors.white70),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Colors.deepPurpleAccent),
                  ),
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
              backgroundColor: const Color(0xFF1C1F3E),
              title: const Text(
                "Edit Question",
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
                      quizQuestions[index]["question"] =
                          questionController.text;
                      quizQuestions[index]["answer"] = answerController.text;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.deepPurpleAccent),
                  ),
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
      backgroundColor: const Color(0xFF0D102C), // dark blue background
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B4DFF), // purple achievement theme
        title: const Text(
          "Science Quiz 🧪",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          if (widget.role == "teacher" || widget.role == "admin")
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () => editQuestion(currentQuestionIndex),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Owl mascot
            Center(
              child: Column(
                children: [
                  Image.asset(
                    "lib/assets/owl.png", // 🦉 owl mascot
                    height: 100,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Professor Owl says:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Question Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: const Color(0xFF1C1F3E), // card theme
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  question["question"],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Options
            ...question["options"].map<Widget>((opt) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B4DFF), // purple button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => checkAnswer(opt),
                  child: Text(
                    opt,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              );
            }).toList(),

            const Spacer(),

            // Progress
            Text(
              "Question ${currentQuestionIndex + 1} of ${quizQuestions.length}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
