/// Modelo de dominio para historial de mantenimientos
/// 
/// Este modelo representa una entrada en el historial de mantenimientos,
/// ya sea completado, pendiente o urgente.
class MaintenanceHistoryModel {
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

  MaintenanceHistoryModel({
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

  /// Convierte el modelo a un Map para la base de datos
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

  /// Crea un modelo desde un Map de la base de datos
  factory MaintenanceHistoryModel.fromMap(Map<String, dynamic> map) {
    return MaintenanceHistoryModel(
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

  /// Crea una copia del modelo con algunos campos modificados
  MaintenanceHistoryModel copyWith({
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
    return MaintenanceHistoryModel(
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

  /// Obtiene el color asociado al estado
  String get statusColor {
    switch (status) {
      case 'completed':
        return 'green';
      case 'pending':
        return 'orange';
      case 'urgent':
        return 'red';
      default:
        return 'grey';
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

  /// Obtiene la fecha formateada
  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Obtiene el kilometraje formateado con separadores de miles
  String get formattedMileage {
    return mileage.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  /// Calcula cuántos días han pasado desde la fecha programada
  int get daysFromScheduledDate {
    return DateTime.now().difference(date).inDays;
  }

  /// Verifica si el mantenimiento fue completado a tiempo
  bool get wasCompletedOnTime {
    if (!isCompleted) return false;
    
    // Se considera a tiempo si se completó dentro de 7 días de la fecha programada
    return daysFromScheduledDate.abs() <= 7;
  }

  /// Verifica si el mantenimiento fue completado temprano
  bool get wasCompletedEarly {
    if (!isCompleted) return false;
    return daysFromScheduledDate > 7;
  }

  /// Verifica si el mantenimiento fue completado tarde
  bool get wasCompletedLate {
    if (!isCompleted) return false;
    return daysFromScheduledDate < -7;
  }

  /// Obtiene el nivel de puntualidad
  String get punctualityLevel {
    if (!isCompleted) return 'No aplica';
    
    final daysDiff = daysFromScheduledDate.abs();
    if (daysDiff <= 3) return 'Excelente';
    if (daysDiff <= 7) return 'Bueno';
    if (daysDiff <= 14) return 'Regular';
    return 'Tardío';
  }

  @override
  String toString() {
    return 'MaintenanceHistoryModel(id: $id, vehicleId: $vehicleId, maintenanceType: $maintenanceType, date: $date, mileage: $mileage, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MaintenanceHistoryModel &&
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
