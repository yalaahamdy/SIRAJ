import 'package:equatable/equatable.dart';

/// Provenance metadata tracking the origin and justification of the repetition count (§13).
class RepetitionProvenance extends Equatable {
  final int count;
  final bool isSourced;
  final String? note;

  const RepetitionProvenance({
    required this.count,
    this.isSourced = true,
    this.note,
  }) : assert(count >= 1, 'Repetition count must be at least 1');

  static const RepetitionProvenance single = RepetitionProvenance(count: 1, isSourced: true);

  factory RepetitionProvenance.fromMap(Map<String, dynamic> map) {
    return RepetitionProvenance(
      count: map['count'] as int? ?? 1,
      isSourced: map['is_sourced'] as bool? ?? true,
      note: map['note'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'count': count,
      'is_sourced': isSourced,
      if (note != null) 'note': note,
    };
  }

  @override
  List<Object?> get props => [count, isSourced, note];
}
