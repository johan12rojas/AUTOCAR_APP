import '../local/database/dao/vehicle_dao.dart';
import '../local/database/dao/maintenance_state_dao.dart';
import '../local/database/dao/maintenance_history_dao.dart';
import '../local/database/dao/notification_dao.dart';
import '../models/vehicle_model.dart';
import '../models/maintenance_state_model.dart';
import '../models/maintenance_history_model.dart';
import '../models/notification_model.dart';
import '../../core/constants/maintenance_intervals.dart';
import '../../core/utils/validators.dart';

/// Repositorio para operaciones de vehículos
/// 
/// Maneja todas las operaciones relacionadas con vehículos:
/// - CRUD de vehículos
/// - Creación de datos de ejemplo para primer vehículo
/// - Actualización de kilometraje
/// - Gestión de estados de mantenimiento
class VehicleRepository {
  final VehicleDao _vehicleDao = VehicleDao();
  final MaintenanceStateDao _maintenanceStateDao = MaintenanceStateDao();
  final MaintenanceHistoryDao _maintenanceHistoryDao = MaintenanceHistoryDao();
  final NotificationDao _notificationDao = NotificationDao();

  /// Agrega un nuevo vehículo al sistema
  /// 
  /// Proceso completo:
  /// 1. Valida los datos del vehículo
  /// 2. Inserta el vehículo en la BD
  /// 3. Crea estados de mantenimiento iniciales
  /// 4. Si es el primer vehículo, crea datos de ejemplo
  /// 5. Crea notificaciones relacionadas
  Future<VehicleModel?> addVehicle({
    required int userId,
    required String make,
    required String model,
    required int year,
    required int mileage,
    required String type,
  }) async {
    try {
      // 1. Validar datos del vehículo
      if (!Validators.isValidMake(make)) {
        throw Exception('La marca debe tener al menos 2 caracteres');
      }
      
      if (!Validators.isValidModel(model)) {
        throw Exception('El modelo no puede estar vacío');
      }
      
      if (!Validators.isValidYear(year)) {
        throw Exception('El año debe estar entre 1900 y ${DateTime.now().year + 1}');
      }
      
      if (!Validators.isValidMileage(mileage)) {
        throw Exception('El kilometraje debe estar entre 0 y 999,999 km');
      }
      
      if (!Validators.isValidVehicleType(type)) {
        throw Exception('El tipo debe ser "car" o "motorcycle"');
      }

      // 2. Crear el vehículo
      final vehicle = VehicleModel(
        userId: userId,
        make: make.trim(),
        model: model.trim(),
        year: year,
        mileage: mileage,
        type: type,
        createdAt: DateTime.now(),
      );

      final vehicleId = await _vehicleDao.insertVehicle(vehicle.toMap());
      if (vehicleId == 0) {
        throw Exception('Error al crear el vehículo');
      }

      // 3. Crear estados de mantenimiento iniciales
      await _createInitialMaintenanceStates(vehicleId, mileage, type);

      // 4. Verificar si es el primer vehículo del usuario
      final vehicleCount = await _vehicleDao.countVehiclesByUserId(userId);
      if (vehicleCount == 1) {
        // Es el primer vehículo, crear datos de ejemplo
        await _createExampleData(vehicleId, mileage, type);
      }

      // 5. Crear notificaciones
      await _createVehicleAddedNotifications(userId, vehicleId, make, model);

      return vehicle.copyWith(id: vehicleId);
    } catch (e) {
      print('Error agregando vehículo: $e');
      return null;
    }
  }

  /// Obtiene todos los vehículos de un usuario
  Future<List<VehicleModel>> getVehiclesByUserId(int userId) async {
    try {
      final vehicleEntities = await _vehicleDao.getVehiclesByUserId(userId);
      return vehicleEntities.map((entity) => VehicleModel.fromMap(entity.toMap())).toList();
    } catch (e) {
      print('Error obteniendo vehículos: $e');
      return [];
    }
  }

  /// Obtiene un vehículo por su ID
  Future<VehicleModel?> getVehicleById(int id) async {
    try {
      final vehicleEntity = await _vehicleDao.getVehicleById(id);
      if (vehicleEntity == null) return null;
      
      return VehicleModel.fromMap(vehicleEntity.toMap());
    } catch (e) {
      print('Error obteniendo vehículo: $e');
      return null;
    }
  }

  /// Actualiza el kilometraje de un vehículo
  /// 
  /// También recalcula los porcentajes de mantenimiento
  Future<bool> updateMileage(int vehicleId, int newMileage) async {
    try {
      if (!Validators.isValidMileage(newMileage)) {
        throw Exception('El kilometraje debe estar entre 0 y 999,999 km');
      }

      // 1. Actualizar kilometraje del vehículo
      final result = await _vehicleDao.updateMileage(vehicleId, newMileage);
      if (result == 0) return false;

      // 2. Recalcular porcentajes de mantenimiento
      await _recalculateMaintenancePercentages(vehicleId, newMileage);

      // 3. Verificar si hay mantenimientos críticos
      await _checkCriticalMaintenances(vehicleId, newMileage);

      return true;
    } catch (e) {
      print('Error actualizando kilometraje: $e');
      return false;
    }
  }

  /// Actualiza todos los datos de un vehículo
  Future<bool> updateVehicle(VehicleModel vehicle) async {
    try {
      final result = await _vehicleDao.updateVehicle(vehicle.toMap());
      return result > 0;
    } catch (e) {
      print('Error actualizando vehículo: $e');
      return false;
    }
  }

  /// Elimina un vehículo y todos sus datos relacionados
  Future<bool> deleteVehicle(int vehicleId) async {
    try {
      final result = await _vehicleDao.deleteVehicle(vehicleId);
      return result > 0;
    } catch (e) {
      print('Error eliminando vehículo: $e');
      return false;
    }
  }

  /// Obtiene el vehículo más reciente de un usuario
  Future<VehicleModel?> getLatestVehicleByUserId(int userId) async {
    try {
      final vehicleEntity = await _vehicleDao.getLatestVehicleByUserId(userId);
      if (vehicleEntity == null) return null;
      
      return VehicleModel.fromMap(vehicleEntity.toMap());
    } catch (e) {
      print('Error obteniendo último vehículo: $e');
      return null;
    }
  }

  /// Crea los estados iniciales de mantenimiento para un vehículo
  Future<void> _createInitialMaintenanceStates(int vehicleId, int mileage, String type) async {
    final now = DateTime.now();
    final states = <MaintenanceStateModel>[];

    // Estados comunes para carros y motos
    final commonMaintenances = ['oil', 'tires', 'brakes', 'battery', 'coolant'];
    
    for (final maintenanceType in commonMaintenances) {
      final interval = MaintenanceIntervals.getInterval(maintenanceType);
      final dueKm = mileage + interval;
      
      // Calcular porcentaje inicial basado en kilometraje simulado
      final simulatedLastChange = mileage - (interval * 0.6).round();
      final percentage = ((dueKm - mileage) / interval * 100).round().clamp(0, 100);
      
      states.add(MaintenanceStateModel(
        vehicleId: vehicleId,
        maintenanceType: maintenanceType,
        percentage: percentage,
        lastChanged: now.subtract(Duration(days: 30)),
        dueKm: dueKm,
      ));
    }

    // Estados específicos según el tipo de vehículo
    if (type == 'car') {
      // Solo para carros
      final carMaintenances = ['airFilter', 'alignment'];
      
      for (final maintenanceType in carMaintenances) {
        final interval = MaintenanceIntervals.getInterval(maintenanceType);
        final dueKm = mileage + interval;
        final percentage = ((dueKm - mileage) / interval * 100).round().clamp(0, 100);
        
        states.add(MaintenanceStateModel(
          vehicleId: vehicleId,
          maintenanceType: maintenanceType,
          percentage: percentage,
          lastChanged: now.subtract(Duration(days: 45)),
          dueKm: dueKm,
        ));
      }
    } else if (type == 'motorcycle') {
      // Solo para motos
      final motorcycleMaintenances = ['chain', 'sparkPlug'];
      
      for (final maintenanceType in motorcycleMaintenances) {
        final interval = MaintenanceIntervals.getInterval(maintenanceType);
        final dueKm = mileage + interval;
        final percentage = ((dueKm - mileage) / interval * 100).round().clamp(0, 100);
        
        states.add(MaintenanceStateModel(
          vehicleId: vehicleId,
          maintenanceType: maintenanceType,
          percentage: percentage,
          lastChanged: now.subtract(Duration(days: 60)),
          dueKm: dueKm,
        ));
      }
    }

    await _maintenanceStateDao.insertAll(states);
  }

  /// Crea datos de ejemplo para el primer vehículo de un usuario
  Future<void> _createExampleData(int vehicleId, int mileage, String type) async {
    final now = DateTime.now();
    final histories = <MaintenanceHistoryModel>[];

    // Crear 5 mantenimientos completados en el pasado
    final completedMaintenances = [
      {
        'type': 'oil',
        'daysAgo': 45,
        'kmAgo': 3200,
        'cost': 45.0,
        'location': 'Taller Express',
        'notes': 'Cambio de aceite sintético 5W-30',
      },
      {
        'type': 'tires',
        'daysAgo': 120,
        'kmAgo': 8500,
        'cost': 280.0,
        'location': 'Llantas Plus',
        'notes': 'Rotación y balanceo de llantas',
      },
      {
        'type': 'brakes',
        'daysAgo': 90,
        'kmAgo': 6200,
        'cost': 150.0,
        'location': 'Frenos Rápidos',
        'notes': 'Cambio de pastillas delanteras',
      },
      {
        'type': 'battery',
        'daysAgo': 60,
        'kmAgo': 4200,
        'cost': 120.0,
        'location': 'Baterías del Norte',
        'notes': 'Batería nueva 12V 60Ah',
      },
      {
        'type': 'coolant',
        'daysAgo': 150,
        'kmAgo': 11200,
        'cost': 35.0,
        'location': 'Refrigerantes Pro',
        'notes': 'Cambio de refrigerante',
      },
    ];

    for (final maintenance in completedMaintenances) {
      histories.add(MaintenanceHistoryModel(
        vehicleId: vehicleId,
        maintenanceType: maintenance['type'] as String,
        date: now.subtract(Duration(days: maintenance['daysAgo'] as int)),
        mileage: mileage - (maintenance['kmAgo'] as int),
        cost: maintenance['cost'] as double,
        location: maintenance['location'] as String,
        notes: maintenance['notes'] as String,
        status: 'completed',
        createdAt: now.subtract(Duration(days: maintenance['daysAgo'] as int)),
      ));
    }

    // Crear 2 mantenimientos pendientes en el futuro
    final pendingMaintenances = [
      {
        'type': 'oil',
        'daysFromNow': 15,
        'kmFromNow': 800,
        'cost': 50.0,
        'location': '',
        'notes': 'Próximo cambio de aceite programado',
      },
      {
        'type': 'airFilter',
        'daysFromNow': 30,
        'kmFromNow': 1500,
        'cost': 25.0,
        'location': '',
        'notes': 'Cambio de filtro de aire programado',
      },
    ];

    for (final maintenance in pendingMaintenances) {
      histories.add(MaintenanceHistoryModel(
        vehicleId: vehicleId,
        maintenanceType: maintenance['type'] as String,
        date: now.add(Duration(days: maintenance['daysFromNow'] as int)),
        mileage: mileage + (maintenance['kmFromNow'] as int),
        cost: maintenance['cost'] as double,
        location: maintenance['location'] as String,
        notes: maintenance['notes'] as String,
        status: 'pending',
        createdAt: now,
      ));
    }

    await _maintenanceHistoryDao.insertAll(histories);
  }

  /// Recalcula los porcentajes de mantenimiento basado en el kilometraje actual
  Future<void> _recalculateMaintenancePercentages(int vehicleId, int currentMileage) async {
    final states = await _maintenanceStateDao.getStatesByVehicleId(vehicleId);
    
    for (final state in states) {
      final interval = MaintenanceIntervals.getInterval(state.maintenanceType);
      final percentage = state.calculatePercentageFromMileage(currentMileage, interval);
      
      if (percentage != state.percentage) {
        await _maintenanceStateDao.updatePercentage(
          vehicleId, 
          state.maintenanceType, 
          percentage,
        );
      }
    }
  }

  /// Verifica si hay mantenimientos críticos y crea notificaciones
  Future<void> _checkCriticalMaintenances(int vehicleId, int currentMileage) async {
    final states = await _maintenanceStateDao.getStatesByVehicleId(vehicleId);
    
    for (final state in states) {
      if (state.isCritical) {
        // Crear notificación crítica
        final vehicle = await getVehicleById(vehicleId);
        if (vehicle != null) {
          await _notificationDao.insertNotification(NotificationModel(
            userId: vehicle.userId,
            vehicleId: vehicleId,
            type: 'maintenance_critical',
            title: '${state.maintenanceName} - Atención Requerida',
            message: 'El ${state.maintenanceName.toLowerCase()} de tu ${vehicle.shortName} está en nivel crítico (${state.percentage}%). Se recomienda realizar el mantenimiento pronto.',
            maintenanceType: state.maintenanceType,
            priority: 'high',
            createdAt: DateTime.now(),
          ).toMap());
        }
      }
    }
  }

  /// Crea notificaciones cuando se agrega un vehículo
  Future<void> _createVehicleAddedNotifications(int userId, int vehicleId, String make, String model) async {
    // Notificación de bienvenida para el vehículo
    await _notificationDao.insertNotification(NotificationModel(
      userId: userId,
      vehicleId: vehicleId,
      type: 'vehicle_added',
      title: '¡Vehículo Agregado!',
      message: 'Tu $make $model ha sido agregado exitosamente. Ahora puedes comenzar a registrar sus mantenimientos.',
      priority: 'medium',
      createdAt: DateTime.now(),
    ).toMap());

    // Notificación de bienvenida general si es el primer vehículo
    final vehicleCount = await _vehicleDao.countVehiclesByUserId(userId);
    if (vehicleCount == 1) {
      await _notificationDao.insertNotification(NotificationModel(
        userId: userId,
        type: 'welcome',
        title: '¡Bienvenido a AutoCare!',
        message: 'Gracias por usar AutoCare. Tu vehículo ha sido configurado con datos de ejemplo para que puedas explorar todas las funciones.',
        priority: 'medium',
        createdAt: DateTime.now(),
      ).toMap());
    }
  }
}
