import '../domain/unified_message.dart';

/// Single-use confirmation action metadata (§15, §16, §33).
class ConfirmationActionMetadata {
  final String actionId;
  final DateTime expiresAt;
  bool isConsumed;

  ConfirmationActionMetadata({
    required this.actionId,
    required this.expiresAt,
    this.isConsumed = false,
  });

  bool get isExpired => DateTime.now().toUtc().isAfter(expiresAt);
}

/// Engine managing explicit user confirmation before state-mutating actions (§22, §33, §71, §72).
class ConfirmationEngine {
  final Map<String, ConfirmationActionMetadata> _pendingTokens = {};
  final Duration tokenValidity;

  ConfirmationEngine({
    this.tokenValidity = const Duration(minutes: 5),
  });

  static const _affirmativeKeywords = {
    'نعم', 'تأكيد', 'موافق', 'نعم أوافق', 'أكد', 'نعم تأكيد',
    'yes', 'confirm', 'ok', 'agree', 'y'
  };

  static const _negativeKeywords = {
    'لا', 'إلغاء', 'تراجع', 'غير موافق', 'لا أريد',
    'no', 'cancel', 'abort', 'n'
  };

  bool isAffirmativeConfirmation(String text) {
    final clean = text.trim().toLowerCase();
    return _affirmativeKeywords.contains(clean);
  }

  bool isNegativeConfirmation(String text) {
    final clean = text.trim().toLowerCase();
    return _negativeKeywords.contains(clean);
  }

  /// Registers and builds a confirmation request response with interactive Yes/No buttons (§33).
  UnifiedBotResponse requestConfirmation({
    required String requestId,
    required String promptArabic,
    required String actionId,
  }) {
    // Register token with TTL
    _pendingTokens[actionId] = ConfirmationActionMetadata(
      actionId: actionId,
      expiresAt: DateTime.now().toUtc().add(tokenValidity),
    );

    return UnifiedBotResponse(
      requestId: requestId,
      textArabic: promptArabic,
      requiresConfirmation: true,
      confirmationActionId: actionId,
      menu: BotMenu(
        title: 'تأكيد الإجراء',
        rows: [
          [
            BotButton(id: 'confirm_yes', labelArabic: 'نعم، تأكيد', callbackData: 'CONFIRM_$actionId'),
            BotButton(id: 'confirm_no', labelArabic: 'لا، إلغاء', callbackData: 'CANCEL_$actionId'),
          ],
        ],
      ),
    );
  }

  /// Verifies token validity (unexpired & unconsumed) and marks it consumed (§15, §16).
  bool validateAndConsumeToken(String actionId) {
    final token = _pendingTokens[actionId];
    if (token == null) return false;
    if (token.isExpired || token.isConsumed) {
      _pendingTokens.remove(actionId);
      return false;
    }

    token.isConsumed = true;
    _pendingTokens.remove(actionId);
    return true;
  }

  void invalidateToken(String actionId) {
    _pendingTokens.remove(actionId);
  }
}
