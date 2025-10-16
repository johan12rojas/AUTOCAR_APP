import 'package:flutter/foundation.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';

/// Provider para gestión de autenticación
/// 
/// Maneja el estado de autenticación del usuario:
/// - Login/logout
/// - Registro de usuarios
/// - Estado de sesión
/// - Datos del usuario actual
class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  
  UserModel? _currentUser;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Verifica el estado de autenticación al iniciar la app
  Future<void> checkAuthStatus() async {
    _setLoading(true);
    try {
      _isLoggedIn = await _authRepository.isLoggedIn();
      if (_isLoggedIn) {
        _currentUser = await _authRepository.getCurrentUser();
      }
    } catch (e) {
      _setError('Error verificando estado de autenticación: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Carga los datos del usuario actual
  Future<void> loadUserData() async {
    if (!_isLoggedIn) return;
    
    _setLoading(true);
    try {
      _currentUser = await _authRepository.getCurrentUser();
      if (_currentUser != null) {
        _isLoggedIn = true;
      } else {
        _isLoggedIn = false;
      }
    } catch (e) {
      _setError('Error cargando datos del usuario: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Registra un nuevo usuario
  Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final user = await _authRepository.signup(
        name: name,
        email: email,
        password: password,
      );
      
      if (user != null) {
        _currentUser = user;
        _isLoggedIn = true;
        notifyListeners();
        return true;
      } else {
        _setError('Error al crear la cuenta');
        return false;
      }
    } catch (e) {
      _setError('Error al crear la cuenta: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Autentica un usuario existente
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final user = await _authRepository.login(
        email: email,
        password: password,
      );
      
      if (user != null) {
        _currentUser = user;
        _isLoggedIn = true;
        notifyListeners();
        return true;
      } else {
        _setError('Credenciales incorrectas');
        return false;
      }
    } catch (e) {
      _setError('Error al iniciar sesión: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Cierra la sesión del usuario
  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authRepository.logout();
      _currentUser = null;
      _isLoggedIn = false;
      notifyListeners();
    } catch (e) {
      _setError('Error al cerrar sesión: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Actualiza los datos del usuario
  Future<bool> updateUser(UserModel user) async {
    _setLoading(true);
    _clearError();
    
    try {
      final success = await _authRepository.updateUser(user);
      if (success) {
        _currentUser = user;
        notifyListeners();
        return true;
      } else {
        _setError('Error al actualizar el perfil');
        return false;
      }
    } catch (e) {
      _setError('Error al actualizar el perfil: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Cambia la contraseña del usuario
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (_currentUser == null) return false;
    
    _setLoading(true);
    _clearError();
    
    try {
      final success = await _authRepository.changePassword(
        userId: _currentUser!.id!,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      
      if (success) {
        return true;
      } else {
        _setError('Error al cambiar la contraseña');
        return false;
      }
    } catch (e) {
      _setError('Error al cambiar la contraseña: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Elimina la cuenta del usuario
  Future<bool> deleteAccount() async {
    if (_currentUser == null) return false;
    
    _setLoading(true);
    _clearError();
    
    try {
      final success = await _authRepository.deleteAccount(_currentUser!.id!);
      if (success) {
        _currentUser = null;
        _isLoggedIn = false;
        notifyListeners();
        return true;
      } else {
        _setError('Error al eliminar la cuenta');
        return false;
      }
    } catch (e) {
      _setError('Error al eliminar la cuenta: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Verifica si un email está disponible
  Future<bool> isEmailAvailable(String email) async {
    try {
      return await _authRepository.isEmailAvailable(email);
    } catch (e) {
      return false;
    }
  }

  /// Obtiene las estadísticas del usuario
  Future<dynamic> getUserStatistics() async {
    if (_currentUser == null) return null;
    
    try {
      return await _authRepository.getUserStatistics(_currentUser!.id!);
    } catch (e) {
      return null;
    }
  }

  /// Limpia el mensaje de error
  void clearError() {
    _clearError();
  }

  // Métodos privados
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
