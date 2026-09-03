import 'package:equatable/equatable.dart';

/// Cryptographically bound release manifest linking code, content, policies, and config (§6, §48, §50).
class ReleaseManifest extends Equatable {
  final String manifestId;
  final String appVersion;
  final String botVersion;
  final String quranPackageVersion;
  final String adhkarPackageVersion;
  final String knowledgePackageVersion;
  final String learningPackageVersion;
  final String seerahPackageVersion;
  final String hajjPackageVersion;
  final String policyVersion;
  final String aiModelVersion;
  final String configDigestSha256;
  final String contentManifestHashSha256;

  const ReleaseManifest({
    required this.manifestId,
    required this.appVersion,
    required this.botVersion,
    required this.quranPackageVersion,
    required this.adhkarPackageVersion,
    required this.knowledgePackageVersion,
    required this.learningPackageVersion,
    required this.seerahPackageVersion,
    required this.hajjPackageVersion,
    required this.policyVersion,
    required this.aiModelVersion,
    required this.configDigestSha256,
    required this.contentManifestHashSha256,
  });

  bool get isValid =>
      manifestId.isNotEmpty &&
      appVersion.isNotEmpty &&
      botVersion.isNotEmpty &&
      quranPackageVersion.isNotEmpty &&
      adhkarPackageVersion.isNotEmpty &&
      knowledgePackageVersion.isNotEmpty &&
      configDigestSha256.isNotEmpty &&
      contentManifestHashSha256.isNotEmpty;

  @override
  List<Object?> get props => [
        manifestId,
        appVersion,
        botVersion,
        quranPackageVersion,
        adhkarPackageVersion,
        knowledgePackageVersion,
        learningPackageVersion,
        seerahPackageVersion,
        hajjPackageVersion,
        policyVersion,
        aiModelVersion,
        configDigestSha256,
        contentManifestHashSha256,
      ];
}
