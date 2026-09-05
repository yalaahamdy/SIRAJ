import 'package:equatable/equatable.dart';
import 'prayer_type.dart';

/// Defines notification behavior mode for a specific prayer time.
enum PrayerNotificationMode {
  /// Plays full audio Athan with high priority notification.
  fullAthan,

  /// Plays short takbeerat audio cues with notification.
  takbeerOnly,

  /// Standard visual notification with device system tone only.
  notificationOnly,

  /// Silent visual notification without sound or vibration.
  silent,

  /// No notification or sound at all for this prayer.
  disabled,
}

extension PrayerNotificationModeX on PrayerNotificationMode {
  String get displayNameArabic {
    switch (this) {
      case PrayerNotificationMode.fullAthan:
        return 'أذان كامل';
      case PrayerNotificationMode.takbeerOnly:
        return 'تكبيرات فقط';
      case PrayerNotificationMode.notificationOnly:
        return 'إشعار فقط';
      case PrayerNotificationMode.silent:
        return 'صامت';
      case PrayerNotificationMode.disabled:
        return 'معطل';
    }
  }
}

/// Notification configuration for an individual prayer.
class PerPrayerNotificationSetting extends Equatable {
  final PrayerType prayerType;
  final PrayerNotificationMode mode;
  final String soundOptionId;
  final int preAthanMinutes;
  final int iqamaMinutes;

  const PerPrayerNotificationSetting({
    required this.prayerType,
    this.mode = PrayerNotificationMode.fullAthan,
    this.soundOptionId = 'abdulbasit',
    this.preAthanMinutes = 0,
    this.iqamaMinutes = 0,
  });

  PerPrayerNotificationSetting copyWith({
    PrayerType? prayerType,
    PrayerNotificationMode? mode,
    String? soundOptionId,
    int? preAthanMinutes,
    int? iqamaMinutes,
  }) {
    return PerPrayerNotificationSetting(
      prayerType: prayerType ?? this.prayerType,
      mode: mode ?? this.mode,
      soundOptionId: soundOptionId ?? this.soundOptionId,
      preAthanMinutes: preAthanMinutes ?? this.preAthanMinutes,
      iqamaMinutes: iqamaMinutes ?? this.iqamaMinutes,
    );
  }

  Map<String, dynamic> toJson() => {
        'prayerType': prayerType.name,
        'mode': mode.name,
        'soundOptionId': soundOptionId,
        'preAthanMinutes': preAthanMinutes,
        'iqamaMinutes': iqamaMinutes,
      };

  factory PerPrayerNotificationSetting.fromJson(Map<String, dynamic> json) {
    return PerPrayerNotificationSetting(
      prayerType: PrayerType.values.firstWhere(
        (t) => t.name == json['prayerType'],
        orElse: () => PrayerType.fajr,
      ),
      mode: PrayerNotificationMode.values.firstWhere(
        (m) => m.name == json['mode'],
        orElse: () => PrayerNotificationMode.fullAthan,
      ),
      soundOptionId: json['soundOptionId'] as String? ?? 'abdulbasit',
      preAthanMinutes: (json['preAthanMinutes'] as num?)?.toInt() ?? 0,
      iqamaMinutes: (json['iqamaMinutes'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  List<Object?> get props => [prayerType, mode, soundOptionId, preAthanMinutes, iqamaMinutes];
}

/// Comprehensive prayer notification and audio settings model.
class PrayerNotificationSettings extends Equatable {
  final double masterVolume;
  final bool isVibrationEnabled;
  final Map<PrayerType, PerPrayerNotificationSetting> perPrayerSettings;

  const PrayerNotificationSettings({
    this.masterVolume = 0.85,
    this.isVibrationEnabled = true,
    required this.perPrayerSettings,
  });

  /// Standard default configuration for all obligatory prayers.
  factory PrayerNotificationSettings.defaultSettings() {
    return PrayerNotificationSettings(
      masterVolume: 0.85,
      isVibrationEnabled: true,
      perPrayerSettings: {
        PrayerType.fajr: const PerPrayerNotificationSetting(
          prayerType: PrayerType.fajr,
          mode: PrayerNotificationMode.fullAthan,
        ),
        PrayerType.sunrise: const PerPrayerNotificationSetting(
          prayerType: PrayerType.sunrise,
          mode: PrayerNotificationMode.notificationOnly,
        ),
        PrayerType.dhuhr: const PerPrayerNotificationSetting(
          prayerType: PrayerType.dhuhr,
          mode: PrayerNotificationMode.fullAthan,
        ),
        PrayerType.asr: const PerPrayerNotificationSetting(
          prayerType: PrayerType.asr,
          mode: PrayerNotificationMode.fullAthan,
        ),
        PrayerType.maghrib: const PerPrayerNotificationSetting(
          prayerType: PrayerType.maghrib,
          mode: PrayerNotificationMode.fullAthan,
        ),
        PrayerType.isha: const PerPrayerNotificationSetting(
          prayerType: PrayerType.isha,
          mode: PrayerNotificationMode.fullAthan,
        ),
      },
    );
  }

  PerPrayerNotificationSetting getSettingFor(PrayerType type) {
    return perPrayerSettings[type] ??
        PerPrayerNotificationSetting(prayerType: type, mode: PrayerNotificationMode.fullAthan);
  }

  PrayerNotificationSettings copyWith({
    double? masterVolume,
    bool? isVibrationEnabled,
    Map<PrayerType, PerPrayerNotificationSetting>? perPrayerSettings,
  }) {
    return PrayerNotificationSettings(
      masterVolume: masterVolume ?? this.masterVolume,
      isVibrationEnabled: isVibrationEnabled ?? this.isVibrationEnabled,
      perPrayerSettings: perPrayerSettings ?? this.perPrayerSettings,
    );
  }

  PrayerNotificationSettings updatePrayerSetting(PerPrayerNotificationSetting setting) {
    final updated = Map<PrayerType, PerPrayerNotificationSetting>.from(perPrayerSettings);
    updated[setting.prayerType] = setting;
    return copyWith(perPrayerSettings: updated);
  }

  Map<String, dynamic> toJson() => {
        'masterVolume': masterVolume,
        'isVibrationEnabled': isVibrationEnabled,
        'perPrayerSettings': perPrayerSettings.map(
          (k, v) => MapEntry(k.name, v.toJson()),
        ),
      };

  factory PrayerNotificationSettings.fromJson(Map<String, dynamic> json) {
    final rawMap = json['perPrayerSettings'] as Map<String, dynamic>? ?? {};
    final perPrayer = <PrayerType, PerPrayerNotificationSetting>{};

    for (final type in PrayerType.values) {
      if (rawMap.containsKey(type.name)) {
        perPrayer[type] = PerPrayerNotificationSetting.fromJson(
          Map<String, dynamic>.from(rawMap[type.name] as Map),
        );
      } else {
        perPrayer[type] = PerPrayerNotificationSetting(prayerType: type);
      }
    }

    return PrayerNotificationSettings(
      masterVolume: (json['masterVolume'] as num?)?.toDouble() ?? 0.85,
      isVibrationEnabled: json['isVibrationEnabled'] as bool? ?? true,
      perPrayerSettings: perPrayer,
    );
  }

  @override
  List<Object?> get props => [masterVolume, isVibrationEnabled, perPrayerSettings];
}
