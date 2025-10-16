import 'package:sqflite/sqflite.dart';
import '../app_database.dart';
import '../entities/user_entity.dart';

/// DAO para operaciones de usuarios en la base de datos
/// 
/// Maneja todas las operaciones CRUD relacionadas con usuarios:
/// - Crear usuario
/// - Buscar por email
/// - Actualizar datos
/// - Eliminar usuario
class UserDao {
  final AppDatabase _database = AppDatabase();

  /// Inserta un nuevo usuario en la base de datos
  /// 
  /// Retorna el ID del usuario creado
  Future<int> insertUser(UserEntity user) async {
    final db = await _database.database;
    return await db.insert('users', user.toMap());
  }

  /// Busca un usuario por su email
  /// 
  /// Retorna el usuario si existe, null si no
  Future<UserEntity?> getUserByEmail(String email) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return UserEntity.fromMap(maps.first);
    }
    return null;
  }

  /// Busca un usuario por su ID
  Future<UserEntity?> getUserById(int id) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return UserEntity.fromMap(maps.first);
    }
    return null;
  }

  /// Actualiza los datos de un usuario
  Future<int> updateUser(UserEntity user) async {
    final db = await _database.database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  /// Elimina un usuario por ID
  Future<int> deleteUser(int id) async {
    final db = await _database.database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Verifica si existe un usuario con el email dado
  Future<bool> emailExists(String email) async {
    final user = await getUserByEmail(email);
    return user != null;
  }

  /// Obtiene todos los usuarios (útil para debugging)
  Future<List<UserEntity>> getAllUsers() async {
    final db = await _database.database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) => UserEntity.fromMap(maps[i]));
  }
}
