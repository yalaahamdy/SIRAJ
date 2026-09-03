/// Utility dedicated STRICTLY to search query & index normalization (§10, §11, §23).
/// MUST NEVER be applied to the canonical display text.
class QuranTextNormalizer {
  const QuranTextNormalizer();

  // Arabic Harakat and Quranic annotation marks Unicode ranges
  static final RegExp _tashkeelRegex = RegExp(r'[\u064B-\u065F\u0670\u06D6-\u06ED\u06DF-\u06E8]');
  static final RegExp _tatweelRegex = RegExp(r'\u0640');

  /// Normalizes an Arabic string for keyword and sub-string search matching.
  /// Removes diacritics, unifies alef forms, and strips Quranic pause marks.
  static String normalizeForSearch(String input) {
    if (input.isEmpty) return '';

    var text = input;

    // 0. Handle Quranic dagger alifs (superscript alef \u0670)
    // Common exceptions where modern Arabic omits the alif in search queries:
    text = text
        .replaceAll(RegExp(r'مَ?\u0670ن'), 'من') // الرحمن -> الرحمن
        .replaceAll(RegExp(r'هَ?\u0670ذ'), 'هذ') // هذا -> هذا
        .replaceAll(RegExp(r'ذَ?\u0670ل'), 'ذل') // ذلك -> ذلك
        .replaceAll(RegExp(r'لَ?\u0670ك'), 'لك') // لكن -> لكن
        .replaceAll(RegExp(r'لَ?\u0670ه'), 'له'); // إله -> اله

    // For all other words (e.g. العالمين, صراط, اسماعيل, السماوات), dagger alif represents standard 'ا'
    text = text.replaceAll('\u0670', 'ا');

    // 1. Remove Tashkeel and Quranic signs
    text = text.replaceAll(_tashkeelRegex, '');

    // 2. Remove Tatweel / Kashida
    text = text.replaceAll(_tatweelRegex, '');

    // 3. Normalize Alef forms (أ, إ, آ, ٱ -> ا)
    text = text.replaceAll(RegExp(r'[أإآٱ]'), 'ا');

    // 4. Normalize Taa Marbuta (ة -> ه)
    text = text.replaceAll('ة', 'ه');

    // 5. Normalize Alif Maqsura (ى -> ي)
    text = text.replaceAll('ى', 'ي');

    // 6. Normalize Hamza on Waw / Yaa (ؤ -> و, ئ -> ي)
    text = text.replaceAll('ؤ', 'و');
    text = text.replaceAll('ئ', 'ي');

    // 7. Collapse excess whitespace
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();

    return text;
  }
}
