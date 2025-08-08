import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String id;
  final String email;
  final String username;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  UserProfile({
    required this.id,
    required this.email,
    required this.username,
    required this.createdAt,
    this.lastLoginAt,
  });

  // Convert UserProfile to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt': lastLoginAt != null
          ? Timestamp.fromDate(lastLoginAt!)
          : null,
    };
  }

  // Create UserProfile from Firestore document
  factory UserProfile.fromFirestore(String id, Map<String, dynamic> data) {
    return UserProfile(
      id: data['id'] ?? '',
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastLoginAt: data['lastLoginAt'] != null
          ? (data['lastLoginAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Copy with method for updating fields
  UserProfile copyWith({
    String? id,
    String? email,
    String? username,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}
