class LawModel {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String countryCode;
  final String category; // مدني، جنائي، عمالي...
  final String? articleNumber;
  final DateTime? lastUpdated;

  LawModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.countryCode,
    required this.category,
    this.articleNumber,
    this.lastUpdated,
  });

  factory LawModel.fromJson(Map<String, dynamic> json) {
    return LawModel(
      id: json['id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      content: json['content'] as String,
      countryCode: json['countryCode'] as String,
      category: json['category'] as String,
      articleNumber: json['articleNumber'] as String?,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
    );
  }
}

class LawCategory {
  final String id;
  final String nameAr;
  final String icon;

  const LawCategory({
    required this.id,
    required this.nameAr,
    required this.icon,
  });

  static const List<LawCategory> all = [
    LawCategory(id: 'civil', nameAr: 'مدني', icon: '⚖️'),
    LawCategory(id: 'criminal', nameAr: 'جنائي', icon: '🔒'),
    LawCategory(id: 'labor', nameAr: 'عمالي', icon: '👷'),
    LawCategory(id: 'family', nameAr: 'أحوال شخصية', icon: '👨‍👩‍👧'),
    LawCategory(id: 'commercial', nameAr: 'تجاري', icon: '🏢'),
    LawCategory(id: 'real_estate', nameAr: 'عقاري', icon: '🏠'),
    LawCategory(id: 'tax', nameAr: 'ضريبي', icon: '💰'),
    LawCategory(id: 'admin', nameAr: 'إداري', icon: '🏛️'),
  ];
}
