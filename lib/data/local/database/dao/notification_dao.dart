import 'package:sqflite/sqflite.dart';
import '../app_database.dart';
import '../entities/notification_entity.dart';

/// DAO para operaciones de notificaciones en la base de datos
/// 
/// Maneja todas las operaciones relacionadas con las notificaciones
/// del sistema: crear, obtener, actualizar y eliminar notificaciones
class NotificationDao {
  final AppDatabase _database = AppDatabase();

  /// Inserta una nueva notificación
  Future<int> insertNotification(NotificationEntity notification) async {
    final db = await _database.database;
    return await db.insert('notifications', notification.toMap());
  }

  /// Inserta múltiples notificaciones de una vez
  Future<void> insertAll(List<NotificationEntity> notifications) async {
    final db = await _database.database;
    final batch = db.batch();
    
    for (final notification in notifications) {
      batch.insert('notifications', notification.toMap());
    }
    
    await batch.commit();
  }

  /// Obtiene todas las notificaciones de un usuario
  Future<List<NotificationEntity>> getNotificationsByUserId(int userId) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notifications',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) => NotificationEntity.fromMap(maps[i]));
  }

  /// Obtiene notificaciones filtradas por prioridad
  Future<List<NotificationEntity>> getNotificationsByPriority(
    int userId, 
    String priority,
  ) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notifications',
      where: 'user_id = ? AND priority = ?',
      whereArgs: [userId, priority],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) => NotificationEntity.fromMap(maps[i]));
  }

  /// Obtiene notificaciones relacionadas con un vehículo específico
  Future<List<NotificationEntity>> getNotificationsByVehicleId(int vehicleId) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notifications',
      where: 'vehicle_id = ?',
      whereArgs: [vehicleId],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) => NotificationEntity.fromMap(maps[i]));
  }

  /// Obtiene notificaciones por tipo
  Future<List<NotificationEntity>> getNotificationsByType(
    int userId, 
    String type,
  ) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notifications',
      where: 'user_id = ? AND type = ?',
      whereArgs: [userId, type],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) => NotificationEntity.fromMap(maps[i]));
  }

  /// Obtiene una notificación específica por ID
  Future<NotificationEntity?> getNotificationById(int id) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notifications',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return NotificationEntity.fromMap(maps.first);
    }
    return null;
  }

  /// Elimina una notificación por ID
  Future<int> deleteNotification(int id) async {
    final db = await _database.database;
    return await db.delete(
      'notifications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Elimina todas las notificaciones de un usuario
  Future<int> deleteNotificationsByUserId(int userId) async {
    final db = await _database.database;
    return await db.delete(
      'notifications',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  /// Elimina notificaciones relacionadas con un vehículo
  Future<int> deleteNotificationsByVehicleId(int vehicleId) async {
    final db = await _database.database;
    return await db.delete(
      'notifications',
      where: 'vehicle_id = ?',
      whereArgs: [vehicleId],
    );
  }

  /// Elimina notificaciones por tipo de mantenimiento
  Future<int> deleteNotificationsByMaintenanceType(
    int userId, 
    String maintenanceType,
  ) async {
    final db = await _database.database;
    return await db.delete(
      'notifications',
      where: 'user_id = ? AND maintenance_type = ?',
      whereArgs: [userId, maintenanceType],
    );
  }

  /// Cuenta notificaciones por prioridad para un usuario
  Future<Map<String, int>> getNotificationCountsByUserId(int userId) async {
    final db = await _database.database;
    final result = await db.rawQuery('''
      SELECT priority, COUNT(*) as count FROM notifications
      WHERE user_id = ?
      GROUP BY priority
    ''', [userId]);

    final Map<String, int> counts = {};
    for (final row in result) {
      counts[row['priority'] as String] = row['count'] as int;
    }

    return counts;
  }

  /// Obtiene notificaciones de alta prioridad (urgentes)
  Future<List<NotificationEntity>> getHighPriorityNotifications(int userId) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notifications',
      where: 'user_id = ? AND priority = ?',
      whereArgs: [userId, 'high'],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) => NotificationEntity.fromMap(maps[i]));
  }

  /// Elimina notificaciones antiguas (más de 30 días)
  Future<int> deleteOldNotifications() async {
    final db = await _database.database;
    final thirtyDaysAgo = DateTime.now().subtract(Duration(days: 30)).toIso8601String();
    
    return await db.delete(
      'notifications',
      where: 'created_at < ?',
      whereArgs: [thirtyDaysAgo],
    );
  }
}
