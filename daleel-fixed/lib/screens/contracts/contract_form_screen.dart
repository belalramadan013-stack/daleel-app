import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ContractFormScreen extends StatefulWidget {
  final String contractTypeId;
  final String contractTypeName;

  const ContractFormScreen({
    super.key,
    required this.contractTypeId,
    required this.contractTypeName,
  });

  @override
  State<ContractFormScreen> createState() => _ContractFormScreenState();
}

class _ContractFormScreenState extends State<ContractFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  late List<Map<String, String>> _fields;

  @override
  void initState() {
    super.initState();
    _fields = _getFieldsForType(widget.contractTypeId);
    for (final field in _fields) {
      _controllers[field['key']!] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  List<Map<String, String>> _getFieldsForType(String typeId) {
    switch (typeId) {
      case 'employment':
        return [
          {'key': 'employer', 'label': 'اسم صاحب العمل'},
          {'key': 'employee', 'label': 'اسم الموظف'},
          {'key': 'job_title', 'label': 'المسمى الوظيفي'},
          {'key': 'salary', 'label': 'الراتب الشهري'},
          {'key': 'start_date', 'label': 'تاريخ بدء العمل'},
          {'key': 'duration', 'label': 'مدة العقد'},
        ];
      case 'rent':
        return [
          {'key': 'landlord', 'label': 'اسم المؤجر'},
          {'key': 'tenant', 'label': 'اسم المستأجر'},
          {'key': 'property', 'label': 'وصف العقار'},
          {'key': 'rent_amount', 'label': 'قيمة الإيجار'},
          {'key': 'start_date', 'label': 'تاريخ بداية الإيجار'},
          {'key': 'end_date', 'label': 'تاريخ نهاية الإيجار'},
        ];
      case 'power_of_attorney':
        return [
          {'key': 'principal', 'label': 'اسم الموكل'},
          {'key': 'agent', 'label': 'اسم الوكيل'},
          {'key': 'scope', 'label': 'نطاق التوكيل'},
          {'key': 'duration', 'label': 'مدة التوكيل'},
        ];
      case 'sale':
        return [
          {'key': 'seller', 'label': 'اسم البائع'},
          {'key': 'buyer', 'label': 'اسم المشتري'},
          {'key': 'item', 'label': 'وصف المبيع'},
          {'key': 'price', 'label': 'الثمن'},
          {'key': 'date', 'label': 'تاريخ البيع'},
        ];
      case 'nda':
        return [
          {'key': 'party1', 'label': 'الطرف الأول'},
          {'key': 'party2', 'label': 'الطرف الثاني'},
          {'key': 'subject', 'label': 'موضوع السرية'},
          {'key': 'duration', 'label': 'مدة الالتزام'},
        ];
      default:
        return [
          {'key': 'party1', 'label': 'الطرف الأول'},
          {'key': 'party2', 'label': 'الطرف الثاني'},
        ];
    }
  }

  void _preview() {
    if (!_formKey.currentState!.validate()) return;

    final buffer = StringBuffer();
    buffer.writeln('=== ${widget.contractTypeName} ===\n');
    for (final field in _fields) {
      final value = _controllers[field['key']]!.text;
      buffer.writeln('${field['label']}: $value');
    }
    buffer.writeln('\n--- نهاية النموذج ---');
    buffer.writeln(
        '\nتنويه: هذا نموذج استرشادي ويجب مراجعته قانونياً قبل الاستخدام.');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('معاينة ${widget.contractTypeName}'),
        content: SingleChildScrollView(
          child: Text(buffer.toString()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إغلاق'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تجهيز العقد (التحميل الفعلي في المرحلة التالية)'),
                ),
              );
            },
            child: const Text('تحميل PDF'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contractTypeName),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'أدخل البيانات المطلوبة',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            ..._fields.map((field) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  controller: _controllers[field['key']],
                  decoration: InputDecoration(
                    labelText: field['label'],
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
                ),
              );
            }),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _preview,
              child: const Text('معاينة العقد'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('رجوع'),
            ),
          ],
        ),
      ),
    );
  }
}
