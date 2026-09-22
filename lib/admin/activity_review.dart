import 'package:flutter/material.dart';

class ActivityReview extends StatefulWidget {
  const ActivityReview({super.key});

  @override
  State<ActivityReview> createState() => _ActivityReviewState();
}

class _ActivityReviewState extends State<ActivityReview> {
  bool hasPendingActivity = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ตรวจสอบกิจกรรม')),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (hasPendingActivity)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'กิจกรรมรอตรวจสอบ',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text('ผู้ใช้: Pat'),
                    const Text('กิจกรรม: ใช้ถุงผ้า'),
                    const Text('วันที่: 19/09/2026'),

                    const SizedBox(height: 10),

                    const Text(
                      'รายละเอียด: '
                      'ซื้อของที่ Big C และไม่รับถุงพลาสติก',
                    ),

                    const SizedBox(height: 10),

                    const Text('หลักฐาน: รูปใบเสร็จ'),

                    const SizedBox(height: 10),

                    const Text(
                      '+10 Points',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        ElevatedButton.icon(
                          key: const Key('approve-activity'),
                          onPressed: () {
                            setState(() => hasPendingActivity = false);
                          },
                          icon: const Icon(Icons.check),
                          label: const Text('อนุมัติ'),
                        ),

                        const SizedBox(width: 10),

                        ElevatedButton.icon(
                          key: const Key('reject-activity'),
                          onPressed: () {
                            setState(() => hasPendingActivity = false);
                          },
                          icon: const Icon(Icons.close),
                          label: const Text('ไม่อนุมัติ'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.only(top: 48),
              child: Center(
                child: Text(
                  'ไม่มีรายการกิจกรรมรอตรวจสอบ',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
