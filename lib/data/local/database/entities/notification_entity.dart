/// Entidad que representa la tabla 'notifications' en la base de datos
/// 
/// Almacena todas las notificaciones del sistema:
/// - Notificaciones de bienvenida
/// - Alertas de mantenimientos críticos
/// - Recordatorios de mantenimientos pendientes
/// - Notificaciones de mantenimientos completados
class NotificationEntity {
  final int? id;
  final int userId;
  final int? vehicleId; // Puede ser null para notificaciones generales
  final String type;
  final String title;
  final String message;
  final String? maintenanceType; // Tipo de mantenimiento relacionado
  final String priority; // 'low', 'medium', 'high'
  final DateTime createdAt;

  NotificationEntity({
    this.id,
    required this.userId,
    this.vehicleId,
    required this.type,
    required this.title,
    required this.message,
    this.maintenanceType,
    required this.priority,
    required this.createdAt,
  });

  /// Convierte la entidad a un Map para insertar en SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'vehicle_id': vehicleId,
      'type': type,
      'title': title,
      'message': message,
      'maintenance_type': maintenanceType,
      'priority': priority,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Crea una entidad desde un Map obtenido de SQLite
  factory NotificationEntity.fromMap(Map<String, dynamic> map) {
    return NotificationEntity(
      id: map['id'],
      userId: map['user_id'],
      vehicleId: map['vehicle_id'],
      type: map['type'],
      title: map['title'],
      message: map['message'],
      maintenanceType: map['maintenance_type'],
      priority: map['priority'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  /// Crea una copia de la entidad con algunos campos modificados
  NotificationEntity copyWith({
    int? id,
    int? userId,
    int? vehicleId,
    String? type,
    String? title,
    String? message,
    String? maintenanceType,
    String? priority,
    DateTime? createdAt,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      vehicleId: vehicleId ?? this.vehicleId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      maintenanceType: maintenanceType ?? this.maintenanceType,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Verifica si es una notificación de alta prioridad
  bool get isHighPriority => priority == 'high';

  /// Verifica si es una notificación de prioridad media
  bool get isMediumPriority => priority == 'medium';

  /// Verifica si es una notificación de baja prioridad
  bool get isLowPriority => priority == 'low';

  /// Obtiene la prioridad como texto legible
  String get priorityText {
    switch (priority) {
      case 'high':
        return 'Alta';
      case 'medium':
        return 'Media';
      case 'low':
        return 'Baja';
      default:
        return 'Desconocida';
    }
  }

  /// Verifica si la notificación está relacionada con un vehículo específico
  bool get isVehicleRelated => vehicleId != null;

  /// Verifica si la notificación está relacionada con un tipo de mantenimiento
  bool get isMaintenanceRelated => maintenanceType != null;

  /// Obtiene el tipo como texto legible
  String get typeText {
    switch (type) {
      case 'welcome':
        return 'Bienvenida';
      case 'maintenance_critical':
        return 'Mantenimiento Crítico';
      case 'maintenance_pending':
        return 'Mantenimiento Pendiente';
      case 'maintenance_completed':
        return 'Mantenimiento Completado';
      case 'maintenance_reminder':
        return 'Recordatorio';
      default:
        return 'General';
    }
  }

  /// Verifica si la notificación es reciente (menos de 7 días)
  bool get isRecent {
    return DateTime.now().difference(createdAt).inDays < 7;
  }

  @override
  String toString() {
    return 'NotificationEntity(id: $id, userId: $userId, vehicleId: $vehicleId, type: $type, title: $title, priority: $priority, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationEntity &&
        other.id == id &&
        other.userId == userId &&
        other.vehicleId == vehicleId &&
        other.type == type &&
        other.title == title &&
        other.message == message &&
        other.maintenanceType == maintenanceType &&
        other.priority == priority &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        vehicleId.hashCode ^
        type.hashCode ^
        title.hashCode ^
        message.hashCode ^
        maintenanceType.hashCode ^
        priority.hashCode ^
        createdAt.hashCode;
  }
}
