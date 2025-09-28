import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:math';

// --- A more structured Biome class for better data management ---
class Biome {
  final String title;
  final String description;
  final String backgroundKey;
  final List<String> essences;
  final Map<String, String> combos;
  final Map<String, Map<String, dynamic>> creatureVisuals;

  const Biome({
    required this.title,
    required this.description,
    required this.backgroundKey,
    required this.essences,
    required this.combos,
    required this.creatureVisuals,
  });
}

// --- Game Asset Data and Biome Instances ---
final Map<String, Color> biomeBackgrounds = {
  "Forest_BG": const Color(0xFF0F1E0C),
  "Desert_BG": const Color(0xFF332D20),
  "Ocean_BG": const Color(0xFF0C191E),
  "Tundra_BG": const Color(0xFF262A2E),
};

final Map<String, Map<String, dynamic>> essenceVisuals = {
  "Sunlight": {"color": Colors.amber, "icon": Icons.wb_sunny_rounded},
  "Water": {"color": Colors.blue, "icon": Icons.water_drop_rounded},
  "Soil": {"color": const Color(0xFF5A482A), "icon": Icons.eco_rounded},
  "Nutrients": {"color": const Color(0xFF67B547), "icon": Icons.bubble_chart_rounded},
  "Sand": {"color": const Color(0xFFEBCDA3), "icon": Icons.grain},
  "Wind": {"color": const Color(0xFFB0E0E6), "icon": Icons.air},
  "Heat": {"color": Colors.redAccent, "icon": Icons.local_fire_department_rounded},
  "Salt": {"color": Colors.white70, "icon": Icons.waves_rounded},
  "Algae": {"color": Colors.greenAccent, "icon": Icons.bubble_chart_rounded},
  "Oxygen": {"color": Colors.cyanAccent, "icon": Icons.bubble_chart_rounded},
  "Ice": {"color": Colors.lightBlue.shade50, "icon": Icons.ac_unit_rounded},
  "Permafrost": {"color": Colors.grey, "icon": Icons.snowing},
  "Cold": {"color": Colors.indigo, "icon": Icons.ac_unit_rounded},
  "Rock": {"color": const Color(0xFF8B8B8B), "icon": Icons.category_rounded},
  "Sulfur": {"color": const Color(0xFFD4C82E), "icon": Icons.fireplace_rounded},
  "Lava": {"color": const Color(0xFFC4330E), "icon": Icons.local_fire_department_rounded},
  "Grass": {"color": const Color(0xFF4CAF50), "icon": Icons.grass_rounded},
  "Humidity": {"color": const Color(0xFF3E8A85), "icon": Icons.opacity_rounded},
  "Snow": {"color": Colors.white, "icon": Icons.ac_unit_rounded},
  "Pressure": {"color": const Color(0xFF0C191E), "icon": Icons.compress_rounded},
  "Darkness": {"color": const Color(0xFF212121), "icon": Icons.dark_mode_rounded},
};

final List<Biome> biomes = [
  Biome(
    title: "Enchanted Forest",
    description: "Restore life to the ancient woods by nurturing a new life form.",
    backgroundKey: "Forest_BG",
    essences: ["Sunlight", "Water", "Soil", "Nutrients"],
    combos: {
      "Sunlight+Water+Soil+Nutrients": "Seedling",
    },
    creatureVisuals: {
      "Seedling": {"color": Colors.lightGreen, "icon": Icons.eco_rounded, "info": "A plant's first form, requiring light, water, and nutrients to grow."},
    },
  ),
  Biome(
    title: "Mystic Dunes",
    description: "Thrive in the harsh desert climate by creating a new life form adapted to the heat.",
    backgroundKey: "Desert_BG",
    essences: ["Sunlight", "Sand", "Wind", "Heat"],
    combos: {
      "Sunlight+Sand+Wind+Heat": "Cactus",
    },
    creatureVisuals: {
      "Cactus": {"color": const Color(0xFF4C873F), "icon": Icons.grass_rounded, "info": "A succulent plant that stores water, perfectly adapted to arid climates."},
    },
  ),
  Biome(
    title: "Coral Reef Caverns",
    description: "Dive deep to populate a dying reef with vibrant marine life.",
    backgroundKey: "Ocean_BG",
    essences: ["Water", "Salt", "Algae", "Oxygen"],
    combos: {
      "Water+Salt+Algae+Oxygen": "Plankton",
    },
    creatureVisuals: {
      "Plankton": {"color": Colors.white, "icon": Icons.bubble_chart_rounded, "info": "Tiny marine organisms that form the base of the ocean's food web."},
    },
  ),
  Biome(
    title: "Glacial Peaks",
    description: "Brave the cold to create a new life form in the icy, frozen north.",
    backgroundKey: "Tundra_BG",
    essences: ["Ice", "Permafrost", "Wind", "Cold"],
    combos: {
      "Ice+Permafrost+Wind+Cold": "Lichen",
    },
    creatureVisuals: {
      "Lichen": {"color": Colors.white70, "icon": Icons.filter_drama_rounded, "info": "A hardy composite organism, one of the first life forms to colonize bare rock."},
    },
  ),
  Biome(
    title: "Volcanic Crater",
    description: "Bring life to a fiery volcanic region.",
    backgroundKey: "Desert_BG",
    essences: ["Heat", "Rock", "Sulfur", "Lava"],
    combos: {
      "Heat+Rock+Sulfur+Lava": "Magma Plant",
    },
    creatureVisuals: {
      "Magma Plant": {"color": Colors.red, "icon": Icons.local_fire_department_rounded, "info": "A plant that thrives in volcanic heat and soil."},
    },
  ),
  Biome(
    title: "Savannah Plains",
    description: "Populate the grassy plains with diverse life.",
    backgroundKey: "Forest_BG",
    essences: ["Sunlight", "Water", "Grass", "Wind"],
    combos: {
      "Sunlight+Water+Grass+Wind": "Grass Patch",
    },
    creatureVisuals: {
      "Grass Patch": {"color": Colors.green, "icon": Icons.grass_rounded, "info": "Basic plant cover that supports a food web."},
    },
  ),
  Biome(
    title: "Rainforest Canopy",
    description: "Restore tropical biodiversity.",
    backgroundKey: "Forest_BG",
    essences: ["Sunlight", "Water", "Humidity", "Soil"],
    combos: {
      "Sunlight+Water+Humidity+Soil": "Fern",
    },
    creatureVisuals: {
      "Fern": {"color": Colors.green, "icon": Icons.eco_rounded, "info": "A plant thriving in high humidity and moisture."},
    },
  ),
  Biome(
    title: "Mountain Highlands",
    description: "Populate high altitude terrains.",
    backgroundKey: "Tundra_BG",
    essences: ["Rock", "Wind", "Snow", "Sunlight"],
    combos: {
      "Rock+Wind+Snow+Sunlight": "Mountain Flower",
    },
    creatureVisuals: {
      "Mountain Flower": {"color": Colors.purple, "icon": Icons.local_florist_rounded, "info": "A high-altitude plant that survives cold winds and rocky soil."},
    },
  ),
  Biome(
    title: "Mangrove Swamps",
    description: "Restore wetland ecosystems.",
    backgroundKey: "Ocean_BG",
    essences: ["Water", "Soil", "Sunlight", "Salt"],
    combos: {
      "Water+Soil+Sunlight+Salt": "Mangrove Sapling",
    },
    creatureVisuals: {
      "Mangrove Sapling": {"color": Colors.greenAccent, "icon": Icons.eco_rounded, "info": "A young mangrove, adapted to thrive in salty, swampy water."},
    },
  ),
  Biome(
    title: "Deep Sea Trench",
    description: "Populate the deepest parts of the ocean.",
    backgroundKey: "Ocean_BG",
    essences: ["Water", "Pressure", "Darkness", "Oxygen"],
    combos: {
      "Water+Pressure+Darkness+Oxygen": "Abyssal Plankton",
    },
    creatureVisuals: {
      "Abyssal Plankton": {"color": Colors.white70, "icon": Icons.bubble_chart_rounded, "info": "Tiny deep-sea organisms that can survive intense pressure."},
    },
  ),
];


// Main Game Widget
class BiomeBuilderGame extends StatefulWidget {
  final String role;
  const BiomeBuilderGame({Key? key, required this.role}) : super(key: key);

  @override
  State<BiomeBuilderGame> createState() => _BiomeBuilderGameState();
}

class _BiomeBuilderGameState extends State<BiomeBuilderGame> {
  int currentBiomeIndex = 0;
  List<String> discoveredCreatures = [];
  int score = 0;
  List<String> selectedEssences = [];

  Biome get currentBiomeData => biomes[currentBiomeIndex];
  Color get biomeBackgroundColor => biomeBackgrounds[currentBiomeData.backgroundKey]!;

  @override
  void initState() {
    super.initState();
  }

  // --- Game Logic ---
  void _combine() {
    if (selectedEssences.length < 4) {
      _showMessage("Select 4 essences to combine.", Colors.orangeAccent);
      return;
    }
    
    // Sort essences to match combo keys regardless of selection order
    selectedEssences.sort();
    final comboKey = selectedEssences.join('+');
    String? resultCreature;
    
    currentBiomeData.combos.forEach((key, value) {
      final List<String> sortedKey = key.split('+')..sort();
      if (sortedKey.join('+') == comboKey) {
        resultCreature = value;
      }
    });

    if (resultCreature != null) {
      if (!discoveredCreatures.contains(resultCreature!)) {
        setState(() {
          discoveredCreatures.add(resultCreature!);
          score += 25;
          _showMessage("✨ A new lifeform: $resultCreature! Advancing...", Colors.greenAccent);
        });
        Future.delayed(const Duration(seconds: 2), _advanceBiome);
      } else {
        _showMessage("⚠️ You've already created this one!", Colors.orangeAccent);
      }
    } else {
      _showMessage("❌ Nothing was created. Try a different combination.", Colors.redAccent);
    }
    selectedEssences.clear();
    setState(() {});
  }

  void _advanceBiome() {
    if (currentBiomeIndex < biomes.length - 1) {
      setState(() {
        currentBiomeIndex++;
        discoveredCreatures.clear();
        selectedEssences.clear();
      });
    } else {
      _showMessage("🏆 Final Quest Complete! The world is in balance.", Colors.amber);
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

  // --- UI Components ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: biomeBackgroundColor,
      appBar: AppBar(
        title: Text(currentBiomeData.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),
            _buildInfoPanel(),
            _buildDiscoveryCodexSection(), // Moved to the top
            _buildSelectedEssencesGrid(),
            _buildEssenceGrid(),
            _buildActionButtons(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoPanel() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white38),
      ),
      child: Column(
        children: [
          Text(currentBiomeData.description, style: const TextStyle(color: Colors.white70, fontSize: 14), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text("Score: $score", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSelectedEssencesGrid() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.lightGreenAccent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Creature-in-the-Making:",
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              if (index < selectedEssences.length) {
                return _essenceTile(selectedEssences[index]);
              } else {
                return _emptyEssenceSlot();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEssenceGrid() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: currentBiomeData.essences.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.0,
        ),
        itemBuilder: (context, index) {
          final essence = currentBiomeData.essences[index];
          final isSelected = selectedEssences.contains(essence);
          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedEssences.remove(essence);
                } else if (selectedEssences.length < 4) {
                  selectedEssences.add(essence);
                } else {
                  _showMessage("You can only select 4 essences.", Colors.redAccent);
                }
              });
            },
            child: _essenceTile(essence, isSelected: isSelected),
          );
        },
      ),
    );
  }
  
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _combine,
              icon: const Icon(Icons.psychology_alt_rounded, color: Colors.white),
              label: const Text("Create", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() { selectedEssences.clear(); });
                _showMessage("Essences cleared.", Colors.blueGrey);
              },
              icon: const Icon(Icons.clear_rounded, color: Colors.white),
              label: const Text("Clear", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoveryCodexSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white38),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Creatures Created", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(color: Colors.white38),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: discoveredCreatures.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              final creatureName = discoveredCreatures[index];
              return _creatureTile(creatureName);
            },
          ),
        ],
      ),
    );
  }
  
  Widget _essenceTile(String name, {bool isSelected = false}) {
    final visuals = essenceVisuals[name]!;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected ? visuals['color'].withOpacity(0.8) : visuals['color'].withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Colors.white : Colors.white38,
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(visuals['icon'], size: 40, color: Colors.white),
          const SizedBox(height: 4),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _emptyEssenceSlot() {
    return DottedBorder(
      color: Colors.white38,
      borderType: BorderType.RRect,
      radius: const Radius.circular(16),
      padding: EdgeInsets.zero,
      child: Container(
        alignment: Alignment.center,
        child: const Icon(Icons.add_rounded, size: 40, color: Colors.white38),
      ),
    );
  }

  Widget _creatureTile(String name) {
    final visuals = biomes[currentBiomeIndex].creatureVisuals[name]!;
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.black.withOpacity(0.8),
            title: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            content: Text(visuals['info'], style: const TextStyle(color: Colors.white70)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Close", style: TextStyle(color: Colors.blueAccent)),
              ),
            ],
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: visuals['color'].withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white38),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(visuals['icon'], size: 40, color: Colors.white),
            const SizedBox(height: 4),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}