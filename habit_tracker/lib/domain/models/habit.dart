// habit.dart
class Habit {
  final String id; // Changed to String for simplicity
  final String userId; // Changed to String to match AuthController
  final String name;
  final String frequency; // e.g., 'Daily', 'Weekly'
  final DateTime? startDate;
  final List<DateTime> completedDates; // Tracks completion history

  Habit({
    required this.id,
    required this.userId,
    required this.name,
    required this.frequency,
    this.startDate,
    this.completedDates = const [],
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      frequency: json['frequency'],
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      completedDates:
          (json['completedDates'] as List<dynamic>?)
              ?.map((d) => DateTime.parse(d))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'frequency': frequency,
      'startDate': startDate?.toIso8601String(),
      'completedDates': completedDates.map((d) => d.toIso8601String()).toList(),
    };
  }
}
