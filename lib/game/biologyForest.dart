import 'package:flutter/material.dart';

void main() {
  runApp(const ScienceQuestApp());
}

class ScienceQuestApp extends StatelessWidget {
  const ScienceQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Science Quest',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7B4DFF)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D102C),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Science Quest',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Realms of Discovery',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Text(
                    '🌱 Biology Forest\n\nThe forest is sick because the photosynthesis cycle is broken.\nHelp restore balance by solving science puzzles!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const BiologyForestLevel(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Start Biology Forest'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum LevelStage {
  exploration,
  photosynthesis,
  quizBattle,
  microscope,
  complete,
}

class BiologyForestLevel extends StatefulWidget {
  const BiologyForestLevel({super.key});

  @override
  State<BiologyForestLevel> createState() => _BiologyForestLevelState();
}

class _BiologyForestLevelState extends State<BiologyForestLevel> {
  LevelStage stage = LevelStage.exploration;

  void _next(LevelStage next) {
    setState(() => stage = next);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🌱 Biology Forest')),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: switch (stage) {
          LevelStage.exploration => _Exploration(
            onContinue: () => _next(LevelStage.photosynthesis),
          ),
          LevelStage.photosynthesis => PhotosynthesisPuzzle(
            onSolved: () => _next(LevelStage.quizBattle),
          ),
          LevelStage.quizBattle => QuizBattle(
            onWin: () => _next(LevelStage.microscope),
          ),
          LevelStage.microscope => MicroscopeMatch(
            onDone: () => _next(LevelStage.complete),
          ),
          LevelStage.complete => _LevelComplete(
            onExit: () => Navigator.pop(context),
          ),
        },
      ),
    );
  }
}

class _Exploration extends StatelessWidget {
  final VoidCallback onContinue;
  const _Exploration({required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF183A1D), Color(0xFF0B2B15)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🦉 Sage Owl',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '“The forest wilts... Photosynthesis is broken!\nCan you restore the cycle?”',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: onContinue,
                child: const Text('Begin Quest'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// -----------------------
/// Puzzle 1: Photosynthesis
/// Drag & drop inputs to the leaf in the correct slots.
/// Required: Sunlight, CO₂, Water -> Leaf
/// -----------------------
class PhotosynthesisPuzzle extends StatefulWidget {
  final VoidCallback onSolved;
  const PhotosynthesisPuzzle({super.key, required this.onSolved});

  @override
  State<PhotosynthesisPuzzle> createState() => _PhotosynthesisPuzzleState();
}

class _PhotosynthesisPuzzleState extends State<PhotosynthesisPuzzle> {
  final List<_Item> bank = [
    const _Item('Sunlight', '☀️'),
    const _Item('CO₂', '💨'),
    const _Item('Water', '💧'),
    const _Item('Leaf', '🍃'),
  ];

  final Map<int, _Item?> slots = {0: null, 1: null, 2: null, 3: null};
  bool solved = false;

  final List<_Item> correctOrder = const [
    _Item('Sunlight', '☀️'),
    _Item('CO₂', '💨'),
    _Item('Water', '💧'),
    _Item('Leaf', '🍃'),
  ];

  void _checkSolved() {
    bool allFilled = slots.values.every((v) => v != null);
    if (!allFilled) return;
    bool ok = true;
    for (int i = 0; i < slots.length; i++) {
      if (slots[i]?.name != correctOrder[i].name) ok = false;
    }
    if (ok) {
      setState(() => solved = true);
      Future.delayed(const Duration(milliseconds: 600), widget.onSolved);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.green.shade50,
          child: const Text(
            'Puzzle: Restore Photosynthesis\nDrag items into the correct order: Sunlight → CO₂ → Water → Leaf',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 12),
        // Target Slots Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              4,
              (index) => _Slot(
                index: index,
                item: slots[index],
                onAccept: (it) {
                  setState(() => slots[index] = it);
                  _checkSolved();
                },
                solved: solved,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text('Bank (drag from here):'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children:
              bank
                  .map(
                    (e) => Draggable<_Item>(
                      data: e,
                      feedback: _Chip(item: e, elevated: true),
                      childWhenDragging: Opacity(
                        opacity: 0.4,
                        child: _Chip(item: e),
                      ),
                      child: _Chip(item: e),
                    ),
                  )
                  .toList(),
        ),
        const Spacer(),
        if (!solved)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Hint: Plants use sunlight, carbon dioxide, and water in leaves to make food and release oxygen. 🌿',
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
      ],
    );
  }
}

class _Item {
  final String name;
  final String emoji;
  const _Item(this.name, this.emoji);
}

class _Chip extends StatelessWidget {
  final _Item item;
  final bool elevated;
  const _Chip({required this.item, this.elevated = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevated ? 6 : 0,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(item.emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(item.name),
          ],
        ),
      ),
    );
  }
}

class _Slot extends StatelessWidget {
  final int index;
  final _Item? item;
  final void Function(_Item) onAccept;
  final bool solved;
  const _Slot({
    required this.index,
    required this.item,
    required this.onAccept,
    required this.solved,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<_Item>(
      onAccept: onAccept,
      builder: (context, candidates, rejects) {
        final isActive = candidates.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color:
                solved
                    ? Colors.green.shade200
                    : isActive
                    ? Colors.green.shade100
                    : Colors.green.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.green.shade300),
          ),
          child: Center(
            child:
                item == null
                    ? Text(
                      '#${index + 1}',
                      style: TextStyle(
                        color: Colors.green.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item!.emoji, style: const TextStyle(fontSize: 22)),
                        const SizedBox(height: 4),
                        Text(item!.name, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
          ),
        );
      },
    );
  }
}

/// -----------------------
/// Mini-Battle: Quiz
/// Answer 3 questions correctly to win.
/// -----------------------
class QuizBattle extends StatefulWidget {
  final VoidCallback onWin;
  const QuizBattle({super.key, required this.onWin});

  @override
  State<QuizBattle> createState() => _QuizBattleState();
}

class _QuizBattleState extends State<QuizBattle> {
  final List<_Q> questions = [
    _Q('Which gas do plants release during photosynthesis?', [
      'Oxygen',
      'Carbon dioxide',
      'Nitrogen',
      'Hydrogen',
    ], 0),
    _Q('Where does photosynthesis primarily occur in a plant?', [
      'Root',
      'Stem',
      'Leaf',
      'Flower',
    ], 2),
    _Q('What is the main source of energy for photosynthesis?', [
      'Water',
      'Sunlight',
      'Soil',
      'Wind',
    ], 1),
    _Q('Plants take in CO₂ from the…', ['Soil', 'Air', 'Water', 'Sun'], 1),
  ];

  int index = 0;
  int correct = 0;
  int hpMonster = 3;

  void _answer(int choice) {
    final q = questions[index % questions.length];
    final isRight = choice == q.correctIndex;
    setState(() {
      if (isRight) {
        correct++;
        hpMonster = (hpMonster - 1).clamp(0, 3);
      }
      index++;
    });
    if (hpMonster == 0 || correct >= 3) {
      Future.delayed(const Duration(milliseconds: 450), widget.onWin);
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[index % questions.length];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '🧪 Quiz Battle: Smog Monster',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: List.generate(
                  3,
                  (i) => Icon(
                    Icons.heart_broken,
                    size: 22,
                    color: i < hpMonster ? Colors.red : Colors.black12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Question',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(q.text, style: const TextStyle(fontSize: 18)),
                  const Spacer(),
                  ...List.generate(
                    q.choices.length,
                    (i) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: OutlinedButton(
                        onPressed: () => _answer(i),
                        child: Text(q.choices[i]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text('Tip: Correct answers weaken the monster!'),
        ],
      ),
    );
  }
}

class _Q {
  final String text;
  final List<String> choices;
  final int correctIndex;
  _Q(this.text, this.choices, this.correctIndex);
}

/// -----------------------
/// Mini-Experiment: Microscope Match
/// Drag spores to matching outlines.
/// -----------------------
class MicroscopeMatch extends StatefulWidget {
  final VoidCallback onDone;
  const MicroscopeMatch({super.key, required this.onDone});

  @override
  State<MicroscopeMatch> createState() => _MicroscopeMatchState();
}

class _MicroscopeMatchState extends State<MicroscopeMatch> {
  final List<_Spore> spores = const [
    _Spore('Round', '⚪'),
    _Spore('Oval', '🟠'),
    _Spore('Star', '✳️'),
  ];

  final Map<String, String?> placed = {
    'Round': null,
    'Oval': null,
    'Star': null,
  };

  void _checkDone() {
    final ok = placed.entries.every((e) => e.value == e.key);
    if (ok) {
      Future.delayed(const Duration(milliseconds: 400), widget.onDone);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('🔬 Microscope: Match fungal spores to their shapes'),
          const SizedBox(height: 12),
          Expanded(
            child: Row(
              children: [
                // Bank
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Spores (drag):',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            spores
                                .map(
                                  (s) => Draggable<_Spore>(
                                    data: s,
                                    feedback: _SporeChip(
                                      spore: s,
                                      elevated: true,
                                    ),
                                    childWhenDragging: Opacity(
                                      opacity: 0.3,
                                      child: _SporeChip(spore: s),
                                    ),
                                    child: _SporeChip(spore: s),
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Targets
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Microscope Field:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children:
                            placed.keys
                                .map(
                                  (label) => DragTarget<_Spore>(
                                    onAccept: (s) {
                                      setState(() => placed[label] = s.label);
                                      _checkDone();
                                    },
                                    builder: (context, cand, rej) {
                                      final isActive = cand.isNotEmpty;
                                      return AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        width: 120,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color:
                                              isActive
                                                  ? Colors.blue.shade50
                                                  : Colors.white,
                                          border: Border.all(
                                            color: Colors.blue.shade200,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              placed[label] == null
                                                  ? 'Place: $label'
                                                  : '✔ $label',
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              placed[label] == null
                                                  ? '◯'
                                                  : spores
                                                      .firstWhere(
                                                        (s) =>
                                                            s.label ==
                                                            placed[label],
                                                      )
                                                      .emoji,
                                              style: const TextStyle(
                                                fontSize: 28,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Fact: Fungi are key decomposers—returning nutrients to the ecosystem. 🍄',
          ),
        ],
      ),
    );
  }
}

class _Spore {
  final String label;
  final String emoji;
  const _Spore(this.label, this.emoji);
}

class _SporeChip extends StatelessWidget {
  final _Spore spore;
  final bool elevated;
  const _SporeChip({required this.spore, this.elevated = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevated ? 6 : 0,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(spore.emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(spore.label),
          ],
        ),
      ),
    );
  }
}

/// -----------------------
/// Level Complete
/// -----------------------
class _LevelComplete extends StatelessWidget {
  final VoidCallback onExit;
  const _LevelComplete({required this.onExit});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🎉 Forest Restored!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'You solved all challenges and collected a Knowledge Crystal.',
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onExit, child: const Text('Back to Home')),
          ],
        ),
      ),
    );
  }
}
