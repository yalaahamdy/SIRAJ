import 'package:equatable/equatable.dart';
import '../../quran/domain/ayah_key.dart';

/// Categories of mistakes observed during recall training.
enum MistakeCategory {
  omittedWord,
  addedWord,
  substitutedWord,
  wrongOrder,
  stoppedEarly,
  wrongContinuation;

  String get labelArabic {
    switch (this) {
      case MistakeCategory.omittedWord:
        return 'إسقاط كلمة';
      case MistakeCategory.addedWord:
        return 'زيادة كلمة';
      case MistakeCategory.substitutedWord:
        return 'إبدال كلمة';
      case MistakeCategory.wrongOrder:
        return 'تقديم أو تأخير';
      case MistakeCategory.stoppedEarly:
        return 'توقف مبكر';
      case MistakeCategory.wrongContinuation:
        return 'انتقال لآية مشابهة';
    }
  }
}

/// Training diagnostic record for an observed mistake on an Ayah.
class MistakeRecord extends Equatable {
  final AyahKey ayahKey;
  final MistakeCategory category;
  final String? note;
  final DateTime recordedAt;

  const MistakeRecord({
    required this.ayahKey,
    required this.category,
    this.note,
    required this.recordedAt,
  });

  factory MistakeRecord.fromMap(Map<String, dynamic> map) {
    return MistakeRecord(
      ayahKey: AyahKey.parse(map['ayah_key'] as String),
      category: MistakeCategory.values.firstWhere(
        (c) => c.name == map['category'],
        orElse: () => MistakeCategory.substitutedWord,
      ),
      note: map['note'] as String?,
      recordedAt: DateTime.parse(map['recorded_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ayah_key': ayahKey.toString(),
      'category': category.name,
      if (note != null) 'note': note,
      'recorded_at': recordedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [ayahKey, category, note, recordedAt];
}
