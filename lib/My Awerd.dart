import 'package:flutter/material.dart';

class MyAwardPage extends StatelessWidget {
  const MyAwardPage({super.key});

  static const List<Map<String, Object>> _awards = [
    {
      'title': 'นักรีไซเคิลมือใหม่',
      'description': 'รีไซเคิลขยะครบ 5 ครั้ง',
      'icon': Icons.recycling,
      'color': Color.fromARGB(255, 144, 213, 147),
    },
    {
      'title': 'รักษ์โลกต่อเนื่อง',
      'description': 'ใช้งานติดต่อกันครบ 7 วัน',
      'icon': Icons.eco,
      'color': Color.fromARGB(255, 66, 160, 151),
    },
    {
      'title': 'ผู้ช่วยโลก',
      'description': 'สะสมคะแนนครบ 1,000 คะแนน',
      'icon': Icons.volunteer_activism,
      'color': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Award'),
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
                    radius: 30,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(Icons.emoji_events, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('รางวัลของฉัน'),
                      SizedBox(height: 4),
                      Text(
                        'ได้รับแล้ว 3 รางวัล',
                        style: TextStyle(
                          fontSize: 20,
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
          Text(
            'ความสำเร็จของคุณ',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ..._awards.map(
            (award) => Card(
              child: ListTile(
                onTap: () => _showAwardDetails(context, award),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: CircleAvatar(
                  backgroundColor: (award['color'] as Color).withAlpha(35),
                  child: Icon(
                    award['icon'] as IconData,
                    color: award['color'] as Color,
                  ),
                ),
                title: Text(award['title'] as String),
                subtitle: Text(award['description'] as String),
                trailing: const Icon(Icons.check_circle, color: Colors.green),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAwardDetails(BuildContext context, Map<String, Object> award) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(award['icon'] as IconData, color: award['color'] as Color),
            const SizedBox(width: 12),
            Expanded(child: Text(award['title'] as String)),
          ],
        ),
        content: Text(award['description'] as String),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
  }
}
