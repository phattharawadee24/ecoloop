import 'package:flutter/material.dart';

class RewardForm extends StatefulWidget {
  const RewardForm({super.key});

  @override
  State<RewardForm> createState() => _RewardFormState();
}

class _RewardFormState extends State<RewardForm> {
  final nameController = TextEditingController();
  final detailController = TextEditingController();
  final pointsController = TextEditingController();
  final quantityController = TextEditingController();

  void saveReward() {
    print(nameController.text);
    print(detailController.text);
    print(pointsController.text);
    print(quantityController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('บันทึกรางวัลเรียบร้อย'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มรางวัล'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'ชื่อรางวัล',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: detailController,
              decoration: const InputDecoration(
                labelText: 'รายละเอียด',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: pointsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'ราคา Points',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'จำนวน',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            OutlinedButton.icon(
              onPressed: () {
                // TODO: Upload รูป
              },
              icon: const Icon(Icons.upload),
              label: const Text('Upload รูปภาพ'),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: saveReward,
                child: const Text('บันทึก'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}