import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = 'ผู้ใช้งาน';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),

      appBar: AppBar(
        title: const Text(
          'โปรไฟล์',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // =========================
            // PROFILE CARD
            // =========================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // รูปโปรไฟล์
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: const Color(0xFFE8F5E9),
                        child: ClipOval(
                          child: Image.asset(
                            'images/profile.jpg',
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.green,
                              );
                            },
                          ),
                        ),
                      ),

                      // ปุ่มแก้ไขรูป
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Material(
                          color: Colors.green,
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () {
                              _showImageOptions();
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // ชื่อ
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'ยินดีต้อนรับกลับมา',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),

                  const SizedBox(height: 20),

                  // ปุ่มแก้ไขโปรไฟล์
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showEditNameDialog();
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text(
                        'แก้ไขโปรไฟล์',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // ACCOUNT
            // =========================
            _sectionTitle('บัญชีผู้ใช้'),

            _menuItem(
              icon: Icons.person_outline,
              title: 'ข้อมูลส่วนตัว',
              subtitle: 'ดูและแก้ไขข้อมูลส่วนตัว',
              onTap: () {
                _showMessage('เปิดข้อมูลส่วนตัว');
              },
            ),

            _menuItem(
              icon: Icons.lock_outline,
              title: 'เปลี่ยนรหัสผ่าน',
              subtitle: 'เปลี่ยนรหัสผ่านของคุณ',
              onTap: () {
                _showChangePasswordDialog();
              },
            ),

            _menuItem(
              icon: Icons.notifications_none,
              title: 'การแจ้งเตือน',
              subtitle: 'จัดการการแจ้งเตือน',
              onTap: () {
                _showMessage('เปิดการแจ้งเตือน');
              },
            ),

            const SizedBox(height: 15),

            // =========================
            // OTHER
            // =========================
            _sectionTitle('อื่น ๆ'),

            _menuItem(
              icon: Icons.help_outline,
              title: 'ช่วยเหลือ',
              subtitle: 'คำถามที่พบบ่อยและการช่วยเหลือ',
              onTap: () {
                _showMessage('เปิดหน้าช่วยเหลือ');
              },
            ),

            _menuItem(
              icon: Icons.info_outline,
              title: 'เกี่ยวกับแอป',
              subtitle: 'ข้อมูลเกี่ยวกับแอปพลิเคชัน',
              onTap: () {
                _showAboutDialog();
              },
            ),

            const SizedBox(height: 15),

            // =========================
            // LOGOUT
            // =========================
            _menuItem(
              icon: Icons.logout,
              title: 'ออกจากระบบ',
              subtitle: 'ออกจากบัญชีผู้ใช้งาน',
              iconColor: Colors.red,
              titleColor: Colors.red,
              onTap: () {
                _showLogoutDialog();
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // MENU ITEM
  // =====================================================

  Widget _menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color iconColor = Colors.green,
    Color titleColor = Colors.black87,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      // สำคัญมาก:
      // ใช้ Material แทนการให้ DecoratedBox
      // ครอบ ListTile โดยตรง
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        clipBehavior: Clip.antiAlias,

        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

            child: Row(
              children: [
                // ICON
                Container(
                  width: 45,
                  height: 45,

                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Icon(icon, color: iconColor, size: 24),
                ),

                const SizedBox(width: 15),

                // TEXT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: titleColor,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // ARROW
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =====================================================
  // SECTION TITLE
  // =====================================================

  Widget _sectionTitle(String title) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  // =====================================================
  // EDIT NAME
  // =====================================================

  void _showEditNameDialog() {
    final TextEditingController controller = TextEditingController(
      text: userName,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('แก้ไขชื่อ'),

          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'ชื่อ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('ยกเลิก'),
            ),

            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    userName = controller.text.trim();
                  });
                }

                Navigator.pop(context);
              },
              child: const Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

  // =====================================================
  // CHANGE PASSWORD
  // =====================================================

  void _showChangePasswordDialog() {
    final TextEditingController passwordController = TextEditingController();

    final TextEditingController confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('เปลี่ยนรหัสผ่าน'),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'รหัสผ่านใหม่',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: confirmController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'ยืนยันรหัสผ่าน',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('ยกเลิก'),
            ),

            ElevatedButton(
              onPressed: () {
                if (passwordController.text == confirmController.text) {
                  Navigator.pop(context);

                  _showMessage('เปลี่ยนรหัสผ่านเรียบร้อยแล้ว');
                } else {
                  _showMessage('รหัสผ่านไม่ตรงกัน');
                }
              },
              child: const Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

  // =====================================================
  // IMAGE OPTIONS
  // =====================================================

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),

              const Text(
                'เปลี่ยนรูปโปรไฟล์',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('เลือกรูปจากแกลเลอรี'),
                onTap: () {
                  Navigator.pop(context);

                  _showMessage('เลือกภาพจากแกลเลอรี');
                },
              ),

              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('ถ่ายรูป'),
                onTap: () {
                  Navigator.pop(context);

                  _showMessage('เปิดกล้อง');
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // =====================================================
  // ABOUT
  // =====================================================

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'FollowMe',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.person_pin,
        size: 40,
        color: Colors.green,
      ),
      children: const [Text('แอปพลิเคชันสำหรับจัดการข้อมูลผู้ใช้งาน')],
    );
  }

  // =====================================================
  // LOGOUT
  // =====================================================

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('ออกจากระบบ'),

          content: const Text('คุณต้องการออกจากระบบหรือไม่?'),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('ยกเลิก'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(this.context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('ออกจากระบบ'),
            ),
          ],
        );
      },
    );
  }

  // =====================================================
  // SNACKBAR
  // =====================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
