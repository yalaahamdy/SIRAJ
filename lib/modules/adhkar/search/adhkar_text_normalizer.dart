/// Pure function utility for normalizing Arabic text strictly for searching and indexing (§12, §23).
class AdhkarTextNormalizer {
  const AdhkarTextNormalizer._();

  // Arabic Tashkeel regex range
  static final RegExp _diacriticsRegex = RegExp(r'[\u064B-\u065F\u0670\u06D6-\u06ED]');

  static String normalize(String input) {
    if (input.isEmpty) return '';

    // 1. Strip diacritics
    var text = input.replaceAll(_diacriticsRegex, '');

    // 2. Normalize Alef variants
    text = text
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ٱ', 'ا');

    // 3. Normalize Taa Marbuta & Haa
    text = text.replaceAll('ة', 'ه');

    // 4. Normalize Alef Maksura & Yaa
    text = text.replaceAll('ى', 'ي');

    // 5. Normalize whitespace and trim
    return text.replaceAll(RegExp(r'\s+'), ' ').trim().toLowerCase();
  }
}
