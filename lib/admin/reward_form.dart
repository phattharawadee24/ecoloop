import 'package:flutter/material.dart';

class RewardForm extends StatefulWidget {
  final Map<String, dynamic>? reward;

  const RewardForm({super.key, this.reward});

  @override
  State<RewardForm> createState() => _RewardFormState();
}

class _RewardFormState extends State<RewardForm> {
  final nameController = TextEditingController();
  final detailController = TextEditingController();
  final pointsController = TextEditingController();
  final quantityController = TextEditingController();

  bool get isEdit => widget.reward != null;

  @override
  void initState() {
    super.initState();

    // ถ้าเป็นการแก้ไข
    // ให้เอาข้อมูลเดิมมาใส่ในช่อง
    if (widget.reward != null) {
      nameController.text = widget.reward!['name'] ?? '';

      detailController.text = widget.reward!['description'] ?? '';

      pointsController.text = widget.reward!['points'].toString();

      quantityController.text = widget.reward!['quantity'].toString();
    }
  }

  void saveReward() {
    final name = nameController.text.trim();
    final description = detailController.text.trim();
    final points = int.tryParse(pointsController.text);
    final quantity = int.tryParse(quantityController.text);

    // ตรวจสอบข้อมูล
    if (name.isEmpty ||
        description.isEmpty ||
        points == null ||
        quantity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
      );

      return;
    }

    // ส่งข้อมูลกลับไปหน้า RewardManagement
    Navigator.pop(context, {
      'name': name,
      'description': description,
      'points': points,
      'quantity': quantity,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'แก้ไขรางวัล' : 'เพิ่มรางวัล')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              isEdit ? 'แก้ไขข้อมูลรางวัล' : 'เพิ่มรางวัลใหม่',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 25),

            // ชื่อรางวัล
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'ชื่อรางวัล',
                hintText: 'เช่น แก้วน้ำ EcoLoop',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.card_giftcard),
              ),
            ),

            const SizedBox(height: 16),

            // รายละเอียด
            TextField(
              controller: detailController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'รายละเอียด',
                hintText: 'รายละเอียดของรางวัล',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
            ),

            const SizedBox(height: 16),

            // Points
            TextField(
              controller: pointsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'ราคา Points',
                hintText: 'เช่น 1000',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.stars),
              ),
            ),

            const SizedBox(height: 16),

            // จำนวน
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'จำนวน',
                hintText: 'เช่น 20',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.inventory_2),
              ),
            ),

            const SizedBox(height: 20),

            // Upload รูป
            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO:
                  // เพิ่มระบบเลือกไฟล์รูปภาพ
                },
                icon: const Icon(Icons.upload),
                label: const Text('Upload รูปภาพ'),
              ),
            ),

            const SizedBox(height: 30),

            // ปุ่มบันทึก
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: saveReward,
                icon: const Icon(Icons.save),
                label: Text(
                  isEdit ? 'บันทึกการแก้ไข' : 'เพิ่มรางวัล',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    detailController.dispose();
    pointsController.dispose();
    quantityController.dispose();

    super.dispose();
  }
}
