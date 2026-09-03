import 'package:equatable/equatable.dart';

/// Semantic sections of the Unified Home Dashboard (§4, §47).
enum CardSection {
  now,
  next,
  today,
  goals,
  continueSection,
  explore;

  String get titleArabic {
    switch (this) {
      case CardSection.now:
        return 'الآن (الوقت الحاضر)';
      case CardSection.next:
        return 'التالي';
      case CardSection.today:
        return 'المخطط اليومي';
      case CardSection.goals:
        return 'أهدافك الشخصية';
      case CardSection.continueSection:
        return 'متابعة الورد والتعلم';
      case CardSection.explore:
        return 'استكشاف الأقسام';
    }
  }
}

/// Dynamic contextual card rendered on the Unified Home Dashboard (§4, §9).
class DashboardCard extends Equatable {
  final String cardId;
  final CardSection section;
  final String sourceModule;
  final String titleArabic;
  final String subtitleArabic;
  final String? badgeText;
  final String? actionLabel;
  final String? targetRoute;
  final int priorityOrder;
  final Map<String, dynamic> metadata;

  const DashboardCard({
    required this.cardId,
    required this.section,
    required this.sourceModule,
    required this.titleArabic,
    required this.subtitleArabic,
    this.badgeText,
    this.actionLabel,
    this.targetRoute,
    this.priorityOrder = 0,
    this.metadata = const {},
  });

  @override
  List<Object?> get props => [
        cardId,
        section,
        sourceModule,
        titleArabic,
        subtitleArabic,
        badgeText,
        actionLabel,
        targetRoute,
        priorityOrder,
        metadata,
      ];
}
