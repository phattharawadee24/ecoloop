import 'package:flutter/material.dart';

void main() => runApp(const EcoLoopApp());

class EcoLoopApp extends StatelessWidget {
  const EcoLoopApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'EcoLoop Admin',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff2d6a4f)),
      scaffoldBackgroundColor: const Color(0xfff7f9f5),
      useMaterial3: true,
    ),
    home: const AdminApp(),
  );
}

class AdminApp extends StatefulWidget {
  const AdminApp({super.key});
  @override
  State<AdminApp> createState() => _AdminAppState();
}

class _AdminAppState extends State<AdminApp> {
  bool loggedIn = false;
  int page = 0;
  static const titles = ['ภาพรวม', 'ตรวจสอบกิจกรรม', 'จัดการรางวัล', 'สมาชิก'];
  static const icons = [
    Icons.dashboard_outlined,
    Icons.fact_check_outlined,
    Icons.card_giftcard_outlined,
    Icons.people_outline,
  ];

  @override
  Widget build(BuildContext context) {
    if (!loggedIn)
      return LoginPage(onLogin: () => setState(() => loggedIn = true));
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            selected: page,
            onSelected: (value) => setState(() => page = value),
          ),
          Expanded(
            child: AdminPage(title: titles[page], page: page),
          ),
        ],
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onLogin});
  final VoidCallback onLogin;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  bool hidePassword = true;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Brand(),
                const SizedBox(height: 28),
                const Text(
                  'เข้าสู่ระบบ Admin',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff183b2c),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'สำหรับเจ้าของระบบและผู้ดูแลเท่านั้น',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  key: const Key('admin-email'),
                  decoration: const InputDecoration(
                    labelText: 'อีเมล',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) => value == null || !value.contains('@')
                      ? 'กรุณากรอกอีเมลที่ถูกต้อง'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('admin-password'),
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                    labelText: 'รหัสผ่าน',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => hidePassword = !hidePassword),
                      icon: Icon(
                        hidePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                  validator: (value) => value == null || value.length < 6
                      ? 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร'
                      : null,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  key: const Key('admin-login'),
                  onPressed: () {
                    if (formKey.currentState!.validate()) widget.onLogin();
                  },
                  icon: const Icon(Icons.login),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 13),
                    child: Text('เข้าสู่ระบบ'),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'การเข้าถึงหน้านี้จำกัดสำหรับผู้ดูแลระบบ',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class Brand extends StatelessWidget {
  const Brand({super.key});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: const Color(0xffd8f3dc),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.eco, color: Color(0xff2d6a4f), size: 28),
      ),
      const SizedBox(width: 12),
      const Text(
        'EcoLoop',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: Color(0xff183b2c),
        ),
      ),
    ],
  );
}

class Sidebar extends StatelessWidget {
  const Sidebar({super.key, required this.selected, required this.onSelected});
  final int selected;
  final ValueChanged<int> onSelected;
  @override
  Widget build(BuildContext context) => Container(
    width: MediaQuery.sizeOf(context).width < 700 ? 76 : 250,
    padding: const EdgeInsets.fromLTRB(16, 28, 16, 20),
    color: const Color(0xff183b2c),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (MediaQuery.sizeOf(context).width >= 700) const Brand(),
        const SizedBox(height: 44),
        if (MediaQuery.sizeOf(context).width >= 700)
          const Text(
            'ADMIN CONSOLE',
            style: TextStyle(
              color: Color(0xffb7d9c3),
              fontSize: 11,
              letterSpacing: 1.1,
            ),
          ),
        const SizedBox(height: 12),
        ...List.generate(
          _AdminAppState.titles.length,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Material(
              color: Colors.transparent,
              child: ListTile(
                key: Key('nav-$index'),
                onTap: () => onSelected(index),
                selected: selected == index,
                selectedTileColor: const Color(0xff2d6a4f),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                leading: Icon(
                  _AdminAppState.icons[index],
                  color: selected == index
                      ? Colors.white
                      : const Color(0xffb7d9c3),
                ),
                title: MediaQuery.sizeOf(context).width >= 700
                    ? Text(
                        _AdminAppState.titles[index],
                        style: TextStyle(
                          color: selected == index
                              ? Colors.white
                              : const Color(0xffd8f3dc),
                          fontWeight: selected == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ),
        const Spacer(),
        const Divider(color: Color(0xff39604d)),
        if (MediaQuery.sizeOf(context).width >= 700)
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: Color(0xffffc857),
              child: Text('A'),
            ),
            title: Text(
              'ผู้ดูแลระบบ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Administrator',
              style: TextStyle(color: Color(0xffb7d9c3), fontSize: 12),
            ),
          ),
      ],
    ),
  );
}

class AdminPage extends StatelessWidget {
  const AdminPage({super.key, required this.title, required this.page});
  final String title;
  final int page;
  @override
  Widget build(BuildContext context) => SafeArea(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'สวัสดี, ผู้ดูแลระบบ',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: Color(0xff183b2c),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none),
              ),
              const CircleAvatar(
                backgroundColor: Color(0xffffc857),
                child: Text('A'),
              ),
            ],
          ),
          const SizedBox(height: 28),
          if (page == 0)
            const DashboardView()
          else if (page == 1)
            const ActivityView()
          else if (page == 2)
            const RewardsView()
          else
            const MembersView(),
        ],
      ),
    ),
  );
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: constraints.maxWidth < 700 ? 1 : 4,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: constraints.maxWidth < 700 ? 4.2 : 1.5,
          children: const [
            StatCard('สมาชิกทั้งหมด', '128', 'คน', Icons.people_outline),
            StatCard('รอตรวจสอบ', '12', 'รายการ', Icons.fact_check_outlined),
            StatCard(
              'รางวัลทั้งหมด',
              '8',
              'รายการ',
              Icons.card_giftcard_outlined,
            ),
            StatCard(
              'แลกรางวัลแล้ว',
              '28',
              'รายการ',
              Icons.confirmation_number_outlined,
            ),
          ],
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            const Expanded(
              child: Text(
                'กิจกรรมรอตรวจสอบ',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(onPressed: () {}, child: const Text('ดูทั้งหมด')),
          ],
        ),
        const ActivityCard(),
      ],
    ),
  );
}

class StatCard extends StatelessWidget {
  const StatCard(this.label, this.value, this.unit, this.icon, {super.key});
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: cardDecoration,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ),
            Icon(icon, color: const Color(0xff2d6a4f)),
          ],
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff183b2c),
                ),
              ),
              TextSpan(
                text: ' $unit',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class ActivityView extends StatelessWidget {
  const ActivityView({super.key});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'ผู้ใช้ส่งกิจกรรมมาให้ Admin ตรวจสอบ',
        style: TextStyle(color: Colors.grey),
      ),
      const SizedBox(height: 16),
      const ActivityCard(),
      const SizedBox(height: 12),
      const ActivityCard(),
    ],
  );
}

class ActivityCard extends StatefulWidget {
  const ActivityCard({super.key});
  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  String status = 'รอตรวจสอบ';
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: cardDecoration,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xfffff1d6),
              child: Icon(
                Icons.shopping_bag_outlined,
                color: Color(0xffc27c0e),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pat', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    'ใช้ถุงผ้า  •  19/09/2026',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              status,
              style: TextStyle(
                color: status == 'อนุมัติแล้ว' ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Divider(height: 28),
        const Text('ซื้อของที่ Big C และไม่รับถุงพลาสติก'),
        const SizedBox(height: 12),
        const Row(
          children: [
            Icon(Icons.image_outlined, size: 18, color: Color(0xff2d6a4f)),
            SizedBox(width: 6),
            Text(
              'รูปใบเสร็จ',
              style: TextStyle(
                color: Color(0xff2d6a4f),
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Text(
              '+10 Points',
              style: TextStyle(
                color: Color(0xff2d6a4f),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton.icon(
              onPressed: status == 'รอตรวจสอบ'
                  ? () => setState(() => status = 'ไม่อนุมัติ')
                  : null,
              icon: const Icon(Icons.close, size: 16),
              label: const Text('ไม่อนุมัติ'),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: status == 'รอตรวจสอบ'
                  ? () => setState(() => status = 'อนุมัติแล้ว')
                  : null,
              icon: const Icon(Icons.check, size: 16),
              label: const Text('อนุมัติ'),
            ),
          ],
        ),
      ],
    ),
  );
}

class RewardsView extends StatelessWidget {
  const RewardsView({super.key});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          const Expanded(
            child: Text(
              'เพิ่มและแก้ไขของรางวัลสำหรับสมาชิก',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          FilledButton.icon(
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => const RewardDialog(),
            ),
            icon: const Icon(Icons.add),
            label: const Text('เพิ่มรางวัล'),
          ),
        ],
      ),
      const SizedBox(height: 16),
      const RewardTile(name: 'แก้วน้ำ EcoLoop', points: '1,000', stock: '20'),
      const SizedBox(height: 12),
      const RewardTile(name: 'ถุงผ้า EcoLoop', points: '500', stock: '50'),
    ],
  );
}

class RewardTile extends StatelessWidget {
  const RewardTile({
    super.key,
    required this.name,
    required this.points,
    required this.stock,
  });
  final String name;
  final String points;
  final String stock;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: cardDecoration,
    child: Row(
      children: [
        const Icon(Icons.card_giftcard, size: 34, color: Color(0xff2d6a4f)),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          '$points Points\nเหลือ $stock ชิ้น',
          textAlign: TextAlign.right,
          style: const TextStyle(
            color: Color(0xff2d6a4f),
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.edit_outlined)),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
        ),
      ],
    ),
  );
}

class RewardDialog extends StatelessWidget {
  const RewardDialog({super.key});
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('เพิ่มรางวัล'),
    content: const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(decoration: InputDecoration(labelText: 'ชื่อรางวัล')),
        TextField(decoration: InputDecoration(labelText: 'รายละเอียด')),
        TextField(decoration: InputDecoration(labelText: 'ราคา Points')),
        TextField(decoration: InputDecoration(labelText: 'จำนวน')),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('ยกเลิก'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('บันทึก'),
      ),
    ],
  );
}

class MembersView extends StatelessWidget {
  const MembersView({super.key});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('รายชื่อสมาชิกในระบบ', style: TextStyle(color: Colors.grey)),
      const SizedBox(height: 16),
      Container(
        decoration: cardDecoration,
        child: const Column(
          children: [
            MemberTile(name: 'Pat', points: '1,250', activities: '32'),
            Divider(height: 1),
            MemberTile(name: 'Jane', points: '2,100', activities: '45'),
            Divider(height: 1),
            MemberTile(name: 'Mint', points: '2,450', activities: '52'),
          ],
        ),
      ),
    ],
  );
}

class MemberTile extends StatelessWidget {
  const MemberTile({
    super.key,
    required this.name,
    required this.points,
    required this.activities,
  });
  final String name;
  final String points;
  final String activities;
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    leading: CircleAvatar(
      backgroundColor: const Color(0xffd8f3dc),
      child: Text(name[0]),
    ),
    title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
    subtitle: Text('$activities กิจกรรม'),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$points Points',
          style: const TextStyle(
            color: Color(0xff2d6a4f),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 16),
        OutlinedButton(onPressed: () {}, child: const Text('ดูรายละเอียด')),
      ],
    ),
  );
}

const cardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(Radius.circular(16)),
  border: Border.fromBorderSide(BorderSide(color: Color(0xffe5ece6))),
);
