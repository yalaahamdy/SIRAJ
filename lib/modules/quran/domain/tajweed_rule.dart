import 'package:flutter/material.dart';

/// Supported Tajweed recitation rules with canonical color conventions (§12).
enum TajweedRuleType {
  hamzatWasl('hamzat_wasl', 'همزة وصل', Color(0xFF9E9E9E)),
  lamShamsiyyah('lam_shamsiyyah', 'لام شمسية', Color(0xFF757575)),
  ghunnah('ghunnah', 'غنة', Color(0xFF10B981)),
  idghamWithGhunnah('idgham_with_ghunnah', 'إدغام بغنة', Color(0xFF10B981)),
  idghamWithoutGhunnah('idgham_without_ghunnah', 'إدغام بغير غنة', Color(0xFF6B7280)),
  ikhfa('ikhfa', 'إخفاء', Color(0xFFF59E0B)),
  iqlab('iqlab', 'إقلاب', Color(0xFF3B82F6)),
  qalqalah('qalqalah', 'قلقلة', Color(0xFF06B6D4)),
  maddMuttasil('madd_muttasil', 'مد متصل', Color(0xFFEF4444)),
  maddMunfasil('madd_munfasil', 'مد منفصل', Color(0xFFDC2626)),
  maddLazim('madd_lazim', 'مد لازم', Color(0xFFB91C1C)),
  maddArid('madd_arid', 'مد عارض للسكون', Color(0xFFF43F5E)),
  silent('silent', 'حرف لا ينطق', Color(0xFF9CA3AF));

  final String id;
  final String labelArabic;
  final Color color;

  const TajweedRuleType(this.id, this.labelArabic, this.color);

  static TajweedRuleType fromId(String id) {
    for (final rule in TajweedRuleType.values) {
      if (rule.id == id) return rule;
    }
    return TajweedRuleType.silent;
  }
}

/// Character span defining a Tajweed rule range without altering canonical text.
class TajweedSpan {
  final int start;
  final int end;
  final TajweedRuleType rule;

  const TajweedSpan({
    required this.start,
    required this.end,
    required this.rule,
  });

  factory TajweedSpan.fromMap(Map<String, dynamic> map) {
    return TajweedSpan(
      start: map['start'] as int,
      end: map['end'] as int,
      rule: TajweedRuleType.fromId(map['rule'] as String? ?? 'silent'),
    );
  }
}

/// Rendering layer that formats canonical Arabic text into rich Tajweed text spans.
/// Guarantees that canonical text bytes are 100% immutable and pristine.
class TajweedRenderer {
  const TajweedRenderer._();

  /// Renders a list of [TextSpan]s with colored Tajweed rules.
  /// If [rules] is null or empty, returns a single unstyled [TextSpan].
  static List<TextSpan> buildSpans({
    required String textUthmani,
    required List<dynamic>? rawRules,
    required TextStyle baseStyle,
    bool isDark = false,
  }) {
    if (rawRules == null || rawRules.isEmpty) {
      return [TextSpan(text: textUthmani, style: baseStyle)];
    }

    final spans = <TajweedSpan>[];
    for (final r in rawRules) {
      if (r is Map<String, dynamic>) {
        spans.add(TajweedSpan.fromMap(r));
      }
    }

    // Sort spans by start index
    spans.sort((a, b) => a.start.compareTo(b.start));

    final result = <TextSpan>[];
    int cursor = 0;

    for (final span in spans) {
      // Validate bounds against text length
      if (span.start < 0 || span.start > textUthmani.length || span.end > textUthmani.length || span.start >= span.end) {
        continue;
      }

      // Add unstyled text before this span
      if (span.start > cursor) {
        result.add(
          TextSpan(
            text: textUthmani.substring(cursor, span.start),
            style: baseStyle,
          ),
        );
      }

      // Add styled Tajweed span
      result.add(
        TextSpan(
          text: textUthmani.substring(span.start, span.end),
          style: baseStyle.copyWith(
            color: span.rule.color,
          ),
        ),
      );

      cursor = span.end;
    }

    // Add remaining trailing text
    if (cursor < textUthmani.length) {
      result.add(
        TextSpan(
          text: textUthmani.substring(cursor),
          style: baseStyle,
        ),
      );
    }

    return result;
  }
}
