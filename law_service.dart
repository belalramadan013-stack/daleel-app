import '../models/law_model.dart';

/// خدمة القوانين (بيانات تجريبية حالياً)
class LawService {
  // بيانات تجريبية للقوانين
  static final List<LawModel> _sampleLaws = [
    LawModel(
      id: 'sa_labor_1',
      title: 'نظام العمل السعودي - المادة 74',
      summary: 'تنظم حالات انتهاء عقد العمل.',
      content:
          'ينتهي عقد العمل في الحالات التالية:\n1. إذا اتفق الطرفان على إنهائه.\n2. إذا انتهت المدة المحددة في العقد...\n(نص تجريبي للتوضيح)',
      countryCode: 'SA',
      category: 'labor',
      articleNumber: '74',
    ),
    LawModel(
      id: 'sa_civil_1',
      title: 'نظام المعاملات المدنية - العقد',
      summary: 'تعريف العقد وأركانه في النظام السعودي.',
      content:
          'العقد هو ارتباط الإيجاب بالقبول على وجه يثبت أثره في المعقود عليه...\n(نص تجريبي)',
      countryCode: 'SA',
      category: 'civil',
      articleNumber: '1',
    ),
    LawModel(
      id: 'eg_labor_1',
      title: 'قانون العمل المصري رقم 12 لسنة 2003',
      summary: 'الأحكام العامة لعقد العمل الفردي.',
      content: 'يسري أحكام هذا القانون على جميع العمال...\n(نص تجريبي)',
      countryCode: 'EG',
      category: 'labor',
    ),
    LawModel(
      id: 'ae_commercial_1',
      title: 'قانون الشركات التجارية الإماراتي',
      summary: 'أنواع الشركات وإجراءات التأسيس.',
      content: 'تحدد هذا القانون أنواع الشركات التجارية...\n(نص تجريبي)',
      countryCode: 'AE',
      category: 'commercial',
    ),
    LawModel(
      id: 'kw_family_1',
      title: 'قانون الأحوال الشخصية الكويتي',
      summary: 'أحكام الزواج والطلاق والنفقة.',
      content: 'ينظم هذا القانون مسائل الأحوال الشخصية...\n(نص تجريبي)',
      countryCode: 'KW',
      category: 'family',
    ),
    LawModel(
      id: 'jo_civil_1',
      title: 'القانون المدني الأردني',
      summary: 'الأحكام العامة للالتزامات والعقود.',
      content: 'تسري أحكام هذا القانون على جميع المسائل...\n(نص تجريبي)',
      countryCode: 'JO',
      category: 'civil',
    ),
  ];

  Future<List<LawModel>> searchLaws({
    String? query,
    String? countryCode,
    String? category,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    var results = List<LawModel>.from(_sampleLaws);

    if (countryCode != null && countryCode.isNotEmpty) {
      results = results.where((law) => law.countryCode == countryCode).toList();
    }

    if (category != null && category.isNotEmpty) {
      results = results.where((law) => law.category == category).toList();
    }

    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      results = results
          .where((law) =>
              law.title.toLowerCase().contains(q) ||
              law.summary.toLowerCase().contains(q) ||
              law.content.toLowerCase().contains(q))
          .toList();
    }

    return results;
  }

  Future<LawModel?> getLawById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _sampleLaws.firstWhere((law) => law.id == id);
    } catch (_) {
      return null;
    }
  }
}
