/// Modelo de dominio para usuarios
/// 
/// Este modelo representa un usuario en la capa de dominio de la aplicación.
/// Es independiente de la base de datos y contiene la lógica de negocio.
class UserModel {
  final int? id;
  final String name;
  final String email;
  final String password; // Siempre hasheado
  final DateTime createdAt;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.createdAt,
  });

  /// Convierte el modelo a un Map para la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Crea un modelo desde un Map de la base de datos
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  /// Crea una copia del modelo con algunos campos modificados
  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Valida si el email tiene formato válido
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Valida si el nombre tiene longitud mínima
  bool get isValidName {
    return name.trim().length >= 2;
  }

  /// Valida si la contraseña tiene longitud mínima
  bool get isValidPassword {
    return password.length >= 6;
  }

  /// Obtiene las iniciales del usuario para avatares
  String get initials {
    final names = name.trim().split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  /// Obtiene el nombre formateado para mostrar
  String get displayName {
    return name.trim().split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Verifica si el usuario es nuevo (registrado hace menos de 7 días)
  bool get isNewUser {
    return DateTime.now().difference(createdAt).inDays < 7;
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
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
