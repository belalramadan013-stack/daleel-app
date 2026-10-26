import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final List<Map<String, String>> _favorites = [
    {
      'title': 'نظام العمل السعودي - المادة 74',
      'category': 'عمالي',
      'country': 'السعودية',
    },
    {
      'title': 'قانون الأحوال الشخصية - الزواج',
      'category': 'أحوال شخصية',
      'country': 'الكويت',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المفضلة')),
      body: _favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border,
                      size: 64, color: AppTheme.textSecondary.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  const Text('لا توجد عناصر في المفضلة'),
                  const SizedBox(height: 8),
                  const Text('اضغط على أيقونة المفضلة في أي قانون لحفظه'),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _favorites.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = _favorites[index];
                return Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: ListTile(
                    leading: const Icon(Icons.bookmark, color: AppTheme.primary),
                    title: Text(item['title']!),
                    subtitle: Text('${item['category']} • ${item['country']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        setState(() => _favorites.removeAt(index));
                      },
                    ),
                    onTap: () {
                      // فتح القانون
                    },
                  ),
                );
              },
            ),
    );
  }
}
