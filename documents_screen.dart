import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class DocumentItem {
  final String id;
  final String name;
  final String category;
  final DateTime uploadedAt;

  DocumentItem({
    required this.id,
    required this.name,
    required this.category,
    required this.uploadedAt,
  });
}

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  // قائمة تجريبية
  final List<DocumentItem> _documents = [
    DocumentItem(
      id: '1',
      name: 'عقد عمل - أحمد',
      category: 'عقد',
      uploadedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    DocumentItem(
      id: '2',
      name: 'هوية وطنية',
      category: 'هوية',
      uploadedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'رفع مستند جديد',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFEBF8FF),
                    child: Icon(Icons.camera_alt, color: AppTheme.secondary),
                  ),
                  title: const Text('الكاميرا'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _addDemoDocument('صورة من الكاميرا');
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFF0FFF4),
                    child: Icon(Icons.photo_library, color: AppTheme.accent),
                  ),
                  title: const Text('المعرض'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _addDemoDocument('صورة من المعرض');
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFAF5FF),
                    child: Icon(Icons.insert_drive_file, color: Color(0xFF805AD5)),
                  ),
                  title: const Text('اختيار ملف'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _addDemoDocument('ملف PDF');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addDemoDocument(String name) {
    setState(() {
      _documents.insert(
        0,
        DocumentItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          category: 'أخرى',
          uploadedAt: DateTime.now(),
        ),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم رفع المستند (نسخة تجريبية)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مستنداتي'),
        automaticallyImplyLeading: false,
      ),
      body: _documents.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open,
                      size: 72, color: AppTheme.textSecondary.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد مستندات بعد',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'اضغط على الزر أدناه لرفع أول مستند',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _documents.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final doc = _documents[index];
                return Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.insert_drive_file,
                          color: AppTheme.primary),
                    ),
                    title: Text(
                      doc.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      '${doc.category} • ${_formatDate(doc.uploadedAt)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'delete') {
                          setState(() => _documents.removeAt(index));
                        }
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          value: 'view',
                          child: Text('عرض'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('حذف', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showUploadOptions,
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.upload_file),
        label: const Text('رفع مستند'),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
