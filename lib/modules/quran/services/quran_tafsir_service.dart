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

  @override
  TafsirEdition get currentEdition =>
      _package?.edition ?? TafsirEdition.alMuyassar;

  @override
  bool get isAvailable => _package != null && _package.tafsirsByKey.isNotEmpty;

  @override
  AyahTafsir? getTafsir(int surahNumber, int ayahNumber) {
    return _package?.getTafsir(surahNumber, ayahNumber);
  }

  @override
  List<AyahTafsir> getSurahTafsir(int surahNumber) {
    if (_package == null) return const [];
    final results = <AyahTafsir>[];
    int ayah = 1;
    while (true) {
      final t = _package.getTafsir(surahNumber, ayah);
      if (t == null) break;
      results.add(t);
      ayah++;
    }
    return results;
  }

  @override
  List<AyahTafsir> getRangeTafsir(int surahNumber, int startAyah, int endAyah) {
    if (_package == null) return const [];
    final results = <AyahTafsir>[];
    for (int a = startAyah; a <= endAyah; a++) {
      final t = _package.getTafsir(surahNumber, a);
      if (t != null) results.add(t);
    }
    return results;
  }
}
