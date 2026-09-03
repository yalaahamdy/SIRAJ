import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../domain/ayah.dart';
import '../domain/ayah_key.dart';
import '../domain/juz_info.dart';
import '../domain/mushaf_page.dart';
import '../domain/surah.dart';
import 'canonical_quran_package.dart';

/// Read-only, immutable indexed store for canonical Quran data (§8, §9).
/// Enforces Fail-Closed cryptographic integrity verification on mount.
class ReadOnlyCanonicalQuranStore {
  CanonicalQuranPackage? _mountedPackage;

  // In-memory indexed lookups
  final Map<AyahKey, Ayah> _ayahIndex = {};
  final Map<int, List<Ayah>> _surahAyahsIndex = {};
  final Map<int, List<Ayah>> _pageAyahsIndex = {};
  final Map<int, List<Ayah>> _juzAyahsIndex = {};
  final Map<int, Surah> _surahIndex = {};
  final Map<int, JuzInfo> _juzIndex = {};

  bool get isMounted => _mountedPackage != null;
  String? get mountedPackageId => _mountedPackage?.packageId;
  String? get mountedEditionId => _mountedPackage?.edition.id;

  /// Mounts a canonical Quran package after rigorous cryptographic verification.
  /// If integrity verification fails, the store rejects the mount and fails closed.
  Result<bool, Failure> mountPackage(CanonicalQuranPackage package) {
    final verifyRes = package.verifyIntegrity();
    if (verifyRes.isFailure) {
      return Result.err(verifyRes.failureOrNull!);
    }

    _clearIndices();
    _mountedPackage = package;

    // Build Surahs Index
    for (final surah in package.surahs) {
      _surahIndex[surah.number] = surah;
      _surahAyahsIndex[surah.number] = [];
    }

    // Build Juzs Index
    for (final juz in package.juzs) {
      _juzIndex[juz.number] = juz;
      _juzAyahsIndex[juz.number] = [];
    }

    // Build Ayahs Index
    for (final ayah in package.ayahs) {
      _ayahIndex[ayah.key] = ayah;

      // Surah mapping
      _surahAyahsIndex.putIfAbsent(ayah.surahNumber, () => []).add(ayah);

      // Page mapping
      _pageAyahsIndex.putIfAbsent(ayah.pageNumber, () => []).add(ayah);

      // Juz mapping
      _juzAyahsIndex.putIfAbsent(ayah.juzNumber, () => []).add(ayah);
    }

    return Result.ok(true);
  }

  void unmount() {
    _clearIndices();
    _mountedPackage = null;
  }

  void _clearIndices() {
    _ayahIndex.clear();
    _surahAyahsIndex.clear();
    _pageAyahsIndex.clear();
    _juzAyahsIndex.clear();
    _surahIndex.clear();
    _juzIndex.clear();
  }

  /// Retrieves an Ayah by Surah number and Ayah number (O(1)).
  Result<Ayah, Failure> getAyah(int surahNumber, int ayahNumber) {
    if (!isMounted) {
      return Result.err(
        const ContentNotFoundFailure(
          message: 'No canonical Quran package mounted',
          code: 'PACKAGE_NOT_MOUNTED',
        ),
      );
    }

    final key = AyahKey(surahNumber: surahNumber, ayahNumber: ayahNumber);
    final ayah = _ayahIndex[key];
    if (ayah == null) {
      return Result.err(
        ContentNotFoundFailure(
          message: 'Ayah not found: $surahNumber:$ayahNumber',
          code: 'AYAH_NOT_FOUND',
        ),
      );
    }

    return Result.ok(ayah);
  }

  /// Retrieves all Ayahs of a given Surah (O(1)).
  Result<List<Ayah>, Failure> getSurahAyahs(int surahNumber) {
    if (!isMounted) {
      return Result.err(
        const ContentNotFoundFailure(
          message: 'No canonical Quran package mounted',
          code: 'PACKAGE_NOT_MOUNTED',
        ),
      );
    }

    final list = _surahAyahsIndex[surahNumber];
    if (list == null || list.isEmpty) {
      return Result.err(
        ContentNotFoundFailure(
          message: 'Surah not found or has no ayahs: $surahNumber',
          code: 'SURAH_NOT_FOUND',
        ),
      );
    }

    return Result.ok(List.unmodifiable(list));
  }

  /// Retrieves all Ayahs on a given Mushaf page (1..604).
  Result<List<Ayah>, Failure> getPageAyahs(int pageNumber) {
    if (!isMounted) {
      return Result.err(
        const ContentNotFoundFailure(
          message: 'No canonical Quran package mounted',
          code: 'PACKAGE_NOT_MOUNTED',
        ),
      );
    }

    final list = _pageAyahsIndex[pageNumber];
    if (list == null || list.isEmpty) {
      return Result.err(
        ContentNotFoundFailure(
          message: 'Page not found or empty: $pageNumber',
          code: 'PAGE_NOT_FOUND',
        ),
      );
    }

    return Result.ok(List.unmodifiable(list));
  }

  /// Retrieves structured [MushafPage] model with header metadata.
  Result<MushafPage, Failure> getPage(int pageNumber) {
    final ayahsRes = getPageAyahs(pageNumber);
    if (ayahsRes.isFailure) return Result.err(ayahsRes.failureOrNull!);

    final ayahs = ayahsRes.valueOrNull!;
    final distinctSurahNumbers = ayahs.map((a) => a.surahNumber).toSet();
    final surahNames = distinctSurahNumbers
        .map((sNum) => _surahIndex[sNum]?.nameArabic ?? 'سورة $sNum')
        .toList();

    final firstAyah = ayahs.first;
    return Result.ok(
      MushafPage(
        pageNumber: pageNumber,
        juzNumber: firstAyah.juzNumber,
        hizbNumber: firstAyah.hizbNumber,
        surahNames: surahNames,
        ayahs: ayahs,
      ),
    );
  }

  /// Retrieves all Surahs list.
  Result<List<Surah>, Failure> getAllSurahs() {
    if (!isMounted) {
      return Result.err(
        const ContentNotFoundFailure(
          message: 'No canonical Quran package mounted',
          code: 'PACKAGE_NOT_MOUNTED',
        ),
      );
    }

    return Result.ok(_mountedPackage!.surahs);
  }

  /// Retrieves single Surah metadata.
  Result<Surah, Failure> getSurah(int surahNumber) {
    if (!isMounted) {
      return Result.err(
        const ContentNotFoundFailure(
          message: 'No canonical Quran package mounted',
          code: 'PACKAGE_NOT_MOUNTED',
        ),
      );
    }

    final surah = _surahIndex[surahNumber];
    if (surah == null) {
      return Result.err(
        ContentNotFoundFailure(
          message: 'Surah not found: $surahNumber',
          code: 'SURAH_NOT_FOUND',
        ),
      );
    }

    return Result.ok(surah);
  }

  /// Retrieves all Juzs list.
  Result<List<JuzInfo>, Failure> getAllJuzs() {
    if (!isMounted) {
      return Result.err(
        const ContentNotFoundFailure(
          message: 'No canonical Quran package mounted',
          code: 'PACKAGE_NOT_MOUNTED',
        ),
      );
    }

    return Result.ok(_mountedPackage!.juzs);
  }

  /// Retrieves all Ayahs in a given Juz (1..30).
  Result<List<Ayah>, Failure> getJuzAyahs(int juzNumber) {
    if (!isMounted) {
      return Result.err(
        const ContentNotFoundFailure(
          message: 'No canonical Quran package mounted',
          code: 'PACKAGE_NOT_MOUNTED',
        ),
      );
    }

    final list = _juzAyahsIndex[juzNumber];
    if (list == null || list.isEmpty) {
      return Result.err(
        ContentNotFoundFailure(
          message: 'Juz not found or empty: $juzNumber',
          code: 'JUZ_NOT_FOUND',
        ),
      );
    }

    return Result.ok(List.unmodifiable(list));
  }
}
