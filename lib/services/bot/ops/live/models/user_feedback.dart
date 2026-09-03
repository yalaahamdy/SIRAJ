import 'package:equatable/equatable.dart';

/// Categories for user submitted feedback (§18, §19).
enum FeedbackCategory {
  bug,
  contentIssue,
  aiAnswerIssue,
  ux,
  privacy,
  channelIssue,
}

/// Structured, privacy-preserving user feedback object (§19, §20, §21).
class UserFeedback extends Equatable {
  final String feedbackId;
  final FeedbackCategory category;
  final String reason;
  final String detailsArabic;
  final String? responseId;
  final List<String> evidenceIds;
  final DateTime timestamp;
  final bool isAnonymous;
  final String? submitterId;

  const UserFeedback({
    required this.feedbackId,
    required this.category,
    required this.reason,
    required this.detailsArabic,
    this.responseId,
    this.evidenceIds = const [],
    required this.timestamp,
    this.isAnonymous = true,
    this.submitterId,
  });

  @override
  List<Object?> get props => [
        feedbackId,
        category,
        reason,
        detailsArabic,
        responseId,
        evidenceIds,
        timestamp,
        isAnonymous,
        submitterId,
      ];
}
