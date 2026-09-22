import 'package:flutter/material.dart';

import '../Leaderboard.dart';
import '../My Awerd.dart';
import '../Rewards.dart';
import '../profile.dart';
import '../admin/admin_login.dart';
import 'auth_screen.dart';
import 'history_tab.dart';
import 'home_tab.dart';
import 'log_activity_tab.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.username});

  final String username;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const List<String> _titles = [
    'EcoLoop',
    'บันทึกกิจกรรม',
    'ประวัติกิจกรรม',
    'จัดอันดับ',
    'แลกรางวัล',
    'รางวัลของฉัน',
    'โปรไฟล์',
  ];

  int _userPoints = 0;
  final List<ActivityHistoryItem> _historyItems = [];

  void _go(int index) => setState(() => _index = index);

  List<Widget> _pages() => [
    HomeTab(
      username: widget.username,
      availablePoints: _userPoints,
      historyItems: _historyItems,
      onGoTo: _go,
    ),
    LogActivityTab(onSubmitted: () => _go(2), onActivityAdded: _addHistoryItem),
    HistoryTab(items: _historyItems),
    const LeaderboardPage(),
    const RewardsPage(),
    const MyAwardPage(),
    const ProfilePage(),
  ];

  void _openPage(int index) {
    Navigator.of(context).pop();
    if (index < 3) {
      setState(() => _index = index);
      return;
    }

    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => _pages()[index]));
  }

  void _addHistoryItem(ActivityHistoryItem item) {
    setState(() {
      _historyItems.insert(0, item);
      _userPoints += item.points;
      _index = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    final pages = _pages();

    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: primaryColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.eco_rounded,
                      color: Colors.white,
                      size: 42,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'สวัสดี, ${widget.username}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.admin_panel_settings_outlined),
                title: const Text('เข้าสู่ระบบ Admin'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const AdminLogin()));
                },
              ),
              _drawerItem(0, Icons.home_outlined, 'หน้าแรก'),
              _drawerItem(1, Icons.add_circle_outline, 'บันทึกกิจกรรม'),
              _drawerItem(2, Icons.history_outlined, 'ประวัติกิจกรรม'),
              const Divider(),
              _drawerItem(3, Icons.emoji_events_outlined, 'จัดอันดับ'),
              _drawerItem(4, Icons.card_giftcard_outlined, 'แลกรางวัล'),
              _drawerItem(5, Icons.workspace_premium_outlined, 'รางวัลของฉัน'),
              _drawerItem(6, Icons.person_outline, 'โปรไฟล์'),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 16,
        leading: Builder(
          builder: (context) => IconButton(
            key: const Key('open-main-menu'),
            tooltip: 'เมนูทั้งหมด',
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Icon(Icons.eco_rounded, color: primaryColor, size: 22),
            ),
            const SizedBox(width: 12),
            Text(
              _titles[_index],
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200, width: 1.2),
              ),
              child: IconButton(
                tooltip: 'ออกจากระบบ',
                icon: Icon(
                  Icons.logout_rounded,
                  color: Colors.red.shade700,
                  size: 20,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ออกจากระบบแล้ว')),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const AuthScreen()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _index < 3 ? _index : 0,
          onDestinationSelected: _go,
          indicatorColor: primaryColor.withValues(alpha: 0.18),
          elevation: 0,
          backgroundColor: Colors.transparent,
          destinations: [
            NavigationDestination(
              icon: _framedNavIcon(Icons.home_outlined, false, primaryColor),
              selectedIcon: _framedNavIcon(
                Icons.home_rounded,
                true,
                primaryColor,
              ),
              label: 'หน้าแรก',
            ),
            NavigationDestination(
              icon: _framedNavIcon(
                Icons.add_circle_outline_rounded,
                false,
                primaryColor,
              ),
              selectedIcon: _framedNavIcon(
                Icons.add_circle_rounded,
                true,
                primaryColor,
              ),
              label: 'บันทึก',
            ),
            NavigationDestination(
              icon: _framedNavIcon(Icons.history_outlined, false, primaryColor),
              selectedIcon: _framedNavIcon(
                Icons.history_rounded,
                true,
                primaryColor,
              ),
              label: 'ประวัติ',
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(int index, IconData icon, String label) => ListTile(
    selected: _index == index,
    selectedTileColor: Theme.of(
      context,
    ).colorScheme.primary.withValues(alpha: 0.1),
    leading: Icon(icon),
    title: Text(label),
    onTap: () => _openPage(index),
  );

  Widget _framedNavIcon(IconData iconData, bool isSelected, Color primary) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isSelected
            ? primary.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected
              ? primary.withValues(alpha: 0.4)
              : Colors.transparent,
          width: 1.2,
        ),
      ),
      child: Icon(
        iconData,
        color: isSelected ? primary : const Color(0xFF475569),
      ),
    );
  }
}
