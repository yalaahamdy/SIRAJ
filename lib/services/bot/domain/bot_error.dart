import 'package:equatable/equatable.dart';

/// Categories of safe bot failure reasons (§64, §98).
enum BotFailureReason {
  channelError,
  sessionError,
  toolError,
  retrievalError,
  modelError,
  groundingFailure,
  safetyBlock,
  rateLimitExceeded,
  internalError;

  String get userMessageArabic {
    switch (this) {
      case BotFailureReason.channelError:
        return 'تعذر إرسال الرسالة عبر القناة المحددة. يُرجى المحاولة لاحقاً.';
      case BotFailureReason.sessionError:
        return 'انتهت صلاحية الجلسة الحالية. يُرجى بدء محادثة جديدة عبر الأمر /start.';
      case BotFailureReason.toolError:
        return 'تعذر استدعاء الأداة المعرفية المطلوبة في الوقت الحالي.';
      case BotFailureReason.retrievalError:
        return 'تعذر استرجاع الأدلة الموثقة من قواعد المعرفة الكنسية.';
      case BotFailureReason.modelError:
        return 'واجه مزود الذكاء الاصطناعي صعوبة في المعالجة. تم التحفظ على النتيجة للأمان.';
      case BotFailureReason.groundingFailure:
        return 'تم حجب الإجابة لعدم اكتمال الإسناد الموثق من المصادر المعتمدة.';
      case BotFailureReason.safetyBlock:
        return 'تم رفض الاستعلام لمخالفته ضوابط الأمان الشرعي والمعرفي.';
      case BotFailureReason.rateLimitExceeded:
        return 'تجاوزت الحد المسموح به من الرسائل في الدقيقة. يُرجى الانتظار قليلاً.';
      case BotFailureReason.internalError:
        return 'حدث خطأ تقني غير متوقع. يُرجى المحاولة مرة أخرى.';
    }
  }
}

/// Safe Bot Exception that never exposes raw internal stack traces to end users (§64).
class SafeBotException extends Equatable implements Exception {
  final BotFailureReason reason;
  final String internalDetails;

  const SafeBotException(this.reason, [this.internalDetails = '']);

  String get safeMessageArabic => reason.userMessageArabic;

  @override
  String toString() => 'SafeBotException: ${reason.name} ($internalDetails)';

  @override
  List<Object?> get props => [reason, internalDetails];
}
