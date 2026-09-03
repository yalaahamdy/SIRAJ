import 'package:equatable/equatable.dart';
import '../../quran/domain/ayah_key.dart';

/// User memorization plan and learning pace configuration.
class MemorizationPlan extends Equatable {
  final String id;
  final String title;
  final List<int> targetSurahs;
  final AyahKey startAyah;
  final AyahKey endAyah;
  final int dailyNewAyahs;
  final int dailyReviewTarget;
  final DateTime? targetDate;
  final bool isActive;
  final DateTime createdAt;

  const MemorizationPlan({
    required this.id,
    required this.title,
    required this.targetSurahs,
    required this.startAyah,
    required this.endAyah,
    this.dailyNewAyahs = 5,
    this.dailyReviewTarget = 20,
    this.targetDate,
    this.isActive = true,
    required this.createdAt,
  })  : assert(dailyNewAyahs >= 1, 'Daily new ayahs must be >= 1'),
        assert(dailyReviewTarget >= 1, 'Daily review target must be >= 1');

  static MemorizationPlan createDefaultJuzAmma(DateTime now) {
    return MemorizationPlan(
      id: 'plan_juz_amma',
      title: 'حفظ جزء عم (من سورة النبأ إلى سورة الناس)',
      targetSurahs: List.generate(37, (i) => 78 + i), // 78..114
      startAyah: const AyahKey(surahNumber: 78, ayahNumber: 1),
      endAyah: const AyahKey(surahNumber: 114, ayahNumber: 6),
      dailyNewAyahs: 5,
      dailyReviewTarget: 20,
      createdAt: now,
    );
  }

  MemorizationPlan copyWith({
    String? title,
    List<int>? targetSurahs,
    AyahKey? startAyah,
    AyahKey? endAyah,
    int? dailyNewAyahs,
    int? dailyReviewTarget,
    DateTime? targetDate,
    bool? isActive,
  }) {
    return MemorizationPlan(
      id: id,
      title: title ?? this.title,
      targetSurahs: targetSurahs ?? this.targetSurahs,
      startAyah: startAyah ?? this.startAyah,
      endAyah: endAyah ?? this.endAyah,
      dailyNewAyahs: dailyNewAyahs ?? this.dailyNewAyahs,
      dailyReviewTarget: dailyReviewTarget ?? this.dailyReviewTarget,
      targetDate: targetDate ?? this.targetDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
    );
  }

  factory MemorizationPlan.fromMap(Map<String, dynamic> map) {
    final rawSurahs = map['target_surahs'] as List<dynamic>? ?? [];
    return MemorizationPlan(
      id: map['id'] as String,
      title: map['title'] as String,
      targetSurahs: rawSurahs.map((e) => e as int).toList(),
      startAyah: AyahKey.parse(map['start_ayah'] as String),
      endAyah: AyahKey.parse(map['end_ayah'] as String),
      dailyNewAyahs: map['daily_new_ayahs'] as int? ?? 5,
      dailyReviewTarget: map['daily_review_target'] as int? ?? 20,
      targetDate: map['target_date'] != null ? DateTime.parse(map['target_date'] as String) : null,
      isActive: map['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'target_surahs': targetSurahs,
      'start_ayah': startAyah.toString(),
      'end_ayah': endAyah.toString(),
      'daily_new_ayahs': dailyNewAyahs,
      'daily_review_target': dailyReviewTarget,
      if (targetDate != null) 'target_date': targetDate!.toIso8601String(),
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        targetSurahs,
        startAyah,
        endAyah,
        dailyNewAyahs,
        dailyReviewTarget,
        targetDate,
        isActive,
        createdAt,
      ];
}
