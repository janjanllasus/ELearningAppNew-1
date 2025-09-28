import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class WatchScreen extends StatefulWidget {
  final String role; // Student, Teacher, or Admin

  const WatchScreen({super.key, this.role = "Student"});

  @override
  State<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> {
  late VideoPlayerController _videoController;
  int currentLesson = 1;
  int totalLessons = 3;

  final TextEditingController _notesController = TextEditingController();
  bool _isInitialized = false;

  // Example lesson list
  final List<Map<String, String>> lessons = [
    {
      "title": "Solar System for Kids",
      "desc": "Explore planets, moons, and stars in space!",
      "url": "https://samplelib.com/lib/preview/mp4/sample-5s.mp4"
    },
    {
      "title": "Animal Habitats",
      "desc": "Learn about different animal homes.",
      "url": "https://samplelib.com/lib/preview/mp4/sample-10s.mp4"
    },
    {
      "title": "The Water Cycle",
      "desc": "Discover evaporation, condensation, and rain.",
      "url": "https://samplelib.com/lib/preview/mp4/sample-15s.mp4"
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadVideo(lessons[0]["url"]!);
  }

  void _loadVideo(String url) {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  Widget _buildRoleFeatures() {
    if (widget.role == "Teacher") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: Colors.white30),
          const Text("📂 Teacher Tools",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.upload_file),
            label: const Text("Upload/Replace Video"),
          ),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text("Attach Resources"),
          ),
        ],
      );
    } else if (widget.role == "Admin") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: Colors.white30),
          const Text("🛠️ Admin Tools",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.check_circle),
            label: const Text("Approve Content"),
          ),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.bar_chart),
            label: const Text("View Analytics"),
          ),
        ],
      );
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    final lesson = lessons[currentLesson - 1];

    return Scaffold(
      backgroundColor: const Color(0xFF0D102C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B4DFF),
        title: Text(
          lesson["title"]!,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 📺 Video Player
          AspectRatio(
            aspectRatio: _isInitialized ? _videoController.value.aspectRatio : 16 / 9,
            child: _isInitialized
                ? Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      VideoPlayer(_videoController),
                      VideoProgressIndicator(
                        _videoController,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                          playedColor: Colors.purpleAccent,
                          backgroundColor: Colors.white24,
                        ),
                      ),
                      Center(
                        child: IconButton(
                          icon: Icon(
                            _videoController.value.isPlaying
                                ? Icons.pause_circle
                                : Icons.play_circle,
                            size: 60,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _videoController.value.isPlaying
                                  ? _videoController.pause()
                                  : _videoController.play();
                            });
                          },
                        ),
                      )
                    ],
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
          const SizedBox(height: 16),

          // 📌 Description
          Text(
            lesson["desc"]!,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 16),

          // 📊 Progress Tracker
          LinearProgressIndicator(
            value: currentLesson / totalLessons,
            color: Colors.purpleAccent,
            backgroundColor: Colors.white24,
          ),
          Text("Lesson $currentLesson of $totalLessons",
              style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 16),

          // ⏭️ Navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  if (currentLesson > 1) {
                    setState(() {
                      currentLesson--;
                      _videoController.dispose();
                      _loadVideo(lessons[currentLesson - 1]["url"]!);
                    });
                  }
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                label: const Text("Previous", style: TextStyle(color: Colors.white)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white54)),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  if (currentLesson < totalLessons) {
                    setState(() {
                      currentLesson++;
                      _videoController.dispose();
                      _loadVideo(lessons[currentLesson - 1]["url"]!);
                    });
                  }
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text("Next Lesson"),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7B4DFF)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 📝 Notes
          const Text("Your Notes",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          TextField(
            controller: _notesController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Write your notes...",
              hintStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF1C1F3E),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),

          // 🎯 Quiz
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.quiz),
            label: const Text("Take Quiz"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
          ),

          const SizedBox(height: 20),
          _buildRoleFeatures(),
        ],
      ),
    );
  }
}
