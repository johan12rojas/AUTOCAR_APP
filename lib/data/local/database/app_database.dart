import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Configuración principal de la base de datos SQLite
/// 
/// Esta clase maneja la creación y configuración de todas las tablas
/// del sistema AutoCare: users, vehicles, maintenance_states, etc.
class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;
  AppDatabase._internal();

  static Database? _database;

  /// Obtiene la instancia de la base de datos
  /// Si no existe, la crea automáticamente
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Inicializa la base de datos y crea todas las tablas
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'autocare.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Crea todas las tablas cuando se crea la base de datos por primera vez
  Future<void> _onCreate(Database db, int version) async {
    // Tabla de usuarios
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Tabla de vehículos
    await db.execute('''
      CREATE TABLE vehicles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        make TEXT NOT NULL,
        model TEXT NOT NULL,
        year INTEGER NOT NULL,
        mileage INTEGER NOT NULL,
        type TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Tabla de estados de mantenimiento
    await db.execute('''
      CREATE TABLE maintenance_states (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        vehicle_id INTEGER NOT NULL,
        maintenance_type TEXT NOT NULL,
        percentage INTEGER NOT NULL,
        last_changed TEXT NOT NULL,
        due_km INTEGER NOT NULL,
        FOREIGN KEY (vehicle_id) REFERENCES vehicles (id) ON DELETE CASCADE,
        UNIQUE (vehicle_id, maintenance_type)
      )
    ''');

    // Tabla de historial de mantenimientos
    await db.execute('''
      CREATE TABLE maintenance_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        vehicle_id INTEGER NOT NULL,
        maintenance_type TEXT NOT NULL,
        date TEXT NOT NULL,
        mileage INTEGER NOT NULL,
        notes TEXT,
        cost REAL,
        location TEXT,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (vehicle_id) REFERENCES vehicles (id) ON DELETE CASCADE
      )
    ''');

    // Tabla de notificaciones
    await db.execute('''
      CREATE TABLE notifications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        vehicle_id INTEGER,
        type TEXT NOT NULL,
        title TEXT NOT NULL,
        message TEXT NOT NULL,
        maintenance_type TEXT,
        priority TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (vehicle_id) REFERENCES vehicles (id) ON DELETE CASCADE
      )
    ''');

    // Tabla de estadísticas
    await db.execute('''
      CREATE TABLE statistics (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL UNIQUE,
        total_maintenance INTEGER DEFAULT 0,
        on_time_completions INTEGER DEFAULT 0,
        streak INTEGER DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    print('✅ Base de datos AutoCare creada exitosamente');
  }

  /// Maneja las actualizaciones de la base de datos
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Aquí se pueden agregar migraciones futuras
    print('🔄 Actualizando base de datos de v$oldVersion a v$newVersion');
  }

  /// Cierra la conexión a la base de datos
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  /// Elimina la base de datos (útil para testing)
  Future<void> deleteDatabase() async {
    String path = join(await getDatabasesPath(), 'autocare.db');
    await databaseFactory.deleteDatabase(path);
    _database = null;
    print('🗑️ Base de datos eliminada');
  }
}
