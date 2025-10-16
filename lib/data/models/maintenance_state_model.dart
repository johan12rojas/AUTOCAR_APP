/// Modelo de dominio para estados de mantenimiento
/// 
/// Este modelo representa el estado actual de un tipo de mantenimiento
/// específico en un vehículo, incluyendo porcentaje de vida útil y fechas.
class MaintenanceStateModel {
  final int? id;
  final int vehicleId;
  final String maintenanceType;
  final int percentage; // 0-100 (100 = nuevo, 0 = crítico)
  final DateTime lastChanged;
  final int dueKm; // Kilometraje para próximo cambio

  MaintenanceStateModel({
    this.id,
    required this.vehicleId,
    required this.maintenanceType,
    required this.percentage,
    required this.lastChanged,
    required this.dueKm,
  });

  /// Convierte el modelo a un Map para la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehicle_id': vehicleId,
      'maintenance_type': maintenanceType,
      'percentage': percentage,
      'last_changed': lastChanged.toIso8601String(),
      'due_km': dueKm,
    };
  }

  /// Crea un modelo desde un Map de la base de datos
  factory MaintenanceStateModel.fromMap(Map<String, dynamic> map) {
    return MaintenanceStateModel(
      id: map['id'],
      vehicleId: map['vehicle_id'],
      maintenanceType: map['maintenance_type'],
      percentage: map['percentage'],
      lastChanged: DateTime.parse(map['last_changed']),
      dueKm: map['due_km'],
    );
  }

  /// Crea una copia del modelo con algunos campos modificados
  MaintenanceStateModel copyWith({
    int? id,
    int? vehicleId,
    String? maintenanceType,
    int? percentage,
    DateTime? lastChanged,
    int? dueKm,
  }) {
    return MaintenanceStateModel(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      maintenanceType: maintenanceType ?? this.maintenanceType,
      percentage: percentage ?? this.percentage,
      lastChanged: lastChanged ?? this.lastChanged,
      dueKm: dueKm ?? this.dueKm,
    );
  }

  /// Verifica si el mantenimiento está en estado crítico (< 30%)
  bool get isCritical => percentage < 30;

  /// Verifica si el mantenimiento está próximo a vencer (30-50%)
  bool get isUpcoming => percentage >= 30 && percentage < 50;

  /// Verifica si el mantenimiento está en buen estado (> 50%)
  bool get isGood => percentage >= 50;

  /// Verifica si el mantenimiento está en excelente estado (> 80%)
  bool get isExcellent => percentage > 80;

  /// Obtiene el estado como texto legible
  String get statusText {
    if (isCritical) return 'Crítico';
    if (isUpcoming) return 'Próximo';
    if (isGood) return 'Bueno';
    return 'Excelente';
  }

  /// Obtiene el color asociado al estado
  String get statusColor {
    if (isCritical) return 'red';
    if (isUpcoming) return 'orange';
    if (isGood) return 'yellow';
    return 'green';
  }

  /// Calcula los kilómetros restantes hasta el próximo mantenimiento
  int getRemainingKm(int currentMileage) {
    return dueKm - currentMileage;
  }

  /// Calcula el porcentaje basado en el kilometraje actual
  int calculatePercentageFromMileage(int currentMileage, int interval) {
    final remainingKm = dueKm - currentMileage;
    if (remainingKm <= 0) return 0;
    
    final percentage = (remainingKm / interval * 100).round();
    return percentage.clamp(0, 100);
  }

  /// Verifica si el mantenimiento está vencido por kilometraje
  bool isOverdueByMileage(int currentMileage) {
    return currentMileage >= dueKm;
  }

  /// Obtiene el nombre legible del tipo de mantenimiento
  String get maintenanceName {
    switch (maintenanceType) {
      case 'oil':
        return 'Aceite de Motor';
      case 'tires':
        return 'Llantas';
      case 'brakes':
        return 'Frenos';
      case 'battery':
        return 'Batería';
      case 'coolant':
        return 'Refrigerante';
      case 'airFilter':
        return 'Filtro de Aire';
      case 'alignment':
        return 'Alineación';
      case 'chain':
        return 'Cadena';
      case 'sparkPlug':
        return 'Bujía';
      default:
        return maintenanceType;
    }
  }

  /// Obtiene el icono del tipo de mantenimiento
  String get maintenanceIcon {
    switch (maintenanceType) {
      case 'oil':
        return '🛢️';
      case 'tires':
        return '🚗';
      case 'brakes':
        return '🛑';
      case 'battery':
        return '🔋';
      case 'coolant':
        return '🌡️';
      case 'airFilter':
        return '💨';
      case 'alignment':
        return '⚖️';
      case 'chain':
        return '⛓️';
      case 'sparkPlug':
        return '⚡';
      default:
        return '🔧';
    }
  }

  /// Obtiene el intervalo recomendado para este tipo de mantenimiento
  int get recommendedInterval {
    switch (maintenanceType) {
      case 'oil':
        return 5000;
      case 'tires':
        return 40000;
      case 'brakes':
        return 30000;
      case 'battery':
        return 50000;
      case 'coolant':
        return 20000;
      case 'airFilter':
        return 17500;
      case 'alignment':
        return 10000;
      case 'chain':
        return 22500;
      case 'sparkPlug':
        return 11000;
      default:
        return 10000;
    }
  }

  /// Calcula cuántos días han pasado desde el último cambio
  int get daysSinceLastChange {
    return DateTime.now().difference(lastChanged).inDays;
  }

  /// Verifica si el mantenimiento está vencido por tiempo
  bool get isOverdueByTime {
    // Algunos mantenimientos tienen límites de tiempo además de kilometraje
    switch (maintenanceType) {
      case 'oil':
        return daysSinceLastChange > 365; // 1 año máximo
      case 'battery':
        return daysSinceLastChange > 1095; // 3 años máximo
      case 'coolant':
        return daysSinceLastChange > 730; // 2 años máximo
      default:
        return false; // Solo kilometraje para otros
    }
  }

  @override
  String toString() {
    return 'MaintenanceStateModel(id: $id, vehicleId: $vehicleId, maintenanceType: $maintenanceType, percentage: $percentage, lastChanged: $lastChanged, dueKm: $dueKm)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MaintenanceStateModel &&
        other.id == id &&
        other.vehicleId == vehicleId &&
        other.maintenanceType == maintenanceType &&
        other.percentage == percentage &&
        other.lastChanged == lastChanged &&
        other.dueKm == dueKm;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        vehicleId.hashCode ^
        maintenanceType.hashCode ^
        percentage.hashCode ^
        lastChanged.hashCode ^
        dueKm.hashCode;
  }
}
