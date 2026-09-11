import 'package:flutter/material.dart';
import '../../../modules/hajj/domain/ritual_step.dart';

class RitualStepCard extends StatelessWidget {
  final RitualStep step;
  final bool isCompleted;
  final VoidCallback onTap;
  final VoidCallback onToggleCompleted;

  const RitualStepCard({
    super.key,
    required this.step,
    required this.isCompleted,
    required this.onTap,
    required this.onToggleCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: isCompleted ? 1 : 2,
      color: isCompleted
          ? (isDark ? const Color(0xFF064E3B).withValues(alpha: 0.35) : Colors.green.shade50)
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isCompleted
            ? BorderSide(
                color: isDark ? const Color(0xFF059669) : Colors.green.shade300,
                width: 1.5,
              )
            : BorderSide(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                width: 1,
              ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: isCompleted
              ? (isDark ? const Color(0xFF059669) : Colors.green)
              : (step.isRequired ? Colors.teal : Colors.blueGrey),
          foregroundColor: Colors.white,
          child: isCompleted
              ? const Icon(Icons.check, size: 20)
              : Text('${step.sequence}', style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        title: Text(
          step.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${step.phase.labelArabic} • ${step.isRequired ? "ركن/واجب" : "سنة ومستحب"}',
          style: TextStyle(
            fontSize: 12,
            color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade700,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isCompleted ? (isDark ? const Color(0xFF34D399) : Colors.green) : (isDark ? Colors.white38 : Colors.grey),
          ),
          onPressed: onToggleCompleted,
          tooltip: isCompleted ? 'إلغاء التعليم' : 'تعليم كمكتمل',
        ),
      ),
    );
  }
}
