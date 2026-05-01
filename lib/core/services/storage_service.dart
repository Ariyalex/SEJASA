/// Service for local storage.
/// Handle write, read, and delete data.
/// Using shared preferences for regular data and secure storage for token.

library;

import 'dart:async';
import 'package:sejasa/core/utils/log_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service class for Storage service.
class StorageService {
  ///instance of shared preferences
  late SharedPreferences _prefs;

  // Completer to track initialization status
  final Completer<void> _initCompleter = Completer<void>();
  Future<void> get isReady => _initCompleter.future;

  Future<void> initStorage() async {
    try {
      _prefs = await SharedPreferences.getInstance();

      _initCompleter.complete();
      LogUtils.d("✅ StorageService: Initialized successfully");
    } catch (e) {
      LogUtils.e("❌ StorageService: Initialization failed", e);
      // Don't leave the completer hanging if it errors
      if (!_initCompleter.isCompleted) _initCompleter.complete();
    }
  }

  /// Write string with key to shared preferences
  Future<void> write(String key, String value) async {
    await isReady;
    await _prefs.setString(key, value);
  }

  /// Write boolean with key to shared preferences
  Future<void> writeBool(String key, bool value) async {
    await isReady;
    await _prefs.setBool(key, value);
  }

  /// Write Integer with key to shared preferences
  Future<void> writeInt(String key, int value) async {
    await isReady;
    await _prefs.setInt(key, value);
  }

  /// Read String using key in shared preference.
  Future<String?> read(String key) async {
    await isReady;
    return _prefs.getString(key);
  }

  /// Read boolean using key in shared preferences.
  Future<bool?> readBool(String key) async {
    await isReady;
    return _prefs.getBool(key);
  }

  /// Read Integer using key in shared preferences.
  Future<int?> readInt(String key) async {
    await isReady;
    return _prefs.getInt(key);
  }

  /// Delete any data in shared prefences based on key.
  Future<void> delete(String key) async {
    await isReady;
    await _prefs.remove(key);
  }

  /// Delete all data in shared preferences.
  Future<void> clear() async {
    await isReady;
    await _prefs.clear();
  }
}
