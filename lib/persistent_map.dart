import 'package:shared_preferences/shared_preferences.dart';

class PersistentMap {
  static PersistentMap? _instance;
  late final SharedPreferences _prefs;

  PersistentMap._internal(this._prefs);

  /// Call once before using [PersistentMap.instance]
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _instance = PersistentMap._internal(prefs);
  }

  /// Get the singleton instance
  static PersistentMap get instance {
    if (_instance == null) {
      throw Exception('PersistentMap not initialized. Call PersistentMap.init() first.');
    }
    return _instance!;
  }

  /// Set a value (supports bool, int, double, String, List<String>)
  Future<void> set(String key, dynamic value) async {
    if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    } else {
      throw UnsupportedError('Unsupported type for SharedPreferences: ${value.runtimeType}');
    }
  }

  /// Get a value with optional default
  dynamic get(String key, {dynamic defaultValue}) {
    return _prefs.get(key) ?? defaultValue;
  }

  /// Remove a key
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  /// Clear all keys
  Future<void> clear() async {
    await _prefs.clear();
  }

  /// Check if a key exists
  bool contains(String key) {
    return _prefs.containsKey(key);
  }

  /// Get all key-value pairs
  Map<String, Object?> get all {
    return _prefs.getKeys().fold<Map<String, Object?>>({}, (map, key) {
      map[key] = _prefs.get(key);
      return map;
    });
  }
}
