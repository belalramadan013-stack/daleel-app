import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ClientModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String type; // فرد، شركة
  final int activeCases;
  final double totalFees;

  ClientModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.type,
    this.activeCases = 0,
    this.totalFees = 0,
  });
}

class ClientsManagementScreen extends StatefulWidget {
  const ClientsManagementScreen({super.key});

  @override
  State<ClientsManagementScreen> createState() => _ClientsManagementScreenState();
}

class _ClientsManagementScreenState extends State<ClientsManagementScreen> {
  final List<ClientModel> _clients = [
    ClientModel(
      id: '1',
      name: 'محمد أحمد العتيبي',
      phone: '0501234567',
      email: 'mohamed@example.com',
      type: 'فرد',
      activeCases: 2,
      totalFees: 8500,
    ),
    ClientModel(
      id: '2',
      name: 'شركة النور للتجارة',
      phone: '0112345678',
      email: 'info@alnoor.com',
      type: 'شركة',
      activeCases: 1,
      totalFees: 25000,
    ),
    ClientModel(
      id: '3',
      name: 'سارة خالد',
      phone: '0559876543',
      email: 'sara@example.com',
      type: 'فرد',
      activeCases: 1,
      totalFees: 3200,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة العملاء'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: _showAddClient,
          ),
        ],
      ),
      body: Column(
        children: [
          // إحصائيات سريعة
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _Stat(label: 'العملاء', value: '${_clients.length}'),
                _Stat(
                  label: 'القضايا النشطة',
                  value: '${_clients.fold<int>(0, (sum, c) => sum + c.activeCases)}',
                ),
                _Stat(
                  label: 'إجمالي الأتعاب',
                  value: '${_clients.fold<double>(0, (sum, c) => sum + c.totalFees).toInt()} ر.س',
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _clients.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final client = _clients[index];
                return _ClientCard(client: client);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddClient() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('عميل جديد'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'الاسم'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'الجوال'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  _clients.insert(
                    0,
                    ClientModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameController.text,
                      phone: phoneController.text,
                      email: '',
                      type: 'فرد',
                    ),
                  );
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;

  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleLarge),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _ClientCard extends StatelessWidget {
  final ClientModel client;

  const _ClientCard({required this.client});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primary.withOpacity(0.1),
          child: Text(
            client.name[0],
            style: const TextStyle(
              color: AppTheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(client.name),
        subtitle: Text('${client.phone} • ${client.type}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${client.activeCases} قضية',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              '${client.totalFees.toInt()} ر.س',
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}
