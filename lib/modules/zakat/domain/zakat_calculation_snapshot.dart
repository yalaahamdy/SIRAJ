import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'market_data_snapshot.dart';
import 'zakat_asset.dart';
import 'zakat_calculation_result.dart';
import 'zakat_policy.dart';

/// Immutable historical snapshot of a completed Zakat calculation for audit trails (§28, §29).
class ZakatCalculationSnapshot extends Equatable {
  final String snapshotId;
  final List<ZakatAsset> assets;
  final ZakatPolicy policy;
  final MarketDataSnapshot marketSnapshot;
  final ZakatCalculationResult result;
  final DateTime createdAt;
  final String integrityHash;

  const ZakatCalculationSnapshot({
    required this.snapshotId,
    required this.assets,
    required this.policy,
    required this.marketSnapshot,
    required this.result,
    required this.createdAt,
    required this.integrityHash,
  });

  static String computeHash({
    required String snapshotId,
    required int assetCount,
    required String policyId,
    required int zakatDueUnits,
    required DateTime createdAt,
  }) {
    final payload = '$snapshotId|$assetCount|$policyId|$zakatDueUnits|${createdAt.toIso8601String()}';
    final digest = sha256.convert(utf8.encode(payload)).toString();
    return 'sha256:$digest';
  }

  bool verifyHash() {
    final expected = computeHash(
      snapshotId: snapshotId,
      assetCount: assets.length,
      policyId: policy.policyId,
      zakatDueUnits: result.zakatDue.units,
      createdAt: createdAt,
    );
    return integrityHash == expected;
  }

  factory ZakatCalculationSnapshot.create({
    required String snapshotId,
    required List<ZakatAsset> assets,
    required ZakatPolicy policy,
    required MarketDataSnapshot marketSnapshot,
    required ZakatCalculationResult result,
    required DateTime createdAt,
  }) {
    final hash = computeHash(
      snapshotId: snapshotId,
      assetCount: assets.length,
      policyId: policy.policyId,
      zakatDueUnits: result.zakatDue.units,
      createdAt: createdAt,
    );

    return ZakatCalculationSnapshot(
      snapshotId: snapshotId,
      assets: List.unmodifiable(assets),
      policy: policy,
      marketSnapshot: marketSnapshot,
      result: result,
      createdAt: createdAt,
      integrityHash: hash,
    );
  }

  factory ZakatCalculationSnapshot.fromMap(Map<String, dynamic> map) {
    final rawAssets = map['assets'] as List<dynamic>;
    final parsedAssets = rawAssets
        .map((a) => ZakatAsset.fromMap(a as Map<String, dynamic>))
        .toList();

    return ZakatCalculationSnapshot(
      snapshotId: map['snapshot_id'] as String,
      assets: parsedAssets,
      policy: ZakatPolicy.fromMap(map['policy'] as Map<String, dynamic>),
      marketSnapshot: MarketDataSnapshot.fromMap(map['market_snapshot'] as Map<String, dynamic>),
      result: ZakatCalculationResult.fromMap(map['result'] as Map<String, dynamic>),
      createdAt: DateTime.parse(map['created_at'] as String),
      integrityHash: map['integrity_hash'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'snapshot_id': snapshotId,
      'assets': assets.map((a) => a.toMap()).toList(),
      'policy': policy.toMap(),
      'market_snapshot': marketSnapshot.toMap(),
      'result': result.toMap(),
      'created_at': createdAt.toIso8601String(),
      'integrity_hash': integrityHash,
    };
  }

  @override
  List<Object?> get props => [
        snapshotId,
        assets,
        policy,
        marketSnapshot,
        result,
        createdAt,
        integrityHash,
      ];
}
