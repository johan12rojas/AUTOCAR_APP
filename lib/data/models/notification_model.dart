/// Modelo de dominio para notificaciones
/// 
/// Este modelo representa una notificación del sistema con diferentes
/// tipos, prioridades y contenido personalizado.
class NotificationModel {
  final int? id;
  final int userId;
  final int? vehicleId; // Puede ser null para notificaciones generales
  final String type;
  final String title;
  final String message;
  final String? maintenanceType; // Tipo de mantenimiento relacionado
  final String priority; // 'low', 'medium', 'high'
  final DateTime createdAt;

  NotificationModel({
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

  /// Convierte el modelo a un Map para la base de datos
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

  /// Crea un modelo desde un Map de la base de datos
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
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

  /// Crea una copia del modelo con algunos campos modificados
  NotificationModel copyWith({
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
    return NotificationModel(
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
      case 'vehicle_added':
        return 'Vehículo Agregado';
      case 'mileage_updated':
        return 'Kilometraje Actualizado';
      default:
        return 'General';
    }
  }

  /// Obtiene el icono según el tipo de notificación
  String get typeIcon {
    switch (type) {
      case 'welcome':
        return '👋';
      case 'maintenance_critical':
        return '🚨';
      case 'maintenance_pending':
        return '⏰';
      case 'maintenance_completed':
        return '✅';
      case 'maintenance_reminder':
        return '🔔';
      case 'vehicle_added':
        return '🚗';
      case 'mileage_updated':
        return '📊';
      default:
        return '📢';
    }
  }

  /// Verifica si la notificación es reciente (menos de 7 días)
  bool get isRecent {
    return DateTime.now().difference(createdAt).inDays < 7;
  }

  /// Verifica si la notificación es muy reciente (menos de 1 día)
  bool get isVeryRecent {
    return DateTime.now().difference(createdAt).inHours < 24;
  }

  /// Obtiene el tiempo transcurrido desde la creación
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'Ahora mismo';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} h';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return 'Hace ${difference.inDays ~/ 7} semanas';
    }
  }

  /// Obtiene el nombre del tipo de mantenimiento si aplica
  String get maintenanceName {
    if (maintenanceType == null) return '';
    
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
        return maintenanceType!;
    }
  }

  /// Obtiene el icono del tipo de mantenimiento si aplica
  String get maintenanceIcon {
    if (maintenanceType == null) return '';
    
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

  /// Verifica si la notificación requiere acción inmediata
  bool get requiresImmediateAction {
    return isHighPriority && isMaintenanceRelated;
  }

  /// Obtiene el color de fondo sugerido para la UI
  String get backgroundColor {
    switch (priority) {
      case 'high':
        return 'red';
      case 'medium':
        return 'orange';
      case 'low':
        return 'blue';
      default:
        return 'grey';
    }
  }

  @override
  String toString() {
    return 'NotificationModel(id: $id, userId: $userId, vehicleId: $vehicleId, type: $type, title: $title, priority: $priority, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationModel &&
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
