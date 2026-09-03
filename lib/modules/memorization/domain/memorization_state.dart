/// Training lifecycle states for an Ayah within the memorization engine.
enum MemorizationState {
  notStarted,
  learning,
  inProgress,
  memorized,
  needsReview,
  weak,
  mastered;

  String get labelArabic {
    switch (this) {
      case MemorizationState.notStarted:
        return 'لم يبدأ';
      case MemorizationState.learning:
        return 'قيد التعلم';
      case MemorizationState.inProgress:
        return 'قيد التثبيت';
      case MemorizationState.memorized:
        return 'محفوظ';
      case MemorizationState.needsReview:
        return 'مستحق للمراجعة';
      case MemorizationState.weak:
        return 'يحتاج تركيزاً';
      case MemorizationState.mastered:
        return 'متقن';
    }
  }

  String get labelEnglish {
    switch (this) {
      case MemorizationState.notStarted:
        return 'Not Started';
      case MemorizationState.learning:
        return 'Learning';
      case MemorizationState.inProgress:
        return 'In Progress';
      case MemorizationState.memorized:
        return 'Memorized';
      case MemorizationState.needsReview:
        return 'Needs Review';
      case MemorizationState.weak:
        return 'Needs Focus';
      case MemorizationState.mastered:
        return 'Mastered';
    }
  }
}
