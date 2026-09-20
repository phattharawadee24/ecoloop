import 'dart:typed_data';

import 'package:flutter/material.dart';

enum ReviewStatus {
  pending,
  approved,
  rejected;

  String get label {
    switch (this) {
      case ReviewStatus.pending:
        return 'รอตรวจสอบ';
      case ReviewStatus.approved:
        return 'อนุมัติแล้ว';
      case ReviewStatus.rejected:
        return 'ไม่ผ่าน';
    }
  }

  Color get color {
    switch (this) {
      case ReviewStatus.pending:
        return Colors.amber.shade800;
      case ReviewStatus.approved:
        return Colors.green.shade700;
      case ReviewStatus.rejected:
        return Colors.red.shade700;
    }
  }
}

class ActivityHistoryItem {
  const ActivityHistoryItem({
    required this.title,
    required this.status,
    required this.subtitle,
    this.points = 0,
    this.imageUrl,
    this.imagePath,
    this.imageBytes,
  });

  final String title;
  final ReviewStatus status;
  final String subtitle;
  final int points;
  final String? imageUrl;
  final String? imagePath;
  final Uint8List? imageBytes;
}

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key, this.items});

  final List<ActivityHistoryItem>? items;

  static const List<ActivityHistoryItem> defaultItems = [];

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  ReviewStatus? _filter;
  late List<ActivityHistoryItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List<ActivityHistoryItem>.from(
      widget.items ?? HistoryTab.defaultItems,
    );
  }

  @override
  void didUpdateWidget(covariant HistoryTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != null && widget.items != oldWidget.items) {
      _items = List<ActivityHistoryItem>.from(widget.items!);
    }
  }

  void _showImageViewer(BuildContext context, ActivityHistoryItem item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                if (item.imageBytes != null)
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 360),
                    child: Image.memory(
                      item.imageBytes!,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  )
                else if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 360),
                    child: Image.network(
                      item.imageUrl!,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 200,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(
                            Icons.broken_image_rounded,
                            size: 48,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    height: 200,
                    color: Colors.green.shade100,
                    child: Icon(
                      Icons.image_rounded,
                      size: 48,
                      color: Colors.green.shade700,
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton.filledTonal(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Chip(
                        label: Text(
                          item.status.label,
                          style: TextStyle(
                            color: item.status.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        side: BorderSide(
                          color: item.status.color.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  if (item.imageUrl != null && item.imageUrl!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.link_rounded,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.imageUrl!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shown = _filter == null
        ? _items
        : _items.where((item) => item.status == _filter).toList();

    return Column(
      children: [
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _filterChip('ทั้งหมด (${_items.length})', null),
              for (final status in ReviewStatus.values)
                _filterChip(
                  '${status.label} (${_items.where((item) => item.status == status).length})',
                  status,
                ),
            ],
          ),
        ),
        Expanded(
          child: shown.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('ยังไม่มีประวัติกิจกรรม'),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: shown.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (_, index) {
                    final item = shown[index];
                    final Widget attachment;

                    if (item.imageBytes != null) {
                      attachment = Image.memory(
                        item.imageBytes!,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _fallbackAttachment(),
                      );
                    } else if (item.imageUrl != null &&
                        item.imageUrl!.isNotEmpty) {
                      attachment = Image.network(
                        item.imageUrl!,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _fallbackAttachment(),
                      );
                    } else {
                      attachment = _fallbackAttachment();
                    }

                    return Card(
                      child: ListTile(
                        onTap: () => _showImageViewer(context, item),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            width: 64,
                            height: 64,
                            child: attachment,
                          ),
                        ),
                        title: Text(item.title),
                        subtitle: Text(item.subtitle),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Chip(
                              label: Text(
                                item.status.label,
                                style: TextStyle(
                                  color: item.status.color,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              side: BorderSide(
                                color: item.status.color.withValues(alpha: 0.4),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _fallbackAttachment() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFF059669).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF059669).withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: const Icon(Icons.image_rounded, color: Color(0xFF059669)),
    );
  }

  Widget _filterChip(String label, ReviewStatus? value) {
    final isSelected = _filter == value;
    final primary = const Color(0xFF059669);
    return Padding(
      padding: const EdgeInsets.only(right: 8, top: 6, bottom: 6),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        selected: isSelected,
        selectedColor: primary,
        backgroundColor: Colors.white,
        side: BorderSide(
          color: isSelected ? primary : primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
        onSelected: (_) => setState(() => _filter = value),
      ),
    );
  }
}
