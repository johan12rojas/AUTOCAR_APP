import 'package:shared_preferences/shared_preferences.dart';

/// Helper para manejar SharedPreferences
/// 
/// Centraliza todas las operaciones de almacenamiento local
/// para datos de sesión y configuraciones del usuario.
class SharedPrefsHelper {
  static const String _loggedInEmailKey = 'logged_in_email';
  static const String _selectedVehicleIdKey = 'selected_vehicle_id';
  static const String _firstLaunchKey = 'first_launch';
  static const String _themeModeKey = 'theme_mode';
  static const String _notificationsEnabledKey = 'notifications_enabled';

  /// Obtiene la instancia de SharedPreferences
  Future<SharedPreferences> get _prefs async {
    return await SharedPreferences.getInstance();
  }

  /// Guarda el email del usuario logueado
  Future<bool> setLoggedInEmail(String email) async {
    try {
      final prefs = await _prefs;
      return await prefs.setString(_loggedInEmailKey, email);
    } catch (e) {
      print('Error guardando email logueado: $e');
      return false;
    }
  }

  /// Obtiene el email del usuario logueado
  Future<String?> getLoggedInEmail() async {
    try {
      final prefs = await _prefs;
      return prefs.getString(_loggedInEmailKey);
    } catch (e) {
      print('Error obteniendo email logueado: $e');
      return null;
    }
  }

  /// Limpia el email del usuario logueado (logout)
  Future<bool> clearLoggedInEmail() async {
    try {
      final prefs = await _prefs;
      return await prefs.remove(_loggedInEmailKey);
    } catch (e) {
      print('Error limpiando email logueado: $e');
      return false;
    }
  }

  /// Guarda el ID del vehículo seleccionado
  Future<bool> setSelectedVehicleId(int vehicleId) async {
    try {
      final prefs = await _prefs;
      return await prefs.setInt(_selectedVehicleIdKey, vehicleId);
    } catch (e) {
      print('Error guardando vehículo seleccionado: $e');
      return false;
    }
  }

  /// Obtiene el ID del vehículo seleccionado
  Future<int?> getSelectedVehicleId() async {
    try {
      final prefs = await _prefs;
      return prefs.getInt(_selectedVehicleIdKey);
    } catch (e) {
      print('Error obteniendo vehículo seleccionado: $e');
      return null;
    }
  }

  /// Limpia el vehículo seleccionado
  Future<bool> clearSelectedVehicleId() async {
    try {
      final prefs = await _prefs;
      return await prefs.remove(_selectedVehicleIdKey);
    } catch (e) {
      print('Error limpiando vehículo seleccionado: $e');
      return false;
    }
  }

  /// Marca que la app ya se ha lanzado por primera vez
  Future<bool> setFirstLaunchCompleted() async {
    try {
      final prefs = await _prefs;
      return await prefs.setBool(_firstLaunchKey, false);
    } catch (e) {
      print('Error marcando primer lanzamiento: $e');
      return false;
    }
  }

  /// Verifica si es el primer lanzamiento de la app
  Future<bool> isFirstLaunch() async {
    try {
      final prefs = await _prefs;
      return prefs.getBool(_firstLaunchKey) ?? true;
    } catch (e) {
      print('Error verificando primer lanzamiento: $e');
      return true;
    }
  }

  /// Guarda el modo de tema (light, dark, system)
  Future<bool> setThemeMode(String mode) async {
    try {
      final prefs = await _prefs;
      return await prefs.setString(_themeModeKey, mode);
    } catch (e) {
      print('Error guardando modo de tema: $e');
      return false;
    }
  }

  /// Obtiene el modo de tema guardado
  Future<String> getThemeMode() async {
    try {
      final prefs = await _prefs;
      return prefs.getString(_themeModeKey) ?? 'system';
    } catch (e) {
      print('Error obteniendo modo de tema: $e');
      return 'system';
    }
  }

  /// Habilita o deshabilita las notificaciones
  Future<bool> setNotificationsEnabled(bool enabled) async {
    try {
      final prefs = await _prefs;
      return await prefs.setBool(_notificationsEnabledKey, enabled);
    } catch (e) {
      print('Error guardando estado de notificaciones: $e');
      return false;
    }
  }

  /// Verifica si las notificaciones están habilitadas
  Future<bool> areNotificationsEnabled() async {
    try {
      final prefs = await _prefs;
      return prefs.getBool(_notificationsEnabledKey) ?? true;
    } catch (e) {
      print('Error obteniendo estado de notificaciones: $e');
      return true;
    }
  }

  /// Guarda un valor string personalizado
  Future<bool> setString(String key, String value) async {
    try {
      final prefs = await _prefs;
      return await prefs.setString(key, value);
    } catch (e) {
      print('Error guardando string: $e');
      return false;
    }
  }

  /// Obtiene un valor string personalizado
  Future<String?> getString(String key) async {
    try {
      final prefs = await _prefs;
      return prefs.getString(key);
    } catch (e) {
      print('Error obteniendo string: $e');
      return null;
    }
  }

  /// Guarda un valor entero personalizado
  Future<bool> setInt(String key, int value) async {
    try {
      final prefs = await _prefs;
      return await prefs.setInt(key, value);
    } catch (e) {
      print('Error guardando int: $e');
      return false;
    }
  }

  /// Obtiene un valor entero personalizado
  Future<int?> getInt(String key) async {
    try {
      final prefs = await _prefs;
      return prefs.getInt(key);
    } catch (e) {
      print('Error obteniendo int: $e');
      return null;
    }
  }

  /// Guarda un valor booleano personalizado
  Future<bool> setBool(String key, bool value) async {
    try {
      final prefs = await _prefs;
      return await prefs.setBool(key, value);
    } catch (e) {
      print('Error guardando bool: $e');
      return false;
    }
  }

  /// Obtiene un valor booleano personalizado
  Future<bool?> getBool(String key) async {
    try {
      final prefs = await _prefs;
      return prefs.getBool(key);
    } catch (e) {
      print('Error obteniendo bool: $e');
      return null;
    }
  }

  /// Guarda un valor double personalizado
  Future<bool> setDouble(String key, double value) async {
    try {
      final prefs = await _prefs;
      return await prefs.setDouble(key, value);
    } catch (e) {
      print('Error guardando double: $e');
      return false;
    }
  }

  /// Obtiene un valor double personalizado
  Future<double?> getDouble(String key) async {
    try {
      final prefs = await _prefs;
      return prefs.getDouble(key);
    } catch (e) {
      print('Error obteniendo double: $e');
      return null;
    }
  }

  /// Elimina una clave específica
  Future<bool> remove(String key) async {
    try {
      final prefs = await _prefs;
      return await prefs.remove(key);
    } catch (e) {
      print('Error eliminando clave: $e');
      return false;
    }
  }

  /// Limpia todas las preferencias
  Future<bool> clear() async {
    try {
      final prefs = await _prefs;
      return await prefs.clear();
    } catch (e) {
      print('Error limpiando preferencias: $e');
      return false;
    }
  }

  /// Verifica si existe una clave
  Future<bool> containsKey(String key) async {
    try {
      final prefs = await _prefs;
      return prefs.containsKey(key);
    } catch (e) {
      print('Error verificando clave: $e');
      return false;
    }
  }

  /// Obtiene todas las claves
  Future<Set<String>> getKeys() async {
    try {
      final prefs = await _prefs;
      return prefs.getKeys();
    } catch (e) {
      print('Error obteniendo claves: $e');
      return <String>{};
    }
  }
}
