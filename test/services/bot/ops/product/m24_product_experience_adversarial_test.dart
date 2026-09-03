import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/services/bot/ops/product/models/federated_search_result.dart';
import 'package:siraj/services/bot/ops/product/models/product_capability_record.dart';
import 'package:siraj/services/bot/ops/product/services/federated_search_coordinator.dart';
import 'package:siraj/services/bot/ops/product/services/product_gap_analysis_service.dart';

class MockQuranSearchProvider implements SearchProviderContract {
  @override
  SearchDomain get domain => SearchDomain.quran;

  @override
  Future<List<FederatedSearchItem>> search(String query) async {
    if (query.contains('صلاة')) {
      return [
        const FederatedSearchItem(
          itemId: 'quran_002_043',
          domain: SearchDomain.quran,
          titleArabic: 'سورة البقرة - آية 43',
          snippetArabic: 'وَأَقِيمُوا الصَّلَاةَ وَآتُوا الزَّكَاةَ وَارْكَعُوا مَعَ الرَّاكِعِينَ',
          sourceEdition: 'المصحف العثماني برواية حفص',
          deepLinkUri: 'siraj://quran/2:43',
          relevanceScore: 0.98,
        ),
      ];
    }
    return [];
  }
}

class MockAdhkarSearchProvider implements SearchProviderContract {
  @override
  SearchDomain get domain => SearchDomain.adhkar;

  @override
  Future<List<FederatedSearchItem>> search(String query) async {
    if (query.contains('صلاة')) {
      return [
        const FederatedSearchItem(
          itemId: 'adhkar_post_prayer_01',
          domain: SearchDomain.adhkar,
          titleArabic: 'الاستغفار بعد الصلاة',
          snippetArabic: 'أستغفر الله، أستغفر الله، أستغفر الله. اللهم أنت السلام ومنك السلام',
          sourceEdition: 'صحيح مسلم',
          deepLinkUri: 'siraj://adhkar/post_prayer_01',
          relevanceScore: 0.92,
        ),
      ];
    }
    return [];
  }
}

void main() {
  group('M24 Product Completion & Federated Experience Suite (§2, §25, §59, §76, §116)', () {
    late ProductGapAnalysisService gapService;
    late FederatedSearchCoordinator searchCoordinator;

    setUp(() {
      gapService = ProductGapAnalysisService();
      searchCoordinator = FederatedSearchCoordinator();

      searchCoordinator.registerProvider(MockQuranSearchProvider());
      searchCoordinator.registerProvider(MockAdhkarSearchProvider());
    });

    test('Gap Analysis: Evaluates completeness and filters out P4 rejected features', () {
      gapService.registerCapability(const ProductCapabilityRecord(
        capabilityId: 'cap_prayer_core',
        titleArabic: 'مواقيت الصلاة والقبلة',
        associatedModule: 'prayer',
        status: CapabilityStatus.implemented,
        priority: CapabilityPriority.p0Critical,
        userValueScore: 10.0,
        effortScore: 4.0,
        descriptionArabic: 'حساب دقيق لمواقيت الصلاة',
      ));

      gapService.registerCapability(const ProductCapabilityRecord(
        capabilityId: 'cap_tafsir_scholarly',
        titleArabic: 'حزم التفسير الكنسية الموثقة',
        associatedModule: 'knowledge',
        status: CapabilityStatus.planned,
        priority: CapabilityPriority.p1Core,
        userValueScore: 9.5,
        effortScore: 6.0,
        descriptionArabic: 'عرض التفسير المعتمد للآيات',
      ));

      gapService.registerCapability(const ProductCapabilityRecord(
        capabilityId: 'cap_piety_score',
        titleArabic: 'تقييم مستوى تدين المستخدم',
        associatedModule: 'analytics',
        status: CapabilityStatus.notRecommended,
        priority: CapabilityPriority.p4Reject,
        userValueScore: 0.0,
        effortScore: 2.0,
        isPrivacyCompliant: false,
        descriptionArabic: 'مرفوض قطعاً لحماية الخصوصية وحرمة العبادة',
      ));

      expect(gapService.calculateCompletenessRatio(), closeTo(33.33, 0.1));

      final roadmap = gapService.getPrioritizedRoadmap();
      expect(roadmap.length, equals(1));
      expect(roadmap.first.capabilityId, equals('cap_tafsir_scholarly'));
    });

    test('Federated Search: Executes parallel search across Quran and Adhkar domains', () async {
      final results = await searchCoordinator.searchAll(query: 'صلاة');

      expect(results.totalHits, equals(2));
      expect(results.items.first.domain, equals(SearchDomain.quran));
      expect(results.items.first.titleArabic, contains('سورة البقرة'));
      expect(results.items.last.domain, equals(SearchDomain.adhkar));
      expect(results.items.last.titleArabic, contains('الاستغفار بعد الصلاة'));
    });

    test('Federated Search: Domain filtering isolates target domain hits', () async {
      final results = await searchCoordinator.searchAll(
        query: 'صلاة',
        filterDomains: {SearchDomain.adhkar},
      );

      expect(results.totalHits, equals(1));
      expect(results.items.first.domain, equals(SearchDomain.adhkar));
    });
  });
}
