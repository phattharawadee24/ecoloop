import 'package:ecoloop/screens/home_shell.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLogin = true;
  bool _obscure = true;

  String get _resolvedUsername {
    final username = _usernameController.text.trim();
    if (username.isNotEmpty) {
      return username;
    }

    final email = _emailController.text.trim();
    if (email.contains('@')) {
      return email.split('@').first;
    }

    return 'ผู้ใช้';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final username = _resolvedUsername;

      if (_isLogin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeShell(username: username),
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('สมัครสมาชิกสำเร็จ สำหรับ $username'),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeShell(username: username),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: primaryColor.withValues(alpha: 0.2), width: 1.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                primaryColor.withValues(alpha: 0.15),
                                primaryColor.withValues(alpha: 0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: primaryColor.withValues(alpha: 0.4),
                              width: 2.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withValues(alpha: 0.15),
                                blurRadius: 16,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.eco_rounded,
                            size: 54,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'EcoLoop',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF0F172A),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'ทำดีต่อโลก สะสมคะแนน แลกรางวัล',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF475569),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300, width: 1.2),
                        ),
                        child: SegmentedButton<bool>(
                          style: ButtonStyle(
                            side: WidgetStateProperty.all(BorderSide.none),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          segments: const [
                            ButtonSegment(
                              value: true,
                              label: Text(
                                'เข้าสู่ระบบ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              icon: Icon(Icons.login_rounded),
                            ),
                            ButtonSegment(
                              value: false,
                              label: Text(
                                'สมัครสมาชิก',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              icon: Icon(Icons.person_add_rounded),
                            ),
                          ],
                          selected: {_isLogin},
                          onSelectionChanged: (values) {
                            setState(() {
                              _isLogin = values.first;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            if (!_isLogin) ...[
                              TextFormField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  labelText: 'ชื่อผู้ใช้งาน',
                                  prefixIcon: Icon(Icons.person_outline_rounded, color: primaryColor),
                                ),
                                validator: (value) {
                                  final username = (value ?? '').trim();
                                  if (username.isEmpty) {
                                    return 'กรุณากรอกชื่อผู้ใช้งาน';
                                  }
                                  if (username.length < 3) {
                                    return 'ชื่อผู้ใช้งานต้องมีอย่างน้อย 3 ตัวอักษร';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                            ],
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'อีเมล',
                                prefixIcon: Icon(Icons.mail_outline_rounded, color: primaryColor),
                              ),
                              validator: (value) {
                                final email = value?.trim() ?? '';
                                if (email.isEmpty || !email.contains('@')) {
                                  return 'กรุณากรอกอีเมลที่ถูกต้อง';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscure,
                              decoration: InputDecoration(
                                labelText: 'รหัสผ่าน',
                                prefixIcon: Icon(Icons.lock_outline_rounded, color: primaryColor),
                                suffixIcon: IconButton(
                                  onPressed: () => setState(() => _obscure = !_obscure),
                                  icon: Icon(
                                    _obscure
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if ((value ?? '').length < 6) {
                                  return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      FilledButton.icon(
                        onPressed: _submit,
                        icon: Icon(_isLogin ? Icons.arrow_forward_rounded : Icons.check_circle_rounded),
                        label: Text(_isLogin ? 'เข้าสู่ระบบ' : 'สมัครสมาชิก'),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(54),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
