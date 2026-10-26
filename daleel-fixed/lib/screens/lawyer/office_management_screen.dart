import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class OfficeManagementScreen extends StatelessWidget {
  const OfficeManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة المكتب')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // معلومات المكتب
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('مكتب العتيبي للمحاماة',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                const Text('الرياض - المملكة العربية السعودية'),
                const SizedBox(height: 8),
                const Text('رقم الترخيص: 12345'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // الأقسام
          Text('إدارة الفريق', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          _OfficeTile(
            title: 'المحامون',
            subtitle: '3 محامين',
            icon: Icons.gavel,
            onTap: () {},
          ),
          _OfficeTile(
            title: 'المساعدون القانونيون',
            subtitle: '2 مساعد',
            icon: Icons.support_agent,
            onTap: () {},
          ),
          _OfficeTile(
            title: 'الموظفون الإداريون',
            subtitle: '4 موظفين',
            icon: Icons.people,
            onTap: () {},
          ),

          const SizedBox(height: 24),
          Text('المصروفات', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          _OfficeTile(
            title: 'مصروفات المكتب',
            subtitle: 'إيجار، كهرباء، إنترنت...',
            icon: Icons.account_balance_wallet,
            onTap: () {},
          ),
          _OfficeTile(
            title: 'رواتب الموظفين',
            subtitle: 'إدارة الرواتب',
            icon: Icons.payments,
            onTap: () {},
          ),

          const SizedBox(height: 24),
          Text('الإعدادات', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          _OfficeTile(
            title: 'بيانات المكتب',
            subtitle: 'تعديل المعلومات الأساسية',
            icon: Icons.business,
            onTap: () {},
          ),
          _OfficeTile(
            title: 'الصلاحيات',
            subtitle: 'إدارة صلاحيات الفريق',
            icon: Icons.admin_panel_settings,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _OfficeTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _OfficeTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
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
