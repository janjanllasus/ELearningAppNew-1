import 'package:flutter/material.dart';
import 'dart:math';

class PuzzleScreen extends StatefulWidget {
  final String role;
  const PuzzleScreen({super.key, required this.role});

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  final List<String> baseElements = ["Fire", "Water", "Earth", "Air"];
  final List<String> discoveredElements = [];

  final Map<String, String> combos = {
    "Air+Water": "Rain",
    "Earth+Fire": "Lava",
    "Earth+Water": "Mud",
    "Fire+Air": "Energy",
    "Fire+Water": "Steam",
  };

  String? targetElement; // 🎯 target element

  @override
  void initState() {
    super.initState();
    _pickNewTarget();
  }

  // pick a new target that isn’t discovered yet
  void _pickNewTarget() {
    final allResults = combos.values.toSet().toList();
    final undiscovered =
        allResults
            .where((element) => !discoveredElements.contains(element))
            .toList();

    if (undiscovered.isNotEmpty) {
      targetElement = undiscovered[Random().nextInt(undiscovered.length)];
    } else {
      targetElement = null; // all discovered
    }
    setState(() {});
  }

  void _combine(String target, String dragged) {
    if (target == dragged) return;
    final k = _key(target, dragged);
    final result = combos[k];

    if (result != null) {
      if (!discoveredElements.contains(result)) {
        setState(() => discoveredElements.add(result));

        if (result == targetElement) {
          // 🎉 Correct discovery
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("🎯 You found the target: $result!"),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          Future.delayed(const Duration(milliseconds: 500), _pickNewTarget);
        } else {
          // Normal discovery
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("✨ You discovered: $result")));
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Already discovered!")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ No new element from that combo")),
      );
    }
  }

  String _key(String a, String b) {
    final pair = [a, b]..sort();
    return "${pair[0]}+${pair[1]}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D102C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B4DFF),
        title: const Text(
          "Element Puzzle",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          // 🎯 Show target element
          if (targetElement != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1F3E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "🎯 Target: ",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  _elementIcon(targetElement!, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    targetElement!,
                    style: const TextStyle(
                      color: Colors.amberAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "✅ All elements discovered!",
                style: TextStyle(color: Colors.greenAccent, fontSize: 16),
              ),
            ),

          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              "Drag one element onto another to combine!",
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ),

          if (discoveredElements.isNotEmpty)
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1F3E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "🔬 Discoveries:",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children:
                            discoveredElements.map(_discoveryIcon).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),

          // 🔹 Base elements
          Expanded(
            flex: 2,
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: baseElements.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final element = baseElements[index];
                return LongPressDraggable<String>(
                  data: element,
                  feedback: Material(
                    color: Colors.transparent,
                    child: _tile(element, isDragging: true),
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0.35,
                    child: _tile(element),
                  ),
                  child: DragTarget<String>(
                    onWillAccept: (incoming) => incoming != element,
                    onAccept: (incoming) => _combine(element, incoming),
                    builder:
                        (context, candidate, rejected) =>
                            _tile(element, isHighlighted: candidate.isNotEmpty),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(
    String text, {
    bool isDragging = false,
    bool isHighlighted = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color:
            isHighlighted ? const Color(0xFF2A2E53) : const Color(0xFF1C1F3E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDragging ? Colors.orangeAccent : Colors.white24,
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _elementIcon(text, size: 40),
          const SizedBox(height: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _discoveryIcon(String element) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _elementIcon(element, size: 36),
        const SizedBox(height: 4),
        Text(
          element,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _elementIcon(String element, {double size = 40}) {
    IconData icon;
    switch (element) {
      case "Fire":
        icon = Icons.local_fire_department;
        break;
      case "Water":
        icon = Icons.water_drop;
        break;
      case "Earth":
        icon = Icons.landscape;
        break;
      case "Air":
        icon = Icons.air;
        break;
      case "Rain":
        icon = Icons.cloud;
        break;
      case "Lava":
        icon = Icons.volcano;
        break;
      case "Mud":
        icon = Icons.grass;
        break;
      case "Energy":
        icon = Icons.flash_on;
        break;
      case "Steam":
        icon = Icons.cloud_queue;
        break;
      default:
        icon = Icons.help_outline;
    }
    return Icon(icon, size: size, color: Colors.white);
  }
}
