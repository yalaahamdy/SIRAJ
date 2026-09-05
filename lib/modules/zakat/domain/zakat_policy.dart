import 'package:equatable/equatable.dart';
import 'debt_treatment.dart';
import 'nisab_standard.dart';

/// Transparent jurisprudential policy profile for Zakat calculations (§23, §24).
class ZakatPolicy extends Equatable {
  final String policyId;
  final String nameArabic;
  final String sourceInstitution;
  final String reference;
  final NisabStandard nisabStandard;
  final DebtTreatment debtTreatment;
  final double annualRateHijri;
  final double annualRateGregorian;
  final double goldNisabGrams;
  final double silverNisabGrams;
  final String description;

  const ZakatPolicy({
    required this.policyId,
    required this.nameArabic,
    required this.sourceInstitution,
    required this.reference,
    required this.nisabStandard,
    required this.debtTreatment,
    this.annualRateHijri = 0.025, // 2.5%
    this.annualRateGregorian = 0.02577, // 2.577%
    this.goldNisabGrams = 85.0,
    this.silverNisabGrams = 595.0,
    required this.description,
  });

  static const String goldStandardId = 'policy_gold_standard_85g';
  static const String silverStandardId = 'policy_silver_standard_595g';
  static const String manualStandardId = 'policy_manual_standard';

  /// Standard contemporary policy using the 85g Gold standard (Islamic Fiqh Academy).
  static const ZakatPolicy goldStandard = ZakatPolicy(
    policyId: goldStandardId,
    nameArabic: 'سياسة معيار الذهب (85 جرام - مجمع الفقه الإسلامي الدولي)',
    sourceInstitution: 'مجمع الفقه الإسلامي الدولي / هيئة كبار العلماء',
    reference: 'قرار رقم 3 (3/1) بشأن زكاة الأوراق النقدية المعاصرة',
    nisabStandard: NisabStandard.gold85g,
    debtTreatment: DebtTreatment.deductCurrentDebts,
    annualRateHijri: 0.025,
    annualRateGregorian: 0.02577,
    goldNisabGrams: 85.0,
    silverNisabGrams: 595.0,
    description: 'اعتماد نصاب الذهب (85 جرام عيار 24) كمعيار أساسي للأموال النقدية المعاصرة مع خصم الديون الحالة العاجلة.',
  );

  /// Standard classical policy using the 595g Silver standard (Hanafi school / Pro-poor).
  static const ZakatPolicy silverStandard = ZakatPolicy(
    policyId: silverStandardId,
    nameArabic: 'سياسة معيار الفضة (595 جرام - المذهب الحنفي)',
    sourceInstitution: 'المذهب الحنفي ودار الإفتاء المصرية',
    reference: 'الفتاوى الهندية وكتاب المبسوط للسرخسي',
    nisabStandard: NisabStandard.silver595g,
    debtTreatment: DebtTreatment.deductCurrentDebts,
    annualRateHijri: 0.025,
    annualRateGregorian: 0.02577,
    goldNisabGrams: 85.0,
    silverNisabGrams: 595.0,
    description: 'اعتماد نصاب الفضة (595 جرام) كمعيار للأوراق النقدية تحقيقاً لمصلحة الفقراء مع خصم الديون الحالة.',
  );

  /// Custom manual policy allowing direct monetary input.
  static const ZakatPolicy manualStandard = ZakatPolicy(
    policyId: manualStandardId,
    nameArabic: 'سياسة النصاب المخصص يدوياً',
    sourceInstitution: 'تحديد يدوي مباشر من المزكي',
    reference: 'تحديد مباشر لقيمة النصاب النقدية',
    nisabStandard: NisabStandard.custom,
    debtTreatment: DebtTreatment.deductCurrentDebts,
    annualRateHijri: 0.025,
    annualRateGregorian: 0.02577,
    goldNisabGrams: 85.0,
    silverNisabGrams: 595.0,
    description: 'إدخال قيمة النصاب النقدية مباشرة وفقاً لتقدير المزكي أو فتاوى دار الإفتاء المحلية.',
  );

  factory ZakatPolicy.fromMap(Map<String, dynamic> map) {
    return ZakatPolicy(
      policyId: map['policy_id'] as String,
      nameArabic: map['name_arabic'] as String,
      sourceInstitution: map['source_institution'] as String,
      reference: map['reference'] as String,
      nisabStandard: NisabStandard.values.firstWhere(
        (n) => n.name == map['nisab_standard'],
        orElse: () => NisabStandard.gold85g,
      ),
      debtTreatment: DebtTreatment.values.firstWhere(
        (d) => d.name == map['debt_treatment'],
        orElse: () => DebtTreatment.deductCurrentDebts,
      ),
      annualRateHijri: (map['annual_rate_hijri'] as num?)?.toDouble() ?? 0.025,
      annualRateGregorian: (map['annual_rate_gregorian'] as num?)?.toDouble() ?? 0.02577,
      goldNisabGrams: (map['gold_nisab_grams'] as num?)?.toDouble() ?? 85.0,
      silverNisabGrams: (map['silver_nisab_grams'] as num?)?.toDouble() ?? 595.0,
      description: map['description'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'policy_id': policyId,
      'name_arabic': nameArabic,
      'source_institution': sourceInstitution,
      'reference': reference,
      'nisab_standard': nisabStandard.name,
      'debt_treatment': debtTreatment.name,
      'annual_rate_hijri': annualRateHijri,
      'annual_rate_gregorian': annualRateGregorian,
      'gold_nisab_grams': goldNisabGrams,
      'silver_nisab_grams': silverNisabGrams,
      'description': description,
    };
  }

  @override
  List<Object?> get props => [
        policyId,
        nameArabic,
        sourceInstitution,
        reference,
        nisabStandard,
        debtTreatment,
        annualRateHijri,
        annualRateGregorian,
        goldNisabGrams,
        silverNisabGrams,
        description,
      ];
}
