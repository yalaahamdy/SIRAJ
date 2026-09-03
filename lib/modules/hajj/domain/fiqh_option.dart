/// Sourced Scholarly Fiqh Position for a specific ritual step (§9).
class FiqhOption {
  final String schoolOrScholar;
  final String positionArabic;
  final String evidenceSummary;
  final String? sourceId;

  const FiqhOption({
    required this.schoolOrScholar,
    required this.positionArabic,
    required this.evidenceSummary,
    this.sourceId,
  });

  Map<String, dynamic> toJson() => {
        'schoolOrScholar': schoolOrScholar,
        'positionArabic': positionArabic,
        'evidenceSummary': evidenceSummary,
        if (sourceId != null) 'sourceId': sourceId,
      };

  factory FiqhOption.fromJson(Map<String, dynamic> json) => FiqhOption(
        schoolOrScholar: json['schoolOrScholar'] as String,
        positionArabic: json['positionArabic'] as String,
        evidenceSummary: json['evidenceSummary'] as String,
        sourceId: json['sourceId'] as String?,
      );
}
