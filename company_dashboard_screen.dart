import 'package:flutter/material.dart';
import 'compliance_screen.dart';
import 'employee_contracts_screen.dart';

class CompanyDashboardScreen extends StatelessWidget {
  const CompanyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة الشركة')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // إحصائيات الشركة
          Row(
            children: [
              _CompanyStat(title: 'العقود', value: '24', icon: Icons.description),
              const SizedBox(width: 12),
              _CompanyStat(title: 'الموظفين', value: '45', icon: Icons.people),
              const SizedBox(width: 12),
              _CompanyStat(title: 'التنبيهات', value: '3', icon: Icons.warning),
            ],
          ),
          const SizedBox(height: 24),

          // الأقسام
          _SectionCard(
            title: 'الامتثال القانوني',
            subtitle: 'متابعة الالتزامات والأنظمة',
            icon: Icons.verified,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ComplianceScreen()),
              );
            },
          ),
          _SectionCard(
            title: 'عقود الموظفين',
            subtitle: 'إدارة عقود العمل والتجديد',
            icon: Icons.work,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => const EmployeeContractsScreen()),
              );
            },
          ),
          _SectionCard(
            title: 'المستندات الرسمية',
            subtitle: 'السجل التجاري والتراخيص',
            icon: Icons.folder_special,
            onTap: () {},
          ),
          _SectionCard(
            title: 'الفريق القانوني',
            subtitle: 'إضافة مستخدمين من الشركة',
            icon: Icons.group_add,
            onTap: () {},
          ),

          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.upload_file),
            label: const Text('رفع مستند شركة'),
          ),
        ],
      ),
    );
  }
}

class _CompanyStat extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _CompanyStat({required this.title, required this.value, required this.icon});

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

class _SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primary.withOpacity(0.1),
          child: Icon(icon, color: AppTheme.primary),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
