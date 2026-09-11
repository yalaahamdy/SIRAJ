import 'package:flutter/material.dart';
import '../../../modules/hajj/domain/ritual_step.dart';
import '../../../modules/hajj/hajj_module.dart';
import 'widgets/adhkar_link_box.dart';
import 'widgets/fiqh_options_box.dart';

/// Ritual Step Detail Screen (§28, §29, §62, §63, §107).
class RitualStepDetailScreen extends StatefulWidget {
  final RitualStep step;
  final HajjModule module;

  const RitualStepDetailScreen({
    super.key,
    required this.step,
    required this.module,
  });

  @override
  State<RitualStepDetailScreen> createState() => _RitualStepDetailScreenState();
}

class _RitualStepDetailScreenState extends State<RitualStepDetailScreen> {
  final TextEditingController _noteController = TextEditingController();
  bool _isSavingNote = false;

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  Future<void> _loadNote() async {
    final progRes = await widget.module.getUserProgress();
    if (mounted && progRes.isSuccess) {
      final note = progRes.valueOrNull!.userNotes[widget.step.stepId];
      if (note != null) {
        setState(() {
          _noteController.text = note;
        });
      }
    }
  }

  Future<void> _saveNote() async {
    setState(() => _isSavingNote = true);
    await widget.module.saveUserNote(widget.step.stepId, _noteController.text);
    if (mounted) {
      setState(() {
        _isSavingNote = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ الملاحظة الشخصية بنجاح')),
      );
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final refsRes = widget.module.resolveStepReferences(widget.step.stepId);
    final refs = refsRes.isSuccess ? refsRes.valueOrNull! : const StepResolvedReferences();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.step.title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          maxLines: 2,
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Chip(
                          label: Text(
                            widget.step.phase.labelArabic,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isDark ? const Color(0xFF6EE7B7) : const Color(0xFF0F5132),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          backgroundColor: isDark ? const Color(0xFF064E3B) : Colors.teal.shade50,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Chip(
                          label: Text(
                            widget.step.isRequired ? 'ركن / واجب' : 'سنة ومستحب',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: widget.step.isRequired
                                  ? (isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E))
                                  : (isDark ? const Color(0xFF93C5FD) : const Color(0xFF1E40AF)),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          backgroundColor: widget.step.isRequired
                              ? (isDark ? const Color(0xFF451A03) : Colors.amber.shade100)
                              : (isDark ? const Color(0xFF172554) : Colors.blue.shade50),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.step.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'التوقيت الشرعي: ${widget.step.timeContext}',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Description
          const Text(
            'الصفة والبيان الإرشادي (§8):',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 6),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                widget.step.description,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ),
          ),

          // Fiqh Options
          FiqhOptionsBox(options: widget.step.fiqhOptions),

          // Adhkar & Dua
          AdhkarLinkBox(adhkar: refs.adhkar),

          const SizedBox(height: 12),

          // Sources / Provenance
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : Colors.grey.shade300,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.verified,
                      size: 16,
                      color: isDark ? const Color(0xFF2DD4BF) : Colors.teal,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'التوثيق والمصادر المعتمدة (§41, §42):',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'المصادر المرجعية: ${widget.step.sourceIds.join("، ")}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Personal User Notes (§62, §63)
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.note_alt_outlined, size: 18, color: Colors.teal),
                      SizedBox(width: 6),
                      Text(
                        'ملاحظاتك وتذكيراتك الشخصية:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _noteController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText: 'أضف تذكيراً أو ملاحظة خاصة بهذه الخطوة...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      onPressed: _isSavingNote ? null : _saveNote,
                      icon: const Icon(Icons.save, size: 16),
                      label: const Text('حفظ الملاحظة'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
