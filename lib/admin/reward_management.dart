import 'package:flutter/material.dart';

class RewardManagement extends StatelessWidget {
  const RewardManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('จัดการรางวัล'),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // เปิดหน้าเพิ่มรางวัล
        },
        child: const Icon(Icons.add),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          rewardCard(
            'แก้วน้ำ EcoLoop',
            '1,000 Points',
            '20 ชิ้น',
          ),

          rewardCard(
            'ถุงผ้า EcoLoop',
            '500 Points',
            '50 ชิ้น',
          ),
        ],
      ),
    );
  }

  Widget rewardCard(
    String name,
    String points,
    String quantity,
  ) {
    return Card(
      child: ListTile(
        leading: const Icon(
          Icons.card_giftcard,
          size: 40,
        ),

        title: Text(name),

        subtitle: Text(
          '$points • จำนวน $quantity',
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {},
            ),

            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}