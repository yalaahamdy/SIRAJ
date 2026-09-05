import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../../core/storage/storage_contract.dart';
import '../../../../modules/quran/domain/quran_reader_modes.dart';
import '../../../../modules/quran/services/quran_typography_service.dart';

/// Single source of truth for Quran reader settings and typography state (§10, §11, §12).
/// Enforces immutable copy-with semantics and persists to local module storage.
class QuranReaderSettingsController extends ChangeNotifier {
  static const String settingsStorageKey = 'quran_reader_settings_v1';

  final KeyValueStore? _store;
  QuranTypographyConfig _state;

  QuranReaderSettingsController({
    KeyValueStore? store,
    QuranTypographyConfig? initialConfig,
  })  : _store = store,
        _state = initialConfig ?? const QuranTypographyConfig() {
    _loadFromStorage();
  }

  QuranTypographyConfig get state => _state;

  Future<void> _loadFromStorage() async {
    if (_store == null) return;
    try {
      final res = await _store.getString(settingsStorageKey);
      if (res.isSuccess && res.valueOrNull != null) {
        final Map<String, dynamic> json = jsonDecode(res.valueOrNull!);
        _state = QuranTypographyConfig.fromJson(json);
        notifyListeners();
      }
    } catch (_) {
      // Graceful fallback to default on corrupted storage
    }
  }

  Future<void> _persist() async {
    if (_store == null) return;
    try {
      final encoded = jsonEncode(_state.toJson());
      await _store.setString(settingsStorageKey, encoded);
    } catch (_) {
      // Non-fatal persistence error
    }
  }

  void updateConfig(QuranTypographyConfig newConfig) {
    _state = newConfig;
    notifyListeners();
    _persist();
  }

  void setFontFamily(QuranFontFamily fontFamily) {
    _state = _state.copyWith(fontFamily: fontFamily);
    notifyListeners();
    _persist();
  }

  void setFontSize(double fontSize) {
    _state = _state.copyWith(fontSize: fontSize);
    notifyListeners();
    _persist();
  }

  void setLineHeight(double lineHeight) {
    _state = _state.copyWith(lineHeight: lineHeight);
    notifyListeners();
    _persist();
  }

  void setReaderMode(QuranReaderMode readerMode) {
    _state = _state.copyWith(readerMode: readerMode);
    notifyListeners();
    _persist();
  }

  void setThemeMode(QuranReaderThemeMode themeMode) {
    _state = _state.copyWith(themeMode: themeMode);
    notifyListeners();
    _persist();
  }

  void setShowTajweed(bool showTajweed) {
    _state = _state.copyWith(showTajweed: showTajweed);
    notifyListeners();
    _persist();
  }

  void setShowTranslation(bool showTranslation) {
    _state = _state.copyWith(showTranslation: showTranslation);
    notifyListeners();
    _persist();
  }

  void setShowWordByWord(bool showWordByWord) {
    _state = _state.copyWith(showWordByWord: showWordByWord);
    notifyListeners();
    _persist();
  }

  void setAutoScroll(bool autoScroll) {
    _state = _state.copyWith(autoScroll: autoScroll);
    notifyListeners();
    _persist();
  }

  void setReciter(String reciter) {
    _state = _state.copyWith(reciter: reciter);
    notifyListeners();
    _persist();
  }

  void setPlaybackSpeed(double playbackSpeed) {
    _state = _state.copyWith(playbackSpeed: playbackSpeed);
    notifyListeners();
    _persist();
  }

  void setRepeatCount(int repeatCount) {
    _state = _state.copyWith(repeatCount: repeatCount);
    notifyListeners();
    _persist();
  }

  void setMaxWidth(double maxWidth) {
    _state = _state.copyWith(maxWidth: maxWidth);
    notifyListeners();
    _persist();
  }

  void setShowTafsir(bool showTafsir) {
    _state = _state.copyWith(showTafsir: showTafsir);
    notifyListeners();
    _persist();
  }

  void setPageTurnMode(QuranPageTurnMode pageTurnMode) {
    _state = _state.copyWith(pageTurnMode: pageTurnMode);
    notifyListeners();
    _persist();
  }

  void togglePageTurnMode() {
    final next = _state.pageTurnMode == QuranPageTurnMode.vertical
        ? QuranPageTurnMode.horizontal
        : QuranPageTurnMode.vertical;
    setPageTurnMode(next);
  }

  void setTranslationLanguage(String translationLanguage) {
    _state = _state.copyWith(translationLanguage: translationLanguage);
    notifyListeners();
    _persist();
  }
}
