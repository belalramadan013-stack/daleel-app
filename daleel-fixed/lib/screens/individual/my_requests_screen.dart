import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class MyRequest {
  final String id;
  final String title;
  final String type; // استشارة، عقد، قضية
  final String status; // قيد المراجعة، مكتمل، مرفوض
  final DateTime date;

  MyRequest({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    required this.date,
  });
}

class MyRequestsScreen extends StatelessWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final requests = [
      MyRequest(
        id: '1',
        title: 'استشارة عقد إيجار',
        type: 'استشارة',
        status: 'مكتمل',
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),
      MyRequest(
        id: '2',
        title: 'توليد عقد عمل',
        type: 'عقد',
        status: 'قيد المراجعة',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      MyRequest(
        id: '3',
        title: 'استفسار عن حقوق العامل',
        type: 'استشارة',
        status: 'مكتمل',
        date: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('طلباتي')),
      body: requests.isEmpty
          ? const Center(child: Text('لا توجد طلبات بعد'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final req = requests[index];
                return _RequestCard(request: req);
              },
            ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final MyRequest request;

  const _RequestCard({required this.request});

  Color _statusColor() {
    switch (request.status) {
      case 'مكتمل':
        return Colors.green;
      case 'مرفوض':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primary.withOpacity(0.1),
          child: Icon(
            request.type == 'عقد' ? Icons.description : Icons.chat,
            color: AppTheme.primary,
          ),
        ),
        title: Text(request.title),
        subtitle: Text(
          '${request.type} • ${request.date.day}/${request.date.month}/${request.date.year}',
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _statusColor().withOpacity(0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            request.status,
            style: TextStyle(
              color: _statusColor(),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
