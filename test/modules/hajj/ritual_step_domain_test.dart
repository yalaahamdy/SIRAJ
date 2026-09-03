import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/hajj/domain/fiqh_option.dart';
import 'package:siraj/modules/hajj/domain/journey_type.dart';
import 'package:siraj/modules/hajj/domain/ritual_phase.dart';
import 'package:siraj/modules/hajj/domain/ritual_step.dart';

void main() {
  group('L2 Ritual Step Domain & Hashes Tests (§7, §8, §9)', () {
    test('RitualStep computes and verifies cryptographic hash correctly', () {
      final step = RitualStep.create(
        stepId: 'step_test_tawaf',
        journeyType: JourneyType.umrah,
        phase: RitualPhase.arrivalAndTawaf,
        sequence: 2,
        title: 'طواف العمرة',
        description: 'الطواف سبعة أشواط حول الكعبة المشرفة.',
        isRequired: true,
        locationId: 'loc_masjid_al_haram',
        timeContext: 'عند القدوم',
        fiqhOptions: const [
          FiqhOption(
            schoolOrScholar: 'الجمهور',
            positionArabic: 'الطهارة شرط',
            evidenceSummary: 'حديث عائشة',
          ),
        ],
        duaAdhkarKeys: const ['dhikr_tawaf_yamani'],
        sourceIds: const ['src_hadith_muslim_jaber'],
      );

      expect(step.integrityHash.startsWith('sha256:'), isTrue);
      expect(step.verifyHash(), isTrue);
    });

    test('RitualStep fails hash verification when title or description is tampered', () {
      final validStep = RitualStep.create(
        stepId: 'step_valid',
        journeyType: JourneyType.umrah,
        phase: RitualPhase.sai,
        sequence: 3,
        title: 'السعي بين الصفا والمروة',
        description: 'السعي سبعة أشواط.',
        isRequired: true,
        timeContext: 'بعد الطواف',
        sourceIds: const ['src_hadith_muslim_jaber'],
      );

      final tamperedStep = RitualStep(
        stepId: validStep.stepId,
        journeyType: validStep.journeyType,
        phase: validStep.phase,
        sequence: validStep.sequence,
        title: 'السعي ثمانية أشواط (تحريف غير موثق)',
        description: validStep.description,
        isRequired: validStep.isRequired,
        timeContext: validStep.timeContext,
        sourceIds: validStep.sourceIds,
        integrityHash: validStep.integrityHash,
      );

      expect(tamperedStep.verifyHash(), isFalse);
    });
  });
}
