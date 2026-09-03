import 'package:equatable/equatable.dart';

/// Permission level governing tool execution (§25).
enum ToolPermissionLevel {
  readPublicVerified('قراءة محتوى كنسي عام'),
  readUserScoped('قراءة بيانات المستخدم'),
  writeUserScoped('كتابة/تعديل بيانات المستخدم (يتطلب تأكيداً)'),
  sensitiveUserData('بيانات حساسة (زكاة/مالية)'),
  adminOnly('إداري فقط (محظور للمستخدمين)'),
  disabled('معطل');

  final String labelArabic;
  const ToolPermissionLevel(this.labelArabic);
}

/// Execution result returned by a safe bot tool (§70).
class ToolResult extends Equatable {
  final bool isSuccess;
  final String outputTextArabic;
  final Map<String, dynamic> data;
  final String? errorMessageArabic;

  const ToolResult({
    required this.isSuccess,
    required this.outputTextArabic,
    this.data = const {},
    this.errorMessageArabic,
  });

  static ToolResult success(String output, [Map<String, dynamic> data = const {}]) {
    return ToolResult(isSuccess: true, outputTextArabic: output, data: data);
  }

  static ToolResult failure(String errorMessage) {
    return ToolResult(isSuccess: false, outputTextArabic: '', errorMessageArabic: errorMessage);
  }

  @override
  List<Object?> get props => [isSuccess, outputTextArabic, data, errorMessageArabic];
}

/// Abstract definition for a typed, scoped bot tool (§18, §25).
abstract class BotToolDefinition {
  String get name;
  String get descriptionArabic;
  ToolPermissionLevel get permissionLevel;

  Future<ToolResult> execute(Map<String, dynamic> arguments);
}
