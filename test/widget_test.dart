// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:ecoloop/screens/history_tab.dart';
import 'package:ecoloop/screens/log_activity_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ecoloop/main.dart';

void main() {
  testWidgets('EcoLoop app loads the login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const EcoLoopApp());

    expect(find.text('EcoLoop'), findsOneWidget);
    expect(find.text('เข้าสู่ระบบ'), findsOneWidget);
    expect(find.text('สมัครสมาชิก'), findsOneWidget);
  });

  testWidgets('Sign-up form shows username field and home screen uses the real username',
      (WidgetTester tester) async {
    await tester.pumpWidget(const EcoLoopApp());

    await tester.tap(find.text('สมัครสมาชิก'));
    await tester.pumpAndSettle();

    expect(find.text('ชื่อผู้ใช้งาน'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'earthlover');
    await tester.enterText(find.byType(TextFormField).at(1), 'earthlover@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), '123456');
    await tester.tap(find.text('สมัครสมาชิก'));
    await tester.pumpAndSettle();

    expect(find.text('สวัสดี, earthlover'), findsOneWidget);
  });

  testWidgets('History items show an attachment image thumbnail',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HistoryTab()));

    expect(find.byType(Image), findsWidgets);
  });

  testWidgets('Activity form includes a real photo attachment button',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: LogActivityTab(onSubmitted: () {})),
    );

    expect(find.text('แนบรูปภาพ'), findsOneWidget);
  });
}
