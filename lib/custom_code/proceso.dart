import 'dart:convert';

class Proceso {
  int? id;
  String abbreviation;
  String name;

  Proceso({
    this.id,
    required this.name,
    required this.abbreviation,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'abbreviation': abbreviation,
      'name': name,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'abbreviation': abbreviation,
    };
  }

  factory Proceso.fromJson(Map<String, dynamic> json) {
    return Proceso(
      id: json['id'],
      name: json['name'],
      abbreviation: json['abbreviation'],
    );
  }

  factory Proceso.fromMap(Map<String, dynamic> m) => Proceso(
        id: m['id'] as int?,
        name: m['name'] as String,
        abbreviation: m['abbreviation'] as String,
      );
}
