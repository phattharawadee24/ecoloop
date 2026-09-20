import 'package:flutter/material.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  int _points = 1250;
  final Set<String> _redeemedRewards = {};

  static const List<Map<String, Object>> _rewards = [
    {
      'title': 'ส่วนลดเครื่องดื่ม 10 บาท',
      'points': 100,
      'icon': Icons.local_cafe,
      'color': Colors.orange,
    },
    {
      'title': 'ถุงผ้ารักษ์โลก',
      'points': 250,
      'icon': Icons.shopping_bag,
      'color': Colors.green,
    },
    {
      'title': 'ต้นไม้สำหรับปลูกที่บ้าน',
      'points': 500,
      'icon': Icons.park,
      'color': Colors.teal,
    },
  ];

  void _redeemReward(Map<String, Object> reward) {
    final title = reward['title'] as String;
    final cost = reward['points'] as int;

    if (_redeemedRewards.contains(title)) {
      return;
    }

    if (_points < cost) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('คะแนนของคุณไม่เพียงพอ')));
      return;
    }

    setState(() {
      _points -= cost;
      _redeemedRewards.add(title);
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('แลก $title สำเร็จแล้ว')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(Icons.stars, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('คะแนนของคุณ'),
                      SizedBox(height: 4),
                      Text(
                        '$_points คะแนน',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('แลกรางวัล', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ..._rewards.map(
            (reward) => Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: (reward['color'] as Color).withAlpha(35),
                  child: Icon(
                    reward['icon'] as IconData,
                    color: reward['color'] as Color,
                  ),
                ),
                title: Text(reward['title'] as String),
                subtitle: Text('${reward['points']} คะแนน'),
                trailing: FilledButton(
                  onPressed: () => _redeemReward(reward),
                  child: Text(
                    _redeemedRewards.contains(reward['title'])
                        ? 'แลกแล้ว'
                        : 'แลก',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
