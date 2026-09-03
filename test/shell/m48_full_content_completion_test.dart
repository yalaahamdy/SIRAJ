import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/fasting/domain/fasting_guide_topic.dart';
import 'package:siraj/modules/zakat/domain/zakat_guide_topic.dart';
import 'package:siraj/shell/seed/default_canonical_seed_provider.dart';

void main() {
  group('M48: SIRAJ v1.0 — Full Content Completion Verification (§1..§20)', () {
    test('Quran: Package contains 114 Surahs, 30 Juzs, and core authentic verses', () {
      final quran = DefaultCanonicalSeedProvider.getQuranSeedPackage();
      expect(quran.surahs.length, equals(114), reason: 'Must contain all 114 Surahs');
      expect(quran.juzs.length, equals(30), reason: 'Must contain all 30 Juzs');
      expect(quran.ayahs.length, greaterThanOrEqualTo(45), reason: 'Must contain full sets of core and daily surahs');
      expect(quran.contentHash.startsWith('sha256:'), isTrue);

      // Verify Surah 1 (Al-Fatihah) has all 7 verses
      final fatihahAyahs = quran.ayahs.where((a) => a.surahNumber == 1).toList();
      expect(fatihahAyahs.length, equals(7));

      // Verify Surah 112 (Al-Ikhlas) has all 4 verses
      final ikhlasAyahs = quran.ayahs.where((a) => a.surahNumber == 112).toList();
      expect(ikhlasAyahs.length, equals(4));

      // Verify Surah 114 (An-Nas) has all 6 verses
      final nasAyahs = quran.ayahs.where((a) => a.surahNumber == 114).toList();
      expect(nasAyahs.length, equals(6));
    });

    test('Adhkar: Package contains 35+ authentic, provenance-backed items across all occasions', () {
      final adhkar = DefaultCanonicalSeedProvider.getAdhkarSeedPackage();
      expect(adhkar.items.length, greaterThanOrEqualTo(35), reason: 'Must contain at least 35 authentic adhkar');

      for (final item in adhkar.items) {
        expect(item.id.isNotEmpty, isTrue);
        expect(item.textArabic.isNotEmpty, isTrue);
        expect(item.sourceTitle.isNotEmpty, isTrue);
        expect(item.reference.isNotEmpty, isTrue);
        expect(item.repetition.count, greaterThan(0));
        expect(item.verifyHash(), isTrue, reason: 'Hash must match item integrity for ${item.id}');
      }
    });

    test('Knowledge: Package contains 15+ hadiths and 8+ comparative fiqh topics', () {
      final knowledge = DefaultCanonicalSeedProvider.getKnowledgeSeedPackage();
      expect(knowledge.hadiths.length, greaterThanOrEqualTo(15), reason: 'Must contain at least 15 authenticated hadiths');
      expect(knowledge.fiqhTopics.length, greaterThanOrEqualTo(8), reason: 'Must contain at least 8 fiqh topics');

      for (final hadith in knowledge.hadiths) {
        expect(hadith.arabicMatn.isNotEmpty, isTrue);
        expect(hadith.isnad?.isNotEmpty ?? false, isTrue);
        expect(hadith.gradings.isNotEmpty, isTrue);
        expect(hadith.verifyHash(), isTrue);
      }

      for (final topic in knowledge.fiqhTopics) {
        expect(topic.positions.length, greaterThanOrEqualTo(1));
        expect(topic.verifyHash(), isTrue);
      }
    });

    test('Learning: Package contains 3 complete courses, 8 lessons, and 3 quizzes', () {
      final learning = DefaultCanonicalSeedProvider.getLearningSeedPackage();
      expect(learning.paths.length, equals(3));
      expect(learning.courses.length, equals(3));
      expect(learning.lessons.length, equals(8));
      expect(learning.quizzes.length, equals(3));

      for (final lesson in learning.lessons) {
        expect(lesson.sections.isNotEmpty, isTrue);
        expect(lesson.objectives.isNotEmpty, isTrue);
      }

      for (final quiz in learning.quizzes) {
        expect(quiz.questions.isNotEmpty, isTrue);
        expect(quiz.verifyHash(), isTrue);
      }
    });

    test('Seerah: Package contains 3 periods, 12 pivotal events, 8 persons, and 6 places', () {
      final seerah = DefaultCanonicalSeedProvider.getSeerahSeedPackage();
      expect(seerah.periods.length, equals(3));
      expect(seerah.events.length, greaterThanOrEqualTo(12));
      expect(seerah.persons.length, equals(8));
      expect(seerah.places.length, equals(6));

      for (final event in seerah.events) {
        expect(event.summary.isNotEmpty, isTrue);
        expect(event.historicalDate.dateDisplay.isNotEmpty, isTrue);
        expect(event.verifyHash(), isTrue);
      }
    });

    test('Hajj: Package contains 6 miqats, 6 locations, 19 ritual steps, and 10 prep items', () {
      final hajj = DefaultCanonicalSeedProvider.getHajjSeedPackage();
      expect(hajj.miqats.length, equals(6));
      expect(hajj.locations.length, equals(6));
      expect(hajj.steps.length, equals(19));
      expect(hajj.preparationItems.length, equals(10));
    });

    test('Fasting & Zakat: Guides are populated with authentic structured content', () {
      expect(FastingGuideData.topics.length, greaterThanOrEqualTo(5));
      for (final t in FastingGuideData.topics) {
        expect(t.title.isNotEmpty, isTrue);
        expect(t.content.isNotEmpty, isTrue);
        expect(t.keyPoints.isNotEmpty, isTrue);
        expect(t.references.isNotEmpty, isTrue);
      }

      expect(ZakatGuideData.topics.length, greaterThanOrEqualTo(5));
      for (final z in ZakatGuideData.topics) {
        expect(z.title.isNotEmpty, isTrue);
        expect(z.content.isNotEmpty, isTrue);
        expect(z.references.isNotEmpty, isTrue);
      }
    });
  });
}
