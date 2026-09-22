import 'package:flutter/material.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  // สร้าง ScrollController
  final ScrollController _scrollController = ScrollController();

  static const List<Map<String, dynamic>> _leaders = [
    {
      'name': 'Green Hero',
      'points': 2450,
      'icon': Icons.forest_rounded,
      'level': 'ระดับ 5 Master',
    },
    {
      'name': 'Eco Friend',
      'points': 2100,
      'icon': Icons.eco_rounded,
      'level': 'ระดับ 4 Expert',
    },
    {
      'name': 'รักษ์โลก',
      'points': 1850,
      'icon': Icons.recycling_rounded,
      'level': 'ระดับ 4 Expert',
    },
    {
      'name': 'ต้นไม้สีเขียว',
      'points': 1620,
      'icon': Icons.park_rounded,
      'level': 'ระดับ 3 Pro',
    },
    {
      'name': 'นักแยกขยะ',
      'points': 1400,
      'icon': Icons.delete_sweep_rounded,
      'level': 'ระดับ 3 Pro',
    },
    {
      'name': 'สายลมเย็น',
      'points': 1230,
      'icon': Icons.air_rounded,
      'level': 'ระดับ 2 Active',
    },
    {
      'name': 'Nature Lover',
      'points': 1100,
      'icon': Icons.spa_rounded,
      'level': 'ระดับ 2 Active',
    },
    {
      'name': 'ผู้พิทักษ์ป่า',
      'points': 1050,
      'icon': Icons.nature_rounded,
      'level': 'ระดับ 2 Active',
    },
    {
      'name': 'คุณ (Me)',
      'points': 890,
      'icon': Icons.nature_people_rounded,
      'level': 'ระดับ 2 Active',
    }, 
    {
      'name': 'Newbie Green',
      'points': 700,
      'icon': Icons.energy_savings_leaf_rounded,
      'level': 'ระดับ 1 Starter',
    },
    {
      'name': 'Seedling',
      'points': 450,
      'icon': Icons.grass_rounded,
      'level': 'ระดับ 1 Starter',
    },
    {
      'name': 'เพิ่งเริ่มต้น',
      'points': 200,
      'icon': Icons.local_florist_rounded,
      'level': 'ระดับ 1 Starter',
    },
  ];

  static const Map<String, dynamic> _currentUser = {
    'rank': 9, 
    'name': 'คุณ (Me)',
    'points': 890,
    'icon': Icons.nature_people_rounded,
    'level': 'ระดับ 2 Active',
  };

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ฟังก์ชันเลื่อนหน้าจอไปยังอันดับของผู้ใช้
  void _scrollToMyRank() {
    // ความสูงโดยประมาณ:
    // Header Hero: ~150
    // Podium: ~230
    // ข้อความ 'อันดับทั้งหมด': ~50
    // ระยะห่างรวม: ~100
    // ความสูงการ์ดอันดับต่อชิ้น (รวม Margin): ~80
    const double topSectionsHeight = 530.0;
    const double cardHeight = 80.0;

    // คำนวณตำแหน่ง (อันดับของผู้ใช้ - 1) * ความสูงการ์ด
    // ถ้าผู้ใช้อยู่ใน Top 3 ไม่ต้องเลื่อนไปหาในการ์ดล่าง (เพราะมี Podium อยู่แล้ว)
    if (_currentUser['rank'] > 3) {
      final targetPosition =
          topSectionsHeight + ((_currentUser['rank'] - 1) * cardHeight);

      _scrollController.animateTo(
        targetPosition,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    } else {
      // ถ้าอยู่ Top 3 ให้เลื่อนไปบนสุด
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final int topPoints = (_leaders.first['points'] as num).toInt();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'อันดับนักรักษ์โลก',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Color(0xFF2D2B3E),
          ),
        ),
      ),
      body: ListView(
        controller: _scrollController, 
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 120),
        children: [
          _buildHeroCard(),
          const SizedBox(height: 28),
          _buildPodium(context),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'อันดับทั้งหมด',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2A2838),
                ),
              ),
              Text(
                'อัปเดตแบบเรียลไทม์',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ..._leaders.asMap().entries.map((entry) {
            final rank = entry.key + 1;
            final leader = entry.value;

            
            final bool isMe = rank == _currentUser['rank'];

            return _buildRankItem(
              context: context,
              rank: rank,
              name: leader['name'] as String,
              level: leader['level'] as String,
              points: leader['points'] as int,
              icon: leader['icon'] as IconData,
              maxPoints: topPoints,
              isMe: isMe,
            );
          }),
        ],
      ),
      bottomNavigationBar: _buildMyRankBar(context),
    );
  }

  Widget _buildMyRankBar(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2438),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2A2438).withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: InkWell(
          
          onTap: _scrollToMyRank,
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 40, 121, 87),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '#${_currentUser['rank']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF3F8F5B),
                child: Icon(
                  _currentUser['icon'] as IconData,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _currentUser['name'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'YOU',
                            style: TextStyle(
                              color: Color(0xFFFFD54F),
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _currentUser['level'] as String,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.65),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${_currentUser['points']}',
                    style: const TextStyle(
                      color: Color(0xFFFFD54F),
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'คะแนน',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              // เพิ่มไอคอนลูกศรบอกให้รู้ว่ากดได้
              const SizedBox(width: 10),
              Icon(
                Icons.unfold_more_rounded,
                color: Colors.white.withOpacity(0.5),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C4AB6), Color(0xFF8D6BB8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C4AB6).withOpacity(0.32),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              size: 42,
              color: Color(0xFFFFD54F),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Green Champions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'สะสมคะแนนจากการแยกขยะ ปลูกต้นไม้ และกิจกรรมเพื่อโลก',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.85),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodium(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: _podiumPlayer(
            context: context,
            rank: 2,
            name: _leaders[1]['name'] as String,
            points: _leaders[1]['points'] as int,
            icon: _leaders[1]['icon'] as IconData,
            height: 175,
            badgeColor: const Color(0xFFB0BEC5),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _podiumPlayer(
            context: context,
            rank: 1,
            name: _leaders[0]['name'] as String,
            points: _leaders[0]['points'] as int,
            icon: _leaders[0]['icon'] as IconData,
            height: 205,
            badgeColor: const Color(0xFFFFB300),
            isChampion: true,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _podiumPlayer(
            context: context,
            rank: 3,
            name: _leaders[2]['name'] as String,
            points: _leaders[2]['points'] as int,
            icon: _leaders[2]['icon'] as IconData,
            height: 160,
            badgeColor: const Color(0xFFCD7F32),
          ),
        ),
      ],
    );
  }

  Widget _podiumPlayer({
    required BuildContext context,
    required int rank,
    required String name,
    required int points,
    required IconData icon,
    required double height,
    required Color badgeColor,
    bool isChampion = false,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => _showLeaderDetails(context, rank, name, points),
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isChampion
                ? badgeColor.withOpacity(0.5)
                : Colors.transparent,
            width: isChampion ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isChampion
                  ? badgeColor.withOpacity(0.2)
                  : Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: isChampion ? 30 : 25,
                  backgroundColor: const Color(0xFFE8F5E9),
                  child: Icon(
                    icon,
                    size: isChampion ? 32 : 26,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
                Positioned(
                  bottom: -6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: badgeColor.withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '#$rank',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: Color(0xFF2D2B3E),
              ),
            ),
            const SizedBox(height: 3),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFF3EDFA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$points pts',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6C4AB6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankItem({
    required BuildContext context,
    required int rank,
    required String name,
    required String level,
    required int points,
    required IconData icon,
    required int maxPoints,
    bool isMe = false, // เพิ่มพารามิเตอร์เช็คว่าใช่การ์ดผู้ใช้หรือไม่
  }) {
    final double progress = (points / maxPoints).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        // ถ้าเป็นการ์ดของผู้ใช้ เปลี่ยนสีพื้นหลังนิดหน่อยให้เด่นขึ้น
        color: isMe ? const Color(0xFFF0EBFF) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _showLeaderDetails(context, rank, name, points),
          child: Container(
            decoration: isMe
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFF6C4AB6),
                      width: 1.5,
                    ),
                  )
                : null,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                  child: Center(
                    child: Text(
                      '$rank',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: rank <= 3
                            ? const Color(0xFF6C4AB6)
                            : Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFFF1F8F4),
                  child: Icon(icon, color: const Color(0xFF2E7D32), size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2A2838),
                              ),
                            ),
                          ),
                          Text(
                            '$points',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              color: Color.fromARGB(255, 54, 147, 90),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 6,
                                backgroundColor: isMe
                                    ? Colors.white
                                    : const Color(0xFFEDEBF0),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF4CAF50),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            level,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLeaderDetails(
    BuildContext context,
    int rank,
    String name,
    int points,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 34,
                backgroundColor: const Color(0xFFE8F5E9),
                child: const Icon(
                  Icons.eco_rounded,
                  size: 36,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'ครองอันดับที่ $rank ของกระดานผู้นำ',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F7FC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _metricCol('คะแนนสะสม', '$points'),
                    Container(
                      width: 1,
                      height: 28,
                      color: Colors.grey.shade300,
                    ),
                    _metricCol(
                      'ลดก๊าซเรือนกระจก',
                      '${(points * 0.12).toStringAsFixed(1)} kg',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C4AB6),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'ปิด',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _metricCol(String title, String val) {
    return Column(
      children: [
        Text(
          val,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6C4AB6),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
