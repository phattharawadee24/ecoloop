// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:ecoloop/screens/history_tab.dart';
import 'package:ecoloop/screens/log_activity_tab.dart';
import 'package:ecoloop/screens/home_shell.dart';
import 'package:ecoloop/admin/admin_dashboard.dart';
import 'package:ecoloop/admin/activity_review.dart';
import 'package:ecoloop/admin/reward_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ecoloop/main.dart';

void main() {
  testWidgets('EcoLoop app loads the login screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EcoLoopApp());

    expect(find.text('EcoLoop'), findsWidgets);
    expect(find.text('เข้าสู่ระบบ'), findsWidgets);
    expect(find.text('สมัครสมาชิก'), findsOneWidget);
  });

  testWidgets(
    'Sign-up form shows username field and home screen uses the real username',
    (WidgetTester tester) async {
      await tester.pumpWidget(const EcoLoopApp());

      await tester.tap(find.text('สมัครสมาชิก').last);
      await tester.pumpAndSettle();

      expect(find.text('ชื่อผู้ใช้งาน'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField).at(0), 'earthlover');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'earthlover@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(2), '123456');
      final submitIcon = find.byIcon(Icons.check_circle_rounded);
      await tester.ensureVisible(submitIcon);
      await tester.tap(submitIcon);
      await tester.pumpAndSettle();

      expect(find.textContaining('earthlover'), findsWidgets);
    },
  );

  testWidgets('History screen renders with no submitted activities', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: HistoryTab())),
    );

    expect(find.byType(Image), findsNothing);
  });

  testWidgets('Activity form includes a real photo attachment button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: LogActivityTab(onSubmitted: () {})),
      ),
    );

    expect(find.text('แนบรูปภาพ'), findsOneWidget);
  });

  testWidgets('main menu connects to rewards and admin login', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeShell(key: UniqueKey(), username: 'Pat'),
      ),
    );

    await tester.tap(find.byKey(const Key('open-main-menu')));
    await tester.pumpAndSettle();
    expect(find.text('แลกรางวัล'), findsOneWidget);
    await tester.tap(find.text('แลกรางวัล'));
    await tester.pumpAndSettle();
    expect(find.text('Rewards'), findsOneWidget);
  });

  testWidgets('main menu opens admin login', (tester) async {
    await tester.pumpWidget(MaterialApp(home: HomeShell(username: 'Pat')));
    await tester.tap(find.byKey(const Key('open-main-menu')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('เข้าสู่ระบบ Admin'));
    await tester.pumpAndSettle();
    expect(find.text('EcoLoop Admin'), findsOneWidget);
  });

  testWidgets('admin menu opens all management pages', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AdminDashboard()));

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('admin-activity-menu')));
    await tester.pumpAndSettle();
    expect(find.text('ตรวจสอบกิจกรรม'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('admin-rewards-menu')));
    await tester.pumpAndSettle();
    expect(find.text('จัดการรางวัล'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('admin-members-menu')));
    await tester.pumpAndSettle();
    expect(find.text('จัดการสมาชิก'), findsOneWidget);
  });

  testWidgets('approving or rejecting an activity removes it', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: ActivityReview(key: UniqueKey())),
    );

    expect(find.text('กิจกรรมรอตรวจสอบ'), findsOneWidget);
    await tester.tap(find.byKey(const Key('approve-activity')));
    await tester.pumpAndSettle();
    expect(find.text('ไม่มีรายการกิจกรรมรอตรวจสอบ'), findsOneWidget);
    expect(find.text('ผู้ใช้: Pat'), findsNothing);

    await tester.pumpWidget(const MaterialApp(home: ActivityReview()));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('reject-activity')));
    await tester.pumpAndSettle();
    expect(find.text('ไม่มีรายการกิจกรรมรอตรวจสอบ'), findsOneWidget);
  });

  testWidgets('admin can add a reward', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RewardManagement()));
    await tester.tap(find.byKey(const Key('add-admin-reward-button')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'กล่องข้าว EcoLoop');
    await tester.enterText(find.byType(TextField).at(1), 'กล่องรักษ์โลก');
    await tester.enterText(find.byType(TextField).at(2), '750');
    await tester.enterText(find.byType(TextField).at(3), '15');
    await tester.tap(find.byKey(const Key('save-reward')));
    await tester.pumpAndSettle();

    expect(find.text('กล่องข้าว EcoLoop'), findsOneWidget);
    expect(find.textContaining('750 Points'), findsOneWidget);
  });
}
