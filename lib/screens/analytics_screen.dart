import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFF0D102C),
        appBar: AppBar(
          backgroundColor: const Color(0xFF7B4DFF),
          elevation: 0,
          title: const Text("My Honor", style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CircleAvatar(
                backgroundColor: Colors.orangeAccent,
                child: const Icon(Icons.play_arrow, color: Colors.white),
              ),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            isScrollable: true,
            tabs: [
              Tab(text: "Puzzle"),
              Tab(text: "Adventure"),
              Tab(text: "Trivia"),
              Tab(text: "Quizz"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            BadgeCategory(
              categoryName: "Puzzle",
              badges: [
                BadgeData(
                  "Logic Master",
                  "Star",
                  "Completed",
                  Colors.deepPurple,
                ),
                BadgeData("Element Master", "Junior", "70%", Colors.indigo),
              ],
            ),
            BadgeCategory(
              categoryName: "Adventure",
              badges: [
                BadgeData("Explorer", "Senior", "Completed", Colors.teal),
                BadgeData("Map Reader", "None", "0%", Colors.grey),
              ],
            ),
            BadgeCategory(
              categoryName: "Trivia",
              badges: [
                BadgeData("Fact Hunter", "Junior", "40%", Colors.blue),
                BadgeData("Quick Thinker", "Star", "Completed", Colors.green),
              ],
            ),
            BadgeCategory(
              categoryName: "Quizz",
              badges: [
                BadgeData("Quiz Champ", "Senior", "90%", Colors.orange),
                BadgeData("Speed Brain", "None", "0%", Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BadgeCategory extends StatelessWidget {
  final String categoryName;
  final List<BadgeData> badges;

  const BadgeCategory({
    super.key,
    required this.categoryName,
    required this.badges,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(12.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Achievements",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 0.95,
            padding: const EdgeInsets.all(10),
            children:
                badges
                    .map(
                      (badge) => badgeCard(
                        badge.title,
                        badge.level,
                        badge.status,
                        badge.color,
                      ),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }

  Widget badgeCard(
    String title,
    String level,
    String status,
    Color badgeColor,
  ) {
    bool isCompleted = status == "Completed";
    bool isNotReached = status == "0%";

    return Card(
      color: const Color(0xFF1C1F3E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(Icons.emoji_events, color: badgeColor, size: 40),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                level,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const Spacer(),
            isCompleted
                ? const Text("Completed", style: TextStyle(color: Colors.green))
                : isNotReached
                ? const Text("Not Reach", style: TextStyle(color: Colors.red))
                : Column(
                  children: [
                    const Text("Next", style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: double.tryParse(status.replaceAll('%', ''))! / 100,
                      backgroundColor: Colors.white12,
                      valueColor: AlwaysStoppedAnimation<Color>(badgeColor),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}

class BadgeData {
  final String title;
  final String level;
  final String status;
  final Color color;

  const BadgeData(this.title, this.level, this.status, this.color);
}
