/// Redacts sensitive information from bot logs and observability traces (§38, §39).
class SensitiveDataRedactor {
  // Regex patterns for sensitive data
  static final RegExp _phoneRegex = RegExp(r'(\+?\d{1,3}[-.\s]?)?(\d{2,4})[-.\s]?\d{3}[-.\s]?(\d{4})');
  static final RegExp _emailRegex = RegExp(r'[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+');
  static final RegExp _bearerRegex = RegExp(r'Bearer\s+[a-zA-Z0-9_\-\.]+', caseSensitive: false);
  static final RegExp _secretKeyRegex = RegExp(r'(key|secret|token|password)[\s:=]+([^\s,;]+)', caseSensitive: false);
  static final RegExp _financialRegex = RegExp(r'\b\d+([\.,]\d+)?\s*(SAR|USD|ريال|دولار|درهم)\b', caseSensitive: false);

  /// Cleanses any text input by masking identifiable or confidential attributes.
  static String redact(String text) {
    if (text.isEmpty) return text;

    var result = text;

    // Mask Bearer tokens
    result = result.replaceAllMapped(_bearerRegex, (m) => 'Bearer [REDACTED_TOKEN]');

    // Mask secret keys/passwords
    result = result.replaceAllMapped(_secretKeyRegex, (m) => '${m.group(1)}: [REDACTED_SECRET]');

    // Mask Emails
    result = result.replaceAllMapped(_emailRegex, (m) {
      final email = m.group(0) ?? '';
      final parts = email.split('@');
      if (parts.length == 2 && parts[0].isNotEmpty) {
        return '${parts[0][0]}***@${parts[1]}';
      }
      return '[REDACTED_EMAIL]';
    });

    // Mask Phone numbers
    result = result.replaceAllMapped(_phoneRegex, (m) => '[REDACTED_PHONE]');

    // Mask Financial figures
    result = result.replaceAllMapped(_financialRegex, (m) => '[REDACTED_FINANCIAL]');

    return result;
  }

  /// Cleanses a Map by redacting sensitive values while preserving safe keys.
  static Map<String, dynamic> redactMap(Map<String, dynamic> data) {
    final Map<String, dynamic> cleaned = {};

    for (final entry in data.entries) {
      final key = entry.key.toLowerCase();
      final value = entry.value;

      if (key.contains('secret') ||
          key.contains('token') ||
          key.contains('password') ||
          key.contains('authorization')) {
        cleaned[entry.key] = '[REDACTED_SECRET]';
      } else if (value is String) {
        cleaned[entry.key] = redact(value);
      } else if (value is Map<String, dynamic>) {
        cleaned[entry.key] = redactMap(value);
      } else if (value is List) {
        cleaned[entry.key] = value.map((item) {
          if (item is String) return redact(item);
          if (item is Map<String, dynamic>) return redactMap(item);
          return item;
        }).toList();
      } else {
        cleaned[entry.key] = value;
      }
    }

    return cleaned;
  }
}
