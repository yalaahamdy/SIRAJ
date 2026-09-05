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
    return Card(
      elevation: isCompleted ? 1 : 2,
      color: isCompleted ? Colors.green.shade50 : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isCompleted
            ? BorderSide(color: Colors.green.shade300, width: 1.5)
            : BorderSide.none,
      ),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: isCompleted
              ? Colors.green
              : (step.isRequired ? Colors.teal : Colors.blueGrey),
          foregroundColor: Colors.white,
          child: isCompleted
              ? const Icon(Icons.check, size: 20)
              : Text('${step.sequence}'),
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
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
        ),
        trailing: IconButton(
          icon: Icon(
            isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isCompleted ? Colors.green : Colors.grey,
          ),
          onPressed: onToggleCompleted,
          tooltip: isCompleted ? 'إلغاء التعليم' : 'تعليم كمكتمل',
        ),
      ),
    );
  }
}
