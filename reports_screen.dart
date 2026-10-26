import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التقارير والإحصائيات')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ملخص شهري
          Text('ملخص الشهر الحالي', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Row(
            children: [
              _ReportCard(
                title: 'القضايا الجديدة',
                value: '5',
                icon: Icons.folder_open,
                color: Colors.blue,
              ),
              const SizedBox(width: 12),
              _ReportCard(
                title: 'الجلسات',
                value: '12',
                icon: Icons.gavel,
                color: Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _ReportCard(
                title: 'الاستشارات',
                value: '28',
                icon: Icons.chat,
                color: Colors.green,
              ),
              const SizedBox(width: 12),
              _ReportCard(
                title: 'الأتعاب',
                value: '45K',
                icon: Icons.payments,
                color: AppTheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // توزيع القضايا
          Text('توزيع القضايا حسب النوع', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          _DistributionBar(label: 'عمالي', percent: 0.35, color: Colors.blue),
          _DistributionBar(label: 'تجاري', percent: 0.25, color: Colors.green),
          _DistributionBar(label: 'مدني', percent: 0.20, color: Colors.orange),
          _DistributionBar(label: 'أحوال شخصية', percent: 0.15, color: Colors.purple),
          _DistributionBar(label: 'أخرى', percent: 0.05, color: Colors.grey),

          const SizedBox(height: 24),

          // أداء شهري
          Text('الأداء خلال 6 أشهر', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Container(
            height: 120,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('رسم بياني للأداء الشهري\n(قابل للتوسع لاحقاً)'),
            ),
          ),

          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download),
            label: const Text('تصدير التقرير'),
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _ReportCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.titleLarge),
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _DistributionBar extends StatelessWidget {
  final String label;
  final double percent;
  final Color color;

  const _DistributionBar({
    required this.label,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label)),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percent,
                backgroundColor: Colors.grey.withOpacity(0.2),
                color: color,
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text('${(percent * 100).toInt()}%'),
        ],
      ),
    );
  }
}
