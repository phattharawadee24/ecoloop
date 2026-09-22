import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/image_upload_service.dart';
import 'history_tab.dart';

class LogActivityTab extends StatefulWidget {
  const LogActivityTab({
    super.key,
    required this.onSubmitted,
    this.onActivityAdded,
  });

  final VoidCallback onSubmitted;
  final ValueChanged<ActivityHistoryItem>? onActivityAdded;

  @override
  State<LogActivityTab> createState() => _LogActivityTabState();
}

class _LogActivityTabState extends State<LogActivityTab> {
  final _formKey = GlobalKey<FormState>();
  final _detailController = TextEditingController();
  final _picker = ImagePicker();

  String? _selectedType;
  int _quantity = 1;
  XFile? _selectedImage;
  Uint8List? _selectedImageBytes;
  bool _isUploading = false;

  @override
  void dispose() {
    _detailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Wrap(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: const Icon(
                    Icons.photo_library_rounded,
                    color: Colors.green,
                  ),
                ),
                title: const Text(
                  'เลือกจากคลังรูปภาพ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF059669).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF059669).withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Color(0xFF059669),
                  ),
                ),
                title: const Text(
                  'ถ่ายรูปใหม่',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
            ],
          ),
        ),
      ),
    );

    if (source == null) return;

    final picked = await _picker.pickImage(source: source);
    if (!mounted || picked == null) return;

    final bytes = await picked.readAsBytes();
    if (!mounted) return;

    setState(() {
      _selectedImage = picked;
      _selectedImageBytes = bytes;
    });
  }

  void _clearImage() {
    setState(() {
      _selectedImage = null;
      _selectedImageBytes = null;
    });
  }

  Future<void> _submit() async {
    if (_selectedType == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('กรุณาเลือกกิจกรรมก่อน')));
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    String? uploadedUrl;
    Uint8List? localBytes = _selectedImageBytes;

    if (_selectedImage != null) {
      setState(() {
        _isUploading = true;
      });

      final result = await ImageUploadService.uploadImage(_selectedImage!);

      if (!mounted) return;

      setState(() {
        _isUploading = false;
      });

      if (!result.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'อัปโหลดรูปภาพไม่สำเร็จ: ${result.errorMessage ?? "โปรดลองใหม่"}',
            ),
            backgroundColor: Colors.red.shade700,
          ),
        );
        return;
      }

      uploadedUrl = result.imageUrl;
    }

    final pointsEarned = _quantity * 10;
    final item = ActivityHistoryItem(
      title: _selectedType!,
      status: ReviewStatus.pending,
      points: pointsEarned,
      subtitle:
          '+$pointsEarned คะแนน · $_quantity รายการ · ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
      imageUrl:
          uploadedUrl ??
          'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?auto=format&fit=crop&w=600&q=80',
      imageBytes: localBytes,
    );

    widget.onActivityAdded?.call(item);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          uploadedUrl != null
              ? 'อัปโหลดรูปภาพและบันทึกกิจกรรม $_selectedType แล้ว'
              : 'บันทึกกิจกรรม $_selectedType แล้ว',
        ),
      ),
    );
    widget.onSubmitted();
  }

  @override
  Widget build(BuildContext context) {
    final types = ['แยกขยะ', 'ลดพลาสติก', 'ปลูกต้นไม้', 'ประหยัดไฟ'];
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.touch_app_rounded,
                  color: primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '1. เลือกประเภทกิจกรรม',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Material(
            color: Colors.transparent,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: types.map((type) {
                final selected = _selectedType == type;
                return ChoiceChip(
                  showCheckmark: true,
                  avatar: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: selected
                          ? Colors.white
                          : primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.eco_rounded,
                      size: 14,
                      color: selected ? primaryColor : primaryColor,
                    ),
                  ),
                  label: Text(
                    type,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: selected ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  selected: selected,
                  selectedColor: primaryColor,
                  backgroundColor: Colors.white,
                  elevation: selected ? 2 : 0,
                  side: BorderSide(
                    color: selected
                        ? primaryColor
                        : primaryColor.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  onSelected: _isUploading
                      ? null
                      : (_) => setState(() => _selectedType = type),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.edit_note_rounded,
                  color: primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '2. รายละเอียดกิจกรรม',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'จำนวนชิ้น / ครั้ง',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: IconButton(
                      onPressed: _quantity > 1 && !_isUploading
                          ? () => setState(() => _quantity--)
                          : null,
                      icon: Icon(Icons.remove_rounded, color: primaryColor),
                    ),
                  ),
                  SizedBox(
                    width: 44,
                    child: Text(
                      '$_quantity',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: IconButton(
                      onPressed: _quantity < 20 && !_isUploading
                          ? () => setState(() => _quantity++)
                          : null,
                      icon: Icon(Icons.add_rounded, color: primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _detailController,
            enabled: !_isUploading,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'เล่ารายละเอียดกิจกรรมเพิ่มเติม...',
              alignLabelWithHint: true,
            ),
            validator: (value) {
              if ((value ?? '').trim().length < 5) {
                return 'กรุณาเขียนรายละเอียดอย่างน้อย 5 ตัวอักษร';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.image_outlined,
                  color: primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '3. หลักฐานรูปภาพ',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_selectedImageBytes == null)
            InkWell(
              onTap: _isUploading ? null : _pickImage,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.4),
                    width: 1.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: primaryColor.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        Icons.add_a_photo_rounded,
                        color: primaryColor,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'แนบรูปภาพ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ถ่ายภาพหรือเลือกจากคลังรูปภาพ',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor, width: 2),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Image.memory(
                      _selectedImageBytes!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.red.shade300,
                        width: 1.5,
                      ),
                    ),
                    child: IconButton(
                      onPressed: _isUploading ? null : _clearImage,
                      icon: const Icon(
                        Icons.delete_forever_rounded,
                        color: Colors.red,
                      ),
                      tooltip: 'ยกเลิกรูปภาพ',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _isUploading ? null : _pickImage,
              icon: const Icon(Icons.change_circle_rounded),
              label: const Text('เปลี่ยนรูปภาพใหม่'),
            ),
          ],
          const SizedBox(height: 28),
          FilledButton.icon(
            onPressed: _isUploading ? null : _submit,
            icon: _isUploading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.8,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.send_rounded),
            label: Text(
              _isUploading ? 'กำลังอัปโหลดรูปภาพ...' : 'ส่งกิจกรรมเพื่อตรวจสอบ',
            ),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
              elevation: 4,
            ),
          ),
        ],
      ),
    );
  }
}
