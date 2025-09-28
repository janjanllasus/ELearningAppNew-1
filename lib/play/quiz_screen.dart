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
        builder: (_) => AlertDialog(
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
      TextEditingController questionController =
          TextEditingController(text: quizQuestions[index]["question"]);
      TextEditingController answerController =
          TextEditingController(text: quizQuestions[index]["answer"]);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
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
                  quizQuestions[index]["question"] = questionController.text;
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D102C), Color(0xFF2A1B4A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Top Owl Mascot with Speech Bubble
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset("lib/assets/owl.png", height: 90),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "Hello, I’m Professor Owl! 🦉\nLet’s see what you know!",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Question Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1F3E),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurpleAccent.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  child: Text(
                    question["question"],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 25),

                // Options
                ...question["options"].map<Widget>((opt) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 5,
                      ),
                      onPressed: () => checkAnswer(opt),
                      child: Text(
                        opt,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }).toList(),

                const Spacer(),

                // Progress Bar
                Column(
                  children: [
                    LinearProgressIndicator(
                      value: (currentQuestionIndex + 1) /
                          quizQuestions.length,
                      backgroundColor: Colors.white24,
                      color: Colors.deepPurpleAccent,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Question ${currentQuestionIndex + 1} of ${quizQuestions.length}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
