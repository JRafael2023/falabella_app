import 'dart:convert';

class Usuario {
  int? id;
  String? userUid; // ID de Supabase Auth
  String? email;
  String? displayName;
  String? photoUrl;
  String? phoneNumber;
  String? country;
  String? role;
  int sincronizadoNube;
  int sincronizadoLocal;
  String createdAt;
  String updatedAt;
  bool status;
  // ✅ Contraseña temporal solo para usuarios creados offline (se borra tras sincronizar)
  String? passwordTemp;

  Usuario({
    this.id,
    this.userUid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
    this.country,
    this.role,
    this.sincronizadoNube = 1,
    this.sincronizadoLocal = 0,
    this.createdAt = "",
    this.updatedAt = "",
    this.status = true,
    this.passwordTemp,
  });

  // Convertir un objeto Usuario a Map (para SQLite)
  Map<String, dynamic> toMap() {
    return {
      'user_uid': userUid,
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'phone_number': phoneNumber,
      'country': country,
      'role': role,
      'sincronizadoNube': sincronizadoNube,
      'sincronizadoLocal': sincronizadoLocal,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'status': status ? 1 : 0,
      'password_temp': passwordTemp,
    };
  }

  // Crear un objeto Usuario desde un Map (SQLite)
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      userUid: map['user_uid'],
      email: map['email'],
      displayName: map['display_name'],
      photoUrl: map['photo_url'],
      phoneNumber: map['phone_number'],
      country: map['country'],
      role: map['role'],
      sincronizadoNube: map['sincronizadoNube'] ?? 1,
      sincronizadoLocal: map['sincronizadoLocal'] ?? 0,
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
      status: map['status'] == 1,
      passwordTemp: map['password_temp'] as String?,
    );
  }

  // Convertir a JSON (para Supabase)
  Map<String, dynamic> toJson() {
    return {
      'user_uid': userUid,
      'email': email,
      'display_name': displayName,
      'country': country,
      'role': role,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'status': status,
      // ✅ Incluido para que el UI pueda mostrar badge "pendiente de sync"
      'sincronizadoNube': sincronizadoNube,
    };
  }

  // Factory para crear desde UsersRow (Supabase)
  factory Usuario.fromUsersRow(dynamic row) {
    return Usuario(
      userUid: row.userUid ?? '',
      email: row.email ?? '',
      displayName: row.displayName ?? '',
      country: row.country ?? '',
      role: row.role ?? '',
      createdAt:
          row.createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      updatedAt:
          row.updatedAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      status: row.status ?? true,
      sincronizadoNube: 1,
      sincronizadoLocal: 0,
    );
  }

  // Factory para crear desde Auth (Supabase Auth)
  factory Usuario.fromAuth({
    required String uid,
    String? email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
  }) {
    return Usuario(
      userUid: uid,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      phoneNumber: phoneNumber,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );
  }

  // Factory para crear desde HighBond API
  factory Usuario.fromHighBondJson(Map<String, dynamic> json) {
    return Usuario(
      userUid: json['id'].toString(), // Usamos el ID de HighBond como userUid
      email: json['attributes']?['email'],
      displayName: json['attributes']?['name'],
      role: json['attributes']?['role'],
      createdAt:
          json['attributes']?['created_at'] ?? DateTime.now().toIso8601String(),
      updatedAt:
          json['attributes']?['updated_at'] ?? DateTime.now().toIso8601String(),
    );
  }

  // Método copyWith para crear copias modificadas
  Usuario copyWith({
    int? id,
    String? userUid,
    String? email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    String? country,
    String? role,
    int? sincronizadoNube,
    int? sincronizadoLocal,
    String? createdAt,
    String? updatedAt,
    bool? status,
    String? passwordTemp,
  }) {
    return Usuario(
      id: id ?? this.id,
      userUid: userUid ?? this.userUid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      country: country ?? this.country,
      role: role ?? this.role,
      sincronizadoNube: sincronizadoNube ?? this.sincronizadoNube,
      sincronizadoLocal: sincronizadoLocal ?? this.sincronizadoLocal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      passwordTemp: passwordTemp ?? this.passwordTemp,
    );
  }

  @override
  String toString() {
    return 'Usuario{id: $id, userUid: $userUid, email: $email, displayName: $displayName, country: $country, role: $role, status: $status}';
  }
}
