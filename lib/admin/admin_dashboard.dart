import 'package:flutter/material.dart';

import 'activity_review.dart';
import 'member_management.dart';
import 'reward_management.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoLoop Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.eco, size: 50),
                  SizedBox(height: 10),
                  Text(
                    'EcoLoop Admin',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            ListTile(
              key: const Key('admin-dashboard-menu'),
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () => Navigator.pop(context),
            ),

            ListTile(
              key: const Key('admin-activity-menu'),
              leading: const Icon(Icons.assignment),
              title: const Text('ตรวจสอบกิจกรรม'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ActivityReview()),
                );
              },
            ),

            ListTile(
              key: const Key('admin-rewards-menu'),
              leading: const Icon(Icons.card_giftcard),
              title: const Text('จัดการรางวัล'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RewardManagement()),
                );
              },
            ),

            ListTile(
              key: const Key('admin-members-menu'),
              leading: const Icon(Icons.people),
              title: const Text('จัดการสมาชิก'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MemberManagement()),
                );
              },
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: const [
                  DashboardCard(
                    icon: Icons.people,
                    title: 'สมาชิกทั้งหมด',
                    value: '128 คน',
                  ),

                  DashboardCard(
                    icon: Icons.assignment,
                    title: 'รอตรวจสอบ',
                    value: '12 รายการ',
                  ),

                  DashboardCard(
                    icon: Icons.card_giftcard,
                    title: 'รางวัลทั้งหมด',
                    value: '8 รายการ',
                  ),

                  DashboardCard(
                    icon: Icons.confirmation_number,
                    title: 'แลกรางวัลแล้ว',
                    value: '28 รายการ',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(icon, size: 45),

            const SizedBox(width: 20),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
