/// Entidad que representa la tabla 'statistics' en la base de datos
/// 
/// Almacena las estadísticas del usuario:
/// - Total de mantenimientos realizados
/// - Mantenimientos completados a tiempo
/// - Racha de días consecutivos usando la app
class StatisticsEntity {
  final int? id;
  final int userId;
  final int totalMaintenance;
  final int onTimeCompletions;
  final int streak;

  StatisticsEntity({
    this.id,
    required this.userId,
    required this.totalMaintenance,
    required this.onTimeCompletions,
    required this.streak,
  });

  /// Convierte la entidad a un Map para insertar en SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'total_maintenance': totalMaintenance,
      'on_time_completions': onTimeCompletions,
      'streak': streak,
    };
  }

  /// Crea una entidad desde un Map obtenido de SQLite
  factory StatisticsEntity.fromMap(Map<String, dynamic> map) {
    return StatisticsEntity(
      id: map['id'],
      userId: map['user_id'],
      totalMaintenance: map['total_maintenance'],
      onTimeCompletions: map['on_time_completions'],
      streak: map['streak'],
    );
  }

  /// Crea una copia de la entidad con algunos campos modificados
  StatisticsEntity copyWith({
    int? id,
    int? userId,
    int? totalMaintenance,
    int? onTimeCompletions,
    int? streak,
  }) {
    return StatisticsEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      totalMaintenance: totalMaintenance ?? this.totalMaintenance,
      onTimeCompletions: onTimeCompletions ?? this.onTimeCompletions,
      streak: streak ?? this.streak,
    );
  }

  /// Calcula el porcentaje de mantenimientos completados a tiempo
  double get onTimePercentage {
    if (totalMaintenance == 0) return 0.0;
    return (onTimeCompletions / totalMaintenance) * 100;
  }

  /// Obtiene el porcentaje formateado como texto
  String get onTimePercentageText {
    return '${onTimePercentage.toStringAsFixed(1)}%';
  }

  /// Verifica si el usuario tiene una buena racha (más de 7 días)
  bool get hasGoodStreak => streak >= 7;

  /// Verifica si el usuario es muy activo (más de 10 mantenimientos)
  bool get isVeryActive => totalMaintenance >= 10;

  /// Obtiene el nivel de experiencia del usuario
  String get experienceLevel {
    if (totalMaintenance >= 50) return 'Experto';
    if (totalMaintenance >= 20) return 'Avanzado';
    if (totalMaintenance >= 10) return 'Intermedio';
    if (totalMaintenance >= 5) return 'Principiante';
    return 'Nuevo';
  }

  /// Obtiene el nivel de puntualidad del usuario
  String get punctualityLevel {
    if (onTimePercentage >= 90) return 'Excelente';
    if (onTimePercentage >= 80) return 'Muy Bueno';
    if (onTimePercentage >= 70) return 'Bueno';
    if (onTimePercentage >= 60) return 'Regular';
    return 'Necesita Mejorar';
  }

  @override
  String toString() {
    return 'StatisticsEntity(id: $id, userId: $userId, totalMaintenance: $totalMaintenance, onTimeCompletions: $onTimeCompletions, streak: $streak)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StatisticsEntity &&
        other.id == id &&
        other.userId == userId &&
        other.totalMaintenance == totalMaintenance &&
        other.onTimeCompletions == onTimeCompletions &&
        other.streak == streak;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        totalMaintenance.hashCode ^
        onTimeCompletions.hashCode ^
        streak.hashCode;
  }
}
