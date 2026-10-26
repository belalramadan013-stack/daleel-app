class AppConstants {
  static const String appName = 'دليل';
  static const String appTagline = 'دليلك القانوني في الخليج ومصر والأردن';

  // أنواع الحسابات
  static const String accountIndividual = 'individual';
  static const String accountLawyer = 'lawyer';
  static const String accountCompany = 'company';

  // أنواع العقود المدعومة في المرحلة 1
  static const List<Map<String, String>> contractTypes = [
    {'id': 'employment', 'name': 'عقد عمل'},
    {'id': 'rent', 'name': 'عقد إيجار'},
    {'id': 'power_of_attorney', 'name': 'توكيل'},
    {'id': 'sale', 'name': 'عقد بيع'},
    {'id': 'nda', 'name': 'اتفاقية عدم إفشاء'},
  ];
}
