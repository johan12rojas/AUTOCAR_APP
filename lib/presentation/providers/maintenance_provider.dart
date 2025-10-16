import 'package:flutter/foundation.dart';
import '../../data/repositories/maintenance_repository.dart';
import '../../data/models/maintenance_history_model.dart';

/// Provider para gestión de mantenimientos
/// 
/// Maneja el estado de los mantenimientos:
/// - Historial de mantenimientos
/// - Mantenimientos pendientes/urgentes
/// - Operaciones de programar/completar
class MaintenanceProvider extends ChangeNotifier {
  final MaintenanceRepository _maintenanceRepository = MaintenanceRepository();
  
  List<MaintenanceHistoryModel> _maintenanceHistory = [];
  List<MaintenanceHistoryModel> _pendingMaintenances = [];
  List<MaintenanceHistoryModel> _urgentMaintenances = [];
  List<MaintenanceHistoryModel> _completedMaintenances = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<MaintenanceHistoryModel> get maintenanceHistory => _maintenanceHistory;
  List<MaintenanceHistoryModel> get pendingMaintenances => _pendingMaintenances;
  List<MaintenanceHistoryModel> get urgentMaintenances => _urgentMaintenances;
  List<MaintenanceHistoryModel> get completedMaintenances => _completedMaintenances;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Carga el historial de mantenimientos de un vehículo
  Future<void> loadMaintenanceHistory(int vehicleId) async {
    _setLoading(true);
    _clearError();
    
    try {
      _maintenanceHistory = await _maintenanceRepository.getMaintenanceHistory(vehicleId);
      notifyListeners();
    } catch (e) {
      _setError('Error cargando historial: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Carga mantenimientos pendientes de un usuario
  Future<void> loadPendingMaintenances(int userId) async {
    _setLoading(true);
    _clearError();
    
    try {
      _pendingMaintenances = await _maintenanceRepository.getPendingMaintenancesByUserId(userId);
      notifyListeners();
    } catch (e) {
      _setError('Error cargando mantenimientos pendientes: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Carga mantenimientos urgentes de un usuario
  Future<void> loadUrgentMaintenances(int userId) async {
    _setLoading(true);
    _clearError();
    
    try {
      _urgentMaintenances = await _maintenanceRepository.getUrgentMaintenancesByUserId(userId);
      notifyListeners();
    } catch (e) {
      _setError('Error cargando mantenimientos urgentes: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Carga mantenimientos completados de un usuario
  Future<void> loadCompletedMaintenances(int userId) async {
    _setLoading(true);
    _clearError();
    
    try {
      _completedMaintenances = await _maintenanceRepository.getCompletedMaintenancesByUserId(userId);
      notifyListeners();
    } catch (e) {
      _setError('Error cargando mantenimientos completados: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Programa un nuevo mantenimiento
  Future<bool> scheduleMaintenance({
    required int vehicleId,
    required String maintenanceType,
    required int scheduledMileage,
    DateTime? scheduledDate,
    String? notes,
    double? estimatedCost,
    String? location,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final maintenance = await _maintenanceRepository.scheduleMaintenance(
        vehicleId: vehicleId,
        maintenanceType: maintenanceType,
        scheduledMileage: scheduledMileage,
        scheduledDate: scheduledDate,
        notes: notes,
        estimatedCost: estimatedCost,
        location: location,
      );
      
      if (maintenance != null) {
        _maintenanceHistory.add(maintenance);
        
        // Agregar a la lista correspondiente según el estado
        if (maintenance.isPending) {
          _pendingMaintenances.add(maintenance);
        } else if (maintenance.isUrgent) {
          _urgentMaintenances.add(maintenance);
        }
        
        notifyListeners();
        return true;
      } else {
        _setError('Error al programar el mantenimiento');
        return false;
      }
    } catch (e) {
      _setError('Error al programar el mantenimiento: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Completa un mantenimiento
  Future<bool> completeMaintenance({
    required int maintenanceId,
    required int actualMileage,
    double? actualCost,
    String? actualLocation,
    String? actualNotes,
    bool updateVehicleMileage = true,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final success = await _maintenanceRepository.completeMaintenance(
        maintenanceId: maintenanceId,
        actualMileage: actualMileage,
        actualCost: actualCost,
        actualLocation: actualLocation,
        actualNotes: actualNotes,
        updateVehicleMileage: updateVehicleMileage,
      );
      
      if (success) {
        // Actualizar el mantenimiento en todas las listas
        _updateMaintenanceInLists(maintenanceId, {
          'status': 'completed',
          'mileage': actualMileage,
          'cost': actualCost,
          'location': actualLocation,
          'notes': actualNotes,
          'date': DateTime.now(),
        });
        
        notifyListeners();
        return true;
      } else {
        _setError('Error al completar el mantenimiento');
        return false;
      }
    } catch (e) {
      _setError('Error al completar el mantenimiento: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Elimina un mantenimiento
  Future<bool> deleteMaintenance(int maintenanceId) async {
    _setLoading(true);
    _clearError();
    
    try {
      final success = await _maintenanceRepository.deleteMaintenance(maintenanceId);
      
      if (success) {
        // Remover el mantenimiento de todas las listas
        _maintenanceHistory.removeWhere((m) => m.id == maintenanceId);
        _pendingMaintenances.removeWhere((m) => m.id == maintenanceId);
        _urgentMaintenances.removeWhere((m) => m.id == maintenanceId);
        _completedMaintenances.removeWhere((m) => m.id == maintenanceId);
        
        notifyListeners();
        return true;
      } else {
        _setError('Error al eliminar el mantenimiento');
        return false;
      }
    } catch (e) {
      _setError('Error al eliminar el mantenimiento: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Obtiene mantenimientos por tipo
  List<MaintenanceHistoryModel> getMaintenancesByType(String type) {
    return _maintenanceHistory.where((m) => m.maintenanceType == type).toList();
  }

  /// Obtiene mantenimientos por estado
  List<MaintenanceHistoryModel> getMaintenancesByStatus(String status) {
    return _maintenanceHistory.where((m) => m.status == status).toList();
  }

  /// Cuenta mantenimientos por estado
  int getMaintenanceCountByStatus(String status) {
    return _maintenanceHistory.where((m) => m.status == status).length;
  }

  /// Cuenta mantenimientos por tipo
  int getMaintenanceCountByType(String type) {
    return _maintenanceHistory.where((m) => m.maintenanceType == type).length;
  }

  /// Obtiene el próximo mantenimiento programado
  MaintenanceHistoryModel? getNextScheduledMaintenance() {
    if (_pendingMaintenances.isEmpty) return null;
    
    _pendingMaintenances.sort((a, b) => a.date.compareTo(b.date));
    return _pendingMaintenances.first;
  }

  /// Obtiene el mantenimiento más urgente
  MaintenanceHistoryModel? getMostUrgentMaintenance() {
    if (_urgentMaintenances.isEmpty) return null;
    
    _urgentMaintenances.sort((a, b) => a.date.compareTo(b.date));
    return _urgentMaintenances.first;
  }

  /// Limpia todos los mantenimientos (útil para logout)
  void clearMaintenances() {
    _maintenanceHistory.clear();
    _pendingMaintenances.clear();
    _urgentMaintenances.clear();
    _completedMaintenances.clear();
    notifyListeners();
  }

  /// Limpia el mensaje de error
  void clearError() {
    _clearError();
  }

  // Métodos privados
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _updateMaintenanceInLists(int maintenanceId, Map<String, dynamic> updates) {
    // Actualizar en historial general
    final historyIndex = _maintenanceHistory.indexWhere((m) => m.id == maintenanceId);
    if (historyIndex != -1) {
      final maintenance = _maintenanceHistory[historyIndex];
      _maintenanceHistory[historyIndex] = maintenance.copyWith(
        status: updates['status'] ?? maintenance.status,
        mileage: updates['mileage'] ?? maintenance.mileage,
        cost: updates['cost'] ?? maintenance.cost,
        location: updates['location'] ?? maintenance.location,
        notes: updates['notes'] ?? maintenance.notes,
        date: updates['date'] ?? maintenance.date,
      );
    }

    // Mover de pendientes/urgentes a completados
    final pendingIndex = _pendingMaintenances.indexWhere((m) => m.id == maintenanceId);
    if (pendingIndex != -1) {
      final maintenance = _pendingMaintenances[pendingIndex];
      _pendingMaintenances.removeAt(pendingIndex);
      _completedMaintenances.add(maintenance.copyWith(
        status: 'completed',
        mileage: updates['mileage'] ?? maintenance.mileage,
        cost: updates['cost'] ?? maintenance.cost,
        location: updates['location'] ?? maintenance.location,
        notes: updates['notes'] ?? maintenance.notes,
        date: updates['date'] ?? maintenance.date,
      ));
    }

    final urgentIndex = _urgentMaintenances.indexWhere((m) => m.id == maintenanceId);
    if (urgentIndex != -1) {
      final maintenance = _urgentMaintenances[urgentIndex];
      _urgentMaintenances.removeAt(urgentIndex);
      _completedMaintenances.add(maintenance.copyWith(
        status: 'completed',
        mileage: updates['mileage'] ?? maintenance.mileage,
        cost: updates['cost'] ?? maintenance.cost,
        location: updates['location'] ?? maintenance.location,
        notes: updates['notes'] ?? maintenance.notes,
        date: updates['date'] ?? maintenance.date,
      ));
    }
  }
}
