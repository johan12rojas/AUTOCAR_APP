import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../local/database/dao/user_dao.dart';
import '../local/database/dao/statistics_dao.dart';
import '../local/preferences/shared_prefs_helper.dart';
import '../models/user_model.dart';
import '../models/statistics_model.dart';
import '../../core/utils/validators.dart';

/// Repositorio para operaciones de autenticación
/// 
/// Maneja el registro, login y logout de usuarios con:
/// - Hash de contraseñas usando SHA-256
/// - Validación de datos
/// - Gestión de sesión persistente
/// - Creación de estadísticas iniciales
class AuthRepository {
  final UserDao _userDao = UserDao();
  final StatisticsDao _statisticsDao = StatisticsDao();
  final SharedPrefsHelper _sharedPrefs = SharedPrefsHelper();

  /// Registra un nuevo usuario en el sistema
  /// 
  /// Proceso completo:
  /// 1. Valida los datos de entrada
  /// 2. Verifica que el email no exista
  /// 3. Hashea la contraseña
  /// 4. Crea el usuario en la BD
  /// 5. Crea estadísticas iniciales
  /// 6. Guarda la sesión
  /// 7. Crea notificaciones de bienvenida
  Future<UserModel?> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // 1. Validar datos de entrada
      if (!Validators.isValidName(name)) {
        throw Exception('El nombre debe tener al menos 2 caracteres');
      }
      
      if (!Validators.isValidEmail(email)) {
        throw Exception('El email no tiene un formato válido');
      }
      
      if (!Validators.isValidPassword(password)) {
        throw Exception('La contraseña debe tener al menos 6 caracteres');
      }

      // 2. Verificar que el email no exista
      final existingUser = await _userDao.getUserByEmail(email);
      if (existingUser != null) {
        throw Exception('Ya existe un usuario con este email');
      }

      // 3. Hashear la contraseña
      final hashedPassword = _hashPassword(password);

      // 4. Crear el usuario
      final user = UserModel(
        name: name.trim(),
        email: email.toLowerCase().trim(),
        password: hashedPassword,
        createdAt: DateTime.now(),
      );

      final userId = await _userDao.insertUser(user.toMap());
      if (userId == 0) {
        throw Exception('Error al crear el usuario');
      }

      // 5. Crear estadísticas iniciales
      await _statisticsDao.createStatistics(userId);

      // 6. Guardar sesión
      await _sharedPrefs.setLoggedInEmail(email.toLowerCase().trim());

      // 7. Retornar el usuario creado
      return user.copyWith(id: userId);
    } catch (e) {
      print('Error en signup: $e');
      return null;
    }
  }

  /// Autentica un usuario existente
  /// 
  /// Proceso:
  /// 1. Busca el usuario por email
  /// 2. Verifica la contraseña
  /// 3. Guarda la sesión
  /// 4. Retorna el usuario autenticado
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Buscar usuario por email
      final userEntity = await _userDao.getUserByEmail(email.toLowerCase().trim());
      if (userEntity == null) {
        throw Exception('Usuario no encontrado');
      }

      // 2. Verificar contraseña
      final hashedPassword = _hashPassword(password);
      if (userEntity.password != hashedPassword) {
        throw Exception('Contraseña incorrecta');
      }

      // 3. Guardar sesión
      await _sharedPrefs.setLoggedInEmail(email.toLowerCase().trim());

      // 4. Convertir entidad a modelo y retornar
      return UserModel.fromMap(userEntity.toMap());
    } catch (e) {
      print('Error en login: $e');
      return null;
    }
  }

  /// Cierra la sesión del usuario actual
  Future<void> logout() async {
    await _sharedPrefs.clearLoggedInEmail();
  }

  /// Obtiene el usuario actualmente logueado
  Future<UserModel?> getCurrentUser() async {
    try {
      final email = await _sharedPrefs.getLoggedInEmail();
      if (email == null) return null;

      final userEntity = await _userDao.getUserByEmail(email);
      if (userEntity == null) return null;

      return UserModel.fromMap(userEntity.toMap());
    } catch (e) {
      print('Error obteniendo usuario actual: $e');
      return null;
    }
  }

  /// Verifica si hay un usuario logueado
  Future<bool> isLoggedIn() async {
    final email = await _sharedPrefs.getLoggedInEmail();
    return email != null;
  }

  /// Actualiza los datos del usuario actual
  Future<bool> updateUser(UserModel user) async {
    try {
      final result = await _userDao.updateUser(user.toMap());
      return result > 0;
    } catch (e) {
      print('Error actualizando usuario: $e');
      return false;
    }
  }

  /// Cambia la contraseña del usuario
  Future<bool> changePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      // 1. Obtener usuario actual
      final userEntity = await _userDao.getUserById(userId);
      if (userEntity == null) return false;

      // 2. Verificar contraseña actual
      final currentHashedPassword = _hashPassword(currentPassword);
      if (userEntity.password != currentHashedPassword) {
        throw Exception('Contraseña actual incorrecta');
      }

      // 3. Validar nueva contraseña
      if (!Validators.isValidPassword(newPassword)) {
        throw Exception('La nueva contraseña debe tener al menos 6 caracteres');
      }

      // 4. Hashear nueva contraseña
      final newHashedPassword = _hashPassword(newPassword);

      // 5. Actualizar en la BD
      final user = UserModel.fromMap(userEntity.toMap());
      final updatedUser = user.copyWith(password: newHashedPassword);
      
      final result = await _userDao.updateUser(updatedUser.toMap());
      return result > 0;
    } catch (e) {
      print('Error cambiando contraseña: $e');
      return false;
    }
  }

  /// Elimina la cuenta del usuario
  Future<bool> deleteAccount(int userId) async {
    try {
      // 1. Eliminar usuario (esto eliminará automáticamente todos los datos relacionados
      //    debido a las foreign keys con CASCADE)
      final result = await _userDao.deleteUser(userId);
      
      if (result > 0) {
        // 2. Limpiar sesión
        await logout();
        return true;
      }
      
      return false;
    } catch (e) {
      print('Error eliminando cuenta: $e');
      return false;
    }
  }

  /// Hashea una contraseña usando SHA-256
  /// 
  /// Nota: En una aplicación real, se debería usar bcrypt o scrypt,
  /// pero para este proyecto académico usamos SHA-256 con salt
  String _hashPassword(String password) {
    // Crear un salt simple basado en la contraseña
    final salt = 'autocare_salt_2024';
    final bytes = utf8.encode(password + salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Verifica si una contraseña coincide con el hash almacenado
  bool _verifyPassword(String password, String hash) {
    return _hashPassword(password) == hash;
  }

  /// Obtiene las estadísticas del usuario actual
  Future<StatisticsModel?> getUserStatistics(int userId) async {
    try {
      final statisticsEntity = await _statisticsDao.getStatisticsByUserId(userId);
      if (statisticsEntity == null) return null;
      
      return StatisticsModel.fromMap(statisticsEntity.toMap());
    } catch (e) {
      print('Error obteniendo estadísticas: $e');
      return null;
    }
  }

  /// Valida si un email está disponible para registro
  Future<bool> isEmailAvailable(String email) async {
    try {
      final exists = await _userDao.emailExists(email.toLowerCase().trim());
      return !exists;
    } catch (e) {
      print('Error verificando email: $e');
      return false;
    }
  }
}
