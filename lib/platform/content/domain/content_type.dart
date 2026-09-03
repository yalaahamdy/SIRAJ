/// Content taxonomy defined in SACRED_CONTENT_POLICY.md.
enum ContentType {
  quran,
  hadith,
  dhikr,
  dua,
  ruling,
  scholarQuote,
  info,
  testFixture, // Used strictly for synthetic golden tests
}

extension ContentTypeX on ContentType {
  bool get isSacred {
    switch (this) {
      case ContentType.quran:
      case ContentType.hadith:
      case ContentType.dhikr:
      case ContentType.dua:
      case ContentType.ruling:
      case ContentType.scholarQuote:
        return true;
      case ContentType.info:
      case ContentType.testFixture:
        return false;
    }
  }
}
