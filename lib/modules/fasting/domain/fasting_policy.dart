import 'package:equatable/equatable.dart';

/// Immutable model defining jurisprudential and timing policies for fasting (§4, §24).
class FastingPolicy extends Equatable {
  final String policyId;
  final String nameArabic;
  final String sourceReference;
  final int imsakBufferMinutes;
  final String calendarPolicy;
  final String reviewState;

  const FastingPolicy({
    required this.policyId,
    required this.nameArabic,
    required this.sourceReference,
    this.imsakBufferMinutes = 0,
    this.calendarPolicy = 'tabular_calculated',
    this.reviewState = 'APPROVED',
  });

  /// Standard default policy: Fasting from True Dawn (Fajr) to Sunset (Maghrib) with 0m buffer.
  static const standard = FastingPolicy(
    policyId: 'fasting_policy_standard',
    nameArabic: 'السياسة القياسية (الفجر الصادق والمغرب)',
    sourceReference: 'إجماع المذاهب الأربعة (البقرة: 187)',
    imsakBufferMinutes: 0,
    calendarPolicy: 'tabular_calculated',
  );

  /// Policy with 10-minute pre-Fajr Imsak buffer for precautionary pause.
  static const precautionaryImsak = FastingPolicy(
    policyId: 'fasting_policy_precautionary_imsak',
    nameArabic: 'سياسة الإمساك الاحتياطي (10 دقائق قبل الفجر)',
    sourceReference: 'جداول التقويم المعتمدة كإرشاد استحباي',
    imsakBufferMinutes: 10,
    calendarPolicy: 'tabular_calculated',
  );

  factory FastingPolicy.fromMap(Map<String, dynamic> map) {
    return FastingPolicy(
      policyId: map['policy_id'] as String,
      nameArabic: map['name_arabic'] as String,
      sourceReference: map['source_reference'] as String,
      imsakBufferMinutes: map['imsak_buffer_minutes'] as int? ?? 0,
      calendarPolicy: map['calendar_policy'] as String? ?? 'tabular_calculated',
      reviewState: map['review_state'] as String? ?? 'APPROVED',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'policy_id': policyId,
      'name_arabic': nameArabic,
      'source_reference': sourceReference,
      'imsak_buffer_minutes': imsakBufferMinutes,
      'calendar_policy': calendarPolicy,
      'review_state': reviewState,
    };
  }

  @override
  List<Object?> get props => [
        policyId,
        nameArabic,
        sourceReference,
        imsakBufferMinutes,
        calendarPolicy,
        reviewState,
      ];
}
