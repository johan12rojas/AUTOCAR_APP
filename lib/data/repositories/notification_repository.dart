import '../local/database/dao/notification_dao.dart';
import '../models/notification_model.dart';

/// Repositorio para operaciones de notificaciones
/// 
/// Maneja todas las operaciones relacionadas con notificaciones:
/// - Crear notificaciones
/// - Obtener notificaciones por usuario
/// - Eliminar notificaciones
/// - Filtrar por prioridad y tipo
class NotificationRepository {
  final NotificationDao _notificationDao = NotificationDao();

  /// Obtiene todas las notificaciones de un usuario
  Future<List<NotificationModel>> getNotificationsByUserId(int userId) async {
    try {
      final notificationEntities = await _notificationDao.getNotificationsByUserId(userId);
      return notificationEntities.map((entity) => NotificationModel.fromMap(entity.toMap())).toList();
    } catch (e) {
      print('Error obteniendo notificaciones: $e');
      return [];
    }
  }

  /// Obtiene notificaciones de alta prioridad
  Future<List<NotificationModel>> getHighPriorityNotifications(int userId) async {
    try {
      final notificationEntities = await _notificationDao.getHighPriorityNotifications(userId);
      return notificationEntities.map((entity) => NotificationModel.fromMap(entity.toMap())).toList();
    } catch (e) {
      print('Error obteniendo notificaciones de alta prioridad: $e');
      return [];
    }
  }

  /// Elimina una notificación por ID
  Future<bool> deleteNotification(int notificationId) async {
    try {
      final result = await _notificationDao.deleteNotification(notificationId);
      return result > 0;
    } catch (e) {
      print('Error eliminando notificación: $e');
      return false;
    }
  }

  /// Elimina todas las notificaciones de un usuario
  Future<bool> deleteAllNotifications(int userId) async {
    try {
      final result = await _notificationDao.deleteNotificationsByUserId(userId);
      return result > 0;
    } catch (e) {
      print('Error eliminando todas las notificaciones: $e');
      return false;
    }
  }
}
