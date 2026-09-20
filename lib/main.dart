import 'package:flutter/material.dart';

import 'screens/auth_screen.dart';
import 'package:ecoloop/theme/app_theme.dart';

void main() {
  runApp(const EcoLoopApp());
}

class EcoLoopApp extends StatelessWidget {
  const EcoLoopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoLoop',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AuthScreen(),
    );
  }
}
