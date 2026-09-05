/// Standard categories of wealth and assets eligible for Zakat evaluation (§13).
enum AssetCategory {
  cash,
  gold,
  silver,
  tradeGoods,
  investments,
  receivables,
  debts,
  other;

  String get labelArabic {
    switch (this) {
      case AssetCategory.cash:
        return 'السيولة والنقد والمدخرات';
      case AssetCategory.gold:
        return 'الذهب والسبائك';
      case AssetCategory.silver:
        return 'الفضة والسبائك';
      case AssetCategory.tradeGoods:
        return 'عروض التجارة والمخزون';
      case AssetCategory.investments:
        return 'الأسهم وصناديق الاستثمار';
      case AssetCategory.receivables:
        return 'أموال مستحقة لك عند الغير (ديون مرجوة)';
      case AssetCategory.debts:
        return 'ديون والتزامات حالة عليك (للخصم)';
      case AssetCategory.other:
        return 'أصول زكوية أخرى';
    }
  }

  String get descriptionArabic {
    switch (this) {
      case AssetCategory.cash:
        return 'النقد في المنزل، أرصدة الحسابات البنكية، الودائع، والمدخرات النقدية.';
      case AssetCategory.gold:
        return 'السبائك والعملات والذهب الادخاري بعياراته المختلفة (24K, 22K, 21K, 18K).';
      case AssetCategory.silver:
        return 'الفضة والسبائك والعملات الفضية المعدة للادخار والتجارة.';
      case AssetCategory.tradeGoods:
        return 'قيمة البضائع والمخزون المعد للبيع بسعر السوق الحالي في نهاية الحول.';
      case AssetCategory.investments:
        return 'الأسهم في الشركات المدرجة، الصناديق الاستثمارية، والأصول الاستثمارية النقدية.';
      case AssetCategory.receivables:
        return 'المبالغ والديون المستحقة لك عند مدينين موسرين مرجو تحصيلها وسدادها.';
      case AssetCategory.debts:
        return 'الديون العاجلة الواجبة السداد، الأقساط الحالة، الفواتير والأجور المستحقة.';
      case AssetCategory.other:
        return 'أي أصول مالية نامية أخرى تنطبق عليها شروط وجوب الزكاة الشرعية.';
    }
  }

  bool get isLiability => this == AssetCategory.debts;
}
