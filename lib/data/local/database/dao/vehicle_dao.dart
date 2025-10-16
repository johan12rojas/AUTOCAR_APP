import 'package:sqflite/sqflite.dart';
import '../app_database.dart';
import '../entities/vehicle_entity.dart';

/// DAO para operaciones de vehículos en la base de datos
/// 
/// Maneja todas las operaciones CRUD relacionadas con vehículos:
/// - Crear vehículo
/// - Obtener vehículos de un usuario
/// - Actualizar kilometraje
/// - Eliminar vehículo
class VehicleDao {
  final AppDatabase _database = AppDatabase();

  /// Inserta un nuevo vehículo en la base de datos
  /// 
  /// Retorna el ID del vehículo creado
  Future<int> insertVehicle(VehicleEntity vehicle) async {
    final db = await _database.database;
    return await db.insert('vehicles', vehicle.toMap());
  }

  /// Obtiene todos los vehículos de un usuario específico
  Future<List<VehicleEntity>> getVehiclesByUserId(int userId) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'vehicles',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) => VehicleEntity.fromMap(maps[i]));
  }

  /// Obtiene un vehículo por su ID
  Future<VehicleEntity?> getVehicleById(int id) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'vehicles',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return VehicleEntity.fromMap(maps.first);
    }
    return null;
  }

  /// Actualiza el kilometraje de un vehículo
  Future<int> updateMileage(int vehicleId, int newMileage) async {
    final db = await _database.database;
    return await db.update(
      'vehicles',
      {'mileage': newMileage},
      where: 'id = ?',
      whereArgs: [vehicleId],
    );
  }

  /// Actualiza todos los datos de un vehículo
  Future<int> updateVehicle(VehicleEntity vehicle) async {
    final db = await _database.database;
    return await db.update(
      'vehicles',
      vehicle.toMap(),
      where: 'id = ?',
      whereArgs: [vehicle.id],
    );
  }

  /// Elimina un vehículo por ID
  /// 
  /// Esto también eliminará automáticamente todos los mantenimientos
  /// relacionados debido a las foreign keys con CASCADE
  Future<int> deleteVehicle(int id) async {
    final db = await _database.database;
    return await db.delete(
      'vehicles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Cuenta cuántos vehículos tiene un usuario
  Future<int> countVehiclesByUserId(int userId) async {
    final db = await _database.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM vehicles WHERE user_id = ?',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Obtiene el vehículo más reciente de un usuario
  Future<VehicleEntity?> getLatestVehicleByUserId(int userId) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'vehicles',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return VehicleEntity.fromMap(maps.first);
    }
    return null;
  }
}
