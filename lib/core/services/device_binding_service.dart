import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceBindingResult {
  const DeviceBindingResult({
    required this.isAuthorized,
    this.reason,
  });

  final bool isAuthorized;
  final String? reason;
}

/// Binds DriftPOS to a single machine using a hashed platform device identifier.
class DeviceBindingService {
  DeviceBindingService._();

  static const storageKey = 'activated_device_id';

  static String? _testMachineIdOverride;

  @visibleForTesting
  static void setTestMachineIdOverride(String? machineId) {
    _testMachineIdOverride = machineId;
  }

  static Future<DeviceBindingResult> ensureAuthorized() async {
    final currentId = await _currentMachineIdHash();
    final prefs = await SharedPreferences.getInstance();
    final storedId = prefs.getString(storageKey);

    if (storedId == null || storedId.isEmpty) {
      await prefs.setString(storageKey, currentId);
      return const DeviceBindingResult(isAuthorized: true);
    }

    if (storedId == currentId) {
      return const DeviceBindingResult(isAuthorized: true);
    }

    return const DeviceBindingResult(
      isAuthorized: false,
      reason: 'This copy of DriftPOS is licensed to another device.',
    );
  }

  /// Clears the stored binding and registers the current machine.
  static Future<void> rebindCurrentDevice() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(storageKey);
    final result = await ensureAuthorized();
    if (!result.isAuthorized) {
      throw StateError('Failed to rebind device.');
    }
  }

  static Future<String> _currentMachineIdHash() async {
    final rawId = await _readPlatformMachineId();
    return _hash(rawId);
  }

  static String _hash(String value) {
    return sha256.convert(utf8.encode(value)).toString();
  }

  static Future<String> _readPlatformMachineId() async {
    if (_testMachineIdOverride != null) {
      return _testMachineIdOverride!;
    }

    final plugin = DeviceInfoPlugin();

    if (Platform.isWindows) {
      final info = await plugin.windowsInfo;
      return info.deviceId;
    }

    if (Platform.isMacOS) {
      final info = await plugin.macOsInfo;
      final guid = info.systemGUID;
      if (guid != null && guid.trim().isNotEmpty) {
        return guid;
      }
      return '${info.computerName}|${info.model}|${info.hostName}';
    }

    if (Platform.isLinux) {
      final info = await plugin.linuxInfo;
      final machineId = info.machineId;
      if (machineId != null && machineId.trim().isNotEmpty) {
        return machineId;
      }
      return '${info.name}|${info.version}|${info.prettyName}';
    }

    if (Platform.isAndroid) {
      return (await plugin.androidInfo).id;
    }

    if (Platform.isIOS) {
      return (await plugin.iosInfo).identifierForVendor ?? 'ios-unknown';
    }

    throw UnsupportedError(
      'Device binding is not supported on this platform.',
    );
  }
}
