import 'package:flutter/material.dart';

class ReadScreen extends StatelessWidget {
  const ReadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D102C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B4DFF),
        title: const Text(
          "READ",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          /// 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFF1C1F3E),
              ),
            ),
          ),

          /// 📚 Science Category
          _sectionTitle("Science"),
          _bookGrid([
            _bookItem(
              "lib/assets/periodicTable.jpg",
              "The Periodic Table of Elements",
            ),
            _bookItem(
              "lib/assets/lifeBook.jpg",
              "Earth Day Every Day - Earth Science",
            ),
            _bookItem("lib/assets/chemistry.jpg", "Chemistry Science"),
            _bookItem(
              "lib/assets/humanBodySystems.jpg",
              "Interactive Science - Human Body",
            ),
          ]),

          /// 🌌 Space Category
          _sectionTitle("Space"),
          _bookGrid([
            _bookItem(
              "lib/assets/spaceBook.jpg",
              "What's out there? - All about space",
            ),
            _bookItem(
              "lib/assets/earthAndSpace.jpg",
              "Earth and Space Science - Planets",
            ),
          ]),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// 📌 Section Title
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  /// 📚 Book Grid
  Widget _bookGrid(List<Widget> books) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.66,
        children: books,
      ),
    );
  }

  /// 📖 Book Item
  Widget _bookItem(String image, String title) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1F3E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              image,
              height: 155,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
