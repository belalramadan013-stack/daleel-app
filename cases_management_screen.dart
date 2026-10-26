import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class CaseModel {
  final String id;
  final String title;
  final String caseNumber;
  final String clientName;
  final String clientPhone;
  final String type; // عمالي، تجاري، مدني، جنائي
  final String status; // جديدة، جارية، انتظار حكم، منتهية
  final String court;
  final DateTime createdAt;
  final DateTime? nextHearing;
  final String notes;
  final List<String> documents;

  CaseModel({
    required this.id,
    required this.title,
    required this.caseNumber,
    required this.clientName,
    required this.clientPhone,
    required this.type,
    required this.status,
    required this.court,
    required this.createdAt,
    this.nextHearing,
    this.notes = '',
    this.documents = const [],
  });

  CaseModel copyWith({
    String? title,
    String? status,
    DateTime? nextHearing,
    String? notes,
  }) {
    return CaseModel(
      id: id,
      title: title ?? this.title,
      caseNumber: caseNumber,
      clientName: clientName,
      clientPhone: clientPhone,
      type: type,
      status: status ?? this.status,
      court: court,
      createdAt: createdAt,
      nextHearing: nextHearing ?? this.nextHearing,
      notes: notes ?? this.notes,
      documents: documents,
    );
  }
}

class CasesManagementScreen extends StatefulWidget {
  const CasesManagementScreen({super.key});

  @override
  State<CasesManagementScreen> createState() => _CasesManagementScreenState();
}

class _CasesManagementScreenState extends State<CasesManagementScreen> {
  final List<CaseModel> _cases = [
    CaseModel(
      id: '1',
      title: 'قضية فصل تعسفي',
      caseNumber: '1445/1234',
      clientName: 'محمد أحمد',
      clientPhone: '0501234567',
      type: 'عمالي',
      status: 'جارية',
      court: 'المحكمة العمالية - الرياض',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      nextHearing: DateTime.now().add(const Duration(days: 5)),
      notes: 'الموكل يطلب تعويض عن الفصل التعسفي.',
    ),
    CaseModel(
      id: '2',
      title: 'نزاع عقد توريد',
      caseNumber: '1445/5678',
      clientName: 'شركة النور للتجارة',
      clientPhone: '0112345678',
      type: 'تجاري',
      status: 'انتظار حكم',
      court: 'المحكمة التجارية - جدة',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      nextHearing: DateTime.now().add(const Duration(days: 15)),
    ),
    CaseModel(
      id: '3',
      title: 'دعوى مطالبة مالية',
      caseNumber: '1444/9012',
      clientName: 'خالد سعيد',
      clientPhone: '0559876543',
      type: 'مدني',
      status: 'منتهية',
      court: 'المحكمة العامة - الدمام',
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
    ),
  ];

  String? _statusFilter;

  List<CaseModel> get _filteredCases {
    if (_statusFilter == null) return _cases;
    return _cases.where((c) => c.status == _statusFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة القضايا'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddCaseDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // فلاتر الحالة
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _FilterChip(
                  label: 'الكل (${_cases.length})',
                  selected: _statusFilter == null,
                  onTap: () => setState(() => _statusFilter = null),
                ),
                ...['جديدة', 'جارية', 'انتظار حكم', 'منتهية'].map((s) {
                  final count = _cases.where((c) => c.status == s).length;
                  return _FilterChip(
                    label: '$s ($count)',
                    selected: _statusFilter == s,
                    onTap: () => setState(() => _statusFilter = s),
                  );
                }),
              ],
            ),
          ),
          Expanded(
            child: _filteredCases.isEmpty
                ? const Center(child: Text('لا توجد قضايا'))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredCases.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final caseModel = _filteredCases[index];
                      return _CaseListTile(
                        caseModel: caseModel,
                        onTap: () => _openCaseDetails(caseModel),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _openCaseDetails(CaseModel caseModel) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CaseDetailScreen(
          caseModel: caseModel,
          onUpdate: (updated) {
            setState(() {
              final idx = _cases.indexWhere((c) => c.id == updated.id);
              if (idx != -1) _cases[idx] = updated;
            });
          },
        ),
      ),
    );
  }

  void _showAddCaseDialog() {
    final titleController = TextEditingController();
    final clientController = TextEditingController();
    String selectedType = 'عمالي';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('قضية جديدة'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'عنوان القضية'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: clientController,
                decoration: const InputDecoration(labelText: 'اسم الموكل'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(labelText: 'نوع القضية'),
                items: ['عمالي', 'تجاري', 'مدني', 'جنائي', 'أحوال شخصية']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => selectedType = v ?? selectedType,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  clientController.text.isNotEmpty) {
                setState(() {
                  _cases.insert(
                    0,
                    CaseModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text,
                      caseNumber: 'جديد',
                      clientName: clientController.text,
                      clientPhone: '',
                      type: selectedType,
                      status: 'جديدة',
                      court: '',
                      createdAt: DateTime.now(),
                    ),
                  );
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: AppTheme.primary.withOpacity(0.15),
        checkmarkColor: AppTheme.primary,
      ),
    );
  }
}

class _CaseListTile extends StatelessWidget {
  final CaseModel caseModel;
  final VoidCallback onTap;

  const _CaseListTile({required this.caseModel, required this.onTap});

  Color _statusColor() {
    switch (caseModel.status) {
      case 'جارية':
        return Colors.blue;
      case 'انتظار حكم':
        return Colors.orange;
      case 'منتهية':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      caseModel.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor().withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      caseModel.status,
                      style: TextStyle(
                        color: _statusColor(),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${caseModel.clientName} • ${caseModel.type}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (caseModel.nextHearing != null) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.event, size: 16, color: AppTheme.secondary),
                    const SizedBox(width: 4),
                    Text(
                      'الجلسة القادمة: ${caseModel.nextHearing!.day}/${caseModel.nextHearing!.month}/${caseModel.nextHearing!.year}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
