import 'package:flutter/material.dart';

import 'Leaderboard.dart';
import 'My Awerd.dart';
import 'Rewards.dart';
import 'profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcoLoop',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 114, 204, 127),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // =====================================================
  // MENU BUTTON
  // =====================================================

  Widget _menuButton({
    required IconData icon,
    required String title,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 150,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 136, 218, 200),
          foregroundColor: const Color.fromARGB(255, 133, 55, 185),
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFE8C8),

      // =================================================
      // APP BAR
      // =================================================
      appBar: AppBar(
        backgroundColor: const Color(0xFF9AD3A7),
        elevation: 0,

        title: const Text(
          'Flutter Demo Home Page',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),

      // =================================================
      // BODY
      // =================================================
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
          child: Column(
            children: [
              // ==========================================
              // WELCOME CARD
              // ==========================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 50, 181, 133),
                      Color.fromARGB(255, 41, 183, 138),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Icon
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.eco,
                        size: 34,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Welcome to EcoLoop',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      'มาร่วมกันสร้างโลกที่น่าอยู่ไปด้วยกัน 🌱',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ==========================================
              // POINT SECTION
              // ==========================================
              const Text(
                'คะแนนของคุณ',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),

              const SizedBox(height: 2),

              Text(
                '$_counter',
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 74, 192, 147),
                ),
              ),

              const Text(
                'คะแนน',
                style: TextStyle(fontSize: 12, color: Colors.black45),
              ),

              const SizedBox(height: 25),

              // ==========================================
              // MENU
              // ==========================================
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'เมนูของฉัน',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 14),

              // Row 1
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _menuButton(
                    icon: Icons.card_giftcard,
                    title: 'Rewards',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RewardsPage(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(width: 12),

                  _menuButton(
                    icon: Icons.emoji_events,
                    title: 'My Award',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyAwardPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Row 2
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _menuButton(
                    icon: Icons.person,
                    title: 'Profile',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(width: 12),

                  _menuButton(
                    icon: Icons.leaderboard,
                    title: 'Leaderboard',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LeaderboardPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // ==========================================
              // ECO TIP
              // ==========================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF6EC),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFCDE8D2)),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Color(0xFF4E9461),
                      size: 28,
                    ),

                    SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Eco Tip',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3E7D4E),
                            ),
                          ),

                          SizedBox(height: 3),

                          Text(
                            'การแยกขยะช่วยลดปริมาณขยะและรักษาสิ่งแวดล้อม',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // =================================================
      // FLOATING BUTTON
      // =================================================
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,

        backgroundColor: const Color(0xFFE4D5FF),
        foregroundColor: const Color(0xFF5E4685),

        elevation: 5,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),

        child: const Icon(Icons.add, size: 27),
      ),
    );
  }
}
