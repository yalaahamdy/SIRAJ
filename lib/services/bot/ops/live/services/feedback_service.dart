import 'dart:math';
import '../models/user_feedback.dart';

/// Privacy-preserving user feedback intake service (§19, §20, §21, §40).
class FeedbackService {
  final List<UserFeedback> _feedbackRecords = [];

  List<UserFeedback> get feedbackRecords => List.unmodifiable(_feedbackRecords);

  /// Submits user feedback safely with optional anonymity (§21).
  String submitFeedback({
    required FeedbackCategory category,
    required String reason,
    required String detailsArabic,
    String? responseId,
    List<String> evidenceIds = const [],
    bool isAnonymous = true,
    String? submitterId,
  }) {
    final feedbackId = 'fb_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';

    final feedback = UserFeedback(
      feedbackId: feedbackId,
      category: category,
      reason: reason,
      detailsArabic: detailsArabic,
      responseId: responseId,
      evidenceIds: evidenceIds,
      timestamp: DateTime.now(),
      isAnonymous: isAnonymous,
      submitterId: isAnonymous ? null : submitterId,
    );

    _feedbackRecords.add(feedback);
    return feedbackId;
  }

  /// Filters feedback by category.
  List<UserFeedback> getFeedbackByCategory(FeedbackCategory category) {
    return _feedbackRecords.where((f) => f.category == category).toList();
  }
}
