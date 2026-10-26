import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/law_model.dart';
import '../../theme/app_theme.dart';

class LawDetailScreen extends StatelessWidget {
  final LawModel law;

  const LawDetailScreen({super.key, required this.law});

  @override
  Widget build(BuildContext context) {
    final category = LawCategory.all.firstWhere(
      (c) => c.id == law.category,
      orElse: () => const LawCategory(id: '', nameAr: 'أخرى', icon: '📄'),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل القانون'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: law.content));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم نسخ النص')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              // مشاركة - لاحقاً
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${category.icon} ${category.nameAr}',
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              law.title,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: 22,
                  ),
            ),
            if (law.articleNumber != null) ...[
              const SizedBox(height: 8),
              Text(
                'المادة رقم: ${law.articleNumber}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'الملخص',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              law.summary,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                  ),
            ),
            const SizedBox(height: 24),
            Text(
              'النص الكامل',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Text(
                law.content,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.8,
                    ),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'تنويه: هذا النص استرشادي وقد لا يكون محدثاً. يُرجى الرجوع للمصادر الرسمية أو استشارة محامٍ.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF742A2A),
                      fontSize: 13,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
