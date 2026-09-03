/// Policy options for deducting liabilities and debts from the zakatable base (§15).
enum DebtTreatment {
  deductCurrentDebts,
  deductAllDebts,
  ignoreDebts;

  String get labelArabic {
    switch (this) {
      case DebtTreatment.deductCurrentDebts:
        return 'خصم الديون الحالة العاجلة فقط (المعتمد عند الجمهور)';
      case DebtTreatment.deductAllDebts:
        return 'خصم كافة الديون الحالة والمؤجلة';
      case DebtTreatment.ignoreDebts:
        return 'عدم خصم الديون من الأموال الظاهرة';
    }
  }
}
