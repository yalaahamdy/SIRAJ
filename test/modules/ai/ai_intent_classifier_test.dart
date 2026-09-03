import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/ai/domain/ai_intent.dart';
import 'package:siraj/modules/ai/engine/intent_classifier.dart';

void main() {
  group('L2 AI Intent Classifier Tests (§8, §9)', () {
    const classifier = IntentClassifier();

    test('Correctly identifies high-risk personal fatwa and worship validity queries', () {
      final fatwaQuery = classifier.classify('افتني في مسألة طرأت لي');
      final validityQuery = classifier.classify('هل صلاتي صحيحة إذا نسيت التشهد الأول؟');
      final takfirQuery = classifier.classify('هل فلان كافر؟');

      expect(fatwaQuery.category, equals(IntentCategory.personalFatwa));
      expect(fatwaQuery.riskLevel, equals(RiskLevel.high));
      expect(fatwaQuery.requiresAbstention, isTrue);

      expect(validityQuery.category, equals(IntentCategory.personalWorshipValidity));
      expect(validityQuery.riskLevel, equals(RiskLevel.high));
      expect(validityQuery.requiresAbstention, isTrue);

      expect(takfirQuery.category, equals(IntentCategory.takfirOrJudgment));
      expect(takfirQuery.riskLevel, equals(RiskLevel.critical));
      expect(takfirQuery.requiresAbstention, isTrue);
    });

    test('Classifies standard informational queries accurately', () {
      final quran = classifier.classify('ما هي الآية الأولى في سورة الكهف؟');
      final hadith = classifier.classify('أريد نص حديث إنما الأعمال بالنيات');
      final dhikr = classifier.classify('ما هي أذكار المساء المأثورة؟');
      final prayer = classifier.classify('كيف أحدد اتجاه القبلة ومواقيت الصلاة؟');

      expect(quran.category, equals(IntentCategory.quranLookup));
      expect(quran.requiresAbstention, isFalse);

      expect(hadith.category, equals(IntentCategory.hadithLookup));
      expect(hadith.requiresAbstention, isFalse);

      expect(dhikr.category, equals(IntentCategory.dhikrLookup));
      expect(prayer.category, equals(IntentCategory.prayer));
    });
  });
}
