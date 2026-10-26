import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class LegalGuideItem {
  final String id;
  final String title;
  final String category;
  final String summary;
  final IconData icon;

  LegalGuideItem({
    required this.id,
    required this.title,
    required this.category,
    required this.summary,
    required this.icon,
  });
}

class LegalGuidesScreen extends StatelessWidget {
  const LegalGuidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final guides = [
      LegalGuideItem(
        id: '1',
        title: 'حقوق المستأجر',
        category: 'عقارات',
        summary: 'تعرف على حقوقك وواجباتك في عقد الإيجار',
        icon: Icons.home,
      ),
      LegalGuideItem(
        id: '2',
        title: 'حقوق العامل',
        category: 'عمالي',
        summary: 'ساعات العمل، الإجازات، مكافأة نهاية الخدمة',
        icon: Icons.work,
      ),
      LegalGuideItem(
        id: '3',
        title: 'الزواج والطلاق',
        category: 'أحوال شخصية',
        summary: 'إجراءات الزواج والطلاق والحضانة',
        icon: Icons.family_restroom,
      ),
      LegalGuideItem(
        id: '4',
        title: 'التوكيل',
        category: 'مدني',
        summary: 'كيفية عمل توكيل رسمي وصحيح',
        icon: Icons.assignment,
      ),
      LegalGuideItem(
        id: '5',
        title: 'الشيكات والكمبيالات',
        category: 'تجاري',
        summary: 'حقوقك عند عدم صرف الشيك',
        icon: Icons.receipt,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('أدلة قانونية')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: guides.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final guide = guides[index];
          return _GuideCard(guide: guide);
        },
      ),
    );
  }
}

class _GuideCard extends StatelessWidget {
  final LegalGuideItem guide;

  const _GuideCard({required this.guide});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('فتح: ${guide.title}')),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(guide.icon, color: AppTheme.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      guide.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      guide.category,
                      style: TextStyle(
                        color: AppTheme.secondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      guide.summary,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
