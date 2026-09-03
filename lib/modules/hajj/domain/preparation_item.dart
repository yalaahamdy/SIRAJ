/// Category for Hajj & Umrah preparation checklist items (§25).
enum PreparationCategory {
  documents('الوثائق والتصاريح'),
  ihramEssentials('ملابس ومستلزمات الإحرام'),
  healthAndSafety('إرشادات السلامة العامة'),
  personalLuggage('الحقيبة الشخصية والأمتعة'),
  knowledgeAndSpiritual('الاستعداد العلمي والقلبي');

  final String labelArabic;
  const PreparationCategory(this.labelArabic);
}

/// Sourced Preparation checklist item (§25).
class PreparationItem {
  final String itemId;
  final String titleArabic;
  final String description;
  final PreparationCategory category;
  final bool isEssential;

  const PreparationItem({
    required this.itemId,
    required this.titleArabic,
    required this.description,
    required this.category,
    this.isEssential = false,
  });

  Map<String, dynamic> toJson() => {
        'itemId': itemId,
        'titleArabic': titleArabic,
        'description': description,
        'category': category.name,
        'isEssential': isEssential,
      };

  factory PreparationItem.fromJson(Map<String, dynamic> json) => PreparationItem(
        itemId: json['itemId'] as String,
        titleArabic: json['titleArabic'] as String,
        description: json['description'] as String,
        category: PreparationCategory.values.firstWhere((e) => e.name == json['category']),
        isEssential: json['isEssential'] as bool? ?? false,
      );
}
