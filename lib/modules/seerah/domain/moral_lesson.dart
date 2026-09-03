import 'package:equatable/equatable.dart';

/// Moral and educational reflection derived from Seerah events, explicitly segregated from historical fact (§15, §16).
class MoralLesson extends Equatable {
  final String lessonText;
  final String themeArabic;
  final String? sourceOrScholar;

  const MoralLesson({
    required this.lessonText,
    required this.themeArabic,
    this.sourceOrScholar,
  });

  Map<String, dynamic> toMap() {
    return {
      'lesson_text': lessonText,
      'theme_arabic': themeArabic,
      'source_or_scholar': sourceOrScholar,
    };
  }

  factory MoralLesson.fromMap(Map<String, dynamic> map) {
    return MoralLesson(
      lessonText: map['lesson_text'] as String,
      themeArabic: map['theme_arabic'] as String,
      sourceOrScholar: map['source_or_scholar'] as String?,
    );
  }

  @override
  List<Object?> get props => [lessonText, themeArabic, sourceOrScholar];
}
