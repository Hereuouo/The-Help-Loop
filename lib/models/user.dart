class User {
  final String id;
  final String name;
  final String email;
  final double trustScore;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.trustScore,
  });

  // Define the copyWith method
  User copyWith({
    String? id,
    String? name,
    String? email,
    double? trustScore,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      trustScore: trustScore ?? this.trustScore,
    );
  }

  // If needed create a toMap and fromMap methods for serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'trustScore': trustScore,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      trustScore: map['trustScore'] ?? 0.0,
    );
  }
}

