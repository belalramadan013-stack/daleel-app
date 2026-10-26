import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'cases_management_screen.dart';

class CaseDetailScreen extends StatefulWidget {
  final CaseModel caseModel;
  final Function(CaseModel) onUpdate;

  const CaseDetailScreen({
    super.key,
    required this.caseModel,
    required this.onUpdate,
  });

  @override
  State<CaseDetailScreen> createState() => _CaseDetailScreenState();
}

class _CaseDetailScreenState extends State<CaseDetailScreen> {
  late CaseModel _case;
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _case = widget.caseModel;
    _notesController.text = _case.notes;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _updateStatus(String newStatus) {
    setState(() {
      _case = _case.copyWith(status: newStatus);
    });
    widget.onUpdate(_case);
  }

  void _saveNotes() {
    setState(() {
      _case = _case.copyWith(notes: _notesController.text);
    });
    widget.onUpdate(_case);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ الملاحظات')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_case.caseNumber),
        actions: [
          PopupMenuButton<String>(
            onSelected: _updateStatus,
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'جديدة', child: Text('جديدة')),
              const PopupMenuItem(value: 'جارية', child: Text('جارية')),
              const PopupMenuItem(
                  value: 'انتظار حكم', child: Text('انتظار حكم')),
              const PopupMenuItem(value: 'منتهية', child: Text('منتهية')),
            ],
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.edit),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // العنوان والحالة
          Text(
            _case.title,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _case.status,
              style: const TextStyle(
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // معلومات الموكل
          _InfoSection(
            title: 'بيانات الموكل',
            children: [
              _InfoRow(label: 'الاسم', value: _case.clientName),
              _InfoRow(label: 'الجوال', value: _case.clientPhone.isEmpty ? 'غير محدد' : _case.clientPhone),
            ],
          ),
          const SizedBox(height: 16),

          // معلومات القضية
          _InfoSection(
            title: 'تفاصيل القضية',
            children: [
              _InfoRow(label: 'النوع', value: _case.type),
              _InfoRow(label: 'المحكمة', value: _case.court.isEmpty ? 'غير محددة' : _case.court),
              _InfoRow(
                label: 'تاريخ الإنشاء',
                value: '${_case.createdAt.day}/${_case.createdAt.month}/${_case.createdAt.year}',
              ),
              if (_case.nextHearing != null)
                _InfoRow(
                  label: 'الجلسة القادمة',
                  value:
                      '${_case.nextHearing!.day}/${_case.nextHearing!.month}/${_case.nextHearing!.year}',
                ),
            ],
          ),
          const SizedBox(height: 24),

          // الملاحظات
          Text('الملاحظات', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _notesController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'أضف ملاحظات عن القضية...',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: _saveNotes,
            child: const Text('حفظ الملاحظات'),
          ),
          const SizedBox(height: 24),

          // المستندات
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('المستندات', style: Theme.of(context).textTheme.titleMedium),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('رفع مستند (قريباً)')),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('إضافة'),
              ),
            ],
          ),
          if (_case.documents.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text('لا توجد مستندات مرفقة'),
            )
          else
            ..._case.documents.map(
              (doc) => ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: Text(doc),
                trailing: const Icon(Icons.download),
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
