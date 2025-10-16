/// Modelo de dominio para estadísticas del usuario
/// 
/// Este modelo representa las estadísticas y métricas del usuario
/// en el uso de la aplicación AutoCare.
class StatisticsModel {
  final int? id;
  final int userId;
  final int totalMaintenance;
  final int onTimeCompletions;
  final int streak;

  StatisticsModel({
    this.id,
    required this.userId,
    required this.totalMaintenance,
    required this.onTimeCompletions,
    required this.streak,
  });

  /// Convierte el modelo a un Map para la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'total_maintenance': totalMaintenance,
      'on_time_completions': onTimeCompletions,
      'streak': streak,
    };
  }

  /// Crea un modelo desde un Map de la base de datos
  factory StatisticsModel.fromMap(Map<String, dynamic> map) {
    return StatisticsModel(
      id: map['id'],
      userId: map['user_id'],
      totalMaintenance: map['total_maintenance'],
      onTimeCompletions: map['on_time_completions'],
      streak: map['streak'],
    );
  }

  /// Crea una copia del modelo con algunos campos modificados
  StatisticsModel copyWith({
    int? id,
    int? userId,
    int? totalMaintenance,
    int? onTimeCompletions,
    int? streak,
  }) {
    return StatisticsModel(
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

  /// Verifica si el usuario tiene una excelente racha (más de 30 días)
  bool get hasExcellentStreak => streak >= 30;

  /// Verifica si el usuario es muy activo (más de 10 mantenimientos)
  bool get isVeryActive => totalMaintenance >= 10;

  /// Verifica si el usuario es extremadamente activo (más de 50 mantenimientos)
  bool get isExtremelyActive => totalMaintenance >= 50;

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
    if (onTimePercentage >= 95) return 'Excelente';
    if (onTimePercentage >= 85) return 'Muy Bueno';
    if (onTimePercentage >= 75) return 'Bueno';
    if (onTimePercentage >= 65) return 'Regular';
    return 'Necesita Mejorar';
  }

  /// Obtiene el nivel de racha del usuario
  String get streakLevel {
    if (streak >= 30) return 'Leyenda';
    if (streak >= 14) return 'Experto';
    if (streak >= 7) return 'Consistente';
    if (streak >= 3) return 'En progreso';
    return 'Comenzando';
  }

  /// Obtiene el icono según el nivel de experiencia
  String get experienceIcon {
    switch (experienceLevel) {
      case 'Experto':
        return '🏆';
      case 'Avanzado':
        return '🥇';
      case 'Intermedio':
        return '🥈';
      case 'Principiante':
        return '🥉';
      default:
        return '🌱';
    }
  }

  /// Obtiene el icono según el nivel de puntualidad
  String get punctualityIcon {
    switch (punctualityLevel) {
      case 'Excelente':
        return '⭐';
      case 'Muy Bueno':
        return '👍';
      case 'Bueno':
        return '👌';
      case 'Regular':
        return '⚠️';
      default:
        return '📈';
    }
  }

  /// Obtiene el icono según el nivel de racha
  String get streakIcon {
    switch (streakLevel) {
      case 'Leyenda':
        return '🔥';
      case 'Experto':
        return '💪';
      case 'Consistente':
        return '🎯';
      case 'En progreso':
        return '📈';
      default:
        return '🌱';
    }
  }

  /// Calcula el número de mantenimientos tardíos
  int get lateCompletions {
    return totalMaintenance - onTimeCompletions;
  }

  /// Obtiene el porcentaje de mantenimientos tardíos
  double get latePercentage {
    if (totalMaintenance == 0) return 0.0;
    return (lateCompletions / totalMaintenance) * 100;
  }

  /// Verifica si el usuario tiene un buen historial general
  bool get hasGoodHistory {
    return onTimePercentage >= 75 && totalMaintenance >= 5;
  }

  /// Obtiene el promedio de mantenimientos por mes (asumiendo 1 año de uso)
  double get averageMaintenancePerMonth {
    return totalMaintenance / 12;
  }

  /// Obtiene el promedio de mantenimientos por semana
  double get averageMaintenancePerWeek {
    return totalMaintenance / 52;
  }

  /// Verifica si el usuario es consistente en el uso
  bool get isConsistentUser {
    return streak >= 7 && totalMaintenance >= 10;
  }

  /// Obtiene una descripción del rendimiento del usuario
  String get performanceDescription {
    if (hasGoodHistory && hasExcellentStreak) {
      return 'Rendimiento excepcional. Mantén el excelente trabajo!';
    } else if (hasGoodHistory && hasGoodStreak) {
      return 'Buen rendimiento. Sigue así!';
    } else if (totalMaintenance >= 5) {
      return 'Progreso constante. Continúa mejorando!';
    } else {
      return 'Recién comenzando. ¡Sigue registrando tus mantenimientos!';
    }
  }

  /// Obtiene el color del tema según el rendimiento
  String get performanceColor {
    if (hasGoodHistory && hasExcellentStreak) return 'gold';
    if (hasGoodHistory && hasGoodStreak) return 'green';
    if (totalMaintenance >= 5) return 'blue';
    return 'grey';
  }

  @override
  String toString() {
    return 'StatisticsModel(id: $id, userId: $userId, totalMaintenance: $totalMaintenance, onTimeCompletions: $onTimeCompletions, streak: $streak)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StatisticsModel &&
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
