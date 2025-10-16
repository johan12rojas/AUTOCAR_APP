/// Modelo de dominio para vehículos
/// 
/// Este modelo representa un vehículo en la capa de dominio de la aplicación.
/// Contiene toda la información del vehículo y métodos de validación.
class VehicleModel {
  final int? id;
  final int userId;
  final String make;
  final String model;
  final int year;
  final int mileage;
  final String type; // 'car' o 'motorcycle'
  final DateTime createdAt;

  VehicleModel({
    this.id,
    required this.userId,
    required this.make,
    required this.model,
    required this.year,
    required this.mileage,
    required this.type,
    required this.createdAt,
  });

  /// Convierte el modelo a un Map para la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'make': make,
      'model': model,
      'year': year,
      'mileage': mileage,
      'type': type,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Crea un modelo desde un Map de la base de datos
  factory VehicleModel.fromMap(Map<String, dynamic> map) {
    return VehicleModel(
      id: map['id'],
      userId: map['user_id'],
      make: map['make'],
      model: map['model'],
      year: map['year'],
      mileage: map['mileage'],
      type: map['type'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  /// Crea una copia del modelo con algunos campos modificados
  VehicleModel copyWith({
    int? id,
    int? userId,
    String? make,
    String? model,
    int? year,
    int? mileage,
    String? type,
    DateTime? createdAt,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      mileage: mileage ?? this.mileage,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Obtiene el nombre completo del vehículo
  String get fullName => '$make $model ($year)';

  /// Obtiene el nombre corto del vehículo
  String get shortName => '$make $model';

  /// Verifica si es un carro
  bool get isCar => type == 'car';

  /// Verifica si es una moto
  bool get isMotorcycle => type == 'motorcycle';

  /// Obtiene el tipo como texto legible
  String get typeText {
    switch (type) {
      case 'car':
        return 'Carro';
      case 'motorcycle':
        return 'Moto';
      default:
        return 'Vehículo';
    }
  }

  /// Obtiene el icono según el tipo de vehículo
  String get typeIcon {
    switch (type) {
      case 'car':
        return '🚗';
      case 'motorcycle':
        return '🏍️';
      default:
        return '🚙';
    }
  }

  /// Valida si el año es válido
  bool get isValidYear {
    final currentYear = DateTime.now().year;
    return year >= 1900 && year <= currentYear + 1;
  }

  /// Valida si el kilometraje es válido
  bool get isValidMileage {
    return mileage >= 0 && mileage <= 999999;
  }

  /// Valida si la marca es válida
  bool get isValidMake {
    return make.trim().isNotEmpty && make.trim().length >= 2;
  }

  /// Valida si el modelo es válido
  bool get isValidModel {
    return model.trim().isNotEmpty && model.trim().length >= 1;
  }

  /// Valida si el tipo es válido
  bool get isValidType {
    return type == 'car' || type == 'motorcycle';
  }

  /// Verifica si el vehículo es nuevo (menos de 2 años)
  bool get isNewVehicle {
    final currentYear = DateTime.now().year;
    return (currentYear - year) <= 2;
  }

  /// Verifica si el vehículo es antiguo (más de 10 años)
  bool get isOldVehicle {
    final currentYear = DateTime.now().year;
    return (currentYear - year) >= 10;
  }

  /// Obtiene la edad del vehículo en años
  int get ageInYears {
    return DateTime.now().year - year;
  }

  /// Obtiene el kilometraje formateado con separadores de miles
  String get formattedMileage {
    return mileage.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  /// Calcula el kilometraje promedio anual
  double get averageMileagePerYear {
    if (ageInYears == 0) return mileage.toDouble();
    return mileage / ageInYears;
  }

  /// Verifica si el vehículo tiene alto kilometraje
  bool get hasHighMileage {
    return averageMileagePerYear > 20000;
  }

  /// Verifica si el vehículo tiene bajo kilometraje
  bool get hasLowMileage {
    return averageMileagePerYear < 10000;
  }

  @override
  String toString() {
    return 'VehicleModel(id: $id, userId: $userId, make: $make, model: $model, year: $year, mileage: $mileage, type: $type, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VehicleModel &&
        other.id == id &&
        other.userId == userId &&
        other.make == make &&
        other.model == model &&
        other.year == year &&
        other.mileage == mileage &&
        other.type == type &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        make.hashCode ^
        model.hashCode ^
        year.hashCode ^
        mileage.hashCode ^
        type.hashCode ^
        createdAt.hashCode;
  }
}
