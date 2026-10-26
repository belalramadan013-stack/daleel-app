import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class LegalReminder {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final String type; // عقد، جلسة، موعد

  LegalReminder({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.type,
  });
}

class MyRemindersScreen extends StatelessWidget {
  const MyRemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reminders = [
      LegalReminder(
        id: '1',
        title: 'تجديد عقد الإيجار',
        description: 'عقد إيجار الشقة ينتهي خلال 30 يوم',
        dueDate: DateTime.now().add(const Duration(days: 30)),
        type: 'عقد',
      ),
      LegalReminder(
        id: '2',
        title: 'موعد استشارة',
        description: 'استشارة مع المحامي أحمد العتيبي',
        dueDate: DateTime.now().add(const Duration(days: 3)),
        type: 'موعد',
      ),
      LegalReminder(
        id: '3',
        title: 'انتهاء فترة التجربة',
        description: 'فترة تجربة الموظف تنتهي بعد أسبوع',
        dueDate: DateTime.now().add(const Duration(days: 7)),
        type: 'عقد',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('تذكيراتي القانونية')),
      body: reminders.isEmpty
          ? const Center(child: Text('لا توجد تذكيرات'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: reminders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final reminder = reminders[index];
                return _ReminderCard(reminder: reminder);
              },
            ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  final LegalReminder reminder;

  const _ReminderCard({required this.reminder});

  int get _daysLeft => reminder.dueDate.difference(DateTime.now()).inDays;

  Color get _urgencyColor {
    if (_daysLeft <= 3) return Colors.red;
    if (_daysLeft <= 7) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 50,
              decoration: BoxDecoration(
                color: _urgencyColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reminder.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'بعد $_daysLeft يوم',
                    style: TextStyle(
                      color: _urgencyColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              reminder.type == 'عقد' ? Icons.description : Icons.event,
              color: AppTheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
