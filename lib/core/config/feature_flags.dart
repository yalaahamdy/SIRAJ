import 'package:equatable/equatable.dart';

/// Feature flags controlling availability of modules and capabilities.
/// Default flags keep experimental / unbuilt modules safely disabled.
class FeatureFlags extends Equatable {
  final bool enablePrayerModule;
  final bool enableQuranModule;
  final bool enableAdhkarModule;
  final bool enableZakatModule;
  final bool enableAiCompanion;
  final bool enableAnalytics;
  final bool enableOfflineSync;

  const FeatureFlags({
    this.enablePrayerModule = false,
    this.enableQuranModule = false,
    this.enableAdhkarModule = false,
    this.enableZakatModule = false,
    this.enableAiCompanion = false,
    this.enableAnalytics = false,
    this.enableOfflineSync = false,
  });

  /// Foundation Phase 1 default flags: All downstream features are disabled
  static const FeatureFlags foundationDefaults = FeatureFlags(
    enablePrayerModule: false,
    enableQuranModule: false,
    enableAdhkarModule: false,
    enableZakatModule: false,
    enableAiCompanion: false,
    enableAnalytics: false,
    enableOfflineSync: false,
  );

  FeatureFlags copyWith({
    bool? enablePrayerModule,
    bool? enableQuranModule,
    bool? enableAdhkarModule,
    bool? enableZakatModule,
    bool? enableAiCompanion,
    bool? enableAnalytics,
    bool? enableOfflineSync,
  }) {
    return FeatureFlags(
      enablePrayerModule: enablePrayerModule ?? this.enablePrayerModule,
      enableQuranModule: enableQuranModule ?? this.enableQuranModule,
      enableAdhkarModule: enableAdhkarModule ?? this.enableAdhkarModule,
      enableZakatModule: enableZakatModule ?? this.enableZakatModule,
      enableAiCompanion: enableAiCompanion ?? this.enableAiCompanion,
      enableAnalytics: enableAnalytics ?? this.enableAnalytics,
      enableOfflineSync: enableOfflineSync ?? this.enableOfflineSync,
    );
  }

  @override
  List<Object?> get props => [
        enablePrayerModule,
        enableQuranModule,
        enableAdhkarModule,
        enableZakatModule,
        enableAiCompanion,
        enableAnalytics,
        enableOfflineSync,
      ];
}
