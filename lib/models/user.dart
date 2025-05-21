import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String name;
  final String email;
  final int? age;
  final String? gender;
  final String? address;
  final GeoPoint? location;
  final List<String> skills;
  final bool willingToPay;
  final double trustScore;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.age,
    this.gender,
    this.address,
    this.location,
    required this.skills,
    required this.willingToPay,
    required this.trustScore,
  });

  factory AppUser.fromMap(String id, Map<String, dynamic> map) {
    return AppUser(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      age: map['age'],
      gender: map['gender'],
      address: map['address'],
      location: map['location'],
      skills: List<String>.from(map['skills'] ?? []),
      willingToPay: map['willingToPay'] ?? false,
      trustScore: (map['trustScore'] is num) ? (map['trustScore'] as num).toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'age': age,
      'gender': gender,
      'address': address,
      'location': location,
      'skills': skills,
      'willingToPay': willingToPay,
      'trustScore': trustScore,
    };
  }
}
