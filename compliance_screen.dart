import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ComplianceItem {
  final String id;
  final String title;
  final String category;
  final String status; // ملتزم، يحتاج مراجعة، متأخر
  final DateTime? dueDate;

  ComplianceItem({
    required this.id,
    required this.title,
    required this.category,
    required this.status,
    this.dueDate,
  });
}

class ComplianceScreen extends StatelessWidget {
  const ComplianceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ComplianceItem(
        id: '1',
        title: 'تجديد السجل التجاري',
        category: 'تراخيص',
        status: 'ملتزم',
        dueDate: DateTime.now().add(const Duration(days: 90)),
      ),
      ComplianceItem(
        id: '2',
        title: 'تقرير الزكاة والضريبة',
        category: 'ضرائب',
        status: 'يحتاج مراجعة',
        dueDate: DateTime.now().add(const Duration(days: 15)),
      ),
      ComplianceItem(
        id: '3',
        title: 'تأمينات الموظفين',
        category: 'موارد بشرية',
        status: 'متأخر',
        dueDate: DateTime.now().subtract(const Duration(days: 5)),
      ),
      ComplianceItem(
        id: '4',
        title: 'عقد إيجار المقر',
        category: 'عقارات',
        status: 'ملتزم',
        dueDate: DateTime.now().add(const Duration(days: 180)),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('الامتثال القانوني')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ملخص الامتثال
          Row(
            children: [
              _ComplianceStat(
                label: 'ملتزم',
                count: items.where((i) => i.status == 'ملتزم').length,
                color: Colors.green,
              ),
              const SizedBox(width: 8),
              _ComplianceStat(
                label: 'يحتاج مراجعة',
                count: items.where((i) => i.status == 'يحتاج مراجعة').length,
                color: Colors.orange,
              ),
              const SizedBox(width: 8),
              _ComplianceStat(
                label: 'متأخر',
                count: items.where((i) => i.status == 'متأخر').length,
                color: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...items.map((item) => _ComplianceCard(item: item)),
        ],
      ),
    );
  }
}

class _ComplianceStat extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _ComplianceStat({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _ComplianceCard extends StatelessWidget {
  final ComplianceItem item;

  const _ComplianceCard({required this.item});

  Color _statusColor() {
    switch (item.status) {
      case 'ملتزم':
        return Colors.green;
      case 'متأخر':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(
          item.status == 'ملتزم' ? Icons.check_circle : Icons.warning,
          color: _statusColor(),
        ),
        title: Text(item.title),
        subtitle: Text('${item.category} • ${item.status}'),
        trailing: item.dueDate != null
            ? Text(
                '${item.dueDate!.day}/${item.dueDate!.month}',
                style: const TextStyle(fontSize: 12),
              )
            : null,
      ),
    );
  }
}
