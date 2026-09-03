import '../../domain/unified_message.dart';
import '../../runtime/api/bot_api_server.dart';
import '../control/bot_feature_flag_service.dart';
import '../control/global_safety_kill_switch.dart';
import '../lifecycle/channel_health_service.dart';
import '../lifecycle/channel_lifecycle_manager.dart';
import '../lifecycle/webhook_lifecycle_manager.dart';
import '../registry/bot_registry.dart';
import '../security/admin_rbac.dart';
import '../security/security_event_logger.dart';
import '../security/staging_allowlist.dart';

/// Admin Control Panel & Operations API Server for Bot Platform Management (§23, §24).
class BotAdminApiServer {
  final BotRegistry _botRegistry;
  final ChannelLifecycleManager _lifecycleManager;
  final WebhookLifecycleManager _webhookManager;
  final ChannelHealthService _healthService;
  final BotFeatureFlagService _featureFlags;
  final GlobalSafetyKillSwitch _killSwitch;
  final StagingAllowlist _allowlist;
  final SecurityEventLogger _securityLogger;

  BotAdminApiServer({
    required BotRegistry botRegistry,
    required ChannelLifecycleManager lifecycleManager,
    required WebhookLifecycleManager webhookManager,
    required ChannelHealthService healthService,
    required BotFeatureFlagService featureFlags,
    required GlobalSafetyKillSwitch killSwitch,
    required StagingAllowlist allowlist,
    required SecurityEventLogger securityLogger,
  })  : _botRegistry = botRegistry,
        _lifecycleManager = lifecycleManager,
        _webhookManager = webhookManager,
        _healthService = healthService,
        _featureFlags = featureFlags,
        _killSwitch = killSwitch,
        _allowlist = allowlist,
        _securityLogger = securityLogger;

  /// Dispatches an administrative HTTP request with RBAC validation (§21, §23).
  Future<HttpResponseContext> handleAdminRequest(
    HttpRequestContext request, {
    AdminRole callerRole = AdminRole.operator,
  }) async {
    final path = request.path;
    final method = request.method.toUpperCase();

    try {
      // 1. List Bots (§10, §23)
      if (path == '/admin/bots' && method == 'GET') {
        final bots = _botRegistry.getAllBots().map((b) => b.toJson()).toList();
        return HttpResponseContext.json(200, {'bots': bots});
      }

      // 2. Channel Operations (§5, §23)
      if (path == '/admin/channels' && method == 'GET') {
        return HttpResponseContext.json(200, {
          'channels': _lifecycleManager.getSummary(),
          'health': _healthService.getHealthSummary(),
        });
      }

      if (path == '/admin/channels/toggle' && method == 'POST') {
        if (!AdminRBAC.hasPermission(callerRole, 'TOGGLE_CHANNEL')) {
          return HttpResponseContext.error(403, 'غير مصرح لك بتعديل حالة القنوات', code: 'FORBIDDEN');
        }
        final body = request.parseJsonBody();
        final channelStr = body['channel'] as String? ?? '';
        final enable = body['enable'] as bool? ?? true;

        final channel = ChannelType.values.firstWhere(
          (c) => c.name == channelStr,
          orElse: () => ChannelType.telegram,
        );

        _lifecycleManager.setChannelState(
          channel,
          enable ? ChannelLifecycleState.active : ChannelLifecycleState.disabled,
        );

        return HttpResponseContext.json(200, {
          'status': 'success',
          'channel': channel.name,
          'is_active': enable,
        });
      }

      // 3. Webhook Rotation (§7, §23)
      if (path == '/admin/webhooks/rotate' && method == 'POST') {
        if (!AdminRBAC.hasPermission(callerRole, 'ROTATE_SECRETS')) {
          return HttpResponseContext.error(403, 'تدوير الأسرار مخصص لمسؤولي الأمان فقط', code: 'FORBIDDEN');
        }
        final body = request.parseJsonBody();
        final channelStr = body['channel'] as String? ?? 'telegram';
        final newSecret = body['new_secret'] as String? ?? 'new_rotated_secret_${DateTime.now().millisecondsSinceEpoch}';

        final channel = ChannelType.values.firstWhere(
          (c) => c.name == channelStr,
          orElse: () => ChannelType.telegram,
        );

        _webhookManager.rotateSecret(channel, newSecret);
        _securityLogger.logEvent(
          type: SecurityEventType.authFailure,
          sourceChannel: channel.name,
          identifier: 'admin_action',
          details: 'Webhook secret rotated successfully',
        );

        return HttpResponseContext.json(200, {
          'status': 'success',
          'message_arabic': 'تم تدوير مفتاح الويب هوك بنجاح مع فترة تداخل آمنة.',
        });
      }

      // 4. Feature Flags (§14, §23)
      if (path == '/admin/flags' && method == 'GET') {
        return HttpResponseContext.json(200, {'flags': _featureFlags.getAllFlags()});
      }

      if (path == '/admin/flags/set' && method == 'POST') {
        final body = request.parseJsonBody();
        final flag = body['flag'] as String? ?? '';
        final value = body['value'] as bool? ?? false;

        _featureFlags.setFlag(flag, value);
        return HttpResponseContext.json(200, {'status': 'success', 'flag': flag, 'value': value});
      }

      // 5. Global Safety Kill Switch (§15, §23)
      if (path == '/admin/kill-switch' && method == 'POST') {
        if (!AdminRBAC.hasPermission(callerRole, 'TRIGGER_KILL_SWITCH')) {
          return HttpResponseContext.error(403, 'غير مصرح بتشغيل زر الطوارئ', code: 'FORBIDDEN');
        }
        final body = request.parseJsonBody();
        final target = body['target'] as String? ?? 'ai';
        final action = body['action'] as String? ?? 'kill';

        if (target == 'ai') {
          if (action == 'kill') {
            _killSwitch.killAi(reason: 'Admin emergency trigger');
          } else {
            _killSwitch.restoreAi();
          }
        }

        _securityLogger.logEvent(
          type: SecurityEventType.killSwitchTriggered,
          sourceChannel: 'admin',
          identifier: 'operator',
          details: 'Kill switch triggered on $target: $action',
        );

        return HttpResponseContext.json(200, {
          'status': 'success',
          'kill_switch_status': _killSwitch.getStatus(),
        });
      }

      // 6. Staging Allowlist (§47)
      if (path == '/admin/allowlist' && method == 'GET') {
        return HttpResponseContext.json(200, {'allowed_users': _allowlist.getAllowedUsers()});
      }

      if (path == '/admin/allowlist/add' && method == 'POST') {
        final body = request.parseJsonBody();
        final user = body['user_id'] as String? ?? '';
        if (user.isNotEmpty) _allowlist.addAllowedUser(user);
        return HttpResponseContext.json(200, {'status': 'success', 'added_user': user});
      }

      // 7. Security Events Log (§37)
      if (path == '/admin/events/security' && method == 'GET') {
        final events = _securityLogger.events.map((e) => e.toJson()).toList();
        return HttpResponseContext.json(200, {'security_events': events});
      }

      // 8. Operations Dashboard Foundation (§24)
      if (path == '/admin/dashboard' && method == 'GET') {
        return HttpResponseContext.json(200, {
          'dashboard': {
            'active_bots': _botRegistry.getAllBots().length,
            'channels': _lifecycleManager.getSummary(),
            'channel_health': _healthService.getHealthSummary(),
            'kill_switch': _killSwitch.getStatus(),
            'flags': _featureFlags.getAllFlags(),
            'recent_security_events_count': _securityLogger.events.length,
          }
        });
      }

      return HttpResponseContext.error(404, 'المسار الإداري غير موجود', code: 'ADMIN_NOT_FOUND');
    } catch (e) {
      return HttpResponseContext.error(500, 'حدث خطأ داخلي في الخادم الإداري', code: 'ADMIN_ERROR');
    }
  }
}
