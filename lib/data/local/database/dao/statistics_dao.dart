import 'package:sqflite/sqflite.dart';
import '../app_database.dart';
import '../entities/statistics_entity.dart';

/// DAO para operaciones de estadísticas en la base de datos
/// 
/// Maneja las estadísticas del usuario como:
/// - Total de mantenimientos realizados
/// - Mantenimientos completados a tiempo
/// - Racha de días consecutivos
class StatisticsDao {
  final AppDatabase _database = AppDatabase();

  /// Crea las estadísticas iniciales para un usuario
  Future<int> createStatistics(int userId) async {
    final db = await _database.database;
    final statistics = StatisticsEntity(
      userId: userId,
      totalMaintenance: 0,
      onTimeCompletions: 0,
      streak: 0,
    );
    
    return await db.insert('statistics', statistics.toMap());
  }

  /// Obtiene las estadísticas de un usuario
  Future<StatisticsEntity?> getStatisticsByUserId(int userId) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'statistics',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    if (maps.isNotEmpty) {
      return StatisticsEntity.fromMap(maps.first);
    }
    return null;
  }

  /// Incrementa el contador de mantenimientos totales
  Future<int> incrementTotalMaintenance(int userId) async {
    final db = await _database.database;
    return await db.rawUpdate('''
      UPDATE statistics 
      SET total_maintenance = total_maintenance + 1 
      WHERE user_id = ?
    ''', [userId]);
  }

  /// Incrementa el contador de mantenimientos completados a tiempo
  Future<int> incrementOnTimeCompletions(int userId) async {
    final db = await _database.database;
    return await db.rawUpdate('''
      UPDATE statistics 
      SET on_time_completions = on_time_completions + 1 
      WHERE user_id = ?
    ''', [userId]);
  }

  /// Actualiza la racha de días consecutivos
  Future<int> updateStreak(int userId, int newStreak) async {
    final db = await _database.database;
    return await db.update(
      'statistics',
      {'streak': newStreak},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  /// Actualiza todas las estadísticas de un usuario
  Future<int> updateStatistics(StatisticsEntity statistics) async {
    final db = await _database.database;
    return await db.update(
      'statistics',
      statistics.toMap(),
      where: 'user_id = ?',
      whereArgs: [statistics.userId],
    );
  }

  /// Elimina las estadísticas de un usuario
  Future<int> deleteStatistics(int userId) async {
    final db = await _database.database;
    return await db.delete(
      'statistics',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  /// Obtiene el porcentaje de mantenimientos completados a tiempo
  Future<double> getOnTimePercentage(int userId) async {
    final statistics = await getStatisticsByUserId(userId);
    if (statistics == null || statistics.totalMaintenance == 0) {
      return 0.0;
    }
    
    return (statistics.onTimeCompletions / statistics.totalMaintenance) * 100;
  }

  /// Resetea todas las estadísticas de un usuario
  Future<int> resetStatistics(int userId) async {
    final db = await _database.database;
    return await db.update(
      'statistics',
      {
        'total_maintenance': 0,
        'on_time_completions': 0,
        'streak': 0,
      },
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }
}
