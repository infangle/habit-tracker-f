class UserProfile {
  final String id;
  final String email;
  final String displayName;
  final String createdAt;

  UserProfile({
    required this.id,
    required this.email,
    required this.displayName,
    required this.createdAt,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      email: map['email'] as String,
      displayName: map['displayName'] as String,
      createdAt: map['createdAt'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'createdAt': createdAt,
    };
  }
}
