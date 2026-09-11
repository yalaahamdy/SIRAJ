import '../domain/quran_tafsir.dart';
import '../store/canonical_quran_loader.dart';

/// Service providing offline access to peer-reviewed, authentic Quranic exegesis (Tafsir).
abstract class QuranTafsirService {
  TafsirEdition get currentEdition;
  AyahTafsir? getTafsir(int surahNumber, int ayahNumber);
  List<AyahTafsir> getSurahTafsir(int surahNumber);
  List<AyahTafsir> getRangeTafsir(int surahNumber, int startAyah, int endAyah);
  bool get isAvailable;
}

class DefaultQuranTafsirService implements QuranTafsirService {
  final CanonicalTafsirPackage? _package;

  DefaultQuranTafsirService({CanonicalTafsirPackage? package})
      : _package = package ?? _resolveDefaultPackage();

  static CanonicalTafsirPackage? _resolveDefaultPackage() {
    try {
      return CanonicalQuranLoader.loadTafsirSync();
    } catch (_) {
      return null;
    }
  }

  CanonicalTafsirPackage? get _effectivePackage =>
      _package ?? CanonicalQuranLoader.cachedTafsirPackage;

  @override
  TafsirEdition get currentEdition =>
      _effectivePackage?.edition ?? TafsirEdition.alMuyassar;

  @override
  bool get isAvailable =>
      _effectivePackage != null && _effectivePackage!.tafsirsByKey.isNotEmpty;

  @override
  AyahTafsir? getTafsir(int surahNumber, int ayahNumber) {
    return _effectivePackage?.getTafsir(surahNumber, ayahNumber);
  }

  @override
  List<AyahTafsir> getSurahTafsir(int surahNumber) {
    final pkg = _effectivePackage;
    if (pkg == null) return const [];
    final results = <AyahTafsir>[];
    int ayah = 1;
    while (true) {
      final t = pkg.getTafsir(surahNumber, ayah);
      if (t == null) break;
      results.add(t);
      ayah++;
    }
    return results;
  }

  @override
  List<AyahTafsir> getRangeTafsir(int surahNumber, int startAyah, int endAyah) {
    final pkg = _effectivePackage;
    if (pkg == null) return const [];
    final results = <AyahTafsir>[];
    for (int a = startAyah; a <= endAyah; a++) {
      final t = pkg.getTafsir(surahNumber, a);
      if (t != null) results.add(t);
    }
    return results;
  }
}
