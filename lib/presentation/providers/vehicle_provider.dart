import 'package:flutter/foundation.dart';
import '../../data/repositories/vehicle_repository.dart';
import '../../data/models/vehicle_model.dart';

/// Provider para gestión de vehículos
/// 
/// Maneja el estado de los vehículos del usuario:
/// - Lista de vehículos
/// - Vehículo seleccionado
/// - Operaciones CRUD
/// - Actualización de kilometraje
class VehicleProvider extends ChangeNotifier {
  final VehicleRepository _vehicleRepository = VehicleRepository();
  
  List<VehicleModel> _vehicles = [];
  VehicleModel? _selectedVehicle;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<VehicleModel> get vehicles => _vehicles;
  VehicleModel? get selectedVehicle => _selectedVehicle;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasVehicles => _vehicles.isNotEmpty;

  /// Carga todos los vehículos del usuario
  Future<void> loadVehicles(int userId) async {
    _setLoading(true);
    _clearError();
    
    try {
      _vehicles = await _vehicleRepository.getVehiclesByUserId(userId);
      
      // Si no hay vehículo seleccionado y hay vehículos disponibles,
      // seleccionar el primero
      if (_selectedVehicle == null && _vehicles.isNotEmpty) {
        _selectedVehicle = _vehicles.first;
      }
      
      notifyListeners();
    } catch (e) {
      _setError('Error cargando vehículos: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Agrega un nuevo vehículo
  Future<bool> addVehicle({
    required int userId,
    required String make,
    required String model,
    required int year,
    required int mileage,
    required String type,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final vehicle = await _vehicleRepository.addVehicle(
        userId: userId,
        make: make,
        model: model,
        year: year,
        mileage: mileage,
        type: type,
      );
      
      if (vehicle != null) {
        _vehicles.add(vehicle);
        
        // Si es el primer vehículo, seleccionarlo automáticamente
        if (_vehicles.length == 1) {
          _selectedVehicle = vehicle;
        }
        
        notifyListeners();
        return true;
      } else {
        _setError('Error al agregar el vehículo');
        return false;
      }
    } catch (e) {
      _setError('Error al agregar el vehículo: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Actualiza el kilometraje de un vehículo
  Future<bool> updateMileage(int vehicleId, int newMileage) async {
    _setLoading(true);
    _clearError();
    
    try {
      final success = await _vehicleRepository.updateMileage(vehicleId, newMileage);
      
      if (success) {
        // Actualizar el vehículo en la lista
        final index = _vehicles.indexWhere((v) => v.id == vehicleId);
        if (index != -1) {
          _vehicles[index] = _vehicles[index].copyWith(mileage: newMileage);
          
          // Actualizar el vehículo seleccionado si es el mismo
          if (_selectedVehicle?.id == vehicleId) {
            _selectedVehicle = _vehicles[index];
          }
        }
        
        notifyListeners();
        return true;
      } else {
        _setError('Error al actualizar el kilometraje');
        return false;
      }
    } catch (e) {
      _setError('Error al actualizar el kilometraje: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Actualiza todos los datos de un vehículo
  Future<bool> updateVehicle(VehicleModel vehicle) async {
    _setLoading(true);
    _clearError();
    
    try {
      final success = await _vehicleRepository.updateVehicle(vehicle);
      
      if (success) {
        // Actualizar el vehículo en la lista
        final index = _vehicles.indexWhere((v) => v.id == vehicle.id);
        if (index != -1) {
          _vehicles[index] = vehicle;
          
          // Actualizar el vehículo seleccionado si es el mismo
          if (_selectedVehicle?.id == vehicle.id) {
            _selectedVehicle = vehicle;
          }
        }
        
        notifyListeners();
        return true;
      } else {
        _setError('Error al actualizar el vehículo');
        return false;
      }
    } catch (e) {
      _setError('Error al actualizar el vehículo: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Elimina un vehículo
  Future<bool> deleteVehicle(int vehicleId) async {
    _setLoading(true);
    _clearError();
    
    try {
      final success = await _vehicleRepository.deleteVehicle(vehicleId);
      
      if (success) {
        // Remover el vehículo de la lista
        _vehicles.removeWhere((v) => v.id == vehicleId);
        
        // Si el vehículo eliminado era el seleccionado, seleccionar otro
        if (_selectedVehicle?.id == vehicleId) {
          _selectedVehicle = _vehicles.isNotEmpty ? _vehicles.first : null;
        }
        
        notifyListeners();
        return true;
      } else {
        _setError('Error al eliminar el vehículo');
        return false;
      }
    } catch (e) {
      _setError('Error al eliminar el vehículo: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Selecciona un vehículo específico
  void selectVehicle(VehicleModel vehicle) {
    _selectedVehicle = vehicle;
    notifyListeners();
  }

  /// Selecciona un vehículo por ID
  void selectVehicleById(int vehicleId) {
    final vehicle = _vehicles.firstWhere(
      (v) => v.id == vehicleId,
      orElse: () => _vehicles.first,
    );
    selectVehicle(vehicle);
  }

  /// Obtiene un vehículo por ID
  VehicleModel? getVehicleById(int vehicleId) {
    try {
      return _vehicles.firstWhere((v) => v.id == vehicleId);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene el vehículo más reciente
  VehicleModel? getLatestVehicle() {
    if (_vehicles.isEmpty) return null;
    
    _vehicles.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return _vehicles.first;
  }

  /// Obtiene vehículos por tipo
  List<VehicleModel> getVehiclesByType(String type) {
    return _vehicles.where((v) => v.type == type).toList();
  }

  /// Obtiene solo los carros
  List<VehicleModel> get cars {
    return getVehiclesByType('car');
  }

  /// Obtiene solo las motos
  List<VehicleModel> get motorcycles {
    return getVehiclesByType('motorcycle');
  }

  /// Cuenta el total de vehículos
  int get vehicleCount => _vehicles.length;

  /// Cuenta los carros
  int get carCount => cars.length;

  /// Cuenta las motos
  int get motorcycleCount => motorcycles.length;

  /// Verifica si hay vehículos del tipo especificado
  bool hasVehicleType(String type) {
    return _vehicles.any((v) => v.type == type);
  }

  /// Limpia todos los vehículos (útil para logout)
  void clearVehicles() {
    _vehicles.clear();
    _selectedVehicle = null;
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
}
