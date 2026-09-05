import 'package:flutter/material.dart';
import '../../../../modules/quran/domain/ayah.dart';
import '../../../../modules/quran/services/quran_tafsir_service.dart';
import '../../theme/app_colors.dart';

/// Context-aware, scholarly exegesis modal displaying Al-Tafsir Al-Muyassar (§13, §14).
class TafsirBottomSheet extends StatefulWidget {
  final int surahNumber;
  final String surahNameArabic;
  final int initialAyahNumber;
  final int totalAyahsInSurah;
  final Ayah Function(int ayahNumber)? ayahLookup;
  final QuranTafsirService tafsirService;

  const TafsirBottomSheet({
    super.key,
    required this.surahNumber,
    required this.surahNameArabic,
    required this.initialAyahNumber,
    required this.totalAyahsInSurah,
    required this.tafsirService,
    this.ayahLookup,
  });

  @override
  State<TafsirBottomSheet> createState() => _TafsirBottomSheetState();
}

class _TafsirBottomSheetState extends State<TafsirBottomSheet> {
  late int _currentAyahNumber;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _currentAyahNumber = widget.initialAyahNumber;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _goToAyah(int ayah) {
    if (ayah >= 1 && ayah <= widget.totalAyahsInSurah) {
      setState(() => _currentAyahNumber = ayah);
      _scrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tafsir = widget.tafsirService.getTafsir(widget.surahNumber, _currentAyahNumber);
    final ayah = widget.ayahLookup?.call(_currentAyahNumber);
    final edition = widget.tafsirService.currentEdition;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF181C22) : const Color(0xFFFAF8F5),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.15),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تفسير سورة ${widget.surahNameArabic} — الآية $_currentAyahNumber',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.goldAccent : AppColors.primary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${edition.nameArabic} • ${edition.publisher}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.grey[400] : Colors.grey[700],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  tooltip: 'إغلاق التفسير',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Content
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              children: [
                // Ayah Reference Card
                if (ayah != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.goldAccent.withValues(alpha: isDark ? 0.12 : 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.goldAccent.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      '${ayah.textUthmani} ﴿${ayah.ayahNumber}﴾',
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 22,
                        height: 2.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.goldAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                ],

                // Tafsir Text
                if (tafsir != null)
                  Text(
                    tafsir.tafsirText,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 18,
                      height: 1.9,
                      color: isDark ? Colors.grey[200] : const Color(0xFF2C241B),
                    ),
                  )
                else
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text('التفسير قيد المعالجة لهذه الآية.'),
                    ),
                  ),

                const SizedBox(height: 24),

                // Provenance Note
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'المصدر: ${edition.provenance}\nالمؤلف: ${edition.author}\nالترخيص: ${edition.license}',
                    style: TextStyle(
                      fontSize: 10,
                      height: 1.5,
                      color: isDark ? Colors.grey[500] : Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Navigation between consecutive ayahs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF14171A) : Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: _currentAyahNumber > 1
                      ? () => _goToAyah(_currentAyahNumber - 1)
                      : null,
                  icon: const Icon(Icons.arrow_back_ios_rounded, size: 14),
                  label: const Text('الآية السابقة'),
                ),
                Text(
                  '$_currentAyahNumber / ${widget.totalAyahsInSurah}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                TextButton.icon(
                  onPressed: _currentAyahNumber < widget.totalAyahsInSurah
                      ? () => _goToAyah(_currentAyahNumber + 1)
                      : null,
                  icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  label: const Text('الآية التالية'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
