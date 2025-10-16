/// Entidad que representa la tabla 'users' en la base de datos
/// 
/// Almacena la información básica de los usuarios del sistema:
/// - Datos personales (nombre, email)
/// - Credenciales (password hasheado)
/// - Fecha de registro
class UserEntity {
  final int? id;
  final String name;
  final String email;
  final String password; // Siempre hasheado, nunca texto plano
  final DateTime createdAt;

  UserEntity({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.createdAt,
  });

  /// Convierte la entidad a un Map para insertar en SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Crea una entidad desde un Map obtenido de SQLite
  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  /// Crea una copia de la entidad con algunos campos modificados
  UserEntity copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    DateTime? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'UserEntity(id: $id, name: $name, email: $email, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.password == password &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        password.hashCode ^
        createdAt.hashCode;
  }
}
