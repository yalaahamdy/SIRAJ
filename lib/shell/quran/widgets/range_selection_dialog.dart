import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Modal dialog allowing the user to specify and action a multi-verse range (§15, §16).
class RangeSelectionDialog extends StatefulWidget {
  final int surahNumber;
  final String surahNameArabic;
  final int initialAyah;
  final int totalAyahs;
  final void Function(int startAyah, int endAyah) onSelectRange;
  final void Function(int startAyah, int endAyah)? onPlayRange;

  const RangeSelectionDialog({
    super.key,
    required this.surahNumber,
    required this.surahNameArabic,
    required this.initialAyah,
    required this.totalAyahs,
    required this.onSelectRange,
    this.onPlayRange,
  });

  @override
  State<RangeSelectionDialog> createState() => _RangeSelectionDialogState();
}

class _RangeSelectionDialogState extends State<RangeSelectionDialog> {
  late int _startAyah;
  late int _endAyah;

  @override
  void initState() {
    super.initState();
    _startAyah = widget.initialAyah;
    _endAyah = (_startAyah + 4).clamp(1, widget.totalAyahs);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      title: Text(
        'تحديد نطاق آيات — سورة ${widget.surahNameArabic}',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'اختر بداية ونهاية نطاق الآيات للتلاوة أو الحفظ أو النسخ:',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),

          // Start Ayah Picker
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('من الآية:', style: TextStyle(fontWeight: FontWeight.w600)),
              DropdownButton<int>(
                value: _startAyah,
                dropdownColor: isDark ? const Color(0xFF232830) : Colors.white,
                items: List.generate(widget.totalAyahs, (i) => i + 1)
                    .map((a) => DropdownMenuItem(value: a, child: Text('$a')))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _startAyah = val;
                      if (_endAyah < _startAyah) _endAyah = _startAyah;
                    });
                  }
                },
              ),
            ],
          ),

          // End Ayah Picker
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('إلى الآية:', style: TextStyle(fontWeight: FontWeight.w600)),
              DropdownButton<int>(
                value: _endAyah,
                dropdownColor: isDark ? const Color(0xFF232830) : Colors.white,
                items: List.generate(widget.totalAyahs - _startAyah + 1, (i) => _startAyah + i)
                    .map((a) => DropdownMenuItem(value: a, child: Text('$a')))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _endAyah = val);
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.goldAccent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'النطاق المحدد: ${_endAyah - _startAyah + 1} آيات ($_startAyah إلى $_endAyah)',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.goldAccent),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        if (widget.onPlayRange != null)
          TextButton.icon(
            icon: const Icon(Icons.play_circle_outline_rounded, size: 18),
            label: const Text('تلاوة النطاق'),
            onPressed: () {
              Navigator.of(context).pop();
              widget.onPlayRange?.call(_startAyah, _endAyah);
            },
          ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? AppColors.goldAccent : AppColors.primary,
            foregroundColor: isDark ? Colors.black87 : Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            widget.onSelectRange(_startAyah, _endAyah);
          },
          child: const Text('تحديد في القارئ'),
        ),
      ],
    );
  }
}
