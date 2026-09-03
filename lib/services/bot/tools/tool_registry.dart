import 'tool_definition.dart';

/// Registry managing safe, typed bot tools and permission enforcement (§18, §25, §69).
class BotToolRegistry {
  final Map<String, BotToolDefinition> _tools = {};

  BotToolRegistry({List<BotToolDefinition>? tools}) {
    if (tools != null) {
      for (final t in tools) {
        registerTool(t);
      }
    }
  }

  void registerTool(BotToolDefinition tool) {
    _tools[tool.name] = tool;
  }

  List<BotToolDefinition> get allTools => _tools.values.toList();

  BotToolDefinition? getTool(String name) => _tools[name];

  /// Executes a tool with strict permission checking (§25, §69).
  Future<ToolResult> executeTool({
    required String toolName,
    required Map<String, dynamic> arguments,
    bool isAdmin = false,
  }) async {
    final tool = _tools[toolName];
    if (tool == null) {
      return ToolResult.failure('الأداة المطلوبة غير مسجلة في المنصة.');
    }

    if (tool.permissionLevel == ToolPermissionLevel.disabled) {
      return ToolResult.failure('الأداة معطلة حالياً لدواعي الأمان.');
    }

    if (tool.permissionLevel == ToolPermissionLevel.adminOnly && !isAdmin) {
      return ToolResult.failure('تم رفض الاستدعاء: هذه الأداة مخصصة للإدارة فقط.');
    }

    try {
      return await tool.execute(arguments);
    } catch (e) {
      return ToolResult.failure('فشل تنفيذ الأداة: $e');
    }
  }
}
