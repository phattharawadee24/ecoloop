import 'package:flutter/material.dart';

class MemberManagement extends StatelessWidget {
  const MemberManagement({super.key});

  @override
  Widget build(BuildContext context) {
    final members = [
      {'name': 'Pat', 'points': '1,250', 'activities': '32'},
      {'name': 'Mo', 'points': '2,100', 'activities': '45'},
      {'name': 'Bo', 'points': '2,450', 'activities': '52'},
      {'name': 'May', 'points': '790', 'activities': '39'},
      {'name': 'sky', 'points': '1,500', 'activities': '75'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('จัดการสมาชิก')),

      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: members.length,
        itemBuilder: (context, index) {
          final member = members[index];

          return Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),

              title: Text(member['name']!),

              subtitle: Text(
                '${member['points']} Points • '
                '${member['activities']} กิจกรรม',
              ),

              trailing: ElevatedButton(
                onPressed: () {},
                child: const Text('ดูรายละเอียด'),
              ),
            ),
          );
        },
      ),
    );
  }
}
