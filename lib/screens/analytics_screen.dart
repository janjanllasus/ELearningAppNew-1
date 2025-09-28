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
          title: const Text("My Honor",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CircleAvatar(
                backgroundColor: Colors.orangeAccent,
                child: const Icon(Icons.person, color: Colors.white),
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
                BadgeData("Logic Master", "Star", "Completed", Colors.deepPurple),
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

  IconData getLevelIcon(String level) {
    switch (level) {
      case "Junior":
        return Icons.emoji_events; 
      case "Senior":
        return Icons.military_tech; 
      case "Star":
        return Icons.star; 
      default:
        return Icons.lock; 
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 360 ? 1 : 2;
    final itemWidth = (screenWidth - 24 - (crossAxisCount - 1) * 12) / crossAxisCount;
    final itemHeight = 180.0;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D102C), Color(0xFF1C1F3E)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$categoryName Achievements",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 3,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.purpleAccent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: crossAxisCount,
              childAspectRatio: itemWidth / itemHeight,
              padding: const EdgeInsets.all(12),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: badges.map((badge) => badgeCard(badge)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget badgeCard(BadgeData badge) {
    bool isCompleted = badge.status == "Completed";
    bool isNotReached = badge.status == "0%";

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              badge.color.withOpacity(0.85),
              badge.color.withOpacity(0.5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 8,
              offset: const Offset(2, 4),
            )
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AnimatedScale(
              scale: isCompleted ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 400),
              child: Icon(getLevelIcon(badge.level), color: Colors.white, size: 45),
            ),
            const SizedBox(height: 10),
            Text(
              badge.title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge.level,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const Spacer(),
            if (isCompleted)
              const Text("🏆 Completed",
                  style: TextStyle(color: Colors.yellow, fontSize: 14))
            else if (isNotReached)
              const Text("🔒 Locked",
                  style: TextStyle(color: Colors.redAccent, fontSize: 14))
            else
              Column(
                children: [
                  const Text("In Progress",
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 4),
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                        begin: 0,
                        end: double.tryParse(badge.status.replaceAll('%', ''))! / 100),
                    duration: const Duration(seconds: 1),
                    builder: (context, value, _) => LinearProgressIndicator(
                      value: value,
                      backgroundColor: Colors.white12,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(badge.status,
                      style: const TextStyle(color: Colors.white, fontSize: 12)),
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
