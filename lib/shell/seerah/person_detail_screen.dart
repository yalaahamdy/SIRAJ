import 'package:flutter/material.dart';
import '../../../modules/seerah/domain/historical_person.dart';
import '../../../modules/seerah/domain/person_relationship.dart';
import '../../../modules/seerah/seerah_module.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text(person.canonicalName),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Header Biography Card
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
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F5132).withAlpha(20),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            person.historicalRole,
                            style: const TextStyle(
                              color: Color(0xFF0F5132),
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      if (person.titleOrLakab != null) ...[
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            person.titleOrLakab!,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF856404)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    person.canonicalName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (person.kunyah != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'الكنية: ${person.kunyah!}',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
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
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                        if (person.deathDate != null)
                          Expanded(
                            child: Text(
                              'الوفاة: ${person.deathDate!.dateDisplay}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                      ],
                    ),
                    const Divider(height: 20),
                  ],
                  Text(
                    person.biographicalSummary,
                    style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 2. Relationships Section
          const Text(
            'العلاقات والروابط التاريخية الموثقة:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          if (relationships.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('لا توجد علاقات مسجلة لهذه الشخصية في الحزمة الحالية', style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            ...relationships.map((r) => _buildRelationshipTile(context, r)),
        ],
      ),
    );
  }

  Widget _buildRelationshipTile(BuildContext context, PersonRelationship r) {
    final otherPersonId = r.fromPersonId == person.personId ? r.toPersonId : r.fromPersonId;
    final otherPersonRes = module.getPerson(otherPersonId);
    final otherName = otherPersonRes.valueOrNull?.canonicalName ?? otherPersonId;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const Icon(Icons.people_alt_outlined, color: Color(0xFF0F5132)),
        title: Text(otherName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(
          '${r.type.labelArabic} ${r.description != null ? '— ${r.description!}' : ''}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 12),
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
