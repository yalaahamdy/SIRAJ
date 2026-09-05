import 'package:flutter/material.dart';
import '../../../modules/seerah/domain/historical_person.dart';
import '../../../modules/seerah/domain/person_relationship.dart';
import '../../../modules/seerah/seerah_module.dart';
import '../theme/app_colors.dart';

/// Screen displaying biographical details, historical roles, and sourced relationships (§8, §10, §36).
class PersonDetailScreen extends StatelessWidget {
  final HistoricalPerson person;
  final SeerahModule module;

  const PersonDetailScreen({
    super.key,
    required this.person,
    required this.module,
  });

  @override
  Widget build(BuildContext context) {
    final relsRes = module.getRelationshipsForPerson(person.personId);
    final relationships = relsRes.valueOrNull ?? [];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final bodyColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF1E293B);
    final subColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final primaryAccent = isDark ? AppColors.goldAccentLight : const Color(0xFF0F5132);
    final cardBg = isDark ? AppColors.surfaceDark : Colors.white;
    final cardBorder = isDark ? AppColors.borderDark : const Color(0xFF0F5132).withAlpha(45);

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            person.canonicalName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        children: [
          // 1. Header Biography Card
          Card(
            elevation: isDark ? 1 : 2,
            color: cardBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: cardBorder, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: primaryAccent.withAlpha(isDark ? 40 : 25),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: primaryAccent.withAlpha(isDark ? 120 : 80)),
                          ),
                          child: Text(
                            person.historicalRole,
                            style: TextStyle(
                              color: primaryAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 11.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      if (person.titleOrLakab != null) ...[
                        const SizedBox(width: 8),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFFFBBF24).withAlpha(35) : const Color(0xFF92400E).withAlpha(20),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isDark ? const Color(0xFFFBBF24).withAlpha(100) : const Color(0xFF92400E).withAlpha(80),
                              ),
                            ),
                            child: Text(
                              person.titleOrLakab!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E),
                                fontSize: 11.5,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    person.canonicalName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (person.kunyah != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'الكنية: ${person.kunyah!}',
                      style: TextStyle(fontSize: 13, color: subColor, fontWeight: FontWeight.w500),
                    ),
                  ],
                  const SizedBox(height: 12),
                  if (person.birthDate != null || person.deathDate != null) ...[
                    Row(
                      children: [
                        if (person.birthDate != null)
                          Expanded(
                            child: Text(
                              'الميلاد: ${person.birthDate!.dateDisplay}',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: bodyColor),
                            ),
                          ),
                        if (person.deathDate != null)
                          Expanded(
                            child: Text(
                              'الوفاة: ${person.deathDate!.dateDisplay}',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: bodyColor),
                            ),
                          ),
                      ],
                    ),
                    Divider(height: 20, color: isDark ? AppColors.borderDark : null),
                  ],
                  Text(
                    person.biographicalSummary,
                    style: TextStyle(
                      fontSize: 14.5,
                      height: 1.65,
                      color: bodyColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 2. Relationships Section
          Text(
            'العلاقات والروابط التاريخية الموثقة:',
            style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: titleColor),
          ),
          const SizedBox(height: 8),

          if (relationships.isEmpty)
            Card(
              elevation: 1,
              color: cardBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'لا توجد علاقات مسجلة لهذه الشخصية في الحزمة الحالية',
                  style: TextStyle(color: subColor, fontSize: 13),
                ),
              ),
            )
          else
            ...relationships.map((r) => _buildRelationshipTile(context, r, isDark)),
        ],
      ),
    );
  }

  Widget _buildRelationshipTile(BuildContext context, PersonRelationship r, bool isDark) {
    final otherPersonId = r.fromPersonId == person.personId ? r.toPersonId : r.fromPersonId;
    final otherPersonRes = module.getPerson(otherPersonId);
    final otherName = otherPersonRes.valueOrNull?.canonicalName ?? otherPersonId;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);
    final accent = isDark ? AppColors.goldAccentLight : const Color(0xFF0F5132);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: isDark ? 0.8 : 1.5,
      color: isDark ? AppColors.surfaceDark : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isDark ? AppColors.goldAccent.withAlpha(45) : const Color(0xFF0F5132),
          child: Icon(
            Icons.people_alt_outlined,
            color: isDark ? AppColors.goldAccentLight : Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          otherName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: titleColor),
        ),
        subtitle: Text(
          '${r.type.labelArabic} ${r.description != null ? '— ${r.description!}' : ''}',
          style: TextStyle(fontSize: 12.5, color: subtitleColor),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 12, color: accent),
        onTap: otherPersonRes.isSuccess
            ? () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PersonDetailScreen(
                      person: otherPersonRes.valueOrNull!,
                      module: module,
                    ),
                  ),
                );
              }
            : null,
      ),
    );
  }
}
