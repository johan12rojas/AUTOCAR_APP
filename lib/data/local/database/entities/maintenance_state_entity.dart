/// Entidad que representa la tabla 'maintenance_states' en la base de datos
/// 
/// Almacena el estado actual de cada tipo de mantenimiento por vehículo:
/// - Porcentaje de vida útil restante (0-100)
/// - Fecha del último cambio
/// - Kilometraje para el próximo mantenimiento
/// - Tipo de mantenimiento específico
class MaintenanceStateEntity {
  final int? id;
  final int vehicleId;
  final String maintenanceType;
  final int percentage; // 0-100 (100 = nuevo, 0 = crítico)
  final DateTime lastChanged;
  final int dueKm; // Kilometraje para próximo cambio

  MaintenanceStateEntity({
    this.id,
    required this.vehicleId,
    required this.maintenanceType,
    required this.percentage,
    required this.lastChanged,
    required this.dueKm,
  });

  /// Convierte la entidad a un Map para insertar en SQLite
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

  /// Crea una entidad desde un Map obtenido de SQLite
  factory MaintenanceStateEntity.fromMap(Map<String, dynamic> map) {
    return MaintenanceStateEntity(
      id: map['id'],
      vehicleId: map['vehicle_id'],
      maintenanceType: map['maintenance_type'],
      percentage: map['percentage'],
      lastChanged: DateTime.parse(map['last_changed']),
      dueKm: map['due_km'],
    );
  }

  /// Crea una copia de la entidad con algunos campos modificados
  MaintenanceStateEntity copyWith({
    int? id,
    int? vehicleId,
    String? maintenanceType,
    int? percentage,
    DateTime? lastChanged,
    int? dueKm,
  }) {
    return MaintenanceStateEntity(
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

  /// Obtiene el estado como texto legible
  String get statusText {
    if (isCritical) return 'Crítico';
    if (isUpcoming) return 'Próximo';
    return 'Bueno';
  }

  /// Calcula los kilómetros restantes hasta el próximo mantenimiento
  int getRemainingKm(int currentMileage) {
    return dueKm - currentMileage;
  }

  @override
  String toString() {
    return 'MaintenanceStateEntity(id: $id, vehicleId: $vehicleId, maintenanceType: $maintenanceType, percentage: $percentage, lastChanged: $lastChanged, dueKm: $dueKm)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MaintenanceStateEntity &&
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
