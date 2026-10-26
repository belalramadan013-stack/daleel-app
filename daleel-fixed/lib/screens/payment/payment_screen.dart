import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class PaymentScreen extends StatefulWidget {
  final String title;
  final double amount;
  final String currency;
  final String description;

  const PaymentScreen({
    super.key,
    required this.title,
    required this.amount,
    this.currency = 'ر.س',
    required this.description,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'card';
  bool _isProcessing = false;

  final _cardController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _isProcessing = false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 12),
            Text('تم الدفع بنجاح'),
          ],
        ),
        content: Text(
          'تم دفع ${widget.amount.toInt()} ${widget.currency} بنجاح.\n${widget.description}',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop(true);
            },
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الدفع الإلكتروني')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ملخص الدفع
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${widget.amount.toInt()} ${widget.currency}',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'طريقة الدفع',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            // خيارات الدفع
            _PaymentMethodTile(
              title: 'بطاقة ائتمان / مدى',
              icon: Icons.credit_card,
              value: 'card',
              groupValue: _selectedMethod,
              onChanged: (v) => setState(() => _selectedMethod = v!),
            ),
            _PaymentMethodTile(
              title: 'Apple Pay',
              icon: Icons.apple,
              value: 'apple',
              groupValue: _selectedMethod,
              onChanged: (v) => setState(() => _selectedMethod = v!),
            ),
            _PaymentMethodTile(
              title: 'Google Pay',
              icon: Icons.g_mobiledata,
              value: 'google',
              groupValue: _selectedMethod,
              onChanged: (v) => setState(() => _selectedMethod = v!),
            ),

            if (_selectedMethod == 'card') ...[
              const SizedBox(height: 20),
              TextField(
                controller: _cardController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'رقم البطاقة',
                  prefixIcon: Icon(Icons.credit_card),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _expiryController,
                      decoration: const InputDecoration(
                        labelText: 'تاريخ الانتهاء',
                        hintText: 'MM/YY',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _cvvController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isProcessing ? null : _processPayment,
              child: _isProcessing
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text('ادفع ${widget.amount.toInt()} ${widget.currency}'),
            ),
            const SizedBox(height: 16),
            Text(
              'الدفع آمن ومشفر. لن يتم حفظ بيانات البطاقة.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  const _PaymentMethodTile({
    required this.title,
    required this.icon,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? AppTheme.primary.withOpacity(0.08) : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        child: RadioListTile<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          title: Text(title),
          secondary: Icon(icon, color: selected ? AppTheme.primary : null),
          activeColor: AppTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: selected ? AppTheme.primary : AppTheme.border,
            ),
          ),
        ),
      ),
    );
  }
}
