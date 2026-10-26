import 'package:flutter/material.dart';
import '../payment/payment_screen.dart';

class LawyerModel {
  final String id;
  final String name;
  final String specialty;
  final String countryCode;
  final double rating;
  final int experienceYears;
  final String? imageUrl;
  final double consultationPrice;

  LawyerModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.countryCode,
    required this.rating,
    required this.experienceYears,
    this.imageUrl,
    required this.consultationPrice,
  });
}

class LawyersScreen extends StatefulWidget {
  const LawyersScreen({super.key});

  @override
  State<LawyersScreen> createState() => _LawyersScreenState();
}

class _LawyersScreenState extends State<LawyersScreen> {
  final List<LawyerModel> _lawyers = [
    LawyerModel(
      id: '1',
      name: 'أحمد العتيبي',
      specialty: 'قانون العمل',
      countryCode: 'SA',
      rating: 4.8,
      experienceYears: 12,
      consultationPrice: 250,
    ),
    LawyerModel(
      id: '2',
      name: 'سارة محمد',
      specialty: 'أحوال شخصية',
      countryCode: 'SA',
      rating: 4.9,
      experienceYears: 8,
      consultationPrice: 200,
    ),
    LawyerModel(
      id: '3',
      name: 'خالد عبدالله',
      specialty: 'قانون تجاري',
      countryCode: 'AE',
      rating: 4.7,
      experienceYears: 15,
      consultationPrice: 400,
    ),
    LawyerModel(
      id: '4',
      name: 'نورة السعيد',
      specialty: 'عقارات',
      countryCode: 'EG',
      rating: 4.6,
      experienceYears: 10,
      consultationPrice: 150,
    ),
  ];

  String? _selectedSpecialty;

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedSpecialty == null
        ? _lawyers
        : _lawyers.where((l) => l.specialty == _selectedSpecialty).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('دليل المحامين')),
      body: Column(
        children: [
          // فلاتر التخصص
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _FilterChip(
                  label: 'الكل',
                  selected: _selectedSpecialty == null,
                  onTap: () => setState(() => _selectedSpecialty = null),
                ),
                ...['قانون العمل', 'أحوال شخصية', 'قانون تجاري', 'عقارات']
                    .map((s) => _FilterChip(
                          label: s,
                          selected: _selectedSpecialty == s,
                          onTap: () => setState(() => _selectedSpecialty = s),
                        )),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final lawyer = filtered[index];
                return _LawyerCard(lawyer: lawyer);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: AppTheme.primary.withOpacity(0.15),
        checkmarkColor: AppTheme.primary,
      ),
    );
  }
}

class _LawyerCard extends StatelessWidget {
  final LawyerModel lawyer;

  const _LawyerCard({required this.lawyer});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 1,
      child: InkWell(
        onTap: () async {
          final paid = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (_) => PaymentScreen(
                title: 'استشارة قانونية',
                amount: lawyer.consultationPrice,
                description: 'استشارة مع ${lawyer.name} - ${lawyer.specialty}',
              ),
            ),
          );
          if (paid == true && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('تم حجز الاستشارة مع ${lawyer.name}')),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppTheme.primary.withOpacity(0.1),
                child: Text(
                  lawyer.name[0],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lawyer.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lawyer.specialty,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(lawyer.rating.toString()),
                        const SizedBox(width: 12),
                        Text('${lawyer.experienceYears} سنة خبرة'),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${lawyer.consultationPrice.toInt()} ر.س',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('للاستشارة', style: TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
