import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// ------------------- WRAPPER CLASS -------------------
class AstronomySkyRealm extends StatelessWidget {
  const AstronomySkyRealm({super.key});

  @override
  Widget build(BuildContext context) {
    return const GameFlow();
  }
}

// ------------------- GAME FLOW -------------------
enum AstronomyStage { intro, meteor, stageClear, complete }

class GameFlow extends StatefulWidget {
  const GameFlow({super.key});

  @override
  State<GameFlow> createState() => _GameFlowState();
}

class _GameFlowState extends State<GameFlow> {
  AstronomyStage stage = AstronomyStage.intro;
  bool hasShield = false;
  int lives = 3;
  int level = 1;

  void _startMeteorStage(int lvl) {
    setState(() {
      level = lvl;
      stage = AstronomyStage.meteor;
    });
  }

  void _gainShield() => setState(() => hasShield = true);

  void _useShield() => setState(() => hasShield = false);

  void _loseLife() {
    setState(() {
      lives--;
      if (lives <= 0) {
        stage = AstronomyStage.complete; // Game Over
      }
    });
  }

  void _stageClear() {
    setState(() {
      stage = AstronomyStage.stageClear;
    });
  }

  void _nextLevel() {
    if (level < 3) {
      _startMeteorStage(level + 1);
    } else {
      setState(() => stage = AstronomyStage.complete); // Final completion
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D102C),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: switch (stage) {
          AstronomyStage.intro => _Intro(
              onContinue: () => _startMeteorStage(1),
            ),
          AstronomyStage.meteor => MeteorDodge(
              key: ValueKey("meteor$level"),
              level: level,
              lives: lives,
              hasShield: hasShield,
              onShieldUsed: _useShield,
              onLifeLost: _loseLife,
              onStageClear: _stageClear,
              onQuiz: (onDone) {
                final quiz = quizPool[Random().nextInt(quizPool.length)];
                Navigator.of(context).push(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (_) => QuizScreen(
                      question: quiz["q"]!,
                      options: quiz["opts"]!,
                      correctAnswer: quiz["ans"]!,
                      onCorrect: () {
                        _gainShield();
                        onDone();
                      },
                      onWrong: onDone,
                    ),
                  ),
                );
              },
            ),
          AstronomyStage.stageClear => StageClearScreen(
              level: level,
              onNext: _nextLevel,
            ),
          AstronomyStage.complete => _Complete(
              lives: lives,
              onExit: () => Navigator.pop(context),
              onPlayAgain: () {
                setState(() {
                  stage = AstronomyStage.intro;
                  hasShield = false;
                  lives = 3;
                  level = 1;
                });
              },
            ),
        },
      ),
    );
  }
}

// ------------------- INTRO -------------------
class _Intro extends StatelessWidget {
  final VoidCallback onContinue;
  const _Intro({required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey("intro"),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "🔭 Astronomy Sky Realm",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text("Start Journey 🚀"),
          ),
        ],
      ),
    );
  }
}

// ------------------- METEOR DODGE GAMEPLAY -------------------
class MeteorDodge extends StatefulWidget {
  final int level;
  final int lives;
  final bool hasShield;
  final VoidCallback onStageClear;
  final VoidCallback onShieldUsed;
  final VoidCallback onLifeLost;
  final Function(VoidCallback resumeGame) onQuiz;

  const MeteorDodge({
    super.key,
    required this.level,
    required this.lives,
    required this.hasShield,
    required this.onStageClear,
    required this.onShieldUsed,
    required this.onLifeLost,
    required this.onQuiz,
  });

  @override
  State<MeteorDodge> createState() => _MeteorDodgeState();
}

class _MeteorDodgeState extends State<MeteorDodge> {
  double rocketX = 0;
  final double rocketSize = 60;
  final double meteorSize = 40;
  final double powerUpSize = 35;

  List<Meteor> meteors = [];
  List<PowerUp> powerUps = [];
  Timer? gameLoop;
  Timer? timer;
  int timeLeft = 60;
  bool paused = false;

  bool localHasShield = false;
  int lastSeenLives = 0;

  // Difficulty scaling
  double meteorSpeed = 0.02;
  double powerUpSpeed = 0.015;
  int stageTime = 60;

  @override
  void initState() {
    super.initState();
    localHasShield = widget.hasShield;
    lastSeenLives = widget.lives;

    // Scale difficulty by level
    meteorSpeed += 0.01 * (widget.level - 1);
    powerUpSpeed += 0.005 * (widget.level - 1);
    stageTime = (60 - (widget.level - 1) * 10).clamp(30, 60);
    timeLeft = stageTime;

    _startGame();
  }

  @override
  void didUpdateWidget(covariant MeteorDodge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hasShield != widget.hasShield) {
      setState(() => localHasShield = widget.hasShield);
    }
    if (oldWidget.lives != widget.lives) {
      lastSeenLives = widget.lives;
      if (widget.lives <= 0) {
        gameLoop?.cancel();
        timer?.cancel();
      }
    }
  }

  void _startGame() {
    meteors.clear();
    powerUps.clear();
    paused = false;

    gameLoop = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (paused) return;
      setState(() {
        for (var meteor in meteors) {
          meteor.y += meteorSpeed;
        }
        meteors.removeWhere((m) => m.y > 1.2);

        for (var p in powerUps) {
          p.y += powerUpSpeed;
        }
        powerUps.removeWhere((p) => p.y > 1.2);

        // Meteor collisions
        for (var meteor in List<Meteor>.from(meteors)) {
          if (_checkCollision(meteor.x, meteor.y, meteorSize)) {
            if (localHasShield) {
              widget.onShieldUsed();
              localHasShield = false;
              meteors.remove(meteor);
            } else {
              meteors.remove(meteor);
              _hit();
            }
            break;
          }
        }

        // Powerup collection
        for (var p in List<PowerUp>.from(powerUps)) {
          if (_checkCollision(p.x, p.y, powerUpSize)) {
            powerUps.remove(p);
            paused = true;
            widget.onQuiz(() => setState(() => paused = false));
            break;
          }
        }

        // Random spawns (increase rate by level)
        final rand = Random().nextDouble();
        if (rand < 0.05 * widget.level + 0.01) {
          meteors.add(Meteor(Random().nextDouble() * 2 - 1, -1));
        }
        if (Random().nextDouble() < 0.01 + (0.002 * widget.level)) {
          powerUps.add(PowerUp(Random().nextDouble() * 2 - 1, -1));
        }
      });
    });

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (paused) return;
      setState(() {
        timeLeft--;
        if (timeLeft <= 0) _win();
      });
    });
  }

  bool _checkCollision(double objX, double objY, double objSize) {
    final rocketRect = Rect.fromCenter(
      center: Offset(
        (rocketX + 1) / 2 * MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height - 100,
      ),
      width: rocketSize,
      height: rocketSize,
    );

    final objRect = Rect.fromCenter(
      center: Offset(
        (objX + 1) / 2 * MediaQuery.of(context).size.width,
        objY * MediaQuery.of(context).size.height,
      ),
      width: objSize,
      height: objSize,
    );

    return rocketRect.overlaps(objRect);
  }

  void _hit() {
    widget.onLifeLost();
    if (lastSeenLives <= 1 || widget.lives <= 1) {
      gameLoop?.cancel();
      timer?.cancel();
    }
    lastSeenLives = max(0, lastSeenLives - 1);
  }

  void _win() {
    gameLoop?.cancel();
    timer?.cancel();
    widget.onStageClear();
  }

  void _moveRocket(double delta) {
    setState(() {
      rocketX = (rocketX + delta).clamp(-1.0, 1.0);
    });
  }

  @override
  void dispose() {
    gameLoop?.cancel();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        _moveRocket(details.delta.dx / MediaQuery.of(context).size.width * 2);
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D102C), Color(0xFF1B1F54)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Meteors
            ...meteors.map(
              (m) => Positioned(
                left: (m.x + 1) / 2 * MediaQuery.of(context).size.width - meteorSize / 2,
                top: m.y * MediaQuery.of(context).size.height,
                child: Icon(Icons.brightness_1, color: Colors.red.shade400, size: meteorSize),
              ),
            ),

            // PowerUps
            ...powerUps.map(
              (p) => Positioned(
                left: (p.x + 1) / 2 * MediaQuery.of(context).size.width - powerUpSize / 2,
                top: p.y * MediaQuery.of(context).size.height,
                child: Icon(Icons.star, color: Colors.greenAccent.shade400, size: powerUpSize),
              ),
            ),

            // Rocket
            Positioned(
              bottom: 50,
              left: (rocketX + 1) / 2 * MediaQuery.of(context).size.width - rocketSize / 2,
              child: Icon(Icons.rocket_launch, color: Colors.orangeAccent.shade200, size: rocketSize),
            ),

            // Shield indicator
            if (localHasShield)
              const Positioned(
                top: 40,
                right: 20,
                child: Icon(Icons.shield, color: Colors.lightBlueAccent, size: 40),
              ),

            // Lives
            Positioned(
              top: 40,
              left: 20,
              child: Row(
                children: List.generate(
                  widget.lives,
                  (i) => const Icon(Icons.favorite, color: Colors.pinkAccent, size: 30),
                ),
              ),
            ),

            // Timer
            Positioned(
              top: 40,
              left: MediaQuery.of(context).size.width / 2 - 30,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "$timeLeft s",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Meteor {
  double x;
  double y;
  Meteor(this.x, this.y);
}

class PowerUp {
  double x;
  double y;
  PowerUp(this.x, this.y);
}

// ------------------- QUIZ SCREEN -------------------
class QuizScreen extends StatelessWidget {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final VoidCallback onCorrect;
  final VoidCallback onWrong;

  const QuizScreen({
    super.key,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.onCorrect,
    required this.onWrong,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        key: const ValueKey("quiz"),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                question,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ...options.map(
                (opt) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      if (opt == correctAnswer) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("✅ Correct! Shield earned")),
                        );
                        onCorrect();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("❌ Wrong! No shield earned")),
                        );
                        onWrong();
                      }
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: Text(opt),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------- STAGE CLEAR -------------------
class StageClearScreen extends StatelessWidget {
  final int level;
  final VoidCallback onNext;
  const StageClearScreen({
    super.key,
    required this.level,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey("stageClear"),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "✅ Stage $level Clear!",
            style: const TextStyle(color: Colors.greenAccent, fontSize: 28),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text("Next Stage"),
          ),
        ],
      ),
    );
  }
}

// ------------------- COMPLETE -------------------
class _Complete extends StatelessWidget {
  final int lives;
  final VoidCallback onExit;
  final VoidCallback onPlayAgain;
  const _Complete({
    required this.lives,
    required this.onExit,
    required this.onPlayAgain,
  });

  @override
  Widget build(BuildContext context) {
    final gameOver = lives <= 0;
    return Center(
      key: const ValueKey("complete"),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            gameOver ? "💀 Game Over" : "🎉 Journey Complete! 🎉",
            style: TextStyle(
              color: gameOver ? Colors.redAccent : Colors.greenAccent,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onPlayAgain,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text("Play Again"),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onExit,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            child: const Text("Exit"),
          ),
        ],
      ),
    );
  }
}

// ------------------- QUIZ POOL -------------------
final List<Map<String, dynamic>> quizPool = [
  {
    "q": "Which planet is known as the Red Planet?",
    "opts": ["Venus", "Mars", "Jupiter", "Mercury"],
    "ans": "Mars",
  },
  {
    "q": "What is the largest planet in our solar system?",
    "opts": ["Saturn", "Earth", "Jupiter", "Neptune"],
    "ans": "Jupiter",
  },
  {
    "q": "Which planet has the most moons?",
    "opts": ["Mars", "Saturn", "Jupiter", "Uranus"],
    "ans": "Saturn",
  },
  {
    "q": "The Sun is mainly composed of?",
    "opts": ["Oxygen", "Hydrogen", "Iron", "Carbon"],
    "ans": "Hydrogen",
  },
];
