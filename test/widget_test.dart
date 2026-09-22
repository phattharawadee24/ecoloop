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

  testWidgets('admin can add and edit rewards', (tester) async {
    await tester.pumpWidget(const EcoLoopApp());
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
    await tester.tap(find.byKey(const Key('nav-2')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('add-reward')));
    await tester.pumpAndSettle();
    expect(find.text('เพิ่มรางวัลใหม่'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('edit-reward')).first);
    await tester.pumpAndSettle();
    expect(find.text('แก้ไขข้อมูลรางวัล'), findsOneWidget);
  });

  testWidgets('admin can open member details', (tester) async {
    await tester.pumpWidget(const EcoLoopApp());
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
    await tester.tap(find.byKey(const Key('nav-3')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('member-details-Pat')));
    await tester.pumpAndSettle();
    expect(find.text('รายละเอียดสมาชิก Pat'), findsOneWidget);
    expect(find.text('1,250 Points'), findsOneWidget);
  });
}
