class Habit {
  final String id;
  final String name;
  final String frequency;
  final DateTime? startDate;
  bool isCompleted;
  DateTime? completedDate;
  final String userId;

  Habit({
    required this.id,
    required this.name,
    required this.frequency,
    this.startDate,
    this.isCompleted = false,
    this.completedDate,
    required this.userId,
  });

  // Copy with method
  Habit copyWith({
    String? id,
    String? name,
    String? frequency,
    DateTime? startDate,
    bool? isCompleted,
    DateTime? completedDate,
    String? userId,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      isCompleted: isCompleted ?? this.isCompleted,
      completedDate: completedDate ?? this.completedDate,
      userId: userId ?? this.userId,
    );
  }

  // Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'frequency': frequency,
      'startDate': startDate?.toIso8601String(),
      'isCompleted': isCompleted,
      'completedDate': completedDate?.toIso8601String(),
      'userId': userId,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  // Create from Firestore
  static Habit fromFirestore(String id, Map<String, dynamic> data) {
    return Habit(
      id: id,
      name: data['name'] ?? '',
      frequency: data['frequency'] ?? 'daily',
      startDate: data['startDate'] != null
          ? DateTime.parse(data['startDate'])
          : null,
      isCompleted: data['isCompleted'] ?? false,
      completedDate: data['completedDate'] != null
          ? DateTime.parse(data['completedDate'])
          : null,
      userId: data['userId'] ?? '',
    );
  }
}
