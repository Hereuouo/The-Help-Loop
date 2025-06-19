class Skill {
  final String name;
  final String description;
  final String level;
  final String? id;

  Skill({
    required this.name,
    required this.description,
    required this.level,
    this.id,
  });


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'level': level,
    };
  }


  factory Skill.fromMap(Map<String, dynamic> map, String id) {
    return Skill(
      name: map['name'],
      description: map['description'],
      level: map['level'],
      id: id,
    );
  }
}
