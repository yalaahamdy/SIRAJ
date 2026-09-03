import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../../domain/unified_message.dart';

class WebhookEndpointConfig {
  final ChannelType channel;
  String activeSecret;
  String? previousSecret; // Grace period secret during rotation
  DateTime? secretRotatedAt;
  bool isEnabled;

  WebhookEndpointConfig({
    required this.channel,
    required this.activeSecret,
    this.previousSecret,
    this.secretRotatedAt,
    this.isEnabled = true,
  });
}

/// Manages Webhook registration, secure secret rotation with overlap, and verification (§6, §7, §8).
class WebhookLifecycleManager {
  final Map<ChannelType, WebhookEndpointConfig> _endpoints = {};
  final Duration rotationGracePeriod;

  WebhookLifecycleManager({
    this.rotationGracePeriod = const Duration(minutes: 15),
    Map<ChannelType, String>? initialSecrets,
  }) {
    if (initialSecrets != null) {
      for (final entry in initialSecrets.entries) {
        _endpoints[entry.key] = WebhookEndpointConfig(
          channel: entry.key,
          activeSecret: entry.value,
        );
      }
    }
  }

  void registerWebhook(ChannelType channel, String secret) {
    _endpoints[channel] = WebhookEndpointConfig(
      channel: channel,
      activeSecret: secret,
    );
  }

  /// Rotates webhook secret safely, keeping the old secret active for the grace period (§7).
  void rotateSecret(ChannelType channel, String newSecret) {
    final endpoint = _endpoints[channel];
    if (endpoint != null) {
      endpoint.previousSecret = endpoint.activeSecret;
      endpoint.activeSecret = newSecret;
      endpoint.secretRotatedAt = DateTime.now().toUtc();
    } else {
      registerWebhook(channel, newSecret);
    }
  }

  /// Verifies an incoming webhook HMAC signature against active and grace period secrets (§7).
  bool verifyHmacSignature({
    required ChannelType channel,
    required String rawBody,
    required String signature,
  }) {
    final endpoint = _endpoints[channel];
    if (endpoint == null || !endpoint.isEnabled || signature.isEmpty || rawBody.isEmpty) {
      return false;
    }

    // 1. Check against active secret
    if (_checkHmac(endpoint.activeSecret, rawBody, signature)) {
      return true;
    }

    // 2. Check against previous secret if within grace period (§7)
    if (endpoint.previousSecret != null && endpoint.secretRotatedAt != null) {
      final elapsed = DateTime.now().toUtc().difference(endpoint.secretRotatedAt!);
      if (elapsed <= rotationGracePeriod) {
        return _checkHmac(endpoint.previousSecret!, rawBody, signature);
      }
    }

    return false;
  }

  bool _checkHmac(String secret, String rawBody, String signature) {
    final key = utf8.encode(secret);
    final bytes = utf8.encode(rawBody);
    final digest = Hmac(sha256, key).convert(bytes);
    return digest.toString() == signature;
  }

  void disableWebhook(ChannelType channel) {
    _endpoints[channel]?.isEnabled = false;
  }

  void enableWebhook(ChannelType channel) {
    _endpoints[channel]?.isEnabled = true;
  }

  Map<String, dynamic> inspectStatus() {
    final Map<String, dynamic> status = {};
    for (final entry in _endpoints.entries) {
      status[entry.key.name] = {
        'enabled': entry.value.isEnabled,
        'has_active_secret': entry.value.activeSecret.isNotEmpty,
        'has_rotating_overlap': entry.value.previousSecret != null,
        'rotated_at': entry.value.secretRotatedAt?.toIso8601String(),
      };
    }
    return status;
  }
}
