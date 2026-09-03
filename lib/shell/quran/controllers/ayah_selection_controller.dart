import 'package:flutter/foundation.dart';

/// Selection and contextual action lifecycle states for the Quran Reader (§12, §15, §16).
enum AyahSelectionState {
  none,
  selected,
  multiSelected,
  playing,
  bookmarking,
  sharing,
  showingTafsir,
  showingTranslation,
  showingWordByWord,
}

/// Controller governing single and multi-ayah selection, ranges, and action modes.
class AyahSelectionController extends ChangeNotifier {
  AyahSelectionState _state = AyahSelectionState.none;
  int? _surahNumber;
  int? _selectedAyah;
  int? _rangeStart;
  int? _rangeEnd;
  final Set<int> _selectedAyahs = <int>{};

  AyahSelectionState get state => _state;
  int? get surahNumber => _surahNumber;
  int? get selectedAyah => _selectedAyah;
  int? get rangeStart => _rangeStart;
  int? get rangeEnd => _rangeEnd;
  Set<int> get selectedAyahs => Set.unmodifiable(_selectedAyahs);

  bool get hasSelection =>
      _state != AyahSelectionState.none &&
      (_selectedAyah != null || _selectedAyahs.isNotEmpty);

  bool get isRangeSelection =>
      _state == AyahSelectionState.multiSelected &&
      _rangeStart != null &&
      _rangeEnd != null;

  /// Selects a single Ayah with instant visual feedback and opens quick toolbar.
  void selectAyah(int surah, int ayah) {
    if (_surahNumber == surah &&
        _selectedAyah == ayah &&
        _state == AyahSelectionState.selected) {
      clearSelection();
      return;
    }

    _surahNumber = surah;
    _selectedAyah = ayah;
    _rangeStart = null;
    _rangeEnd = null;
    _selectedAyahs
      ..clear()
      ..add(ayah);
    _state = AyahSelectionState.selected;
    notifyListeners();
  }

  /// Establishes a contiguous selection range (e.g. Ayahs 5..9).
  void selectRange(int surah, int startAyah, int endAyah) {
    _surahNumber = surah;
    final minA = startAyah <= endAyah ? startAyah : endAyah;
    final maxA = startAyah <= endAyah ? endAyah : startAyah;

    _rangeStart = minA;
    _rangeEnd = maxA;
    _selectedAyah = minA;
    _selectedAyahs.clear();

    for (int a = minA; a <= maxA; a++) {
      _selectedAyahs.add(a);
    }

    _state = AyahSelectionState.multiSelected;
    notifyListeners();
  }

  /// Toggles individual Ayah membership in a multi-selection set.
  void toggleAyah(int surah, int ayah) {
    if (_surahNumber != surah) {
      _surahNumber = surah;
      _selectedAyahs.clear();
    }

    if (_selectedAyahs.contains(ayah)) {
      _selectedAyahs.remove(ayah);
      if (_selectedAyahs.isEmpty) {
        clearSelection();
        return;
      }
    } else {
      _selectedAyahs.add(ayah);
    }

    _selectedAyah = _selectedAyahs.first;
    _state = _selectedAyahs.length > 1
        ? AyahSelectionState.multiSelected
        : AyahSelectionState.selected;
    notifyListeners();
  }

  /// Sets the active contextual action state (e.g. showingTafsir, playing).
  void setActionState(AyahSelectionState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }

  /// Checks if a given Ayah is currently selected or part of the active range.
  bool isAyahSelected(int ayah) {
    return _selectedAyahs.contains(ayah);
  }

  /// Deselects all active verses and restores neutral reader state.
  void clearSelection() {
    if (_state == AyahSelectionState.none &&
        _selectedAyah == null &&
        _selectedAyahs.isEmpty) {
      return;
    }
    _state = AyahSelectionState.none;
    _selectedAyah = null;
    _rangeStart = null;
    _rangeEnd = null;
    _selectedAyahs.clear();
    notifyListeners();
  }
}
