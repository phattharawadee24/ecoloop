import 'package:flutter/material.dart';

import 'reward_form.dart';

class RewardManagement extends StatefulWidget {
  const RewardManagement({super.key});

  @override
  State<RewardManagement> createState() => _RewardManagementState();
}

class _RewardManagementState extends State<RewardManagement> {
  final rewards = <Map<String, dynamic>>[
    {
      'name': 'แก้วน้ำ EcoLoop',
      'description': 'แก้วเก็บความเย็น',
      'points': 1000,
      'quantity': 20,
    },
    {
      'name': 'ถุงผ้า EcoLoop',
      'description': 'ถุงผ้ารักษ์โลก',
      'points': 500,
      'quantity': 50,
    },
  ];

  Future<void> openForm({int? index}) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            RewardForm(reward: index == null ? null : rewards[index]),
      ),
    );
    if (!mounted || result == null) return;
    setState(() {
      if (index == null) {
        rewards.add(result);
      } else {
        rewards[index] = result;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('จัดการรางวัล')),

      floatingActionButton: FloatingActionButton(
        onPressed: () => openForm(),
        child: const Icon(Icons.add),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ...rewards.asMap().entries.map(
            (entry) => rewardCard(entry.key, entry.value),
          ),
        ],
      ),
    );
  }

  Widget rewardCard(int index, Map<String, dynamic> reward) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.card_giftcard, size: 40),

        title: Text(reward['name'] as String),

        subtitle: Text(
          '${reward['points']} Points • จำนวน ${reward['quantity']} ชิ้น',
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => openForm(index: index),
            ),

            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => setState(() => rewards.removeAt(index)),
            ),
          ],
        ),
      ),
    );
  }
}
