import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final DateTime time;
  final bool isRead;
  final String type; // law_update, consultation, system

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false,
    required this.type,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'تحديث قانوني جديد',
      body: 'تم تحديث نظام العمل السعودي - المادة 74',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      type: 'law_update',
    ),
    NotificationItem(
      id: '2',
      title: 'استشارة جديدة',
      body: 'تم الرد على طلب استشارتك من المحامي أحمد العتيبي',
      time: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
      type: 'consultation',
    ),
    NotificationItem(
      id: '3',
      title: 'تذكير',
      body: 'موعد جلسة قضائية غداً الساعة 10 صباحاً',
      time: DateTime.now().subtract(const Duration(days: 1)),
      type: 'system',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (var n in _notifications) {
                  // mark all as read logic
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تعليم الكل كمقروء')),
              );
            },
            child: const Text('تعليم الكل'),
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? const Center(child: Text('لا توجد إشعارات'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final notif = _notifications[index];
                return _NotificationTile(notification: notif);
              },
            ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationItem notification;

  const _NotificationTile({required this.notification});

  IconData _getIcon() {
    switch (notification.type) {
      case 'law_update':
        return Icons.gavel;
      case 'consultation':
        return Icons.chat;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: notification.isRead ? Colors.white : AppTheme.primary.withOpacity(0.05),
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primary.withOpacity(0.1),
          child: Icon(_getIcon(), color: AppTheme.primary, size: 20),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Text(notification.body),
        trailing: Text(
          _formatTime(notification.time),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
        ),
        onTap: () {
          // فتح التفاصيل
        },
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inHours < 1) return 'منذ قليل';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    return 'منذ ${diff.inDays} يوم';
  }
}
