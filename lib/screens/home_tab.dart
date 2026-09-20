import 'package:flutter/material.dart';

import 'history_tab.dart';

class Reward {
  const Reward({
    required this.name,
    required this.cost,
    required this.icon,
  });

  final String name;
  final int cost;
  final IconData icon;
}

class HomeTab extends StatelessWidget {
  const HomeTab({
    super.key,
    required this.username,
    required this.onGoTo,
    this.availablePoints = 0,
    this.historyItems = const [],
  });

  final String username;
  final ValueChanged<int> onGoTo;
  final int availablePoints;
  final List<ActivityHistoryItem> historyItems;

  static const List<Reward> _rewards = [
    Reward(name: 'บรรจุภัณฑ์กลับคืน', cost: 120, icon: Icons.recycling_rounded),
    Reward(name: 'คูปองร้านกาแฟ', cost: 200, icon: Icons.coffee_rounded),
    Reward(name: 'กระเป๋าผ้า', cost: 350, icon: Icons.shopping_bag_rounded),
    Reward(name: 'ตั๋วหนังสือ', cost: 500, icon: Icons.book_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final recentItems = historyItems.take(3).toList();
    final primaryColor = Theme.of(context).colorScheme.primary;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        // Modern Gradient Points Hero Banner
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF0F5132), // Deep Emerald
                Color(0xFF059669), // Electric Teal
                Color(0xFF10B981), // Mint Accent
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF059669).withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'สวัสดี, $username 👋',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.workspace_premium_rounded,
                      color: Colors.amber,
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'คะแนนสะสมที่ใช้ได้',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$availablePoints',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'คะแนน',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Vibrant Action Button with Icon & Elevation
        FilledButton.icon(
          onPressed: () => onGoTo(1),
          icon: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.add_a_photo_rounded, size: 20),
          ),
          label: const Text('บันทึกกิจกรรมใหม่'),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(54),
            elevation: 4,
            shadowColor: primaryColor.withValues(alpha: 0.4),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            const Expanded(
              child: Text(
                'กิจกรรมล่าสุด',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () => onGoTo(2),
              icon: const Icon(Icons.arrow_forward_rounded, size: 16),
              label: const Text('ดูทั้งหมด'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (recentItems.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(Icons.eco_rounded, color: primaryColor, size: 28),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ยังไม่มีกิจกรรมที่ทำ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'กด "บันทึกกิจกรรมใหม่" เพื่อเริ่มสะสมคะแนนแรก',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          for (final item in recentItems) ...[
            Card(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(Icons.eco_rounded, color: primaryColor, size: 24),
                ),
                title: Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(item.subtitle),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: item.status.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: item.status.color.withValues(alpha: 0.4),
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    item.status.label,
                    style: TextStyle(
                      color: item.status.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        const SizedBox(height: 22),
        const Text(
          'รางวัลแนะนำ',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 195,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _rewards.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final reward = _rewards[index];
              final canRedeem = availablePoints >= reward.cost;
              return SizedBox(
                width: 175,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: primaryColor.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Icon(reward.icon, color: primaryColor, size: 24),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          reward.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${reward.cost} คะแนน',
                          style: const TextStyle(
                            color: Color(0xFF475569),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.tonal(
                            onPressed: canRedeem ? () {} : null,
                            style: FilledButton.styleFrom(
                              backgroundColor: canRedeem
                                  ? primaryColor.withValues(alpha: 0.15)
                                  : Colors.grey.shade200,
                              foregroundColor:
                                  canRedeem ? primaryColor : Colors.grey.shade600,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: canRedeem
                                      ? primaryColor.withValues(alpha: 0.4)
                                      : Colors.transparent,
                                  width: 1.2,
                                ),
                              ),
                            ),
                            child: Text(
                              canRedeem ? 'แลกรางวัล' : 'ไม่ถึง',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
