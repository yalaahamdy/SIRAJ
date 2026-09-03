import 'dart:math';

/// Status of a corrective action item (§94, §95).
enum CorrectiveActionStatus {
  open,
  inProgress,
  verifiedAndClosed,
}

/// Corrective action record resulting from postmortems (§94, §95).
class CorrectiveActionItem {
  final String actionId;
  final String incidentId;
  final String owner;
  final String descriptionArabic;
  final CorrectiveActionStatus status;
  final DateTime targetDate;
  final DateTime? verificationDate;

  CorrectiveActionItem({
    required this.actionId,
    required this.incidentId,
    required this.owner,
    required this.descriptionArabic,
    this.status = CorrectiveActionStatus.open,
    required this.targetDate,
    this.verificationDate,
  });

  CorrectiveActionItem copyWith({
    String? actionId,
    String? incidentId,
    String? owner,
    String? descriptionArabic,
    CorrectiveActionStatus? status,
    DateTime? targetDate,
    DateTime? verificationDate,
  }) {
    return CorrectiveActionItem(
      actionId: actionId ?? this.actionId,
      incidentId: incidentId ?? this.incidentId,
      owner: owner ?? this.owner,
      descriptionArabic: descriptionArabic ?? this.descriptionArabic,
      status: status ?? this.status,
      targetDate: targetDate ?? this.targetDate,
      verificationDate: verificationDate ?? this.verificationDate,
    );
  }
}

/// Registry tracking corrective actions and postmortem learning (§94, §95).
class CorrectiveActionRegistry {
  final List<CorrectiveActionItem> _items = [];

  List<CorrectiveActionItem> get items => List.unmodifiable(_items);

  /// Registers a new corrective action item (§95).
  CorrectiveActionItem registerAction({
    required String incidentId,
    required String owner,
    required String descriptionArabic,
    required DateTime targetDate,
  }) {
    final actionId = 'capa_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';

    final item = CorrectiveActionItem(
      actionId: actionId,
      incidentId: incidentId,
      owner: owner,
      descriptionArabic: descriptionArabic,
      targetDate: targetDate,
    );

    _items.add(item);
    return item;
  }

  /// Closes an action item after verified proof (§95).
  bool verifyAndCloseAction(String actionId) {
    final index = _items.indexWhere((i) => i.actionId == actionId);
    if (index == -1) return false;

    _items[index] = _items[index].copyWith(
      status: CorrectiveActionStatus.verifiedAndClosed,
      verificationDate: DateTime.now(),
    );
    return true;
  }
}
