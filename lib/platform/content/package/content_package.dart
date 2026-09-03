import 'package:equatable/equatable.dart';
import '../domain/content_record.dart';
import 'package_manifest.dart';

/// Represents a verifiable, immutable content package bundle.
class ContentPackage extends Equatable {
  final PackageManifest manifest;
  final List<ContentRecord> records;

  const ContentPackage({
    required this.manifest,
    required this.records,
  });

  String get packageId => manifest.packageId;
  String get version => manifest.version;
  String get targetModule => manifest.targetModule;

  /// Retrieves a record by contentId or null if not in package.
  ContentRecord? getRecord(String contentId) {
    try {
      return records.firstWhere((r) => r.contentId == contentId);
    } catch (_) {
      return null;
    }
  }

  @override
  List<Object?> get props => [manifest, records];
}
