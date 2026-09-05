import 'package:equatable/equatable.dart';

/// Dashboard layout density mode (§31, §44).
enum DashboardDensity {
  compact,
  balanced,
  expanded;

  String get labelArabic {
    switch (this) {
      case DashboardDensity.compact:
        return 'موجز وهادئ';
      case DashboardDensity.balanced:
        return 'متوازن';
      case DashboardDensity.expanded:
        return 'شامل ومفصل';
    }
  }
}

/// Dashboard focus profile (§31).
enum DashboardFocusMode {
  minimal,
  balanced,
  quranFocus,
  learningFocus,
  ramadanFocus,
  hajjFocus;

  String get labelArabic {
    switch (this) {
      case DashboardFocusMode.minimal:
        return 'الأساسي (أوقات الصلاة والأذكار)';
      case DashboardFocusMode.balanced:
        return 'المتوازن اليومي';
      case DashboardFocusMode.quranFocus:
        return 'التركيز القرآني والتلاوة';
      case DashboardFocusMode.learningFocus:
        return 'التركيز التعليمي والمناهج';
      case DashboardFocusMode.ramadanFocus:
        return 'أجواء الصيام ورمضان';
      case DashboardFocusMode.hajjFocus:
        return 'استعداد ومناسك الحج والعمرة';
    }
  }
}

/// User personalization preferences for Unified Dashboard (§44).
class CompanionPreferences extends Equatable {
  final DashboardDensity density;
  final DashboardFocusMode focusMode;
  final Set<String> pinnedModuleIds;
  final Set<String> hiddenCardIds;
  final bool enableQuietHours;
  final int quietHoursStartHour; // e.g. 23 (11 PM)
  final int quietHoursEndHour; // e.g. 5 (5 AM)
  final int maxDailyCards;
  final bool enableSoundEffects;

  const CompanionPreferences({
    this.density = DashboardDensity.balanced,
    this.focusMode = DashboardFocusMode.balanced,
    this.pinnedModuleIds = const {'prayer', 'quran', 'adhkar'},
    this.hiddenCardIds = const {},
    this.enableQuietHours = true,
    this.quietHoursStartHour = 23,
    this.quietHoursEndHour = 5,
    this.maxDailyCards = 7,
    this.enableSoundEffects = true,
  });

  CompanionPreferences copyWith({
    DashboardDensity? density,
    DashboardFocusMode? focusMode,
    Set<String>? pinnedModuleIds,
    Set<String>? hiddenCardIds,
    bool? enableQuietHours,
    int? quietHoursStartHour,
    int? quietHoursEndHour,
    int? maxDailyCards,
    bool? enableSoundEffects,
  }) {
    return CompanionPreferences(
      density: density ?? this.density,
      focusMode: focusMode ?? this.focusMode,
      pinnedModuleIds: pinnedModuleIds ?? this.pinnedModuleIds,
      hiddenCardIds: hiddenCardIds ?? this.hiddenCardIds,
      enableQuietHours: enableQuietHours ?? this.enableQuietHours,
      quietHoursStartHour: quietHoursStartHour ?? this.quietHoursStartHour,
      quietHoursEndHour: quietHoursEndHour ?? this.quietHoursEndHour,
      maxDailyCards: maxDailyCards ?? this.maxDailyCards,
      enableSoundEffects: enableSoundEffects ?? this.enableSoundEffects,
    );
  }

  factory CompanionPreferences.fromJson(Map<String, dynamic> json) {
    return CompanionPreferences(
      density: DashboardDensity.values.firstWhere(
        (e) => e.name == json['density'],
        orElse: () => DashboardDensity.balanced,
      ),
      focusMode: DashboardFocusMode.values.firstWhere(
        (e) => e.name == json['focus_mode'],
        orElse: () => DashboardFocusMode.balanced,
      ),
      pinnedModuleIds: (json['pinned_module_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toSet() ??
          const {'prayer', 'quran', 'adhkar'},
      hiddenCardIds: (json['hidden_card_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toSet() ??
          const {},
      enableQuietHours: json['enable_quiet_hours'] as bool? ?? true,
      quietHoursStartHour: json['quiet_hours_start_hour'] as int? ?? 23,
      quietHoursEndHour: json['quiet_hours_end_hour'] as int? ?? 5,
      maxDailyCards: json['max_daily_cards'] as int? ?? 7,
      enableSoundEffects: json['enable_sound_effects'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'density': density.name,
      'focus_mode': focusMode.name,
      'pinned_module_ids': pinnedModuleIds.toList(),
      'hidden_card_ids': hiddenCardIds.toList(),
      'enable_quiet_hours': enableQuietHours,
      'quiet_hours_start_hour': quietHoursStartHour,
      'quiet_hours_end_hour': quietHoursEndHour,
      'max_daily_cards': maxDailyCards,
      'enable_sound_effects': enableSoundEffects,
    };
  }

  @override
  List<Object?> get props => [
        density,
        focusMode,
        pinnedModuleIds,
        hiddenCardIds,
        enableQuietHours,
        quietHoursStartHour,
        quietHoursEndHour,
        maxDailyCards,
        enableSoundEffects,
      ];
}
