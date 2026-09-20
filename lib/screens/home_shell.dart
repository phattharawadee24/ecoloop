import 'package:flutter/material.dart';

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
  ];

  int _userPoints = 0;
  final List<ActivityHistoryItem> _historyItems = [];

  void _go(int index) => setState(() => _index = index);

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

    final pages = [
      HomeTab(
        username: widget.username,
        availablePoints: _userPoints,
        historyItems: _historyItems,
        onGoTo: _go,
      ),
      LogActivityTab(
        onSubmitted: () => _go(2),
        onActivityAdded: _addHistoryItem,
      ),
      HistoryTab(items: _historyItems),
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 16,
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
              child: Icon(
                Icons.eco_rounded,
                color: primaryColor,
                size: 22,
              ),
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
                border: Border.all(
                  color: Colors.red.shade200,
                  width: 1.2,
                ),
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
      body: IndexedStack(
        index: _index,
        children: pages,
      ),
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
          selectedIndex: _index,
          onDestinationSelected: _go,
          indicatorColor: primaryColor.withValues(alpha: 0.18),
          elevation: 0,
          backgroundColor: Colors.transparent,
          destinations: [
            NavigationDestination(
              icon: _framedNavIcon(Icons.home_outlined, false, primaryColor),
              selectedIcon: _framedNavIcon(Icons.home_rounded, true, primaryColor),
              label: 'หน้าแรก',
            ),
            NavigationDestination(
              icon: _framedNavIcon(Icons.add_circle_outline_rounded, false, primaryColor),
              selectedIcon: _framedNavIcon(Icons.add_circle_rounded, true, primaryColor),
              label: 'บันทึก',
            ),
            NavigationDestination(
              icon: _framedNavIcon(Icons.history_outlined, false, primaryColor),
              selectedIcon: _framedNavIcon(Icons.history_rounded, true, primaryColor),
              label: 'ประวัติ',
            ),
          ],
        ),
      ),
    );
  }

  Widget _framedNavIcon(IconData iconData, bool isSelected, Color primary) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isSelected ? primary.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? primary.withValues(alpha: 0.4) : Colors.transparent,
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
