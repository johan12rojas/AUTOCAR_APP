import '../local/database/dao/maintenance_history_dao.dart';
import '../local/database/dao/maintenance_state_dao.dart';
import '../local/database/dao/vehicle_dao.dart';
import '../local/database/dao/notification_dao.dart';
import '../local/database/dao/statistics_dao.dart';
import '../models/maintenance_history_model.dart';
import '../models/maintenance_state_model.dart';
import '../models/vehicle_model.dart';
import '../models/notification_model.dart';
import '../../core/constants/maintenance_intervals.dart';
import '../../core/utils/validators.dart';

/// Repositorio para operaciones de mantenimientos
/// 
/// Maneja todas las operaciones relacionadas con mantenimientos:
/// - Agendar mantenimientos
/// - Completar mantenimientos
/// - Obtener historial
/// - Actualizar estados
/// - Generar notificaciones
class MaintenanceRepository {
  final MaintenanceHistoryDao _maintenanceHistoryDao = MaintenanceHistoryDao();
  final MaintenanceStateDao _maintenanceStateDao = MaintenanceStateDao();
  final VehicleDao _vehicleDao = VehicleDao();
  final NotificationDao _notificationDao = NotificationDao();
  final StatisticsDao _statisticsDao = StatisticsDao();

  /// Agenda un nuevo mantenimiento
  /// 
  /// Proceso:
  /// 1. Valida los datos del mantenimiento
  /// 2. Determina el estado (pending/urgent)
  /// 3. Inserta en el historial
  /// 4. Crea notificación
  Future<MaintenanceHistoryModel?> scheduleMaintenance({
    required int vehicleId,
    required String maintenanceType,
    required int scheduledMileage,
    DateTime? scheduledDate,
    String? notes,
    double? estimatedCost,
    String? location,
  }) async {
    try {
      // 1. Validar datos
      if (!Validators.isValidMaintenanceType(maintenanceType)) {
        throw Exception('Tipo de mantenimiento no válido');
      }

      final vehicle = await _vehicleDao.getVehicleById(vehicleId);
      if (vehicle == null) {
        throw Exception('Vehículo no encontrado');
      }

      if (!Validators.isValidScheduledMileage(vehicle.mileage, scheduledMileage)) {
        throw Exception('El kilometraje programado debe ser mayor al actual');
      }

      if (scheduledDate != null && !Validators.isValidMaintenanceDate(scheduledDate)) {
        throw Exception('La fecha programada no es válida');
      }

      // 2. Determinar estado
      String status = 'pending';
      final kmRemaining = scheduledMileage - vehicle.mileage;
      
      if (kmRemaining < 500) {
        status = 'urgent';
      } else if (scheduledDate != null && scheduledDate.isBefore(DateTime.now())) {
        status = 'urgent';
      }

      // 3. Crear entrada en historial
      final maintenance = MaintenanceHistoryModel(
        vehicleId: vehicleId,
        maintenanceType: maintenanceType,
        date: scheduledDate ?? DateTime.now().add(Duration(days: 30)),
        mileage: scheduledMileage,
        notes: notes,
        cost: estimatedCost,
        location: location,
        status: status,
        createdAt: DateTime.now(),
      );

      final maintenanceId = await _maintenanceHistoryDao.insertMaintenanceHistory(maintenance);
      if (maintenanceId == 0) {
        throw Exception('Error al programar el mantenimiento');
      }

      // 4. Crear notificación
      await _createScheduledNotification(vehicle, maintenanceType, scheduledMileage, status);

      return maintenance.copyWith(id: maintenanceId);
    } catch (e) {
      print('Error programando mantenimiento: $e');
      return null;
    }
  }

  /// Completa un mantenimiento programado
  /// 
  /// Proceso:
  /// 1. Actualiza la entrada del historial
  /// 2. Actualiza el estado de mantenimiento
  /// 3. Actualiza kilometraje del vehículo si es necesario
  /// 4. Actualiza estadísticas del usuario
  /// 5. Elimina notificaciones relacionadas
  /// 6. Crea notificación de completado
  Future<bool> completeMaintenance({
    required int maintenanceId,
    required int actualMileage,
    double? actualCost,
    String? actualLocation,
    String? actualNotes,
    bool updateVehicleMileage = true,
  }) async {
    try {
      // 1. Obtener el mantenimiento
      final maintenance = await _maintenanceHistoryDao.getHistoryById(maintenanceId);
      if (maintenance == null) {
        throw Exception('Mantenimiento no encontrado');
      }

      if (maintenance.isCompleted) {
        throw Exception('Este mantenimiento ya fue completado');
      }

      // 2. Actualizar entrada del historial
      final updatedMaintenance = maintenance.copyWith(
        status: 'completed',
        mileage: actualMileage,
        cost: actualCost,
        location: actualLocation,
        notes: actualNotes,
        date: DateTime.now(),
      );

      final result = await _maintenanceHistoryDao.updateMaintenanceHistory(updatedMaintenance);
      if (result == 0) return false;

      // 3. Actualizar estado de mantenimiento
      await _updateMaintenanceState(
        maintenance.vehicleId,
        maintenance.maintenanceType,
        actualMileage,
      );

      // 4. Actualizar kilometraje del vehículo si es necesario
      if (updateVehicleMileage) {
        await _vehicleDao.updateMileage(maintenance.vehicleId, actualMileage);
      }

      // 5. Actualizar estadísticas del usuario
      final vehicle = await _vehicleDao.getVehicleById(maintenance.vehicleId);
      if (vehicle != null) {
        await _statisticsDao.incrementTotalMaintenance(vehicle.userId);
        
        // Verificar si fue completado a tiempo
        if (updatedMaintenance.wasCompletedOnTime) {
          await _statisticsDao.incrementOnTimeCompletions(vehicle.userId);
        }
      }

      // 6. Eliminar notificaciones relacionadas
      await _notificationDao.deleteNotificationsByMaintenanceType(
        vehicle!.userId,
        maintenance.maintenanceType,
      );

      // 7. Crear notificación de completado
      await _createCompletedNotification(vehicle, maintenance.maintenanceType);

      return true;
    } catch (e) {
      print('Error completando mantenimiento: $e');
      return false;
    }
  }

  /// Obtiene el historial de mantenimientos de un vehículo
  Future<List<MaintenanceHistoryModel>> getMaintenanceHistory(int vehicleId) async {
    try {
      final histories = await _maintenanceHistoryDao.getHistoryByVehicleId(vehicleId);
      return histories.map((entity) => MaintenanceHistoryModel.fromMap(entity.toMap())).toList();
    } catch (e) {
      print('Error obteniendo historial: $e');
      return [];
    }
  }

  /// Obtiene mantenimientos por estado
  Future<List<MaintenanceHistoryModel>> getMaintenancesByStatus(
    int vehicleId,
    String status,
  ) async {
    try {
      final histories = await _maintenanceHistoryDao.getHistoryByStatus(vehicleId, status);
      return histories.map((entity) => MaintenanceHistoryModel.fromMap(entity.toMap())).toList();
    } catch (e) {
      print('Error obteniendo mantenimientos por estado: $e');
      return [];
    }
  }

  /// Obtiene mantenimientos pendientes de un usuario
  Future<List<MaintenanceHistoryModel>> getPendingMaintenancesByUserId(int userId) async {
    try {
      final histories = await _maintenanceHistoryDao.getPendingMaintenancesByUserId(userId);
      return histories.map((entity) => MaintenanceHistoryModel.fromMap(entity.toMap())).toList();
    } catch (e) {
      print('Error obteniendo mantenimientos pendientes: $e');
      return [];
    }
  }

  /// Obtiene mantenimientos urgentes de un usuario
  Future<List<MaintenanceHistoryModel>> getUrgentMaintenancesByUserId(int userId) async {
    try {
      final histories = await _maintenanceHistoryDao.getUrgentMaintenancesByUserId(userId);
      return histories.map((entity) => MaintenanceHistoryModel.fromMap(entity.toMap())).toList();
    } catch (e) {
      print('Error obteniendo mantenimientos urgentes: $e');
      return [];
    }
  }

  /// Obtiene mantenimientos completados de un usuario
  Future<List<MaintenanceHistoryModel>> getCompletedMaintenancesByUserId(int userId) async {
    try {
      final histories = await _maintenanceHistoryDao.getCompletedMaintenancesByUserId(userId);
      return histories.map((entity) => MaintenanceHistoryModel.fromMap(entity.toMap())).toList();
    } catch (e) {
      print('Error obteniendo mantenimientos completados: $e');
      return [];
    }
  }

  /// Actualiza el estado de mantenimiento después de completar uno
  Future<void> _updateMaintenanceState(
    int vehicleId,
    String maintenanceType,
    int actualMileage,
  ) async {
    final interval = MaintenanceIntervals.getInterval(maintenanceType);
    final nextDueKm = actualMileage + interval;
    
    await _maintenanceStateDao.updateLastChanged(
      vehicleId,
      maintenanceType,
      DateTime.now(),
      nextDueKm,
    );
  }

  /// Crea notificación cuando se programa un mantenimiento
  Future<void> _createScheduledNotification(
    VehicleModel vehicle,
    String maintenanceType,
    int scheduledMileage,
    String status,
  ) async {
    final priority = status == 'urgent' ? 'high' : 'medium';
    final maintenanceName = MaintenanceIntervals.getMaintenanceName(maintenanceType);
    
    await _notificationDao.insertNotification(NotificationModel(
      userId: vehicle.userId,
      vehicleId: vehicle.id,
      type: 'maintenance_pending',
      title: '$maintenanceName Programado',
      message: 'Se ha programado el mantenimiento de $maintenanceName para tu ${vehicle.shortName} a los $scheduledMileage km.',
      maintenanceType: maintenanceType,
      priority: priority,
      createdAt: DateTime.now(),
    ).toMap());
  }

  /// Crea notificación cuando se completa un mantenimiento
  Future<void> _createCompletedNotification(
    VehicleModel vehicle,
    String maintenanceType,
  ) async {
    final maintenanceName = MaintenanceIntervals.getMaintenanceName(maintenanceType);
    
    await _notificationDao.insertNotification(NotificationModel(
      userId: vehicle.userId,
      vehicleId: vehicle.id,
      type: 'maintenance_completed',
      title: '$maintenanceName Completado',
      message: '¡Excelente! El mantenimiento de $maintenanceName de tu ${vehicle.shortName} ha sido completado exitosamente.',
      maintenanceType: maintenanceType,
      priority: 'low',
      createdAt: DateTime.now(),
    ).toMap());
  }

  /// Elimina un mantenimiento del historial
  Future<bool> deleteMaintenance(int maintenanceId) async {
    try {
      final result = await _maintenanceHistoryDao.deleteHistoryEntry(maintenanceId);
      return result > 0;
    } catch (e) {
      print('Error eliminando mantenimiento: $e');
      return false;
    }
  }

  /// Obtiene estadísticas de mantenimientos por usuario
  Future<Map<String, int>> getMaintenanceStatisticsByUserId(int userId) async {
    try {
      return await _maintenanceHistoryDao.getMaintenanceCountsByUserId(userId);
    } catch (e) {
      print('Error obteniendo estadísticas: $e');
      return {};
    }
  }
}
