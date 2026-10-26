import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/theme_provider.dart';
import '../payment/payment_screen.dart';
import '../../models/country_model.dart';
import '../../services/auth_service.dart';
import '../../utils/constants.dart';
import '../laws/laws_search_screen.dart';
import '../assistant/smart_chat_screen.dart';
import '../contracts/contracts_screen.dart';
import '../documents/documents_screen.dart';
import '../lawyers/lawyers_screen.dart';
import '../notifications/notifications_screen.dart';
import '../favorites/favorites_screen.dart';
import '../individual/my_requests_screen.dart';
import '../individual/legal_guides_screen.dart';
import '../lawyer/lawyer_dashboard_screen.dart';
import '../company/company_dashboard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final country = AppCountries.getByCode(
      auth.currentUser?.selectedCountry ?? 'SA',
    );

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // الشريط العلوي
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مرحباً، ${auth.currentUser?.fullName.split(' ').first ?? 'مستخدم'}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _getAccountTypeLabel(auth.currentUser?.accountType),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const SelectCountryScreen(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  country?.flag ?? '🌍',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  country?.nameAr ?? 'اختر الدولة',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: AppTheme.secondary),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 18,
                                  color: AppTheme.secondary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const NotificationsScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.notifications_outlined),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<ThemeProvider>().toggleTheme();
                      },
                      icon: Icon(
                        context.watch<ThemeProvider>().isDarkMode
                            ? Icons.light_mode
                            : Icons.dark_mode,
                      ),
                      tooltip: 'تغيير اللون',
                    ),
                  ],
                ),
              ),
            ),

            // مربع البحث
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const LawsSearchScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: AppTheme.textSecondary),
                        const SizedBox(width: 12),
                        Text(
                          'ابحث عن قانون أو موضوع قانوني...',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // البطاقات الرئيسية
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                delegate: SliverChildListDelegate(
                  _getFeatureCards(context, auth.currentUser?.accountType),
                ),
              ),
            ),

            // تنويه
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF5F5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFEB2B2)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline,
                          color: Color(0xFFC53030), size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'المعلومات الواردة في التطبيق استرشادية فقط وليست بديلاً عن استشارة محامٍ مرخص.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFF742A2A),
                                height: 1.4,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

  List<Widget> _getFeatureCards(BuildContext context, String? accountType) {
    final common = [
      _FeatureCard(
        title: 'المساعد الذكي',
        subtitle: 'اسأل أي سؤال قانوني',
        icon: Icons.smart_toy_outlined,
        color: const Color(0xFF2B6CB0),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SmartChatScreen()),
        ),
      ),
      _FeatureCard(
        title: 'البحث في القوانين',
        subtitle: 'استعرض المواد والأنظمة',
        icon: Icons.menu_book_outlined,
        color: const Color(0xFF38A169),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const LawsSearchScreen()),
        ),
      ),
      _FeatureCard(
        title: 'توليد عقد',
        subtitle: 'أنشئ عقداً جاهزاً',
        icon: Icons.description_outlined,
        color: const Color(0xFFD69E2E),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ContractsScreen()),
        ),
      ),
    ];

    if (accountType == AppConstants.accountLawyer) {
      return [
        _FeatureCard(
          title: 'لوحة المحامي',
          subtitle: 'القضايا والاستشارات',
          icon: Icons.dashboard,
          color: const Color(0xFF805AD5),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const LawyerDashboardScreen()),
          ),
        ),
        ...common,
        _FeatureCard(
          title: 'المفضلة',
          subtitle: 'القوانين المحفوظة',
          icon: Icons.bookmark_outline,
          color: const Color(0xFFD69E2E),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const FavoritesScreen()),
          ),
        ),
      ];
    }

    if (accountType == AppConstants.accountCompany) {
      return [
        _FeatureCard(
          title: 'لوحة الشركة',
          subtitle: 'العقود والامتثال',
          icon: Icons.business,
          color: const Color(0xFF2B6CB0),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CompanyDashboardScreen()),
          ),
        ),
        ...common,
        _FeatureCard(
          title: 'دليل المحامين',
          subtitle: 'استشارات للشركات',
          icon: Icons.people_outline,
          color: const Color(0xFF805AD5),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const LawyersScreen()),
          ),
        ),
      ];
    }

    // فرد (افتراضي)
    return [
      ...common,
      _FeatureCard(
        title: 'أدلة قانونية',
        subtitle: 'معلومات مبسطة عن حقوقك',
        icon: Icons.menu_book,
        color: const Color(0xFF2B6CB0),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const LegalGuidesScreen()),
        ),
      ),
      _FeatureCard(
        title: 'طلباتي',
        subtitle: 'متابعة الاستشارات والعقود',
        icon: Icons.assignment,
        color: const Color(0xFF805AD5),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const MyRequestsScreen()),
        ),
      ),
      _FeatureCard(
        title: 'تذكيراتي',
        subtitle: 'المواعيد والمواعيد النهائية',
        icon: Icons.notifications_active,
        color: const Color(0xFFE53E3E),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const MyRemindersScreen()),
        ),
      ),
      _FeatureCard(
        title: 'دليل المحامين',
        subtitle: 'تواصل مع محامي متخصص',
        icon: Icons.people_outline,
        color: const Color(0xFF38A169),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const LawyersScreen()),
        ),
      ),
      _FeatureCard(
        title: 'المفضلة',
        subtitle: 'القوانين المحفوظة',
        icon: Icons.bookmark_outline,
        color: const Color(0xFFD69E2E),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const FavoritesScreen()),
        ),
      ),
    ];
  }

  String _getAccountTypeLabel(String? type) {
    switch (type) {
      case AppConstants.accountLawyer:
        return 'محامي';
      case AppConstants.accountCompany:
        return 'شركة';
      default:
        return 'فرد';
    }
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.06),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const Spacer(),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
