import 'package:equatable/equatable.dart';

/// Represents available Athan audio options in the application (§32).
class AthanSoundOption extends Equatable {
  final String id;
  final String displayNameArabic;
  final String displayNameEnglish;
  final String reciterNameArabic;
  final String assetPath;
  final bool isDefault;

  const AthanSoundOption({
    required this.id,
    required this.displayNameArabic,
    required this.displayNameEnglish,
    required this.reciterNameArabic,
    required this.assetPath,
    this.isDefault = false,
  });

  /// Canonical default: Sheikh Abdulbasit Abdulsamad.
  static const AthanSoundOption abdulbasit = AthanSoundOption(
    id: 'abdulbasit',
    displayNameArabic: 'أذان الشيخ عبد الباسط عبد الصمد',
    displayNameEnglish: 'Athan - Sheikh Abdulbasit Abdulsamad',
    reciterNameArabic: 'الشيخ عبد الباسط عبد الصمد',
    assetPath: 'assets/audio/athan_abdulbasit.mp3',
    isDefault: true,
  );

  /// Canonical short takbeerat.
  static const AthanSoundOption takbeerOnly = AthanSoundOption(
    id: 'takbeer_only',
    displayNameArabic: 'تكبيرات فقط',
    displayNameEnglish: 'Takbeerat Only',
    reciterNameArabic: 'تكبيرات مختصرة',
    assetPath: 'assets/audio/athan_abdulbasit.mp3', // Uses main asset with duration cue
  );

  /// All available canonical sound options.
  static const List<AthanSoundOption> availableOptions = [
    abdulbasit,
    takbeerOnly,
  ];

  static AthanSoundOption fromId(String id) {
    return availableOptions.firstWhere(
      (opt) => opt.id == id,
      orElse: () => abdulbasit,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'displayNameArabic': displayNameArabic,
        'displayNameEnglish': displayNameEnglish,
        'reciterNameArabic': reciterNameArabic,
        'assetPath': assetPath,
        'isDefault': isDefault,
      };

  factory AthanSoundOption.fromJson(Map<String, dynamic> json) {
    return AthanSoundOption(
      id: json['id'] as String? ?? 'abdulbasit',
      displayNameArabic: json['displayNameArabic'] as String? ?? 'أذان الشيخ عبد الباسط عبد الصمد',
      displayNameEnglish: json['displayNameEnglish'] as String? ?? 'Athan - Sheikh Abdulbasit',
      reciterNameArabic: json['reciterNameArabic'] as String? ?? 'الشيخ عبد الباسط عبد الصمد',
      assetPath: json['assetPath'] as String? ?? 'assets/audio/athan_abdulbasit.mp3',
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [id, displayNameArabic, assetPath, isDefault];
}
