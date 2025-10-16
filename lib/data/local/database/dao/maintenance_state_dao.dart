import 'package:sqflite/sqflite.dart';
import '../app_database.dart';
import '../entities/maintenance_state_entity.dart';

/// DAO para operaciones de estados de mantenimiento en la base de datos
/// 
/// Maneja todas las operaciones relacionadas con el estado actual
/// de cada tipo de mantenimiento por vehículo:
/// - Crear estados iniciales
/// - Actualizar porcentajes
/// - Obtener estados por vehículo
/// - Actualizar fechas de último cambio
class MaintenanceStateDao {
  final AppDatabase _database = AppDatabase();

  /// Inserta un nuevo estado de mantenimiento
  Future<int> insertMaintenanceState(MaintenanceStateEntity state) async {
    final db = await _database.database;
    return await db.insert('maintenance_states', state.toMap());
  }

  /// Inserta múltiples estados de mantenimiento de una vez
  Future<void> insertAll(List<MaintenanceStateEntity> states) async {
    final db = await _database.database;
    final batch = db.batch();
    
    for (final state in states) {
      batch.insert('maintenance_states', state.toMap());
    }
    
    await batch.commit();
  }

  /// Obtiene todos los estados de mantenimiento de un vehículo
  Future<List<MaintenanceStateEntity>> getStatesByVehicleId(int vehicleId) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'maintenance_states',
      where: 'vehicle_id = ?',
      whereArgs: [vehicleId],
      orderBy: 'maintenance_type ASC',
    );

    return List.generate(maps.length, (i) => MaintenanceStateEntity.fromMap(maps[i]));
  }

  /// Obtiene un estado específico de mantenimiento
  Future<MaintenanceStateEntity?> getStateByVehicleAndType(
    int vehicleId, 
    String maintenanceType,
  ) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'maintenance_states',
      where: 'vehicle_id = ? AND maintenance_type = ?',
      whereArgs: [vehicleId, maintenanceType],
    );

    if (maps.isNotEmpty) {
      return MaintenanceStateEntity.fromMap(maps.first);
    }
    return null;
  }

  /// Actualiza el porcentaje de un estado de mantenimiento
  Future<int> updatePercentage(
    int vehicleId, 
    String maintenanceType, 
    int newPercentage,
  ) async {
    final db = await _database.database;
    return await db.update(
      'maintenance_states',
      {'percentage': newPercentage},
      where: 'vehicle_id = ? AND maintenance_type = ?',
      whereArgs: [vehicleId, maintenanceType],
    );
  }

  /// Actualiza la fecha de último cambio y el próximo kilometraje
  Future<int> updateLastChanged(
    int vehicleId,
    String maintenanceType,
    DateTime lastChanged,
    int dueKm,
  ) async {
    final db = await _database.database;
    return await db.update(
      'maintenance_states',
      {
        'last_changed': lastChanged.toIso8601String(),
        'due_km': dueKm,
        'percentage': 100, // Al completar, vuelve al 100%
      },
      where: 'vehicle_id = ? AND maintenance_type = ?',
      whereArgs: [vehicleId, maintenanceType],
    );
  }

  /// Actualiza todos los datos de un estado de mantenimiento
  Future<int> updateMaintenanceState(MaintenanceStateEntity state) async {
    final db = await _database.database;
    return await db.update(
      'maintenance_states',
      state.toMap(),
      where: 'id = ?',
      whereArgs: [state.id],
    );
  }

  /// Elimina todos los estados de mantenimiento de un vehículo
  Future<int> deleteStatesByVehicleId(int vehicleId) async {
    final db = await _database.database;
    return await db.delete(
      'maintenance_states',
      where: 'vehicle_id = ?',
      whereArgs: [vehicleId],
    );
  }

  /// Elimina un estado específico de mantenimiento
  Future<int> deleteState(int vehicleId, String maintenanceType) async {
    final db = await _database.database;
    return await db.delete(
      'maintenance_states',
      where: 'vehicle_id = ? AND maintenance_type = ?',
      whereArgs: [vehicleId, maintenanceType],
    );
  }

  /// Obtiene estados críticos (porcentaje < 30%) de un usuario
  Future<List<MaintenanceStateEntity>> getCriticalStatesByUserId(int userId) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT ms.* FROM maintenance_states ms
      INNER JOIN vehicles v ON ms.vehicle_id = v.id
      WHERE v.user_id = ? AND ms.percentage < 30
      ORDER BY ms.percentage ASC
    ''', [userId]);

    return List.generate(maps.length, (i) => MaintenanceStateEntity.fromMap(maps[i]));
  }

  /// Obtiene estados que están próximos a vencer (porcentaje < 50%)
  Future<List<MaintenanceStateEntity>> getUpcomingStatesByUserId(int userId) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT ms.* FROM maintenance_states ms
      INNER JOIN vehicles v ON ms.vehicle_id = v.id
      WHERE v.user_id = ? AND ms.percentage BETWEEN 30 AND 50
      ORDER BY ms.percentage ASC
    ''', [userId]);

    return List.generate(maps.length, (i) => MaintenanceStateEntity.fromMap(maps[i]));
  }
}
