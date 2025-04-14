class Skill {
  final String name;
  final String description;
  final String level; // Beginner, Mid, Advanced
  final String? id;

  Skill({
    required this.name,
    required this.description,
    required this.level,
    this.id,
  });

  // Convert Skill object to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'level': level,
    };
  }

  // Convert Firestore document to Skill object
  factory Skill.fromMap(Map<String, dynamic> map, String id) {
    return Skill(
      name: map['name'],
      description: map['description'],
      level: map['level'],
      id: id,
    );
  }
}
