import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String name;
  final String phone;
  final String place;
  final DateTime createdAt;
  final bool isAdmin;

  AppUser({
    required this.uid,
    required this.name,
    required this.phone,
    required this.place,
    required this.createdAt,
    this.isAdmin = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'phone': phone,
      'place': place,
      'createdAt': createdAt,
      'isAdmin': isAdmin,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      place: map['place'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isAdmin: map['isAdmin'] ?? false,
    );
  }
}