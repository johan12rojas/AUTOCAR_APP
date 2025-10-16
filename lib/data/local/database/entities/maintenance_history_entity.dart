/// Entidad que representa la tabla 'maintenance_history' en la base de datos
/// 
/// Almacena el historial completo de mantenimientos realizados y programados:
/// - Mantenimientos completados (con costo, ubicación, notas)
/// - Mantenimientos pendientes (programados para el futuro)
/// - Mantenimientos urgentes (que requieren atención inmediata)
class MaintenanceHistoryEntity {
  final int? id;
  final int vehicleId;
  final String maintenanceType;
  final DateTime date;
  final int mileage;
  final String? notes;
  final double? cost;
  final String? location;
  final String status; // 'completed', 'pending', 'urgent'
  final DateTime createdAt;

  MaintenanceHistoryEntity({
    this.id,
    required this.vehicleId,
    required this.maintenanceType,
    required this.date,
    required this.mileage,
    this.notes,
    this.cost,
    this.location,
    required this.status,
    required this.createdAt,
  });

  /// Convierte la entidad a un Map para insertar en SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehicle_id': vehicleId,
      'maintenance_type': maintenanceType,
      'date': date.toIso8601String(),
      'mileage': mileage,
      'notes': notes,
      'cost': cost,
      'location': location,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Crea una entidad desde un Map obtenido de SQLite
  factory MaintenanceHistoryEntity.fromMap(Map<String, dynamic> map) {
    return MaintenanceHistoryEntity(
      id: map['id'],
      vehicleId: map['vehicle_id'],
      maintenanceType: map['maintenance_type'],
      date: DateTime.parse(map['date']),
      mileage: map['mileage'],
      notes: map['notes'],
      cost: map['cost']?.toDouble(),
      location: map['location'],
      status: map['status'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  /// Crea una copia de la entidad con algunos campos modificados
  MaintenanceHistoryEntity copyWith({
    int? id,
    int? vehicleId,
    String? maintenanceType,
    DateTime? date,
    int? mileage,
    String? notes,
    double? cost,
    String? location,
    String? status,
    DateTime? createdAt,
  }) {
    return MaintenanceHistoryEntity(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      maintenanceType: maintenanceType ?? this.maintenanceType,
      date: date ?? this.date,
      mileage: mileage ?? this.mileage,
      notes: notes ?? this.notes,
      cost: cost ?? this.cost,
      location: location ?? this.location,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Verifica si el mantenimiento está completado
  bool get isCompleted => status == 'completed';

  /// Verifica si el mantenimiento está pendiente
  bool get isPending => status == 'pending';

  /// Verifica si el mantenimiento es urgente
  bool get isUrgent => status == 'urgent';

  /// Obtiene el estado como texto legible
  String get statusText {
    switch (status) {
      case 'completed':
        return 'Completado';
      case 'pending':
        return 'Pendiente';
      case 'urgent':
        return 'Urgente';
      default:
        return 'Desconocido';
    }
  }

  /// Verifica si el mantenimiento está vencido (fecha pasada y pendiente)
  bool get isOverdue {
    return isPending && date.isBefore(DateTime.now());
  }

  /// Obtiene el costo formateado como texto
  String get costText {
    if (cost == null) return 'Sin costo';
    return '\$${cost!.toStringAsFixed(2)}';
  }

  /// Obtiene la ubicación o texto por defecto
  String get locationText {
    return location ?? 'No especificado';
  }

  /// Obtiene las notas o texto por defecto
  String get notesText {
    return notes ?? 'Sin notas';
  }

  @override
  String toString() {
    return 'MaintenanceHistoryEntity(id: $id, vehicleId: $vehicleId, maintenanceType: $maintenanceType, date: $date, mileage: $mileage, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MaintenanceHistoryEntity &&
        other.id == id &&
        other.vehicleId == vehicleId &&
        other.maintenanceType == maintenanceType &&
        other.date == date &&
        other.mileage == mileage &&
        other.notes == notes &&
        other.cost == cost &&
        other.location == location &&
        other.status == status &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        vehicleId.hashCode ^
        maintenanceType.hashCode ^
        date.hashCode ^
        mileage.hashCode ^
        notes.hashCode ^
        cost.hashCode ^
        location.hashCode ^
        status.hashCode ^
        createdAt.hashCode;
  }
}
