import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'fasting_day_record.dart';
import 'fasting_policy.dart';
import 'qada_plan.dart';

/// Immutable historical audit snapshot for fasting records (§24, §30, §31).
class FastingRecordSnapshot extends Equatable {
  final String snapshotId;
  final List<FastingDayRecord> records;
  final QadaPlan? qadaPlan;
  final FastingPolicy policy;
  final DateTime createdAt;
  final String integrityHash;

  const FastingRecordSnapshot({
    required this.snapshotId,
    required this.records,
    this.qadaPlan,
    required this.policy,
    required this.createdAt,
    required this.integrityHash,
  });

  static String computeHash({
    required String snapshotId,
    required List<FastingDayRecord> records,
    required QadaPlan? qadaPlan,
    required FastingPolicy policy,
    required DateTime createdAt,
  }) {
    final payload = {
      'snapshot_id': snapshotId,
      'records': records.map((r) => r.toMap()).toList(),
      if (qadaPlan != null) 'qada_plan': qadaPlan.toMap(),
      'policy': policy.toMap(),
      'created_at': createdAt.toIso8601String(),
    };
    final jsonStr = jsonEncode(payload);
    return 'sha256:${sha256.convert(utf8.encode(jsonStr)).toString()}';
  }

  factory FastingRecordSnapshot.create({
    required String snapshotId,
    required List<FastingDayRecord> records,
    QadaPlan? qadaPlan,
    required FastingPolicy policy,
    required DateTime createdAt,
  }) {
    final hash = computeHash(
      snapshotId: snapshotId,
      records: records,
      qadaPlan: qadaPlan,
      policy: policy,
      createdAt: createdAt,
    );
    return FastingRecordSnapshot(
      snapshotId: snapshotId,
      records: records,
      qadaPlan: qadaPlan,
      policy: policy,
      createdAt: createdAt,
      integrityHash: hash,
    );
  }

  bool verifyHash() {
    final expected = computeHash(
      snapshotId: snapshotId,
      records: records,
      qadaPlan: qadaPlan,
      policy: policy,
      createdAt: createdAt,
    );
    return integrityHash == expected;
  }

  factory FastingRecordSnapshot.fromMap(Map<String, dynamic> map) {
    return FastingRecordSnapshot(
      snapshotId: map['snapshot_id'] as String,
      records: (map['records'] as List<dynamic>)
          .map((e) => FastingDayRecord.fromMap(e as Map<String, dynamic>))
          .toList(),
      qadaPlan: map['qada_plan'] != null
          ? QadaPlan.fromMap(map['qada_plan'] as Map<String, dynamic>)
          : null,
      policy: FastingPolicy.fromMap(map['policy'] as Map<String, dynamic>),
      createdAt: DateTime.parse(map['created_at'] as String),
      integrityHash: map['integrity_hash'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'snapshot_id': snapshotId,
      'records': records.map((r) => r.toMap()).toList(),
      if (qadaPlan != null) 'qada_plan': qadaPlan!.toMap(),
      'policy': policy.toMap(),
      'created_at': createdAt.toIso8601String(),
      'integrity_hash': integrityHash,
    };
  }

  @override
  List<Object?> get props => [
        snapshotId,
        records,
        qadaPlan,
        policy,
        createdAt,
        integrityHash,
      ];
}
