import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/seerah/domain/date_precision.dart';
import 'package:siraj/modules/seerah/domain/historical_date.dart';
import 'package:siraj/modules/seerah/domain/moral_lesson.dart';
import 'package:siraj/modules/seerah/domain/seerah_event.dart';
import '../../fixtures/seerah/synthetic_seerah_fixtures.dart';

void main() {
  group('L2 Seerah Event Domain & Hashes Tests (§5, §6, §11, §15)', () {
    test('SeerahEvent computes and verifies cryptographic hash correctly', () {
      final event = SyntheticSeerahFixtures.createEvent();
      expect(event.integrityHash.startsWith('sha256:'), isTrue);
      expect(event.verifyHash(), isTrue);
    });

    test('HistoricalPlace computes and verifies hash', () {
      final place = SyntheticSeerahFixtures.createPlace();
      expect(place.integrityHash.startsWith('sha256:'), isTrue);
      expect(place.verifyHash(), isTrue);
    });

    test('NarrativeVariant computes and verifies hash', () {
      final variant = SyntheticSeerahFixtures.createVariant();
      expect(variant.integrityHash.startsWith('sha256:'), isTrue);
      expect(variant.verifyHash(), isTrue);
    });

    test('Strict semantic separation: Moral lessons are segregated from historical facts', () {
      const lesson = MoralLesson(
        lessonText: 'الصبر واليقين أساس النصر',
        themeArabic: 'الصبر',
      );

      final event = SeerahEvent.create(
        eventId: 'evt_test',
        title: 'حدث اختباري',
        periodId: 'prd_test',
        historicalDate: const HistoricalDate(
          hijriYear: 1,
          precision: DatePrecision.yearOnly,
          dateDisplay: '1 هـ',
        ),
        summary: 'ملخص تاريخي مسند',
        sourceIds: const ['src_1'],
        moralLessons: const [lesson],
      );

      expect(event.summary, isNot(contains('الصبر واليقين')));
      expect(event.moralLessons.first.lessonText, contains('الصبر واليقين'));
    });
  });
}
