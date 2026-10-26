import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';
import 'contract_form_screen.dart';

class ContractsScreen extends StatelessWidget {
  const ContractsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('توليد العقود'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'اختر نوع العقد',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'سيتم توجيهك لتعبئة البيانات ثم معاينة وتحميل العقد',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ...AppConstants.contractTypes.map((type) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ContractTypeCard(
                title: type['name']!,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ContractFormScreen(
                        contractTypeId: type['id']!,
                        contractTypeName: type['name']!,
                      ),
                    ),
                  );
                },
              ),
            );
          }),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFF6E05E)),
            ),
            child: Text(
              'العقود المُولَّدة نماذج استرشادية. يُفضل مراجعتها من محامٍ قبل التوقيع.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF744210),
                    fontSize: 13,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContractTypeCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _ContractTypeCard({required this.title, required this.onTap});

  IconData _getIcon(String title) {
    if (title.contains('عمل')) return Icons.work_outline;
    if (title.contains('إيجار')) return Icons.home_outlined;
    if (title.contains('توكيل')) return Icons.assignment_ind_outlined;
    if (title.contains('بيع')) return Icons.shopping_cart_outlined;
    if (title.contains('إفشاء')) return Icons.security_outlined;
    return Icons.description_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_getIcon(title), color: AppTheme.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
