import 'package:equatable/equatable.dart';

/// Unified Search Result item returned by Search Federation across modules (§42, §43).
class FederatedSearchResult extends Equatable {
  final String moduleId;
  final String moduleTitleArabic;
  final String itemId;
  final String titleArabic;
  final String snippet;
  final String itemType;
  final String provenanceState;
  final String targetRoute;
  final Map<String, dynamic> metadata;

  const FederatedSearchResult({
    required this.moduleId,
    required this.moduleTitleArabic,
    required this.itemId,
    required this.titleArabic,
    required this.snippet,
    required this.itemType,
    required this.provenanceState,
    required this.targetRoute,
    this.metadata = const {},
  });

  @override
  List<Object?> get props => [
        moduleId,
        moduleTitleArabic,
        itemId,
        titleArabic,
        snippet,
        itemType,
        provenanceState,
        targetRoute,
        metadata,
      ];
}
