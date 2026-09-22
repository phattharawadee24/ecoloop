// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ecoloop/main.dart';

void main() {
  testWidgets('admin can log in and move between pages', (tester) async {
    await tester.pumpWidget(const EcoLoopApp());

    expect(find.text('เข้าสู่ระบบ Admin'), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('admin-email')),
      'admin@ecoloop.test',
    );
    await tester.enterText(
      find.byKey(const Key('admin-password')),
      'secret123',
    );
    await tester.tap(find.byKey(const Key('admin-login')));
    await tester.pumpAndSettle();

    expect(find.text('ภาพรวม'), findsWidgets);
    await tester.tap(find.byKey(const Key('nav-1')));
    await tester.pumpAndSettle();
    expect(find.text('ตรวจสอบกิจกรรม'), findsWidgets);
    expect(find.text('Pat'), findsWidgets);
  });
}
