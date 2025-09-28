import 'package:flutter/material.dart';
import 'dart:math';

// --- Element Visuals/Colors (All unique icons ensured) ---
final Map<String, dynamic> elementVisuals = {
  // Base Elements
  "Fire": {"color": Colors.redAccent, "icon": Icons.local_fire_department},
  "Water": {"color": Colors.blueAccent, "icon": Icons.water_drop},
  "Earth": {"color": Colors.green, "icon": Icons.landscape},
  "Air": {"color": Colors.cyanAccent, "icon": Icons.air},
  // Level 1 Discoveries (5 elements)
  "Rain": {"color": Colors.lightBlue, "icon": Icons.umbrella},
  "Lava": {"color": Colors.deepOrange, "icon": Icons.volcano},
  "Mud": {"color": Colors.brown, "icon": Icons.grain},
  "Energy": {"color": Colors.yellowAccent, "icon": Icons.flash_on},
  "Steam": {"color": Colors.white70, "icon": Icons.cloud_queue},
  // Level 2 Discoveries (4 elements - Now using previous discoveries)
  "Cloud": {"color": Colors.lightBlue.shade100, "icon": Icons.cloud_outlined},
  "Obsidian": {"color": Colors.blueGrey.shade900, "icon": Icons.circle},
  "Geyser": {"color": Colors.lightBlueAccent.shade200, "icon": Icons.hot_tub},
  "Lightning": {"color": Colors.yellow, "icon": Icons.electric_bolt},
  // Level 3 Discoveries (4 elements)
  "Rock": {"color": Colors.grey, "icon": Icons.hexagon},
  "Clay": {"color": Colors.deepOrange.shade300, "icon": Icons.category},
  "Glass": {"color": Colors.lightGreenAccent, "icon": Icons.crop_square},
  "Metal": {"color": Colors.blueGrey, "icon": Icons.shield},
  // Level 4 Discoveries (4 elements)
  "Brick": {"color": Colors.red.shade900, "icon": Icons.foundation},
  "Storm": {"color": Colors.indigo, "icon": Icons.thunderstorm},
  "Smoke": {"color": Colors.grey.shade700, "icon": Icons.filter_drama},
  "Swamp": {"color": Colors.green.shade900, "icon": Icons.forest},
  // Level 5 Discoveries (4 elements)
  "Star": {"color": Colors.amber, "icon": Icons.star},
  "Tsunami": {"color": Colors.blue.shade900, "icon": Icons.waves},
  "Structure": {"color": Colors.grey.shade600, "icon": Icons.apartment},
  "Fusion": {"color": Colors.pink, "icon": Icons.autorenew},
};

// --- Level Data Structure (Using progressive discoveries for combos) ---
const List<Map<String, dynamic>> levelData = [
  // Stage 1: Primal (5 unique combos)
  {
    "level": 1,
    "title": "Primal Discoveries",
    "requiredDiscoveries": 5,
    "combos": {
      "Air+Water": "Rain",
      "Earth+Fire": "Lava",
      "Earth+Water": "Mud",
      "Fire+Air": "Energy",
      "Fire+Water": "Steam",
    },
  },
  // Stage 2: Secondary Combos (4 unique combos, using Base + Stage 1 Discoveries)
  {
    "level": 2,
    "title": "Atmospheric & Geological",
    "requiredDiscoveries": 4, 
    "combos": {
      "Rain+Air": "Cloud",
      "Lava+Water": "Obsidian",
      "Energy+Water": "Lightning",
      "Steam+Water": "Geyser",
    },
  },
  // Stage 3: Tertiary Forms (4 unique combos, using Base + Stage 1/2 Discoveries)
  {
    "level": 3,
    "title": "Solid Forms",
    "requiredDiscoveries": 4, 
    "combos": {
      "Earth+Obsidian": "Rock", 
      "Mud+Rock": "Clay", 
      "Fire+Glass": "Glass", // Combo to make glass (simplified)
      "Lava+Rock": "Metal",
    },
  },
  // Stage 4: Advanced Structures (4 unique combos, using Base + Stage 1/2/3 Discoveries)
  {
    "level": 4,
    "title": "Advanced Structures",
    "requiredDiscoveries": 4, 
    "combos": {
      "Clay+Fire": "Brick",
      "Cloud+Lightning": "Storm",
      "Fire+Steam": "Smoke",
      "Mud+Water": "Swamp", 
    },
  },
  // Stage 5: Final Synthesis (4 unique combos, using Base + Stage 1/2/3/4 Discoveries)
  {
    "level": 5,
    "title": "Cosmic Synthesis",
    "requiredDiscoveries": 4, 
    "combos": {
      "Lightning+Energy": "Star",
      "Storm+Water": "Tsunami",
      "Brick+Earth": "Structure",
      "Metal+Energy": "Fusion",
    },
  },
];

// ------------------------------------

class PuzzleScreen extends StatefulWidget {
  final String role;
  const PuzzleScreen({super.key, required this.role});

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  int currentLevel = 1;
  // This list holds ALL elements the user has access to for combination.
  List<String> discoveredElements = []; 
  String? targetElement; 
  int score = 0; 
  
  final List<String> baseElements = ["Fire", "Water", "Earth", "Air"];

  @override
  void initState() {
    super.initState();
    // Initialize the list with the base elements.
    discoveredElements.addAll(baseElements);
    _pickNewTarget();
  }

  // Merges ALL combos from ALL previous and current levels.
  Map<String, String> get allAvailableCombos {
    Map<String, String> combos = {};
    for (int i = 0; i < currentLevel; i++) {
      combos.addAll(levelData[i]['combos'].cast<String, String>());
    }
    return combos;
  }

  // Gets the list of elements that are the explicit targets for the current level.
  List<String> get currentLevelTargets {
      return levelData[currentLevel - 1]['combos'].values.toSet().toList().cast<String>();
  }

  // Checks how many targets in the current level's combo set have been found.
  int get currentLevelDiscoveredTargetCount {
    return currentLevelTargets.where((e) => discoveredElements.contains(e)).length;
  }
  
  // Checks if the current stage is fully complete
  bool get isStageComplete => currentLevelDiscoveredTargetCount == levelData[currentLevel - 1]['requiredDiscoveries'];

  void _pickNewTarget() {
    if (isStageComplete) {
      targetElement = null;
      setState(() {});
      return;
    }
    
    final List<String> undiscoveredTargets = currentLevelTargets
        .where((element) => !discoveredElements.contains(element))
        .toList();

    if (undiscoveredTargets.isNotEmpty) {
      targetElement = undiscoveredTargets[Random().nextInt(undiscoveredTargets.length)];
    } else {
      targetElement = null;
    }
    setState(() {});
  }

  void _advanceLevel() {
    if (currentLevel < levelData.length) {
      currentLevel++;
      _showMessage(
          "🎉 Advancing to Stage $currentLevel: ${levelData[currentLevel - 1]['title']}",
          Colors.purpleAccent);
      _pickNewTarget();
    } else {
      _showMessage("🏆 Final Stage Complete! You are the Elemental Master!", Colors.amber);
    }
    setState(() {});
  }

  // The combination logic remains the same, checking against all discovered elements.
  // The UI handles the inputs (target and dragged) which can be either Base or Discovered.
  void _combine(String target, String dragged) {
    if (target == dragged) return;
    if (isStageComplete) return; 

    String? result;
    final Map<String, String> combos = allAvailableCombos;

    combos.forEach((key, value) {
      final parts = key.split('+');
      if ((parts.contains(target) && parts.contains(dragged))) {
        result = value;
      }
    });

    if (result != null) {
      if (!discoveredElements.contains(result)) {
        setState(() {
          discoveredElements.add(result!);
          score += 10;
          
          if (currentLevelTargets.contains(result)) {
            if (result == targetElement) score += 20;
            _showMessage(
              result == targetElement 
                ? "🎯 You found the target: $result! (+30 pts)"
                : "✨ You discovered a target: $result (+10 pts)", 
              Colors.greenAccent
            );
            Future.delayed(const Duration(milliseconds: 500), _pickNewTarget);
          } else {
            _showMessage("✨ New element found: $result (+10 pts)", Colors.lightBlueAccent);
          }
        });
      } else {
        _showMessage("⚠️ Already discovered!", Colors.orangeAccent);
      }
    } else {
      _showMessage("❌ No known element from that combo", Colors.redAccent);
    }
  }

  void _showMessage(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Function to show the Discovered Element selection dialog
  Future<String?> _showDiscoveredElementSelection(BuildContext context) async {
    // Elements available for selection (all discovered, excluding base 4)
    final List<String> available = discoveredElements.where((e) => !baseElements.contains(e)).toList();

    if (available.isEmpty) {
      _showMessage("No complex elements discovered yet!", Colors.orange);
      return null;
    }

    return await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1C1F3E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Select Second Element (${available.length} available)",
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: available.map((element) {
                      return GestureDetector(
                        onTap: () => Navigator.pop(context, element),
                        child: _tile(element, size: 80.0),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- UI Build Methods ---
  @override
  Widget build(BuildContext context) {
    final int requiredDiscoveries = levelData[currentLevel - 1]['requiredDiscoveries'];
    final int discoveredCount = currentLevelDiscoveredTargetCount;
    final double progress = requiredDiscoveries > 0 ? discoveredCount / requiredDiscoveries : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFF0D102C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B4DFF),
        title: Text(
          "Stage $currentLevel: ${levelData[currentLevel - 1]['title']}",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          // --- Info Panel ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _buildTargetDisplay(),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white24,
                  color: Colors.greenAccent,
                  minHeight: 8,
                ),
                const SizedBox(height: 6),
                Text(
                  "Score: $score | Stage Progress: $discoveredCount/$requiredDiscoveries",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              "Drag Base Elements onto each other or the Fusion Pad below!",
              style: TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),

          // --- Main 4-Element Grid (Fixed Size) ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              shrinkWrap: true, // Use shrinkWrap since it's the only scrollable widget in column
              physics: const NeverScrollableScrollPhysics(),
              itemCount: baseElements.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, 
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.0, 
              ),
              itemBuilder: (context, index) {
                final element = baseElements[index];
                return _draggableTile(element);
              },
            ),
          ),
          
          // --- Fusion Pad (To combine Base Element with Discovered Element) ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: DragTarget<String>(
              onWillAccept: (incoming) => incoming != null,
              onAccept: (incoming) async {
                // When a base element is dropped here, show the selection dialog
                String? selectedElement = await _showDiscoveredElementSelection(context);
                if (selectedElement != null) {
                  _combine(incoming!, selectedElement);
                }
              },
              builder: (context, candidate, rejected) {
                return Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: candidate.isNotEmpty ? Colors.green.shade600 : const Color(0xFF1C1F3E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white38, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    candidate.isNotEmpty ? "Release to Open Fusion Menu" : "Drag Base Element Here to Fuse with Discovered Element",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Draggable Tile only for the 4 Base Elements
  Widget _draggableTile(String element) {
    return LongPressDraggable<String>(
      data: element,
      feedback: Material(
        color: Colors.transparent,
        child: _tile(element, isDragging: true, size: 80.0),
      ),
      childWhenDragging: Opacity(
        opacity: 0.35,
        child: _tile(element, size: 80.0),
      ),
      // Base elements can be dropped onto each other
      child: DragTarget<String>(
        onWillAccept: (incoming) => incoming != element && baseElements.contains(incoming),
        onAccept: (incoming) => _combine(element, incoming!),
        builder: (context, candidate, rejected) =>
            _tile(element, isHighlighted: candidate.isNotEmpty, size: 80.0),
      ),
    );
  }

  Widget _buildTargetDisplay() {
    if (isStageComplete && currentLevel < levelData.length) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text(
              "✅ Stage Complete! You found all targets.",
              style: TextStyle(color: Colors.greenAccent, fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _advanceLevel,
              icon: const Icon(Icons.arrow_forward_ios),
              label: Text("Advance to Stage ${currentLevel + 1}"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ],
        ),
      );
    } else if (currentLevel == levelData.length && isStageComplete) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          "🏆 ALL LEVELS COMPLETE! Congratulations!",
          style: TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      );
    }
    
    // Default Target Display
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1F3E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amberAccent, width: 1.5),
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
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  // --- Element Tile UI and Icon Helpers ---
  Widget _tile(String text, {bool isDragging = false, bool isHighlighted = false, double size = 80.0}) {
    final elementProps = elementVisuals[text] ?? {"color": Colors.grey, "icon": Icons.help_outline};
    final Color elementColor = elementProps['color'];
    final double iconSize = size / 2;
    final double fontSize = size * 0.15; 

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.purpleAccent : elementColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDragging ? Colors.orangeAccent : Colors.white24,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
              color: elementColor.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4)),
        ],
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _elementIcon(text, size: iconSize),
          const SizedBox(height: 4),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _elementIcon(String element, {double size = 40}) {
    final elementProps = elementVisuals[element] ?? {"icon": Icons.help_outline};
    return Icon(elementProps['icon'], size: size, color: Colors.white);
  }
}