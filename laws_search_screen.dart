import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/law_model.dart';
import '../../services/auth_service.dart';
import '../../services/law_service.dart';
import '../../theme/app_theme.dart';
import 'law_detail_screen.dart';

class LawsSearchScreen extends StatefulWidget {
  const LawsSearchScreen({super.key});

  @override
  State<LawsSearchScreen> createState() => _LawsSearchScreenState();
}

class _LawsSearchScreenState extends State<LawsSearchScreen> {
  final _searchController = TextEditingController();
  final _lawService = LawService();
  List<LawModel> _results = [];
  bool _isLoading = false;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _search();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    setState(() => _isLoading = true);

    final countryCode =
        context.read<AuthService>().currentUser?.selectedCountry;

    final results = await _lawService.searchLaws(
      query: _searchController.text,
      countryCode: countryCode,
      category: _selectedCategory,
    );

    if (mounted) {
      setState(() {
        _results = results;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('البحث في القوانين'),
      ),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث عن مادة أو نظام...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _search();
                        },
                      )
                    : null,
              ),
              onChanged: (_) => _search(),
              onSubmitted: (_) => _search(),
            ),
          ),

          // الفلاتر
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _FilterChip(
                  label: 'الكل',
                  selected: _selectedCategory == null,
                  onTap: () {
                    setState(() => _selectedCategory = null);
                    _search();
                  },
                ),
                ...LawCategory.all.map((cat) => _FilterChip(
                      label: '${cat.icon} ${cat.nameAr}',
                      selected: _selectedCategory == cat.id,
                      onTap: () {
                        setState(() => _selectedCategory = cat.id);
                        _search();
                      },
                    )),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // النتائج
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _results.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off,
                                size: 64, color: AppTheme.textSecondary),
                            const SizedBox(height: 16),
                            Text(
                              'لا توجد نتائج',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'جرب كلمات بحث مختلفة أو غيّر الفلتر',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _results.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final law = _results[index];
                          return _LawCard(
                            law: law,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => LawDetailScreen(law: law),
                                ),
                              );
                            },
                          );
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
        labelStyle: TextStyle(
          color: selected ? AppTheme.primary : AppTheme.textPrimary,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}

class _LawCard extends StatelessWidget {
  final LawModel law;
  final VoidCallback onTap;

  const _LawCard({required this.law, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final category = LawCategory.all.firstWhere(
      (c) => c.id == law.category,
      orElse: () => const LawCategory(id: '', nameAr: 'أخرى', icon: '📄'),
    );

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${category.icon} ${category.nameAr}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (law.articleNumber != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      'مادة ${law.articleNumber}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                          ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 10),
              Text(
                law.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                law.summary,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
