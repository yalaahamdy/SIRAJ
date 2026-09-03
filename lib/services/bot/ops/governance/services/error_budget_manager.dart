/// Manager tracking service SLOs and enforcing error budgets (§35, §36, §37).
class ErrorBudgetManager {
  final double monthlyErrorBudget; // e.g. 0.001 (0.1% allowable error)
  double _consumedErrorBudget = 0.0;
  bool _isNonCriticalRolloutFrozen = false;

  ErrorBudgetManager({
    this.monthlyErrorBudget = 0.001,
  });

  double get consumedErrorBudget => _consumedErrorBudget;
  bool get isNonCriticalRolloutFrozen => _isNonCriticalRolloutFrozen;
  double get remainingBudgetPercentage =>
      ((monthlyErrorBudget - _consumedErrorBudget) / monthlyErrorBudget).clamp(0.0, 1.0) * 100;

  /// Records an incident impact and burns error budget (§37).
  void recordErrorBurn(double burnedRatio) {
    _consumedErrorBudget += burnedRatio;
    if (_consumedErrorBudget >= monthlyErrorBudget * 0.8) {
      _isNonCriticalRolloutFrozen = true;
    }
  }

  /// Resets monthly error budget for a new cycle.
  void resetMonthlyCycle() {
    _consumedErrorBudget = 0.0;
    _isNonCriticalRolloutFrozen = false;
  }
}
