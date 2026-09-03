import 'package:equatable/equatable.dart';
import '../../../core/time/clock.dart';
import '../domain/dhikr_item.dart';
import 'canonical_adhkar_package.dart';

enum AdhkarDiffType {
  textMutation,
  provenanceMutation,
  authenticityMutation,
  typeMutation,
  repetitionMutation,
  occasionMutation,
  added,
  removed,
}

class AdhkarDiffEntry extends Equatable {
  final String contentId;
  final AdhkarDiffType diffType;
  final String description;
  final Map<String, dynamic>? oldDetails;
  final Map<String, dynamic>? newDetails;

  const AdhkarDiffEntry({
    required this.contentId,
    required this.diffType,
    required this.description,
    this.oldDetails,
    this.newDetails,
  });

  @override
  List<Object?> get props => [contentId, diffType, description, oldDetails, newDetails];
}

class AdhkarDiffReport extends Equatable {
  final String oldPackageId;
  final String newPackageId;
  final String oldVersion;
  final String newVersion;
  final List<AdhkarDiffEntry> entries;
  final DateTime generatedAt;

  const AdhkarDiffReport({
    required this.oldPackageId,
    required this.newPackageId,
    required this.oldVersion,
    required this.newVersion,
    required this.entries,
    required this.generatedAt,
  });

  bool get hasDifferences => entries.isNotEmpty;
  bool get hasCriticalDifferences => entries.any(
        (e) =>
            e.diffType == AdhkarDiffType.textMutation ||
            e.diffType == AdhkarDiffType.provenanceMutation ||
            e.diffType == AdhkarDiffType.authenticityMutation ||
            e.diffType == AdhkarDiffType.typeMutation,
      );

  @override
  List<Object?> get props => [oldPackageId, newPackageId, oldVersion, newVersion, entries, generatedAt];
}

/// Content Diff Engine for Adhkar packages (§28).
class AdhkarContentDiffEngine {
  final Clock _clock;

  const AdhkarContentDiffEngine({Clock? clock}) : _clock = clock ?? const SystemClock();

  AdhkarDiffReport comparePackages({
    required CanonicalAdhkarPackage oldPackage,
    required CanonicalAdhkarPackage newPackage,
  }) {
    final entries = <AdhkarDiffEntry>[];
    final oldMap = {for (final i in oldPackage.items) i.id: i};
    final newMap = {for (final i in newPackage.items) i.id: i};

    // 1. Check for removed items
    for (final oldId in oldMap.keys) {
      if (!newMap.containsKey(oldId)) {
        entries.add(
          AdhkarDiffEntry(
            contentId: oldId,
            diffType: AdhkarDiffType.removed,
            description: 'Item $oldId was removed in new package',
            oldDetails: oldMap[oldId]!.toMap(),
          ),
        );
      }
    }

    // 2. Check for added or mutated items
    for (final entry in newMap.entries) {
      final newId = entry.key;
      final newItem = entry.value;

      if (!oldMap.containsKey(newId)) {
        entries.add(
          AdhkarDiffEntry(
            contentId: newId,
            diffType: AdhkarDiffType.added,
            description: 'Item $newId was added in new package',
            newDetails: newItem.toMap(),
          ),
        );
      } else {
        final oldItem = oldMap[newId]!;
        _detectItemDifferences(oldItem: oldItem, newItem: newItem, entries: entries);
      }
    }

    return AdhkarDiffReport(
      oldPackageId: oldPackage.packageId,
      newPackageId: newPackage.packageId,
      oldVersion: oldPackage.version,
      newVersion: newPackage.version,
      entries: entries,
      generatedAt: _clock.nowUtc(),
    );
  }

  void _detectItemDifferences({
    required DhikrItem oldItem,
    required DhikrItem newItem,
    required List<AdhkarDiffEntry> entries,
  }) {
    // 1. Text difference
    if (oldItem.textArabic != newItem.textArabic) {
      entries.add(
        AdhkarDiffEntry(
          contentId: newItem.id,
          diffType: AdhkarDiffType.textMutation,
          description: 'Arabic text was modified',
          oldDetails: {'text_arabic': oldItem.textArabic},
          newDetails: {'text_arabic': newItem.textArabic},
        ),
      );
    }

    // 2. Classification Type difference
    if (oldItem.type != newItem.type) {
      entries.add(
        AdhkarDiffEntry(
          contentId: newItem.id,
          diffType: AdhkarDiffType.typeMutation,
          description: 'Dhikr classification type was modified',
          oldDetails: {'type': oldItem.type.name},
          newDetails: {'type': newItem.type.name},
        ),
      );
    }

    // 3. Authenticity Grade difference
    if (oldItem.authenticityGrade != newItem.authenticityGrade) {
      entries.add(
        AdhkarDiffEntry(
          contentId: newItem.id,
          diffType: AdhkarDiffType.authenticityMutation,
          description: 'Authenticity grade was modified',
          oldDetails: {'authenticity_grade': oldItem.authenticityGrade.name},
          newDetails: {'authenticity_grade': newItem.authenticityGrade.name},
        ),
      );
    }

    // 4. Source & Provenance difference
    if (oldItem.sourceTitle != newItem.sourceTitle ||
        oldItem.sourceAuthor != newItem.sourceAuthor ||
        oldItem.reference != newItem.reference ||
        oldItem.attribution != newItem.attribution) {
      entries.add(
        AdhkarDiffEntry(
          contentId: newItem.id,
          diffType: AdhkarDiffType.provenanceMutation,
          description: 'Source or provenance metadata was modified',
          oldDetails: {
            'source_title': oldItem.sourceTitle,
            'source_author': oldItem.sourceAuthor,
            'reference': oldItem.reference,
            'attribution': oldItem.attribution,
          },
          newDetails: {
            'source_title': newItem.sourceTitle,
            'source_author': newItem.sourceAuthor,
            'reference': newItem.reference,
            'attribution': newItem.attribution,
          },
        ),
      );
    }

    // 5. Repetition difference
    if (oldItem.repetition != newItem.repetition) {
      entries.add(
        AdhkarDiffEntry(
          contentId: newItem.id,
          diffType: AdhkarDiffType.repetitionMutation,
          description: 'Repetition count or provenance was modified',
          oldDetails: oldItem.repetition.toMap(),
          newDetails: newItem.repetition.toMap(),
        ),
      );
    }

    // 6. Occasion difference
    if (oldItem.occasion != newItem.occasion) {
      entries.add(
        AdhkarDiffEntry(
          contentId: newItem.id,
          diffType: AdhkarDiffType.occasionMutation,
          description: 'Occasion classification was modified',
          oldDetails: {'occasion': oldItem.occasion.name},
          newDetails: {'occasion': newItem.occasion.name},
        ),
      );
    }
  }
}
