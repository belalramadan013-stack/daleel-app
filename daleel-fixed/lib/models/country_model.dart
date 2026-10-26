class CountryModel {
  final String code;
  final String nameAr;
  final String nameEn;
  final String flag;

  const CountryModel({
    required this.code,
    required this.nameAr,
    required this.nameEn,
    required this.flag,
  });
}

class AppCountries {
  static const List<CountryModel> all = [
    CountryModel(
      code: 'SA',
      nameAr: 'المملكة العربية السعودية',
      nameEn: 'Saudi Arabia',
      flag: '🇸🇦',
    ),
    CountryModel(
      code: 'AE',
      nameAr: 'الإمارات العربية المتحدة',
      nameEn: 'United Arab Emirates',
      flag: '🇦🇪',
    ),
    CountryModel(
      code: 'KW',
      nameAr: 'الكويت',
      nameEn: 'Kuwait',
      flag: '🇰🇼',
    ),
    CountryModel(
      code: 'EG',
      nameAr: 'مصر',
      nameEn: 'Egypt',
      flag: '🇪🇬',
    ),
    CountryModel(
      code: 'JO',
      nameAr: 'الأردن',
      nameEn: 'Jordan',
      flag: '🇯🇴',
    ),
  ];

  static CountryModel? getByCode(String code) {
    try {
      return all.firstWhere((c) => c.code == code);
    } catch (_) {
      return null;
    }
  }
}
