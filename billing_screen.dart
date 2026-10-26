import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class InvoiceModel {
  final String id;
  final String clientName;
  final String description;
  final double amount;
  final DateTime date;
  final String status; // مدفوعة، معلقة، متأخرة

  InvoiceModel({
    required this.id,
    required this.clientName,
    required this.description,
    required this.amount,
    required this.date,
    required this.status,
  });
}

class BillingScreen extends StatelessWidget {
  const BillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final invoices = [
      InvoiceModel(
        id: '1',
        clientName: 'محمد أحمد',
        description: 'أتعاب قضية عمالية',
        amount: 5000,
        date: DateTime.now().subtract(const Duration(days: 5)),
        status: 'مدفوعة',
      ),
      InvoiceModel(
        id: '2',
        clientName: 'شركة النور',
        description: 'استشارة قانونية',
        amount: 2500,
        date: DateTime.now().subtract(const Duration(days: 2)),
        status: 'معلقة',
      ),
      InvoiceModel(
        id: '3',
        clientName: 'سارة خالد',
        description: 'إعداد عقد',
        amount: 1500,
        date: DateTime.now().subtract(const Duration(days: 15)),
        status: 'متأخرة',
      ),
    ];

    final totalPaid = invoices
        .where((i) => i.status == 'مدفوعة')
        .fold<double>(0, (sum, i) => sum + i.amount);
    final totalPending = invoices
        .where((i) => i.status != 'مدفوعة')
        .fold<double>(0, (sum, i) => sum + i.amount);

    return Scaffold(
      appBar: AppBar(title: const Text('الفواتير والأتعاب')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ملخص مالي
          Row(
            children: [
              Expanded(
                child: _FinanceCard(
                  title: 'المحصّل',
                  amount: totalPaid,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FinanceCard(
                  title: 'المعلّق',
                  amount: totalPending,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('الفواتير', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ...invoices.map((inv) => _InvoiceTile(invoice: inv)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('إنشاء فاتورة جديدة'),
          ),
        ],
      ),
    );
  }
}

class _FinanceCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;

  const _FinanceCard({
    required this.title,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text(
            '${amount.toInt()} ر.س',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceTile extends StatelessWidget {
  final InvoiceModel invoice;

  const _InvoiceTile({required this.invoice});

  Color _statusColor() {
    switch (invoice.status) {
      case 'مدفوعة':
        return Colors.green;
      case 'متأخرة':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(invoice.description),
        subtitle: Text(invoice.clientName),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${invoice.amount.toInt()} ر.س',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              invoice.status,
              style: TextStyle(
                color: _statusColor(),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
