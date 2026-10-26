import 'package:flutter/material.dart';
import 'clients_management_screen.dart';
import 'billing_screen.dart';
import 'reports_screen.dart';
import 'office_management_screen.dart';

class CaseModel {
  final String id;
  final String title;
  final String clientName;
  final String status;
  final DateTime nextHearing;

  CaseModel({
    required this.id,
    required this.title,
    required this.clientName,
    required this.status,
    required this.nextHearing,
  });
}

class LawyerDashboardScreen extends StatelessWidget {
  const LawyerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cases = [
      CaseModel(
        id: '1',
        title: 'قضية عمالية - فصل تعسفي',
        clientName: 'محمد أحمد',
        status: 'جارية',
        nextHearing: DateTime.now().add(const Duration(days: 5)),
      ),
      CaseModel(
        id: '2',
        title: 'نزاع تجاري',
        clientName: 'شركة النور',
        status: 'انتظار حكم',
        nextHearing: DateTime.now().add(const Duration(days: 12)),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('لوحة المحامي')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // إحصائيات سريعة
          Row(
            children: [
              _StatCard(title: 'القضايا', value: '8', icon: Icons.folder),
              const SizedBox(width: 12),
              _StatCard(title: 'الاستشارات', value: '15', icon: Icons.chat),
              const SizedBox(width: 12),
              _StatCard(title: 'الأرباح', value: '12.5K', icon: Icons.payments),
            ],
          ),
          const SizedBox(height: 24),
          Text('القضايا الحالية', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ...cases.map((c) => _CaseCard(caseModel: c)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const CasesManagementScreen(),
                ),
              );
            },
            icon: const Icon(Icons.folder_open),
            label: const Text('إدارة القضايا الكاملة'),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AppointmentsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.calendar_month),
            label: const Text('إدارة المواعيد الذكية'),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ClientsManagementScreen(),
                ),
              );
            },
            icon: const Icon(Icons.people),
            label: const Text('إدارة العملاء'),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const BillingScreen(),
                ),
              );
            },
            icon: const Icon(Icons.receipt_long),
            label: const Text('الفواتير والأتعاب'),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ReportsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.bar_chart),
            label: const Text('التقارير والإحصائيات'),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const OfficeManagementScreen(),
                ),
              );
            },
            icon: const Icon(Icons.business),
            label: const Text('إدارة المكتب'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primary),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.titleLarge),
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _CaseCard extends StatelessWidget {
  final CaseModel caseModel;

  const _CaseCard({required this.caseModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(caseModel.title),
        subtitle: Text('${caseModel.clientName} • ${caseModel.status}'),
        trailing: Text(
          '${caseModel.nextHearing.day}/${caseModel.nextHearing.month}',
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
