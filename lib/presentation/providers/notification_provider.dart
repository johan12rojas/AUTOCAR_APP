import 'package:flutter/foundation.dart';
import '../../data/repositories/notification_repository.dart';
import '../../data/models/notification_model.dart';

/// Provider para gestión de notificaciones
/// 
/// Maneja el estado de las notificaciones del usuario:
/// - Lista de notificaciones
/// - Notificaciones por prioridad
/// - Operaciones de crear/eliminar
class NotificationProvider extends ChangeNotifier {
  final NotificationRepository _notificationRepository = NotificationRepository();
  
  List<NotificationModel> _notifications = [];
  List<NotificationModel> _highPriorityNotifications = [];
  List<NotificationModel> _mediumPriorityNotifications = [];
  List<NotificationModel> _lowPriorityNotifications = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<NotificationModel> get notifications => _notifications;
  List<NotificationModel> get highPriorityNotifications => _highPriorityNotifications;
  List<NotificationModel> get mediumPriorityNotifications => _mediumPriorityNotifications;
  List<NotificationModel> get lowPriorityNotifications => _lowPriorityNotifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get totalNotifications => _notifications.length;
  int get unreadNotifications => _notifications.length; // Por ahora todas son "no leídas"

  /// Carga todas las notificaciones de un usuario
  Future<void> loadNotifications(int userId) async {
    _setLoading(true);
    _clearError();
    
    try {
      _notifications = await _notificationRepository.getNotificationsByUserId(userId);
      _categorizeNotifications();
      notifyListeners();
    } catch (e) {
      _setError('Error cargando notificaciones: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Carga notificaciones de alta prioridad
  Future<void> loadHighPriorityNotifications(int userId) async {
    _setLoading(true);
    _clearError();
    
    try {
      _highPriorityNotifications = await _notificationRepository.getHighPriorityNotifications(userId);
      notifyListeners();
    } catch (e) {
      _setError('Error cargando notificaciones de alta prioridad: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Elimina una notificación
  Future<bool> deleteNotification(int notificationId) async {
    _setLoading(true);
    _clearError();
    
    try {
      final success = await _notificationRepository.deleteNotification(notificationId);
      
      if (success) {
        // Remover la notificación de todas las listas
        _notifications.removeWhere((n) => n.id == notificationId);
        _highPriorityNotifications.removeWhere((n) => n.id == notificationId);
        _mediumPriorityNotifications.removeWhere((n) => n.id == notificationId);
        _lowPriorityNotifications.removeWhere((n) => n.id == notificationId);
        
        notifyListeners();
        return true;
      } else {
        _setError('Error al eliminar la notificación');
        return false;
      }
    } catch (e) {
      _setError('Error al eliminar la notificación: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Elimina todas las notificaciones de un usuario
  Future<bool> deleteAllNotifications(int userId) async {
    _setLoading(true);
    _clearError();
    
    try {
      final success = await _notificationRepository.deleteAllNotifications(userId);
      
      if (success) {
        _notifications.clear();
        _highPriorityNotifications.clear();
        _mediumPriorityNotifications.clear();
        _lowPriorityNotifications.clear();
        
        notifyListeners();
        return true;
      } else {
        _setError('Error al eliminar todas las notificaciones');
        return false;
      }
    } catch (e) {
      _setError('Error al eliminar todas las notificaciones: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Obtiene notificaciones por tipo
  List<NotificationModel> getNotificationsByType(String type) {
    return _notifications.where((n) => n.type == type).toList();
  }

  /// Obtiene notificaciones relacionadas con un vehículo
  List<NotificationModel> getNotificationsByVehicle(int vehicleId) {
    return _notifications.where((n) => n.vehicleId == vehicleId).toList();
  }

  /// Obtiene notificaciones relacionadas con un tipo de mantenimiento
  List<NotificationModel> getNotificationsByMaintenanceType(String maintenanceType) {
    return _notifications.where((n) => n.maintenanceType == maintenanceType).toList();
  }

  /// Cuenta notificaciones por prioridad
  int getNotificationCountByPriority(String priority) {
    return _notifications.where((n) => n.priority == priority).length;
  }

  /// Cuenta notificaciones por tipo
  int getNotificationCountByType(String type) {
    return _notifications.where((n) => n.type == type).length;
  }

  /// Obtiene la notificación más reciente
  NotificationModel? getLatestNotification() {
    if (_notifications.isEmpty) return null;
    
    _notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return _notifications.first;
  }

  /// Obtiene notificaciones recientes (últimas 7 días)
  List<NotificationModel> getRecentNotifications() {
    return _notifications.where((n) => n.isRecent).toList();
  }

  /// Obtiene notificaciones muy recientes (últimas 24 horas)
  List<NotificationModel> getVeryRecentNotifications() {
    return _notifications.where((n) => n.isVeryRecent).toList();
  }

  /// Verifica si hay notificaciones críticas
  bool get hasCriticalNotifications => _highPriorityNotifications.isNotEmpty;

  /// Verifica si hay notificaciones pendientes
  bool get hasPendingNotifications => _mediumPriorityNotifications.isNotEmpty;

  /// Obtiene el total de notificaciones por prioridad
  Map<String, int> getNotificationCounts() {
    return {
      'high': _highPriorityNotifications.length,
      'medium': _mediumPriorityNotifications.length,
      'low': _lowPriorityNotifications.length,
    };
  }

  /// Limpia todas las notificaciones (útil para logout)
  void clearNotifications() {
    _notifications.clear();
    _highPriorityNotifications.clear();
    _mediumPriorityNotifications.clear();
    _lowPriorityNotifications.clear();
    notifyListeners();
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

  void _categorizeNotifications() {
    _highPriorityNotifications = _notifications.where((n) => n.isHighPriority).toList();
    _mediumPriorityNotifications = _notifications.where((n) => n.isMediumPriority).toList();
    _lowPriorityNotifications = _notifications.where((n) => n.isLowPriority).toList();
  }
}
