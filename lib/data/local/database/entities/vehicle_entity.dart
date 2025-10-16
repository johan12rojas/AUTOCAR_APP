/// Entidad que representa la tabla 'vehicles' en la base de datos
/// 
/// Almacena la información de los vehículos registrados por cada usuario:
/// - Datos del vehículo (marca, modelo, año)
/// - Kilometraje actual
/// - Tipo de vehículo (carro o moto)
/// - Referencia al usuario propietario
class VehicleEntity {
  final int? id;
  final int userId;
  final String make;
  final String model;
  final int year;
  final int mileage;
  final String type; // 'car' o 'motorcycle'
  final DateTime createdAt;

  VehicleEntity({
    this.id,
    required this.userId,
    required this.make,
    required this.model,
    required this.year,
    required this.mileage,
    required this.type,
    required this.createdAt,
  });

  /// Convierte la entidad a un Map para insertar en SQLite
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

  /// Crea una entidad desde un Map obtenido de SQLite
  factory VehicleEntity.fromMap(Map<String, dynamic> map) {
    return VehicleEntity(
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

  /// Crea una copia de la entidad con algunos campos modificados
  VehicleEntity copyWith({
    int? id,
    int? userId,
    String? make,
    String? model,
    int? year,
    int? mileage,
    String? type,
    DateTime? createdAt,
  }) {
    return VehicleEntity(
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

  /// Verifica si es un carro
  bool get isCar => type == 'car';

  /// Verifica si es una moto
  bool get isMotorcycle => type == 'motorcycle';

  @override
  String toString() {
    return 'VehicleEntity(id: $id, userId: $userId, make: $make, model: $model, year: $year, mileage: $mileage, type: $type, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VehicleEntity &&
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
