/// Constantes para intervalos de mantenimiento
/// 
/// Define los intervalos recomendados en kilómetros para cada tipo
/// de mantenimiento según las mejores prácticas de la industria.
class MaintenanceIntervals {
  /// Intervalos de mantenimiento en kilómetros
  /// 
  /// Estos valores están basados en recomendaciones de fabricantes
  /// y talleres especializados para vehículos promedio.
  static const Map<String, int> intervals = {
    'oil': 5000,        // Aceite de motor - cada 5,000 km
    'tires': 40000,     // Llantas - cada 40,000 km
    'brakes': 30000,    // Frenos - cada 30,000 km
    'battery': 50000,   // Batería - cada 50,000 km
    'coolant': 20000,   // Refrigerante - cada 20,000 km
    'airFilter': 17500, // Filtro de aire - cada 17,500 km (solo carros)
    'alignment': 10000, // Alineación - cada 10,000 km (solo carros)
    'chain': 22500,     // Cadena - cada 22,500 km (solo motos)
    'sparkPlug': 11000, // Bujía - cada 11,000 km (solo motos)
  };

  /// Obtiene el intervalo para un tipo de mantenimiento específico
  /// 
  /// Si el tipo no existe, retorna 10,000 km como valor por defecto
  static int getInterval(String maintenanceType) {
    return intervals[maintenanceType] ?? 10000;
  }

  /// Obtiene todos los tipos de mantenimiento disponibles
  static List<String> getAllMaintenanceTypes() {
    return intervals.keys.toList();
  }

  /// Obtiene los tipos de mantenimiento para carros
  static List<String> getCarMaintenanceTypes() {
    return ['oil', 'tires', 'brakes', 'battery', 'coolant', 'airFilter', 'alignment'];
  }

  /// Obtiene los tipos de mantenimiento para motos
  static List<String> getMotorcycleMaintenanceTypes() {
    return ['oil', 'tires', 'brakes', 'battery', 'coolant', 'chain', 'sparkPlug'];
  }

  /// Verifica si un tipo de mantenimiento es válido
  static bool isValidMaintenanceType(String type) {
    return intervals.containsKey(type);
  }

  /// Obtiene el nombre legible de un tipo de mantenimiento
  static String getMaintenanceName(String type) {
    switch (type) {
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
        return 'Alineación y Balanceo';
      case 'chain':
        return 'Cadena / Kit de Arrastre';
      case 'sparkPlug':
        return 'Bujía';
      default:
        return type;
    }
  }

  /// Obtiene el icono de un tipo de mantenimiento
  static String getMaintenanceIcon(String type) {
    switch (type) {
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

  /// Obtiene la descripción de un tipo de mantenimiento
  static String getMaintenanceDescription(String type) {
    switch (type) {
      case 'oil':
        return 'Cambio de aceite de motor y filtro de aceite';
      case 'tires':
        return 'Rotación, balanceo y revisión de llantas';
      case 'brakes':
        return 'Revisión y cambio de pastillas y discos de freno';
      case 'battery':
        return 'Revisión y cambio de batería del sistema eléctrico';
      case 'coolant':
        return 'Cambio de refrigerante del sistema de enfriamiento';
      case 'airFilter':
        return 'Cambio del filtro de aire del motor';
      case 'alignment':
        return 'Alineación y balanceo de la dirección';
      case 'chain':
        return 'Ajuste y lubricación de cadena y kit de arrastre';
      case 'sparkPlug':
        return 'Cambio de bujías del sistema de encendido';
      default:
        return 'Mantenimiento general del vehículo';
    }
  }

  /// Obtiene el color asociado a un tipo de mantenimiento
  static String getMaintenanceColor(String type) {
    switch (type) {
      case 'oil':
        return 'green';
      case 'tires':
        return 'orange';
      case 'brakes':
        return 'red';
      case 'battery':
        return 'yellow';
      case 'coolant':
        return 'blue';
      case 'airFilter':
        return 'purple';
      case 'alignment':
        return 'teal';
      case 'chain':
        return 'grey';
      case 'sparkPlug':
        return 'orange';
      default:
        return 'blue';
    }
  }

  /// Calcula el próximo kilometraje para un mantenimiento
  static int calculateNextMileage(int currentMileage, String maintenanceType) {
    final interval = getInterval(maintenanceType);
    return currentMileage + interval;
  }

  /// Calcula cuántos kilómetros faltan para el próximo mantenimiento
  static int calculateRemainingKm(int currentMileage, int dueMileage) {
    return dueMileage - currentMileage;
  }

  /// Calcula el porcentaje de vida útil restante
  static int calculatePercentage(int currentMileage, int dueMileage, String maintenanceType) {
    final interval = getInterval(maintenanceType);
    final remainingKm = calculateRemainingKm(currentMileage, dueMileage);
    
    if (remainingKm <= 0) return 0;
    
    final percentage = (remainingKm / interval * 100).round();
    return percentage.clamp(0, 100);
  }

  /// Verifica si un mantenimiento está próximo a vencer
  static bool isUpcoming(int percentage) {
    return percentage >= 30 && percentage < 50;
  }

  /// Verifica si un mantenimiento está crítico
  static bool isCritical(int percentage) {
    return percentage < 30;
  }

  /// Verifica si un mantenimiento está en buen estado
  static bool isGood(int percentage) {
    return percentage >= 50;
  }

  /// Obtiene el estado como texto
  static String getStatusText(int percentage) {
    if (isCritical(percentage)) return 'Crítico';
    if (isUpcoming(percentage)) return 'Próximo';
    if (isGood(percentage)) return 'Bueno';
    return 'Excelente';
  }

  /// Obtiene el estado como color
  static String getStatusColor(int percentage) {
    if (isCritical(percentage)) return 'red';
    if (isUpcoming(percentage)) return 'orange';
    if (isGood(percentage)) return 'green';
    return 'blue';
  }

  /// Obtiene la frecuencia recomendada en texto
  static String getFrequencyText(String maintenanceType) {
    final interval = getInterval(maintenanceType);
    
    if (interval >= 1000) {
      final thousands = interval ~/ 1000;
      return 'Cada $thousands,000 km';
    } else {
      return 'Cada $interval km';
    }
  }

  /// Obtiene el tiempo estimado para completar el mantenimiento
  static String getEstimatedTime(String maintenanceType) {
    switch (maintenanceType) {
      case 'oil':
        return '30-45 minutos';
      case 'tires':
        return '1-2 horas';
      case 'brakes':
        return '2-3 horas';
      case 'battery':
        return '15-30 minutos';
      case 'coolant':
        return '45-60 minutos';
      case 'airFilter':
        return '15-20 minutos';
      case 'alignment':
        return '1-2 horas';
      case 'chain':
        return '30-45 minutos';
      case 'sparkPlug':
        return '20-30 minutos';
      default:
        return '1 hora';
    }
  }

  /// Obtiene el costo estimado del mantenimiento
  static String getEstimatedCost(String maintenanceType) {
    switch (maintenanceType) {
      case 'oil':
        return '\$30-60';
      case 'tires':
        return '\$200-500';
      case 'brakes':
        return '\$100-300';
      case 'battery':
        return '\$80-200';
      case 'coolant':
        return '\$25-50';
      case 'airFilter':
        return '\$15-30';
      case 'alignment':
        return '\$50-100';
      case 'chain':
        return '\$40-80';
      case 'sparkPlug':
        return '\$20-40';
      default:
        return '\$50-100';
    }
  }
}
