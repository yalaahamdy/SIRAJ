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
        return 'السيولة والنقد والبنوك';
      case AssetCategory.gold:
        return 'الذهب والسبائك';
      case AssetCategory.silver:
        return 'الفضة';
      case AssetCategory.tradeGoods:
        return 'عروض التجارة والبضائع';
      case AssetCategory.investments:
        return 'الأسهم والاستثمارات';
      case AssetCategory.receivables:
        return 'الديون المرجوة (لك عند الغير)';
      case AssetCategory.debts:
        return 'الديون والالتزامات (عليك للغير)';
      case AssetCategory.other:
        return 'أصول أخرى';
    }
  }

  bool get isLiability => this == AssetCategory.debts;
}
