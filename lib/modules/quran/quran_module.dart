import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/storage/storage_contract.dart';
import '../../../core/time/clock.dart';
import '../../../platform/content/domain/content_record.dart';
import '../../../platform/content/domain/content_status.dart';
import '../../../platform/content/domain/content_type.dart';
import '../../../platform/content/domain/source_ref.dart';
import '../contracts/quran_contract.dart';
import 'domain/ayah.dart';
import 'domain/mushaf_page.dart';
import 'domain/quran_bookmark.dart';
import 'domain/quran_reading_progress.dart';
import 'domain/surah.dart';
import 'recitation/services/quran_recitation_session_store.dart';
import 'search/quran_search_engine.dart';
import 'services/cairo_radio_audio_service.dart';
import 'services/quran_audio_service.dart';
import 'services/quran_offline_audio_service.dart';
import 'services/quran_reader_service.dart';
import 'services/quran_tafsir_service.dart';
import 'services/quran_user_data_service.dart';
import 'services/sharawy_audio_service.dart';
import 'services/sharawy_offline_audio_service.dart';
import 'store/canonical_quran_package.dart';
import 'store/canonical_quran_store.dart';
import 'store/quran_content_diff_engine.dart';
import 'store/sharawy_store.dart';

/// Unified Module Facade for the Quran Subsystem (L2).
/// Implements [QuranModuleContract] and encapsulates all Quran store, reader, audio, and user data services.
class QuranModule implements QuranModuleContract {
  final ReadOnlyCanonicalQuranStore store;
  final QuranUserDataService userDataService;
  final QuranSearchEngine searchEngine;
  final QuranReaderService readerService;
  final QuranAudioService audioService;
  final QuranOfflineAudioService offlineAudioService;
  final CairoRadioAudioService radioService;
  final QuranTafsirService tafsirService;
  final QuranContentDiffEngine diffEngine;
  final StorageRegistry storageRegistry;
  final QuranRecitationSessionStore recitationSessionStore;
  final SharawyStore sharawyStore;
  final SharawyAudioService sharawyAudioService;
  final SharawyOfflineAudioService sharawyOfflineAudioService;

  QuranModule({
    required StorageRegistry storageRegistry,
    Clock? clock,
    ReadOnlyCanonicalQuranStore? storeInstance,
    QuranAudioService? audioServiceInstance,
    QuranTafsirService? tafsirServiceInstance,
    CairoRadioAudioService? radioServiceInstance,
    SharawyStore? sharawyStoreInstance,
    SharawyAudioService? sharawyAudioServiceInstance,
  }) : this._internal(
          store: storeInstance ?? ReadOnlyCanonicalQuranStore(),
          storageRegistry: storageRegistry,
          clock: clock,
          audioService: audioServiceInstance,
          tafsirService: tafsirServiceInstance,
          radioService: radioServiceInstance,
          sharawyStore: sharawyStoreInstance,
          sharawyAudioService: sharawyAudioServiceInstance,
        );

  QuranModule._internal({
    required this.store,
    required this.storageRegistry,
    Clock? clock,
    QuranAudioService? audioService,
    QuranTafsirService? tafsirService,
    CairoRadioAudioService? radioService,
    SharawyStore? sharawyStore,
    SharawyAudioService? sharawyAudioService,
  })  : recitationSessionStore = QuranRecitationSessionStore(
          storageRegistry: storageRegistry,
        ),
        userDataService = QuranUserDataService(
          storageRegistry: storageRegistry,
          clock: clock,
        ),
        searchEngine = QuranSearchEngine(store: store),
        readerService = QuranReaderService(
          store: store,
          userDataService: QuranUserDataService(
            storageRegistry: storageRegistry,
            clock: clock,
          ),
          searchEngine: QuranSearchEngine(store: store),
        ),
        audioService = audioService ?? QuranAudioService(store: store),
        offlineAudioService = QuranOfflineAudioService.instance..init(),
        radioService = radioService ?? CairoRadioAudioService(),
        sharawyStore = sharawyStore ?? SharawyStore(),
        sharawyAudioService = sharawyAudioService ?? SharawyAudioService(),
        sharawyOfflineAudioService = SharawyOfflineAudioService.instance..init(),
        tafsirService = tafsirService ?? DefaultQuranTafsirService(),
        diffEngine = QuranContentDiffEngine(clock: clock) {
    // Coordinate mutual audio exclusivity
    this.radioService.onPlaybackStarted = () {
      this.audioService.stop();
      this.sharawyAudioService.pause();
    };
    this.sharawyAudioService.onPlaybackStarted = () {
      this.radioService.pause();
      this.audioService.stop();
    };
    this.audioService.reportStream.listen((report) {
      if (report.status == AudioPlaybackStatus.playing) {
        this.radioService.pause();
        this.sharawyAudioService.pause();
      }
    });
  }

  /// Mounts a canonical Quran package into the module.
  Result<bool, Failure> mountPackage(CanonicalQuranPackage package) {
    final mountRes = store.mountPackage(package);
    if (mountRes.isSuccess) {
      searchEngine.rebuildIndex();
    }
    return mountRes;
  }

  @override
  Future<Result<ContentRecord, Failure>> getAyah({
    required int surahNumber,
    required int ayahNumber,
  }) async {
    final res = store.getAyah(surahNumber, ayahNumber);
    if (res.isFailure) return Result.err(res.failureOrNull!);

    final ayah = res.valueOrNull!;
    final record = ContentRecord(
      contentId: ayah.key.toCanonicalId(store.mountedEditionId ?? 'uthmani_hafs'),
      contentType: ContentType.quran,
      text: ayah.textUthmani,
      sources: const [
        SourceRef(
          reference: 'مصحف المدينة النبوية — مجمع الملك فهد لطباعة المصحف الشريف (Tanzil)',
        ),
      ],
      status: ContentStatus.locked,
      version: 1,
      integrityHash: ayah.integrityHash,
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
      metadata: {
        'surah_number': ayah.surahNumber,
        'ayah_number': ayah.ayahNumber,
        'juz': ayah.juzNumber,
        'hizb': ayah.hizbNumber,
        'rub': ayah.rubNumber,
        'page': ayah.pageNumber,
        'has_sajdah': ayah.hasSajdah,
      },
    );

    return Result.ok(record);
  }

  @override
  Future<Result<List<ContentRecord>, Failure>> getPageAyahs(int pageNumber) async {
    final res = store.getPageAyahs(pageNumber);
    if (res.isFailure) return Result.err(res.failureOrNull!);

    final list = res.valueOrNull!;
    final records = list.map((ayah) {
      return ContentRecord(
        contentId: ayah.key.toCanonicalId(store.mountedEditionId ?? 'uthmani_hafs'),
        contentType: ContentType.quran,
        text: ayah.textUthmani,
        sources: const [
          SourceRef(
            reference: 'مصحف المدينة النبوية — مجمع الملك فهد لطباعة المصحف الشريف (Tanzil)',
          ),
        ],
        status: ContentStatus.locked,
        version: 1,
        integrityHash: ayah.integrityHash,
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 1, 1),
        metadata: {
          'surah_number': ayah.surahNumber,
          'ayah_number': ayah.ayahNumber,
          'juz': ayah.juzNumber,
          'hizb': ayah.hizbNumber,
          'rub': ayah.rubNumber,
          'page': ayah.pageNumber,
          'has_sajdah': ayah.hasSajdah,
        },
      );
    }).toList();

    return Result.ok(List.unmodifiable(records));
  }

  Result<List<Surah>, Failure> getAllSurahs() => readerService.getAllSurahs();
  Result<Surah, Failure> getSurah(int surahNumber) => readerService.getSurah(surahNumber);
  Result<List<Ayah>, Failure> getSurahAyahs(int surahNumber) => readerService.getSurahAyahs(surahNumber);
  Result<MushafPage, Failure> getPage(int pageNumber) => readerService.getPage(pageNumber);
  Result<List<QuranSearchResult>, Failure> search(String query, {int? surahNumber, int limit = 50}) =>
      readerService.search(query, surahNumber: surahNumber, limit: limit);
  Future<Result<QuranReadingProgress, Failure>> getReadingProgress() => readerService.getReadingProgress();
  Future<Result<QuranReadingProgress, Failure>> updateReadingPosition({
    required int surahNumber,
    required int ayahNumber,
    required int pageNumber,
    required String surahNameArabic,
  }) =>
      readerService.updateReadingPosition(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        pageNumber: pageNumber,
        surahNameArabic: surahNameArabic,
      );
  Future<Result<QuranBookmark, Failure>> addBookmark({
    required int surahNumber,
    required int ayahNumber,
    required int pageNumber,
    required String surahNameArabic,
    required String ayahSnippet,
    String? note,
  }) =>
      readerService.addBookmark(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        pageNumber: pageNumber,
        surahNameArabic: surahNameArabic,
        ayahSnippet: ayahSnippet,
        note: note,
      );
  Future<Result<List<QuranBookmark>, Failure>> getBookmarks() => readerService.getBookmarks();
  Future<Result<bool, Failure>> deleteBookmark(String bookmarkId) => readerService.deleteBookmark(bookmarkId);
}
