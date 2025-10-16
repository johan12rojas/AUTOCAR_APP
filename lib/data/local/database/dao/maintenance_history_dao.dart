import 'package:sqflite/sqflite.dart';
import '../app_database.dart';
import '../entities/maintenance_history_entity.dart';

/// DAO para operaciones de historial de mantenimientos en la base de datos
/// 
/// Maneja todas las operaciones relacionadas con el historial
/// de mantenimientos realizados y programados:
/// - Crear entrada de historial
/// - Obtener historial por vehículo
/// - Actualizar estado de mantenimiento
/// - Filtrar por estado y tipo
class MaintenanceHistoryDao {
  final AppDatabase _database = AppDatabase();

  /// Inserta una nueva entrada en el historial de mantenimientos
  Future<int> insertMaintenanceHistory(MaintenanceHistoryEntity history) async {
    final db = await _database.database;
    return await db.insert('maintenance_history', history.toMap());
  }

  /// Inserta múltiples entradas de historial de una vez
  Future<void> insertAll(List<MaintenanceHistoryEntity> histories) async {
    final db = await _database.database;
    final batch = db.batch();
    
    for (final history in histories) {
      batch.insert('maintenance_history', history.toMap());
    }
    
    await batch.commit();
  }

  /// Obtiene todo el historial de mantenimientos de un vehículo
  Future<List<MaintenanceHistoryEntity>> getHistoryByVehicleId(int vehicleId) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'maintenance_history',
      where: 'vehicle_id = ?',
      whereArgs: [vehicleId],
      orderBy: 'date DESC, created_at DESC',
    );

    return List.generate(maps.length, (i) => MaintenanceHistoryEntity.fromMap(maps[i]));
  }

  /// Obtiene el historial filtrado por estado
  Future<List<MaintenanceHistoryEntity>> getHistoryByStatus(
    int vehicleId, 
    String status,
  ) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'maintenance_history',
      where: 'vehicle_id = ? AND status = ?',
      whereArgs: [vehicleId, status],
      orderBy: 'date ASC',
    );

    return List.generate(maps.length, (i) => MaintenanceHistoryEntity.fromMap(maps[i]));
  }

  /// Obtiene el historial filtrado por tipo de mantenimiento
  Future<List<MaintenanceHistoryEntity>> getHistoryByType(
    int vehicleId, 
    String maintenanceType,
  ) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'maintenance_history',
      where: 'vehicle_id = ? AND maintenance_type = ?',
      whereArgs: [vehicleId, maintenanceType],
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) => MaintenanceHistoryEntity.fromMap(maps[i]));
  }

  /// Obtiene una entrada específica del historial por ID
  Future<MaintenanceHistoryEntity?> getHistoryById(int id) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'maintenance_history',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return MaintenanceHistoryEntity.fromMap(maps.first);
    }
    return null;
  }

  /// Actualiza el estado de una entrada del historial
  Future<int> updateStatus(int id, String newStatus) async {
    final db = await _database.database;
    return await db.update(
      'maintenance_history',
      {'status': newStatus},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Actualiza todos los datos de una entrada del historial
  Future<int> updateMaintenanceHistory(MaintenanceHistoryEntity history) async {
    final db = await _database.database;
    return await db.update(
      'maintenance_history',
      history.toMap(),
      where: 'id = ?',
      whereArgs: [history.id],
    );
  }

  /// Elimina una entrada del historial por ID
  Future<int> deleteHistoryEntry(int id) async {
    final db = await _database.database;
    return await db.delete(
      'maintenance_history',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Elimina todo el historial de un vehículo
  Future<int> deleteHistoryByVehicleId(int vehicleId) async {
    final db = await _database.database;
    return await db.delete(
      'maintenance_history',
      where: 'vehicle_id = ?',
      whereArgs: [vehicleId],
    );
  }

  /// Obtiene mantenimientos pendientes de un usuario
  Future<List<MaintenanceHistoryEntity>> getPendingMaintenancesByUserId(int userId) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT mh.* FROM maintenance_history mh
      INNER JOIN vehicles v ON mh.vehicle_id = v.id
      WHERE v.user_id = ? AND mh.status = 'pending'
      ORDER BY mh.date ASC
    ''', [userId]);

    return List.generate(maps.length, (i) => MaintenanceHistoryEntity.fromMap(maps[i]));
  }

  /// Obtiene mantenimientos urgentes de un usuario
  Future<List<MaintenanceHistoryEntity>> getUrgentMaintenancesByUserId(int userId) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT mh.* FROM maintenance_history mh
      INNER JOIN vehicles v ON mh.vehicle_id = v.id
      WHERE v.user_id = ? AND mh.status = 'urgent'
      ORDER BY mh.date ASC
    ''', [userId]);

    return List.generate(maps.length, (i) => MaintenanceHistoryEntity.fromMap(maps[i]));
  }

  /// Obtiene mantenimientos completados de un usuario
  Future<List<MaintenanceHistoryEntity>> getCompletedMaintenancesByUserId(int userId) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT mh.* FROM maintenance_history mh
      INNER JOIN vehicles v ON mh.vehicle_id = v.id
      WHERE v.user_id = ? AND mh.status = 'completed'
      ORDER BY mh.date DESC
      LIMIT 50
    ''', [userId]);

    return List.generate(maps.length, (i) => MaintenanceHistoryEntity.fromMap(maps[i]));
  }

  /// Cuenta mantenimientos por estado para un usuario
  Future<Map<String, int>> getMaintenanceCountsByUserId(int userId) async {
    final db = await _database.database;
    final result = await db.rawQuery('''
      SELECT mh.status, COUNT(*) as count FROM maintenance_history mh
      INNER JOIN vehicles v ON mh.vehicle_id = v.id
      WHERE v.user_id = ?
      GROUP BY mh.status
    ''', [userId]);

    final Map<String, int> counts = {};
    for (final row in result) {
      counts[row['status'] as String] = row['count'] as int;
    }

    return counts;
  }
}
