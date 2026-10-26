import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class EmployeeContract {
  final String id;
  final String employeeName;
  final String position;
  final String contractType; // محدد المدة، غير محدد
  final DateTime startDate;
  final DateTime? endDate;
  final String status; // ساري، منتهي، قيد التجديد

  EmployeeContract({
    required this.id,
    required this.employeeName,
    required this.position,
    required this.contractType,
    required this.startDate,
    this.endDate,
    required this.status,
  });
}

class EmployeeContractsScreen extends StatelessWidget {
  const EmployeeContractsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contracts = [
      EmployeeContract(
        id: '1',
        employeeName: 'أحمد محمد',
        position: 'مدير مالي',
        contractType: 'غير محدد المدة',
        startDate: DateTime(2022, 3, 1),
        status: 'ساري',
      ),
      EmployeeContract(
        id: '2',
        employeeName: 'فاطمة علي',
        position: 'محاسبة',
        contractType: 'محدد المدة',
        startDate: DateTime(2024, 1, 15),
        endDate: DateTime(2025, 1, 14),
        status: 'قيد التجديد',
      ),
      EmployeeContract(
        id: '3',
        employeeName: 'خالد سعيد',
        position: 'موظف استقبال',
        contractType: 'محدد المدة',
        startDate: DateTime(2023, 6, 1),
        endDate: DateTime(2024, 5, 31),
        status: 'منتهي',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('عقود الموظفين'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // إحصائيات
          Row(
            children: [
              _ContractStat(
                label: 'ساري',
                count: contracts.where((c) => c.status == 'ساري').length,
                color: Colors.green,
              ),
              const SizedBox(width: 8),
              _ContractStat(
                label: 'قيد التجديد',
                count: contracts.where((c) => c.status == 'قيد التجديد').length,
                color: Colors.orange,
              ),
              const SizedBox(width: 8),
              _ContractStat(
                label: 'منتهي',
                count: contracts.where((c) => c.status == 'منتهي').length,
                color: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...contracts.map((c) => _ContractCard(contract: c)),
        ],
      ),
    );
  }
}

class _ContractStat extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _ContractStat({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(label, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _ContractCard extends StatelessWidget {
  final EmployeeContract contract;

  const _ContractCard({required this.contract});

  Color _statusColor() {
    switch (contract.status) {
      case 'ساري':
        return Colors.green;
      case 'منتهي':
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
        leading: CircleAvatar(
          backgroundColor: AppTheme.primary.withOpacity(0.1),
          child: Text(contract.employeeName[0]),
        ),
        title: Text(contract.employeeName),
        subtitle: Text('${contract.position} • ${contract.contractType}'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _statusColor().withOpacity(0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            contract.status,
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
