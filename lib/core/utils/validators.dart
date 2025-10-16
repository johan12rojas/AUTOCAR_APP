/// Utilidades para validación de datos
/// 
/// Contiene métodos estáticos para validar diferentes tipos de datos
/// utilizados en formularios y operaciones de la aplicación.
class Validators {
  /// Valida si un nombre es válido
  /// 
  /// Requisitos:
  /// - Mínimo 2 caracteres
  /// - No puede estar vacío
  /// - No puede contener solo espacios
  static bool isValidName(String name) {
    if (name.trim().isEmpty) return false;
    return name.trim().length >= 2;
  }

  /// Valida si un email tiene formato válido
  /// 
  /// Utiliza una expresión regular para verificar el formato básico del email
  static bool isValidEmail(String email) {
    if (email.trim().isEmpty) return false;
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email.trim());
  }

  /// Valida si una contraseña es válida
  /// 
  /// Requisitos:
  /// - Mínimo 6 caracteres
  /// - No puede estar vacía
  static bool isValidPassword(String password) {
    if (password.isEmpty) return false;
    return password.length >= 6;
  }

  /// Valida si una contraseña es fuerte
  /// 
  /// Requisitos adicionales:
  /// - Mínimo 8 caracteres
  /// - Al menos una letra mayúscula
  /// - Al menos una letra minúscula
  /// - Al menos un número
  static bool isStrongPassword(String password) {
    if (password.length < 8) return false;
    
    final hasUpperCase = password.contains(RegExp(r'[A-Z]'));
    final hasLowerCase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    
    return hasUpperCase && hasLowerCase && hasDigits;
  }

  /// Valida si dos contraseñas coinciden
  static bool passwordsMatch(String password1, String password2) {
    return password1 == password2;
  }

  /// Valida si un año es válido
  /// 
  /// Requisitos:
  /// - Entre 1900 y el año actual + 1
  static bool isValidYear(int year) {
    final currentYear = DateTime.now().year;
    return year >= 1900 && year <= currentYear + 1;
  }

  /// Valida si un kilometraje es válido
  /// 
  /// Requisitos:
  /// - Mayor o igual a 0
  /// - Menor o igual a 999,999 km
  static bool isValidMileage(int mileage) {
    return mileage >= 0 && mileage <= 999999;
  }

  /// Valida si una marca de vehículo es válida
  /// 
  /// Requisitos:
  /// - Mínimo 2 caracteres
  /// - No puede estar vacía
  static bool isValidMake(String make) {
    if (make.trim().isEmpty) return false;
    return make.trim().length >= 2;
  }

  /// Valida si un modelo de vehículo es válido
  /// 
  /// Requisitos:
  /// - Mínimo 1 carácter
  /// - No puede estar vacío
  static bool isValidModel(String model) {
    if (model.trim().isEmpty) return false;
    return model.trim().length >= 1;
  }

  /// Valida si un tipo de vehículo es válido
  static bool isValidVehicleType(String type) {
    return type == 'car' || type == 'motorcycle';
  }

  /// Valida si un costo es válido
  /// 
  /// Requisitos:
  /// - Mayor o igual a 0
  /// - Menor o igual a 999,999.99
  static bool isValidCost(double? cost) {
    if (cost == null) return true; // El costo es opcional
    return cost >= 0 && cost <= 999999.99;
  }

  /// Valida si una fecha es válida
  /// 
  /// Requisitos:
  /// - No puede ser anterior a 1900
  /// - No puede ser más de 1 año en el futuro
  static bool isValidDate(DateTime date) {
    final now = DateTime.now();
    final minDate = DateTime(1900);
    final maxDate = DateTime(now.year + 1, now.month, now.day);
    
    return date.isAfter(minDate) && date.isBefore(maxDate);
  }

  /// Valida si una fecha de mantenimiento es válida
  /// 
  /// Requisitos más estrictos para mantenimientos:
  /// - No puede ser anterior a 2020
  /// - No puede ser más de 6 meses en el futuro
  static bool isValidMaintenanceDate(DateTime date) {
    final now = DateTime.now();
    final minDate = DateTime(2020);
    final maxDate = DateTime(now.year, now.month + 6, now.day);
    
    return date.isAfter(minDate) && date.isBefore(maxDate);
  }

  /// Valida si un kilometraje programado es válido
  /// 
  /// Requisitos:
  /// - Debe ser mayor al kilometraje actual
  /// - No puede ser más de 100,000 km mayor
  static bool isValidScheduledMileage(int currentMileage, int scheduledMileage) {
    if (scheduledMileage <= currentMileage) return false;
    return (scheduledMileage - currentMileage) <= 100000;
  }

  /// Valida si una ubicación es válida
  /// 
  /// Requisitos:
  /// - Máximo 100 caracteres
  /// - No puede estar vacía si se proporciona
  static bool isValidLocation(String? location) {
    if (location == null) return true; // La ubicación es opcional
    if (location.trim().isEmpty) return false;
    return location.trim().length <= 100;
  }

  /// Valida si las notas son válidas
  /// 
  /// Requisitos:
  /// - Máximo 500 caracteres
  /// - No puede estar vacía si se proporciona
  static bool isValidNotes(String? notes) {
    if (notes == null) return true; // Las notas son opcionales
    if (notes.trim().isEmpty) return false;
    return notes.trim().length <= 500;
  }

  /// Valida si un porcentaje es válido
  /// 
  /// Requisitos:
  /// - Entre 0 y 100
  static bool isValidPercentage(int percentage) {
    return percentage >= 0 && percentage <= 100;
  }

  /// Valida si un intervalo de mantenimiento es válido
  /// 
  /// Requisitos:
  /// - Entre 1,000 y 100,000 km
  static bool isValidMaintenanceInterval(int interval) {
    return interval >= 1000 && interval <= 100000;
  }

  /// Valida si un ID es válido
  /// 
  /// Requisitos:
  /// - Mayor que 0
  static bool isValidId(int? id) {
    return id != null && id > 0;
  }

  /// Valida si un texto no está vacío
  static bool isNotEmpty(String? text) {
    return text != null && text.trim().isNotEmpty;
  }

  /// Valida si un texto tiene longitud mínima
  static bool hasMinLength(String text, int minLength) {
    return text.trim().length >= minLength;
  }

  /// Valida si un texto tiene longitud máxima
  static bool hasMaxLength(String text, int maxLength) {
    return text.trim().length <= maxLength;
  }

  /// Valida si un texto tiene longitud específica
  static bool hasExactLength(String text, int length) {
    return text.trim().length == length;
  }

  /// Valida si un número está en un rango específico
  static bool isInRange(num value, num min, num max) {
    return value >= min && value <= max;
  }

  /// Valida si una lista no está vacía
  static bool isNotEmptyList<T>(List<T>? list) {
    return list != null && list.isNotEmpty;
  }

  /// Valida si una fecha está en el futuro
  static bool isFutureDate(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  /// Valida si una fecha está en el pasado
  static bool isPastDate(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  /// Valida si una fecha está dentro de un rango de días
  static bool isWithinDays(DateTime date, int days) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays.abs();
    return difference <= days;
  }
}
